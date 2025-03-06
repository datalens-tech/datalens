#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

if [ "${CI}" != "true" ]; then
  docker buildx create --use --name buildx-builder --bootstrap 2>/dev/null || echo "buildx container already exists..."
fi

RELEASE_VERSION=$(yq -r '.releaseVersion' ./versions-config.json)

docker buildx build "${SCRIPT_DIR}/../demo-data" --push --platform linux/amd64,linux/arm64 -t "ghcr.io/datalens-tech/datalens-demo-data:${RELEASE_VERSION}"
