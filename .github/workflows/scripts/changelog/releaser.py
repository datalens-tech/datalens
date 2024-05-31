from __future__ import annotations

import argparse
import datetime
import logging
import re
import json
from collections import defaultdict
from typing import Any
from pathlib import Path

import requests

import github_helpers as gh


logging.basicConfig(level=logging.INFO)
LOGGER = logging.getLogger(__name__)

OUTPUTS_FILE = "outputs.txt"

TChangelogSectionKey = tuple[int, str]  # weight, name
TChangelogEntry = tuple[str, str]  # creation timestamp, content
TChangelog = dict[TChangelogSectionKey, list[TChangelogEntry]]

# helper maps
IMG_VERSIONS_BY_NAME: dict[str, dict[str, str]] = defaultdict(dict)  # {"img_name": {"from": "1.0.0", "to": "1.1.0"}}
REPO_VERSIONS: dict[str, dict[str, str]] = defaultdict(dict)  # {"repo_name": {"from": "v1.0.0", "to": "v1.1.0"}}
REPO_CFG_BY_IMG: dict[str, dict[str, Any]] = {}  # {"img_name": repo_cfg}


class ChangelogFormatter:
    @staticmethod
    def release(release_tag: str) -> str:
        return f"## {release_tag}"

    @staticmethod
    def section(name: str) -> str:
        return f"\n### {name}"

    @staticmethod
    def img_version_changed(name: str, v_from: str, v_to: str, url: str) -> str:
        return "- {name}: {v_from} -> {v_to} ([full changelog]({url}))".format(
            name=name, v_from=v_from, v_to=v_to, url=url
        )

    @staticmethod
    def img_version_unchanged(name: str, version: str) -> str:
        return f"- {name}: {version}"

    @staticmethod
    def li(text: str) -> str:
        return f"- {text}"

    @staticmethod
    def clean_pr_title(title: str) -> str:
        prefix_patterns_to_remove = [
            r"^\[?(DLPROJECTS|CHARTS|BI|YCDOCS|DOCSUP)-\d+\]?[ .:]*",
        ]

        for pattern in prefix_patterns_to_remove:
            title = re.sub(pattern, "", title)
        title = title.strip(" .")

        return title

    @staticmethod
    def pr(tags: list[str], title: str, number: int, repo_url: str) -> str:
        title = ChangelogFormatter.clean_pr_title(title)
        tags_str = ", ".join((f"**{tag}**" for tag in tags))
        pr_message = "{title}. [{repo_name}#{number}]({repo_url}/pull/{number})".format(
            repo_name="/".join(repo_url.split("/")[-2:]),
            title=title,
            number=number,
            repo_url=repo_url,
        )
        if tags_str:
            pr_message = f"{tags_str}. {pr_message}"
        return pr_message


def release_bump_version(version: str, release_type: str) -> str:
    major, minor, patch = map(int, normalize_version(version).split("."))
    if release_type == "major":
        major += 1
    elif release_type == "minor":
        minor += 1
    elif release_type == "patch":
        patch += 1
    else:
        raise ValueError(f'Unknown release type: "{release_type}"')

    new_release = f"v{major}.{minor}.{patch}"
    return new_release


def normalize_tag(tag: str) -> str:
    """ Ensures there is a "v" at the beginning """

    return "v" + tag.lstrip("v")


def normalize_version(version: str) -> str:
    """ Ensures there is no "v" at the beginning """

    return version.lstrip("v")


def prepend_file(filename: str, content: str) -> None:
    with open(filename, "r") as f:
        old_data = f.read()
    with open(filename, "w") as f:
        f.write(content + "\n" + old_data)


def write_output(content: str) -> None:
    with open(OUTPUTS_FILE, "a") as f:
        f.write(content)


def populate_helper_maps(
    changelog_config: dict[str, Any],
    current_image_versions: dict[str, str],
    new_repo_versions: dict[str, str],
) -> None:
    for repo in changelog_config["repositories"]:
        for img in repo["images"]:
            REPO_CFG_BY_IMG[img["name"]] = repo
            IMG_VERSIONS_BY_NAME[img["name"]]["from"] = current_image_versions[img["version_descriptor"]]

    for repo in changelog_config["repositories"]:
        for img in repo["images"]:
            existing_tag = REPO_VERSIONS.get(repo["name"], {}).get("from")
            new_tag = current_image_versions[img["version_descriptor"]]
            if existing_tag:
                new_tag = min(new_tag, existing_tag)
                LOGGER.info(
                    f"Got multiple image tags for {img['name']}, "
                    f"picking the older one for the starting version ({new_tag})"
                )
            REPO_VERSIONS[repo["name"]]["from"] = new_tag

    for repo_name, new_version in new_repo_versions.items():
        REPO_VERSIONS[repo_name]["to"] = new_version
    for repo_name, versions in REPO_VERSIONS.items():
        if "to" not in versions:  # means the repo is unchanged
            REPO_VERSIONS[repo_name]["to"] = versions["from"]

        # normalize tags
        REPO_VERSIONS[repo_name] = {
            "from": normalize_tag(REPO_VERSIONS[repo_name]["from"]),
            "to": normalize_tag(REPO_VERSIONS[repo_name]["to"]),
        }

        # save result image to map
        repo_images = next(repo["images"] for repo in changelog_config["repositories"] if repo["name"] == repo_name)
        for img in repo_images:
            IMG_VERSIONS_BY_NAME[img["name"]]["to"] = normalize_version(REPO_VERSIONS[repo_name]["to"])



def gather_changelog(cfg: dict[str, Any], repos_dir: Path, gh_headers: dict[str, str]) -> TChangelog:
    changelog: TChangelog = defaultdict(list)
    CF = ChangelogFormatter
    other_changes_section = (999999, cfg["other_changes_section"])  # max weight to put it at the end

    for repository in cfg["repositories"]:
        repo_full_name = "/".join(repository["url"].split("/")[-2:])

        commits = gh.get_commits_between_tags(
            tag_from=REPO_VERSIONS[repository["name"]]["from"],
            tag_to=REPO_VERSIONS[repository["name"]]["to"],
            repo_path=repos_dir / repository["name"],
        )

        for commit in commits:
            prs_info = gh.get_pull_requests_by_commit(
                repo_full_name, commit, gh_headers, changelog_config['changelog_include_label']
            )

            for pr in prs_info:
                pr_components = []
                for component in changelog_config["component_tags"]["tags"]:
                    prefix = changelog_config["component_tags"]["prefix"]
                    tag = prefix + component["id"]
                    if tag in pr.labels:
                        pr_components.append(component["text"])

                section = next(  # sortable section tuple: weight (order idx in config) and name
                    (
                        (idx, section["text"])
                        for idx, section in enumerate(changelog_config["section_tags"]["tags"])
                        if f"{changelog_config['section_tags']['prefix']}{section['id']}" in pr.labels
                    ),
                    other_changes_section,  # changes without a section (type)
                )

                changelog[section].append((
                    pr.merged_at,
                    CF.pr(pr_components, pr.title, pr.number, repository["url"]),
                ))

    if len(changelog) == 1 and changelog.get(other_changes_section) is not None:
        # switch to a prettier section title if all changes are untyped
        changelog = {
            (0, changelog_config["single_section_title"]): changelog[other_changes_section]
        }

    return changelog


if __name__ == "__main__":
    print(
        'Note: this script operates under the assumption that repo version tag is '
        'the same as the image version tag up to the leading "v"'
    )

    parser = argparse.ArgumentParser(prog="DataLens Changelog Gatherer")
    parser.add_argument("--config-path", required=True, type=Path, help="path to changelog_config.json")
    parser.add_argument("--root-repo-name", default="datalens-tech/datalens")
    parser.add_argument("--repos-dir", type=Path, default=Path("./repos"))
    parser.add_argument("--changelog-path", type=Path, default=Path("../../../../CHANGELOG.md"))
    parser.add_argument("--version-config-path", required=True, type=Path, help="path to versionn_config.json")
    parser.add_argument("--release-type", choices=("major", "minor", "patch"), default="minor")
    parser.add_argument("--new-repo-versions", required=True, help=(
        'a new version for each repo, space separated in the format "name:tag",'
        ' e.g. "datalens-backend:v0.2.0 datalens-ui:v0.3.0"'
    ))
    parser.add_argument("--create-release", default=False, action="store_true", help=(
        "whether to create a GitHub release in the root repo"
    ))
    parser.add_argument("--dry-run", default=False, action="store_true", help=(
        "do not modify files or create a Github release"
    ))
    parser.add_argument("--make-outputs", default=False, action="store_true", help="whether to create outputs file")

    # Load configs
    args = parser.parse_args()
    dry_run = args.dry_run
    if dry_run and args.create_release:
        print("Note: --create-release is ignored in a dry run")

    with open(args.config_path, "r") as f:
        changelog_config: dict[str, Any] = json.load(f)

    with open(args.version_config_path, "r") as f:
        current_image_versions: dict[str, str] = json.load(f)

    new_repo_versions: dict[str, str] = {}
    for item in args.new_repo_versions.strip().split(" "):
        repo_name, new_version = item.split(":")
        new_repo_versions[repo_name] = normalize_version(new_version)

    # Prepare helper mappings
    populate_helper_maps(changelog_config, current_image_versions, new_repo_versions)

    # Gather changes
    gh_auth_headers = gh.make_gh_auth_headers_from_env()
    latest_release = gh.get_latest_repo_release(args.root_repo_name, gh_auth_headers)
    new_release = release_bump_version(latest_release, args.release_type)
    CF = ChangelogFormatter
    changelog = gather_changelog(changelog_config, args.repos_dir, gh_auth_headers)

    # Render changelog
    changelog_lines: list[str] = []
    no_changes = not bool(changelog)

    changelog_lines.append(CF.release(new_release) + f" ({datetime.date.today()})")

    changelog_lines.append(CF.section(changelog_config['images_versions_section']))
    img_versions_list: list[str] = []
    for img_name, img_versions in IMG_VERSIONS_BY_NAME.items():
        if img_versions["from"] != img_versions["to"]:
            full_changelog_url = "{repo_url}/compare/v{v_from}...v{v_to}".format(
                repo_url=REPO_CFG_BY_IMG[img_name]['url'],
                v_from=img_versions['from'],
                v_to=img_versions['to'],
            )
            img_versions_list.append(CF.img_version_changed(img_name, img_versions['from'], img_versions['to'], full_changelog_url))
        else:
            img_versions_list.append(CF.img_version_unchanged(img_name, img_versions['to']))
    changelog_lines.extend(sorted(img_versions_list))  # let's have them in a predictable order

    for changelog_section, section_lines in sorted(changelog.items()):  # type: str, list[tuple[str, str]]
        changelog_lines.append(CF.section(changelog_section[1]))
        changelog_lines.extend(CF.li(line[1]) for line in sorted(section_lines, key=lambda i: i[0]))
        # ^ PRs sorted by mergedAt
    if no_changes:
        changelog_lines.append(CF.section(changelog_config["single_section_title"]))
        changelog_lines.append(CF.li(changelog_config["no_changes_message"]))

    changelog_result = "\n".join(changelog_lines) + "\n\n"
    print("Changelog content:", changelog_result, sep="\n")

    # Write new version to file
    if args.make_outputs:
        write_output(f"release_version={normalize_version(new_release)}\n")

    # Update changelog & create release
    if not dry_run:
        prepend_file(args.changelog_path, changelog_result)

    # Update image versions
    new_image_versions: dict[str, str] = {}
    for repo in changelog_config["repositories"]:
        for img in repo["images"]:
            new_image_versions[img["version_descriptor"]] = IMG_VERSIONS_BY_NAME[img["name"]]["to"]
    if not dry_run:
        with open(args.version_config_path, "w") as f:
            json.dump(new_image_versions, f, indent=4, sort_keys=True)
    else:
        print("New image versions contents:", json.dumps(new_image_versions, indent=4, sort_keys=True), sep="\n")

    # Create GitHub release
    if args.create_release and not dry_run:
        release_resp = requests.post(
            f"https://api.github.com/repos/{args.root_repo_name}/releases",
            headers=gh_auth_headers,
            json=dict(
                tag_name=new_release,
                target_commitish="main",
                name=changelog_lines[0].lstrip("# "),
                body="\n".join(changelog_lines[1:]),  # without the 1st line
                draft=True,
                prerelease=False,
                generate_release_notes=False,
            )
        )
        release_resp.raise_for_status()
        resp_body = release_resp.json()
        release_url = resp_body.get('html_url')
        print(f"Release response body: {resp_body}")
        print(f"Successfully created a release: {release_url}")
        if args.make_outputs:
            write_output(f"release_url={release_url}\n")
