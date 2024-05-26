#!/usr/bin/env sh

set -eux

CONFIG_FILE=${CONFIG_FILE}
REPOS_DIR=${REPOS_DIR:-./repos}

for repo in $(jq -c '.repositories[]' "$CONFIG_FILE"); do
  repo_path="$REPOS_DIR/$(jq -r '.name' <<< $repo)"
  repo_clone_url="$(jq -r '.url' <<< "$repo").git"

  echo "Cloning $repo_clone_url into $repo_path"
  git clone $repo_clone_url $repo_path
done

set +x
