#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IS_SPLIT="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --split)
    IS_SPLIT="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

if [ "${IS_SPLIT}" == "true" ]; then
  echo "Load docker images from separated archives..."

  for IMG in *.tar.gz; do
    echo "  load: ${IMG}"
    docker load --input "${IMG}"
  done

  exit 0
fi

LOAD_FILE="./datalens-images.tar.gz"

if [ -f "${LOAD_FILE}" ]; then
  echo ""
  echo "Load docker images from [${LOAD_FILE}] file..."
  docker load --input "${LOAD_FILE}"
else
  echo "File [${LOAD_FILE}] not found, exit..."
  exit 1
fi
