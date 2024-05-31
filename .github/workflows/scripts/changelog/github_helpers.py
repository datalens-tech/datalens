import functools
import logging
import os
import subprocess
import time
import urllib
from pathlib import Path
from typing import Callable, Optional

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
    max_retries: int = 15,
    retry_delay: int = 10,
) -> requests.Response:
    retries = 0
    while retries < max_retries:
        resp = req_func()

        if resp.status_code in (403, 429) and int(resp.headers.get("X-RateLimit-Remaining", -1)) == 0 or resp.status_code >= 500:
            LOGGER.info(f"Got status {resp.status_code} on try {retries + 1}, going to retry in {retry_delay}s...")
            retries += 1
            time.sleep(retry_delay)
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
    search_str = f"repo:{repo_full_name}+type:pr+is:merged+{commit.sha}"
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
    return prs_info


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
