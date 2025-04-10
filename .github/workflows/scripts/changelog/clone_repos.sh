#!/usr/bin/env sh

set -eux

CONFIG_FILE=${CONFIG_FILE:-./changelog_config.json}
REPOS_DIR=${REPOS_DIR:-./repos}

for repo in $(jq -c '.repositories[]' "$CONFIG_FILE"); do
  repo_path="$REPOS_DIR/$(echo "${repo}" | jq -r '.name')"
  repo_clone_url="$(echo "${repo}" | jq -r '.url').git"

  echo "Cloning $repo_clone_url into $repo_path"
  git clone $repo_clone_url $repo_path
done

set +x
