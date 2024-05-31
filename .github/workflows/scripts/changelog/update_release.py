""" Updates the GitHub release with the content from CHANGELOG.md """
import argparse
import functools
from pathlib import Path

import requests

import github_helpers as gh


def update_release_body(repo_full_name: str, headers: dict[str, str], release_id: str, new_body: str) -> str:
    """ Updates the release description with the passed content, returns release url """

    release_resp = gh.request_with_retries(
        functools.partial(
            requests.patch,
            url=f"https://api.github.com/repos/{repo_full_name}/releases/{release_id}",
            headers=headers,
            json=dict(
                body=new_body,
            ),
        )
    )
    release_resp.raise_for_status()
    return release_resp.json()["html_url"]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="DataLens Release Update")
    parser.add_argument("--changelog-path", type=Path, default=Path("../../../../CHANGELOG.md"))
    parser.add_argument("--root-repo-name", default="datalens-tech/datalens")

    args = parser.parse_args()

    changelog_body = ""
    with open(args.changelog_path, "r") as f:
        release_title = f.readline().strip()
        _, release_tag, _release_date = release_title.split(" ")
        new_line = f.readline()
        while not new_line.startswith("## v"):
            changelog_body += new_line
            new_line = f.readline()

    gh_auth_headers = gh.make_gh_auth_headers_from_env()
    release_to_update = gh.find_release_by_tag(args.root_repo_name, gh_auth_headers, release_tag)
    release_url = update_release_body(args.root_repo_name, gh_auth_headers, release_to_update, changelog_body)
    print("Successfully updated release:",  release_url)
