#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IMAGE_PLATFORM="linux/$(uname -m | grep -o --color=never arm64 || echo amd64)"

# parse args
for _ in "$@"; do
  case ${1} in
  --platform)
    IMAGE_PLATFORM="${2}"
    shift # past argument
    shift # past value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo ""
echo "Save images to single archive..."
echo "  platform: ${IMAGE_PLATFORM}"

echo ""
echo "List images for pack:"

IMAGES_PULL=$(grep -h image: docker-compose.yml | awk '{print $2}' | uniq)

IMAGES_PULL_PRETTY=$(echo "${IMAGES_PULL}" | sort | sed 's|^|  - |')
echo "${IMAGES_PULL_PRETTY}"
echo ""
echo "Pulling images..."

for IMG in ${IMAGES_PULL}; do
  echo "  pull start: ${IMG}"

  IMG_EXISTS=$(docker image ls "${IMG}" -q | xargs -I '{}' sh -c "docker image inspect {} || true" | jq -r '.[0].Os+"/"+.[0].Architecture')

  if [ "${IMG_EXISTS}" == "${IMAGE_PLATFORM}" ]; then
    echo "  pull not needed: image already exists"
  else
    echo "  pull finish: $(docker pull --platform "${IMAGE_PLATFORM}" --quiet "${IMG}")"
  fi
done

echo ""
echo "Prepare version meta file..."

echo ""
echo "Saving images..."

# shellcheck disable=SC2001
IMAGES_SAVE="${IMAGES_PULL}"
echo "${IMAGES_SAVE}" >./datalens-images.txt

IMAGES_SAVE_PRETTY=$(echo "${IMAGES_SAVE}" | sort | sed 's|^|  - |')
echo "${IMAGES_SAVE_PRETTY}"
echo ""

OUT_FILE="./datalens-images.tar"
OUT_ZST_FILE="${OUT_FILE}.zst"

echo "  file: ${OUT_FILE}"

if [ ! -f "${OUT_FILE}" ] && [ ! -f "${OUT_ZST_FILE}" ]; then
  # TODO: support save with platform from docker API 1.48
  # docker save --platform "${IMAGE_PLATFORM}" ${IMAGES} -o "${OUT_FILE}"

  # shellcheck disable=SC2086
  docker save ${IMAGES_SAVE} -o "${OUT_FILE}"
else
  echo "Images tar file [${OUT_FILE}] already exists, skip..."
fi

echo ""
echo "Compress images..."

echo "  file source: ${OUT_FILE}"
echo "  file target: ${OUT_ZST_FILE}"

rm -rf "${OUT_ZST_FILE}.tmp"

if [ ! -f "${OUT_ZST_FILE}" ]; then
  zstd --no-progress -T0 -16 -f --long=25 "${OUT_FILE}" -o "${OUT_ZST_FILE}.tmp" && mv "${OUT_ZST_FILE}.tmp" "${OUT_ZST_FILE}"
else
  echo "Images tar.zst file [${OUT_ZST_FILE}] already exists, skip..."
fi
