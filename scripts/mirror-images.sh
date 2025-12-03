#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

MIRROR_PREFIX="ghcr.io/datalens-tech"
DOCKER_COMPOSE_FILE="docker-compose.yaml"

echo ""
echo "List images for mirror:"
echo "  prefix: ${MIRROR_PREFIX}"
echo "  compose file: ${DOCKER_COMPOSE_FILE}"

IMAGES_PULL=$(
  yq -r '.services[].image' "${DOCKER_COMPOSE_FILE}" |
    { grep -v "${MIRROR_PREFIX}" || true; } |
    sort |
    uniq
)

if [ -n "$(echo "${IMAGES_PULL}" | tr -d '\n')" ]; then
  IMAGES_PRETTY=$(echo "${IMAGES_PULL}" | sort | sed 's|^|  - |')
  echo "${IMAGES_PRETTY}"
  echo ""
  echo "Mirror images..."
fi

for IMG in ${IMAGES_PULL}; do
  echo "  mirror start: ${IMG}"

  IMG_TARGET=$(
    echo "${IMG}" | rev | cut -d '/' -f1 | rev |
      sed -E 's|^.+/(.+):.+\.[0-9]{2}([0-9]+)-([0-9]+)-.+$|\1:\2.\3|'
  )
  IMG_TARGET="${MIRROR_PREFIX}/${IMG_TARGET}"

  docker buildx imagetools create --tag "${IMG_TARGET}" "${IMG}"

  echo "  mirror finish: ${IMG}"

  echo "  replace mirror image from [${IMG}] to [${IMG_TARGET}]"
  IMG="${IMG}" IMG_TARGET="${IMG_TARGET}" yq -i '(.services[].image | select(. == strenv(IMG))) = strenv(IMG_TARGET)' "${DOCKER_COMPOSE_FILE}" # bash-spec ignore

  echo ""
done
