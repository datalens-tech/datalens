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

POSTGRES_VERSION=16

if [ "${CI}" != "true" ]; then
  docker buildx create --use --name buildx-builder --bootstrap 2>/dev/null || echo "buildx container already exists..."
fi

if [ "${IS_DEV}" == "true" ]; then
  docker buildx build "${SCRIPT_DIR}/../postgres" --build-arg "POSTGRES_VERSION=${POSTGRES_VERSION}" --load -t "datalens-postgres:${POSTGRES_VERSION}-dev"
else
  docker buildx build "${SCRIPT_DIR}/../postgres" --build-arg "POSTGRES_VERSION=${POSTGRES_VERSION}" --push --platform linux/amd64,linux/arm64 -t "ghcr.io/datalens-tech/datalens-postgres:${POSTGRES_VERSION}"
fi
