#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DEMO_DATA}" != "1" ] && [ "${INIT_DEMO_DATA}" != "true" ]; then
  exit 0
fi

export PGPASSWORD="${POSTGRES_PASSWORD}"

echo "Start demo data migration..."

# shellcheck disable=SC2236
if [ ! -z "${US_ENDPOINT}" ]; then
  echo "  us endpoint: ${US_ENDPOINT}"

  echo "  sleep ${INIT_SLEEP} seconds..."
  sleep "${INIT_SLEEP}"

  RETRIES="10"
  echo "  retries: ${RETRIES}"

  for RETRY in $(seq 1 $RETRIES); do
    if curl --output /dev/null --silent --head --fail "${US_ENDPOINT}/ping-db"; then
      echo "  us /ping-db success, continue..."
      break
    fi

    echo "  sleep 3 second..."
    sleep 3
  done

  echo "  retry: ${RETRY}"

  if [ "${RETRY}" == "${RETRIES}" ]; then
    echo "Error [${US_ENDPOINT}/ping-db], exit..."
    exit 1
  fi
fi

echo "  import demo data..."
echo "  postgres host: ${POSTGRES_HOST}"
echo "  postgres port: ${POSTGRES_PORT}"

psql -v ON_ERROR_STOP=1 --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_DEMO}" </init/demo-data.sql || exit 1

FERNET_POSTGRES_PASSWORD=$(python /init/crypto.py "${CONTROL_API_CRYPTO_KEY}" "${POSTGRES_PASSWORD}")

echo "  import us demo entries..."

if [ "${HC}" == "1" ]; then
  echo "  mode: hc"
  # shellcheck disable=SC2002
  cat /init/us-hc-data.sql |
    sed "s|{{POSTGRES_HOST}}|${POSTGRES_HOST}|" |
    sed "s|{{POSTGRES_PORT}}|${POSTGRES_PORT}|" |
    sed "s|{{POSTGRES_DB}}|${POSTGRES_DB_DEMO}|" |
    sed "s|{{POSTGRES_USER}}|${POSTGRES_USER}|" |
    sed "s|{{POSTGRES_PASSWORD}}|${FERNET_POSTGRES_PASSWORD}|" |
    psql -v ON_ERROR_STOP=1 --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_US}" || exit 1
else
  echo "  mode: d3"
  # shellcheck disable=SC2002
  cat /init/us-d3-data.sql |
    sed "s|{{POSTGRES_HOST}}|${POSTGRES_HOST}|" |
    sed "s|{{POSTGRES_PORT}}|${POSTGRES_PORT}|" |
    sed "s|{{POSTGRES_DB}}|${POSTGRES_DB_DEMO}|" |
    sed "s|{{POSTGRES_USER}}|${POSTGRES_USER}|" |
    sed "s|{{POSTGRES_PASSWORD}}|${FERNET_POSTGRES_PASSWORD}|" |
    psql -v ON_ERROR_STOP=1 --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_US}" || exit 1
fi

echo "Finish demo data migration..."
