#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

unset NODE_ENV
unset APP_BUILDER_CDN

export APP_PORT=8080

export APP_BUILDER_ENTRY_FILTER=dl-main

export LOCAL_DEV_PORT=8080
export DEV_CLIENT_PORT=8880
export DEV_SERVER_PORT=8890

export APP_DEV_MODE=1

export APP_ENV=development

export US_SURPRESS_DB_STATUS_LOGS="true"
export SWAGGER_ENABLED="true"

export NODE_OPTIONS="--max-old-space-size=8192"

exec 'node' '/opt/dev/npm-dev-entry.js'
