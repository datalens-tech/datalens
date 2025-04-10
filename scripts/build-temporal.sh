#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

TEMPORAL_VERSION=1.27.2

if [ "${CI}" != "true" ]; then
  docker buildx create --use --name buildx-builder --bootstrap 2>/dev/null || echo "buildx container already exists..."
fi

docker buildx build "${SCRIPT_DIR}/../temporal" --build-arg "TEMPORAL_VERSION=${TEMPORAL_VERSION}" --push --platform linux/amd64,linux/arm64 -t "ghcr.io/datalens-tech/datalens-temporal:${TEMPORAL_VERSION}"
