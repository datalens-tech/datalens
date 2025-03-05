#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_DEMO}" != "1" ] && [ "${INIT_DB_DEMO}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_DEMO}" ]; then POSTGRES_USER_DEMO="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_DEMO}" ]; then POSTGRES_PASSWORD_DEMO="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [demo] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_DEMO}" != "${POSTGRES_USER}" ]; then
  echo "  [demo] create [${POSTGRES_USER_DEMO}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_DEMO}" WITH PASSWORD '${POSTGRES_PASSWORD_DEMO}'
EOSQL
fi

echo "  [demo] create [${POSTGRES_DB_DEMO}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER_DEMO}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [demo] init database completed..."
