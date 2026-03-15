#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

IS_DEV="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --dev)
    IS_DEV="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

POSTGRES_VERSION='16'
TEMPORAL_VERSION='1.27.2'

VERSION_CONFIG=$(cat ./versions-config.json)

RELEASE_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.releaseVersion')
UI_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.uiVersion')
US_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.usVersion')
BACKEND_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.backendVersion')
AUTH_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.authVersion')
META_MANAGER_VERSION=$(echo "${VERSION_CONFIG}" | jq -r '.metaManagerVersion')

if [ "${CI}" != "true" ]; then
  docker buildx create --use --name buildx-builder --bootstrap 2>/dev/null || echo "buildx container already exists..."
fi

if [ "${IS_DEV}" == "true" ]; then
  docker buildx build "${SCRIPT_DIR}/../slim" \
    --build-arg "POSTGRES_VERSION=${POSTGRES_VERSION}" \
    --build-arg "TEMPORAL_VERSION=${TEMPORAL_VERSION}" \
    --build-arg "UI_VERSION=${UI_VERSION}" \
    --build-arg "US_VERSION=${US_VERSION}" \
    --build-arg "BACKEND_VERSION=${BACKEND_VERSION}" \
    --build-arg "AUTH_VERSION=${AUTH_VERSION}" \
    --build-arg "META_MANAGER_VERSION=${META_MANAGER_VERSION}" \
    --load -t "datalens:${RELEASE_VERSION}-dev"
else
  docker buildx build "${SCRIPT_DIR}/../slim" \
    --build-arg "POSTGRES_VERSION=${POSTGRES_VERSION}" \
    --build-arg "TEMPORAL_VERSION=${TEMPORAL_VERSION}" \
    --build-arg "UI_VERSION=${UI_VERSION}" \
    --build-arg "US_VERSION=${US_VERSION}" \
    --build-arg "BACKEND_VERSION=${BACKEND_VERSION}" \
    --build-arg "AUTH_VERSION=${AUTH_VERSION}" \
    --build-arg "META_MANAGER_VERSION=${META_MANAGER_VERSION}" \
    --push --platform linux/amd64,linux/arm64 \
    -t "ghcr.io/datalens-tech/datalens:${RELEASE_VERSION}"
  docker buildx imagetools create --tag "ghcr.io/datalens-tech/datalens:${RELEASE_VERSION}" "ghcr.io/datalens-tech/datalens:latest"
fi
