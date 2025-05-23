#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

MIRROR_PREFIX="ghcr.io/datalens-tech"

echo ""
echo "List images for mirror:"
echo "  prefix: ${MIRROR_PREFIX}"

IMAGES_PULL=$(
  grep -h image: docker-compose.*.yaml |
    awk '{print $2}' |
    grep -v "${MIRROR_PREFIX}" |
    uniq
)

IMAGES_PRETTY=$(echo "${IMAGES_PULL}" | sort | sed 's|^|  - |')
echo "${IMAGES_PRETTY}"
echo ""
echo "Mirror images..."

for IMG in ${IMAGES_PULL}; do
  IMG_TARGET=$(
    echo "${IMG}" |
      sed -E 's|^.+/(.+):.+\.[0-9]{2}([0-9]+)-([0-9]+)-.+$|\1:\2.\3|' |
      sed -E 's|temporalio/ui|temporal-ui|' |
      sed -E 's|cr.fluentbit.io/fluent/||'
  )

  echo "  mirror start: [${IMG}] -> [${MIRROR_PREFIX}/${IMG_TARGET}]"

  docker buildx imagetools create --tag "${MIRROR_PREFIX}/${IMG_TARGET}" "${IMG}"

  echo "  mirror finish: [${IMG}] -> [${MIRROR_PREFIX}/${IMG_TARGET}]"
done
