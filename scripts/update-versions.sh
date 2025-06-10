#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo ""
echo "Update versions from [versions-config.json] file..."

RELEASE_VERSION=$(yq -r '.releaseVersion' ./versions-config.json)
BACKEND_VERSION=$(yq -r '.backendVersion' ./versions-config.json)
UI_VERSION=$(yq -r '.uiVersion' ./versions-config.json)
US_VERSION=$(yq -r '.usVersion' ./versions-config.json)
AUTH_VERSION=$(yq -r '.authVersion' ./versions-config.json)
META_MANAGER_VERSION=$(yq -r '.metaManagerVersion' ./versions-config.json)

echo "  release: ${RELEASE_VERSION}"
echo "  backend: ${BACKEND_VERSION}"
echo "  ui: ${UI_VERSION}"
echo "  us: ${US_VERSION}"
echo "  auth: ${AUTH_VERSION}"
echo "  meta-manager: ${META_MANAGER_VERSION}"

echo ""
echo "  update helm values file: ./helm/values.yaml"

RELEASE_VERSION="${RELEASE_VERSION}" \
  BACKEND_VERSION="${BACKEND_VERSION}" \
  UI_VERSION="${UI_VERSION}" \
  US_VERSION="${US_VERSION}" \
  AUTH_VERSION="${AUTH_VERSION}" \
  META_MANAGER_VERSION="${META_MANAGER_VERSION}" \
  yq -i '
  .application.control_api.version = strenv(BACKEND_VERSION) |
  .application.data_api.version = strenv(BACKEND_VERSION) |
  .application.ui.version = strenv(UI_VERSION) |
  .application.ui_api.version = strenv(UI_VERSION) |
  .application.us.version = strenv(US_VERSION) |
  .application.auth.version = strenv(AUTH_VERSION) |
  .application.meta_manager.version = strenv(META_MANAGER_VERSION) |
  .release_version = strenv(RELEASE_VERSION)
' ./helm/values.yaml

echo ""
echo "  update helm chart file: ./helm/Chart.yaml"

RELEASE_VERSION="${RELEASE_VERSION}" yq -i '.appVersion = strenv(RELEASE_VERSION)' ./helm/Chart.yaml

echo ""
echo "  update docker-compose file: ./docker-compose.yaml"

RELEASE_VERSION="${RELEASE_VERSION}" \
  CONTROL_API_IMAGE="ghcr.io/datalens-tech/datalens-control-api:${BACKEND_VERSION}" \
  DATA_API_IMAGE="ghcr.io/datalens-tech/datalens-data-api:${BACKEND_VERSION}" \
  UI_IMAGE="ghcr.io/datalens-tech/datalens-ui:${UI_VERSION}" \
  US_IMAGE="ghcr.io/datalens-tech/datalens-us:${US_VERSION}" \
  AUTH_IMAGE="ghcr.io/datalens-tech/datalens-auth:${AUTH_VERSION}" \
  META_MANAGER_IMAGE="ghcr.io/datalens-tech/datalens-meta-manager:${META_MANAGER_VERSION}" \
  yq -i '
  .services.control-api.image = strenv(CONTROL_API_IMAGE) |
  .services.data-api.image = strenv(DATA_API_IMAGE) |
  .services.ui.image = strenv(UI_IMAGE) |
  .services.ui-api.image = strenv(UI_IMAGE) |
  .services.us.image = strenv(US_IMAGE) |
  .services.auth.image = strenv(AUTH_IMAGE) |
  .services.meta-manager.image = strenv(META_MANAGER_IMAGE) |
  .services.ui.environment.RELEASE_VERSION = strenv(RELEASE_VERSION)
' ./docker-compose.yaml
