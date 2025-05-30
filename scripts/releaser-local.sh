#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo ""
echo "Run releaser script local..."

RELEASE_TYPE="minor"

# parse args
for _ in "$@"; do
  case ${1} in
  --minor)
    RELEASE_TYPE="minor"
    shift # past argument with no value
    ;;
  --major)
    RELEASE_TYPE="major"
    shift # past argument with no value
    ;;
  --patch)
    RELEASE_TYPE="patch"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo "  release type: ${RELEASE_TYPE}"

if [ -z "${GH_TOKEN}" ]; then
  echo ""
  echo "  env variable GH_TOKEN is empty, try to set from [gh] cli..."
  # shellcheck disable=SC2155
  export GH_TOKEN=$(gh auth token)
fi

echo ""
RELEASE_VERSION=$(jq -r '.releaseVersion' ./versions-config.json)
BACKEND_VERSION=$(jq -r '.backendVersion' ./versions-config.json)
UI_VERSION=$(jq -r '.uiVersion' ./versions-config.json)
US_VERSION=$(jq -r '.usVersion' ./versions-config.json)
AUTH_VERSION=$(jq -r '.authVersion' ./versions-config.json)
META_MANAGER_VERSION=$(jq -r '.metaManagerVersion' ./versions-config.json)

echo "  release: ${RELEASE_VERSION}"
echo "  backend: ${BACKEND_VERSION}"
echo "  ui: ${UI_VERSION}"
echo "  us: ${US_VERSION}"
echo "  auth: ${AUTH_VERSION}"
echo "  meta-manager: ${META_MANAGER_VERSION}"

echo ""
echo "  render versions input..."

VERSIONS_INPUT=""
if [ -n "${BACKEND_VERSION}" ]; then
  VERSIONS_INPUT="datalens-backend:${BACKEND_VERSION}"
fi
if [ -n "${UI_VERSION}" ]; then
  VERSIONS_INPUT="${VERSIONS_INPUT} datalens-ui:${UI_VERSION}"
fi
if [ -n "${US_VERSION}" ]; then
  VERSIONS_INPUT="${VERSIONS_INPUT} datalens-us:${US_VERSION}"
fi
if [ -n "${AUTH_VERSION}" ]; then
  VERSIONS_INPUT="${VERSIONS_INPUT} datalens-auth:${AUTH_VERSION}"
fi
if [ -n "${META_MANAGER_VERSION}" ]; then
  VERSIONS_INPUT="${VERSIONS_INPUT} datalens-meta-manager:${META_MANAGER_VERSION}"
fi

echo "${VERSIONS_INPUT}"

pushd ".github/workflows/scripts/changelog" >/dev/null

echo "  fetch main version config..."
git fetch
git show origin/main:versions-config.json >./versions-config.json

VERSION_CONFIG_FILE=$(cat ./versions-config.json)
echo "${VERSION_CONFIG_FILE}" | jq 'if has("uiVersion") then . else . + {uiVersion: "0.0.0"} end' >./versions-config.json
echo "${VERSION_CONFIG_FILE}" | jq 'if has("backendVersion") then . else . + {backendVersion: "0.0.0"} end' >./versions-config.json
echo "${VERSION_CONFIG_FILE}" | jq 'if has("usVersion") then . else . + {usVersion: "0.0.0"} end' >./versions-config.json
echo "${VERSION_CONFIG_FILE}" | jq 'if has("authVersion") then . else . + {authVersion: "0.0.0"} end' >./versions-config.json
echo "${VERSION_CONFIG_FILE}" | jq 'if has("metaManagerVersion") then . else . + {metaManagerVersion: "0.0.0"} end' >./versions-config.json

uv run releaser.py \
  --config-path "./changelog_config.json" \
  --repos-dir "./repos" \
  --release-type "${RELEASE_TYPE}" \
  --changelog-path "../../../../CHANGELOG.md" \
  --version-config-path "./versions-config.json" \
  --root-repo-name "datalens-tech/datalens" \
  --new-repo-versions "${VERSIONS_INPUT}"

popd >/dev/null
