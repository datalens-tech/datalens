#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

# disable create hidden common file with tar
export COPYFILE_DISABLE=1

IMAGE_PLATFORM="linux/amd64"
README_URL=""
SPLIT_MODE="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --platform)
    IMAGE_PLATFORM="${2}"
    shift # past argument
    shift # past value
    ;;
  --readme-url)
    README_URL="${2}"
    shift # past argument
    shift # past value
    ;;
  --split)
    SPLIT_MODE="true"
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
echo "Start pack all release to single archive..."
echo "  platform: ${IMAGE_PLATFORM}"

VERSION=$(jq -r '.releaseVersion' "${SCRIPT_DIR}/../versions-config.json")
echo "  version: ${VERSION}"

FILE_RELEASE="datalens-${VERSION}.tar"
OUT_PATH="${SCRIPT_DIR}/../dist"

rm -rf "${OUT_PATH}/datalens-${VERSION}"
rm -rf "${OUT_PATH}/${FILE_RELEASE}.tmp"
mkdir -p "${OUT_PATH}/datalens-${VERSION}"

if [ "${SPLIT_MODE}" == "true" ]; then
  echo "  split mode: true"
  "${SCRIPT_DIR}/save-images.sh" --platform "${IMAGE_PLATFORM}" --force --split --target-dir "${OUT_PATH}/datalens-${VERSION}"
else
  echo "  split mode: false"
  "${SCRIPT_DIR}/save-images.sh" --platform "${IMAGE_PLATFORM}" --force --target-dir "${OUT_PATH}/datalens-${VERSION}"
fi

echo ""
echo "Continue pack release..."
echo "  file: ${FILE_RELEASE}"

echo ""
echo "Copy resources to [dist/datalens-${VERSION}] directory..."

cp "${SCRIPT_DIR}/../README.md" "${OUT_PATH}/datalens-${VERSION}/README.md"
cp "${SCRIPT_DIR}/../docker-compose.yaml" "${OUT_PATH}/datalens-${VERSION}/docker-compose.yaml"
cp "${SCRIPT_DIR}/save-images.sh" "${OUT_PATH}/datalens-${VERSION}/save-images.sh"
cp "${SCRIPT_DIR}/load-images.sh" "${OUT_PATH}/datalens-${VERSION}/load-images.sh"
cp "${SCRIPT_DIR}/dump-entries.sh" "${OUT_PATH}/datalens-${VERSION}/dump-entries.sh"
cp "${SCRIPT_DIR}/restore-entries.sh" "${OUT_PATH}/datalens-${VERSION}/restore-entries.sh"
cp "${SCRIPT_DIR}/../init.sh" "${OUT_PATH}/datalens-${VERSION}/init.sh"

# shellcheck disable=SC2236
if [ ! -z "${README_URL}" ]; then
  echo "  download external [README.md] file..."
  curl -s "${README_URL}" >"${OUT_PATH}/datalens-${VERSION}/README.md"
fi

echo "  fix exec permissions for [.sh] scripts..."
chmod +x "${OUT_PATH}"/datalens-"${VERSION}"/*.sh

pushd ./ &>/dev/null

echo ""
echo "Pack release to [dist/datalens-${VERSION}/${FILE_RELEASE}] file..."

# shellcheck disable=SC2035
cd "${OUT_PATH}/datalens-${VERSION}" && tar --no-xattrs -cvf "${OUT_PATH}/${FILE_RELEASE}.tmp" * &>/dev/null && mv "${OUT_PATH}/${FILE_RELEASE}.tmp" "${OUT_PATH}/datalens-${VERSION}/${FILE_RELEASE}"

popd &>/dev/null

echo "Pack release completed"
