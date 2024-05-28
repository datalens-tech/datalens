import argparse
import json
from pathlib import Path


README_TPL = """
## Changelog gatherer

The `releaser` script is used to create a GitHub release, including:
- update the `versions-config.json` file
- update the `CHANGELOG.md` file
- create a GitHub release itself

It gathers commits between specified tags across the repositories specified in `changelog_config.json`, matches them
with pull requests and formats their titles into a list of changes.

For a pull request to be included in the changelog, add a `{changelog_label}` label to it.

Other labels can be used to control which section the changes end up in and the component that will be mentioned.

Each pull request can be assigned to a single section – if more than one section (type) label is assigned
to a pull request, then the one that is above in the changelog-config will be chosen. A pull request can be assigned
to any number of components, they will appear in a changelog record in the order in which they are specified
in the changelog-config.

Use the following labels to assign a pull request to a section:
{sections_labels_list}

Use the following labels to assign a pull request to a component,
which will put its name in front of the pull request title:
{component_labels_list}

This manual is generated from a config file, `changelog_config.json`, which includes all possible labels and their role,
known repositories and texts.
"""


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="DataLens Changelog Gatherer")
    parser.add_argument(
        "--config-path",
        type=Path,
        help="path to changelog_config.json",
        default=Path("./changelog_config.json")
    )
    parser.add_argument(
        "--readme-path",
        type=Path,
        help="path to the output README.md",
        default=Path("./README.md")
    )

    args = parser.parse_args()
    with open(args.config_path, "r") as f:
        changelog_config = json.load(f)

    changelog_label = changelog_config["changelog_include_label"]

    section_labels = []
    for section_tag in changelog_config["section_tags"]["tags"]:
        section_prefix = changelog_config["section_tags"]["prefix"]
        section_labels.append(f'- `{section_prefix}{section_tag["id"]}` -> {section_tag["text"]}')

    component_labels = []
    component_prefix = changelog_config["component_tags"]["prefix"]
    for component_tag in changelog_config["component_tags"]["tags"]:
        component_labels.append(f'- `{component_prefix}{component_tag["id"]}` -> {component_tag["text"]}')

    readme_content = README_TPL.format(
        changelog_label=changelog_label,
        sections_labels_list="\n".join(section_labels),
        component_labels_list="\n".join(component_labels),
    )

    with open(args.readme_path, "w") as fo:
        fo.write(readme_content)
