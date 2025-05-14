#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

ENV_FILE_PATH=".env"

echo ""
echo "Reset DataLens admin user password..."
echo ""

if docker compose ps --services postgres | grep -q -s postgres; then
  RESULT=$(docker --log-level error compose exec postgres /init/utils.sh --root-user --reset-admin-password)
else
  echo "Running reset password command for external PostgreSQL..."
  echo ""
  RESULT=$(docker --log-level error compose run --rm --entrypoint /init/utils.sh postgres --reset-admin-password)
fi

EXIT="$?"

echo "${RESULT}"
echo ""

if [ "${EXIT}" != "0" ]; then
  echo "Reset error, exit..."
  exit "${EXIT}"
else
  echo "Reset success..."
  echo ""
fi

PASSWORD_VALUE=$(echo "${RESET_RESULT}" | grep "new admin password: " | sed 's|new admin password: ||' | tr -d ' ')

echo "Update password at [${ENV_FILE_PATH}] file..."

ENV_ADMIN_PASSWORD_KEY="AUTH_ADMIN_PASSWORD"

ENV_CONTENT=$(cat "${ENV_FILE_PATH}")
echo "${ENV_CONTENT}" | grep -v "${ENV_ADMIN_PASSWORD_KEY}=" >"${ENV_FILE_PATH}"
echo "${ENV_ADMIN_PASSWORD_KEY}=${PASSWORD_VALUE}" >>"${ENV_FILE_PATH}"
