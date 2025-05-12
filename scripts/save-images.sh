#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IMAGE_PLATFORM="linux/$(uname -m | grep -o --color=never arm64 || echo amd64)"

IS_GZIP_COMPRESS="true"
IS_FORCE="false"
IS_SPLIT="false"
TARGET_DIR="."

# parse args
for _ in "$@"; do
  case ${1} in
  --platform)
    IMAGE_PLATFORM="${2}"
    shift # past argument
    shift # past value
    ;;
  --target-dir)
    TARGET_DIR="${2}"
    shift # past argument
    shift # past value
    ;;
  --no-compress)
    IS_GZIP_COMPRESS="false"
    shift # past argument with no value
    ;;
  --split)
    IS_SPLIT="true"
    shift # past argument with no value
    ;;
  --force)
    IS_FORCE="true"
    shift # past argument with no value
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

IMAGES_PULL=$(grep -h image: docker-compose.yaml | awk '{print $2}' | uniq)

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
echo "Saving images..."

# shellcheck disable=SC2001
IMAGES_SAVE="${IMAGES_PULL}"
echo "${IMAGES_SAVE}" >"${TARGET_DIR}/datalens-images.txt"

IMAGES_SAVE_PRETTY=$(echo "${IMAGES_SAVE}" | sort | sed 's|^|  - |')
echo "${IMAGES_SAVE_PRETTY}"
echo ""

if [ "${IS_SPLIT}" == "true" ]; then
  echo "Save each image as separate file..."

  for IMG in ${IMAGES_SAVE}; do
    IMG_FILE=$(echo "${IMG}" | sed 's|ghcr.io/datalens-tech/||g' | sed 's|:|-|g')

    TARGET_FILE="${TARGET_DIR}/${IMG_FILE}.tar"

    if [ "${IS_FORCE}" == "true" ]; then
      rm -rf "${TARGET_FILE}"
      rm -rf "${TARGET_FILE}.gz"
    fi

    if [ -f "${OUT_FILE}" ] || [ -f "${OUT_GZ_FILE}" ]; then
      echo "Images tar file [${TARGET_FILE}] or [${TARGET_FILE}.gz] already exists, skip..."
      continue
    fi

    docker save "${IMG}" -o "${TARGET_FILE}"

    if [ "${IS_GZIP_COMPRESS}" == "true" ]; then
      gzip --fast <"${TARGET_FILE}" >"${TARGET_FILE}.tmp" && mv "${TARGET_FILE}.tmp" "${TARGET_FILE}.gz"
      rm -rf "${TARGET_FILE}"
    fi
  done

  exit 0
fi

OUT_FILE="${TARGET_DIR}/datalens-images.tar"
OUT_GZ_FILE="${OUT_FILE}.gz"

if [ "${IS_FORCE}" == "true" ]; then
  rm -rf "${OUT_FILE}"
  rm -rf "${OUT_GZ_FILE}"
fi

echo "  file: ${OUT_FILE}"

if [ ! -f "${OUT_FILE}" ] && [ ! -f "${OUT_GZ_FILE}" ]; then
  # TODO: support save with platform from docker API 1.48
  # docker save --platform "${IMAGE_PLATFORM}" ${IMAGES} -o "${OUT_FILE}"

  # shellcheck disable=SC2086
  docker save ${IMAGES_SAVE} -o "${OUT_FILE}"
else
  echo "Images tar file [${OUT_FILE}] or [${OUT_GZ_FILE}] already exists, skip..."
fi

if [ "${IS_GZIP_COMPRESS}" == "false" ]; then
  echo ""
  echo "Compress disabled, skip..."
  exit 0
fi

echo ""
echo "Compress images..."

echo "  file source: ${OUT_FILE}"
echo "  file target: ${OUT_GZ_FILE}"

rm -rf "${OUT_GZ_FILE}.tmp"

if [ ! -f "${OUT_GZ_FILE}" ]; then
  gzip --fast <"${OUT_FILE}" >"${OUT_GZ_FILE}.tmp" && mv "${OUT_GZ_FILE}.tmp" "${OUT_GZ_FILE}"
else
  echo "Images tar.gz file [${OUT_GZ_FILE}] already exists, skip..."
fi
