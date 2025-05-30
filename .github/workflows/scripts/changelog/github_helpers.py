import datetime
import functools
import logging
import os
import subprocess
import time
import urllib
from pathlib import Path
from typing import Callable, Optional
import shutil

import attr
import requests


LOGGER = logging.getLogger(__name__)


@attr.s(auto_attribs=True)
class CommitInfo:
    sha: str
    message: str


@attr.s(auto_attribs=True)
class PullRequestInfo:
    title: str
    number: int
    merged_at: str
    labels: list[str]


def make_gh_auth_headers_from_env() -> dict[str, str]:
    gh_token = os.getenv("GH_TOKEN")
    gh_auth_headers: dict[str, str] = {}

    if gh_token is None:
        LOGGER.warning("No GH_TOKEN provided, all requests will be sent w/o authorization")
    else:
        LOGGER.info("Got GH_TOKEN from env")
        gh_auth_headers["Authorization"] = f"Bearer {gh_token}"

    return gh_auth_headers


def get_latest_repo_release(repo_full_name: str, headers: dict[str, str]) -> str:
    release_resp = request_with_retries(
        functools.partial(
            requests.get,
            url=f"https://api.github.com/repos/{repo_full_name}/releases/latest",
            headers=headers,
        )
    )
    release_resp.raise_for_status()
    latest_release = release_resp.json()["name"].split(" ")[0]
    return latest_release


def request_with_retries(
    req_func: Callable[[], requests.Response],
    max_retries: int = 20,
    retry_delay: int = 10,
) -> requests.Response:

    def _get_retry_delay(response: requests.Response) -> Optional[int]:
        if response.status_code == 403 and "X-RateLimit-Remaining" not in resp.headers or response.status_code >= 500:
            return retry_delay

        if response.status_code in (403, 429):
            if int(resp.headers.get("X-RateLimit-Remaining", -1)) > 0:
                return retry_delay

            ratelimit_reset = int(resp.headers.get("X-RateLimit-Reset", -1))
            if ratelimit_reset > 0:
                current_timestamp = int(datetime.datetime.now().timestamp())
                return ratelimit_reset - current_timestamp + 1

        return None

    retries = 0
    while retries < max_retries:
        resp = req_func()
        if resp.status_code != 200:
            delay = _get_retry_delay(resp)
            if delay is not None:
                LOGGER.info(f"Got status {resp.status_code} on try {retries + 1}, going to retry in {delay}s...")
                retries += 1
                if retries >= max_retries:
                    resp.raise_for_status()
                    raise RuntimeError(f"Reached maximum number of retries, last response: {resp}")
                time.sleep(delay)
            else:
                resp.raise_for_status()
        else:
            return resp


def get_commits_between_tags(tag_from: str, tag_to: str, repo_path: Path) -> list[CommitInfo]:
    git_log = subprocess.run(
        ["git", "log", f"{tag_from}..{tag_to}", "--format=%H\t%s"],
        capture_output=True,
        text=True,
        cwd=repo_path,
    )
    raw_records = git_log.stdout.strip().split("\n")

    commits: list[CommitInfo] = [
        CommitInfo(
            sha=(parts := record.split("\t"))[0],
            message=parts[1],
        ) for record in raw_records if record
    ]

    return commits


def get_pull_requests_by_commit(repo_full_name: str, commit: CommitInfo, auth_headers: dict, include_label: Optional[str] = None) -> list[PullRequestInfo]:
    search_str = f"repo:{repo_full_name}+type:pr+is:merged+{commit.sha[:10]}"
    if include_label is not None:
        search_str += f"+label:{include_label}"
    params_str = urllib.parse.urlencode(dict(q=search_str), safe=':+')

    prs_info_raw = request_with_retries(
        functools.partial(
            requests.get,
            url="https://api.github.com/search/issues",
            headers=auth_headers,
            params=params_str,
        )
    )
    prs_info_raw.raise_for_status()
    prs_info = [
        PullRequestInfo(
            title=pr_raw["title"],
            number=pr_raw["number"],
            merged_at=pr_raw['pull_request']['merged_at'],
            labels=[label["name"] for label in pr_raw.get("labels", [])],
        )for pr_raw in prs_info_raw.json()['items']
    ]
    if len(prs_info) > 1:
        LOGGER.warning(f"Got >1 ({len(prs_info)}) PRs for search str {search_str}")
    return prs_info

def get_pull_requests_by_numbers(repo_full_name: str, pr_numbers: list[str], auth_headers: dict, include_label: Optional[str] = None) -> list[PullRequestInfo]:
    repos_search = repo_full_name.split("/")
    query_prefix = "query($owner: String!, $repo: String!) { repository(owner: $owner, name: $repo) {"
    all_prs_info = []

    # process in batches of 50
    for i in range(0, len(pr_numbers), 50):
        batch = pr_numbers[i:i+50]
        pr_seed = [f"pr{num}: pullRequest(number: {num}) {{ number title state labels(first: 10){{nodes{{name}}}} mergedAt }}" 
                  for num in batch]

        prs_info_raw = request_with_retries(
            functools.partial(
                requests.post,
                url="https://api.github.com/graphql",
                headers=auth_headers,
                json={
                    "query": query_prefix + " ".join(pr_seed) + "} }",
                    "variables": {
                        "owner": repos_search[0],
                        "repo": repos_search[1]
                    }
                }
            )
        )
        prs_info_raw.raise_for_status()
        
        batch_prs = [
            PullRequestInfo(
                title=pr_raw["title"],
                number=pr_raw["number"],
                merged_at=pr_raw["mergedAt"],
                labels=[label["name"] for label in pr_raw["labels"].get("nodes", [])],
            )
            for pr_raw in prs_info_raw.json()['data']['repository'].values() 
            if pr_raw["state"] == "MERGED"
        ]
        all_prs_info.extend(batch_prs)

    if include_label is not None:
        all_prs_info = [pr for pr in all_prs_info if bool(set(pr.labels) & set([include_label]))]

    return all_prs_info



def find_release_by_tag(repo_full_name: str, headers: dict[str, str], release_tag: str) -> str:
    release_resp = request_with_retries(
        functools.partial(
            requests.get,
            url=f"https://api.github.com/repos/{repo_full_name}/releases",
            headers=headers,
        )
    )
    release_resp.raise_for_status()
    release = next((release for release in release_resp.json() if release["tag_name"] == release_tag), None)
    if release is None:
        raise RuntimeError(f'Could not find a release by tag "{release_tag}"')
    return release["id"]

def clone_repository(repo_url: str, repo_path: Path) -> None:
    clone_url = f"{repo_url}.git"

    gh_token = os.getenv("GH_TOKEN")
    if gh_token is not None and "github.com" in repo_url:
        clone_url = clone_url.replace("github.com", f"{gh_token}@github.com")

    if repo_path.exists():
        try:
            LOGGER.info(f"Pull existed repo: [{repo_url}] in [{repo_path}]")
            subprocess.run(
                ["git", "pull", "origin"],
                check= True,
                capture_output=True,
                text=True,
                cwd=repo_path,
            )          
            return
        except:
            LOGGER.info(f"Pull repo error, trying to remove and clone: [{repo_url}] in [{repo_path}]")
            shutil.rmtree(repo_path)

    LOGGER.info(f"Clone new repo: [{repo_url}] to [{repo_path}]")
    subprocess.run(
        ["git", "clone", clone_url, repo_path],
        check= True,
        capture_output=True,
        text=True,
    )
