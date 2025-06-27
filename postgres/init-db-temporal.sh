#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_TEMPORAL}" != "1" ] && [ "${INIT_DB_TEMPORAL}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_TEMPORAL}" ]; then POSTGRES_USER_TEMPORAL="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_TEMPORAL}" ]; then POSTGRES_PASSWORD_TEMPORAL="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [temporal] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_TEMPORAL}" != "${POSTGRES_USER}" ]; then
  echo "  [temporal] create [${POSTGRES_USER_TEMPORAL}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_TEMPORAL}" WITH PASSWORD '${POSTGRES_PASSWORD_TEMPORAL}'
EOSQL
fi

echo "  [temporal] create [${POSTGRES_DB_TEMPORAL_VISIBILITY}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_TEMPORAL_VISIBILITY}" WITH OWNER "${POSTGRES_USER_TEMPORAL}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [temporal] add [btree_gin] extensions to [${POSTGRES_DB_TEMPORAL_VISIBILITY}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_TEMPORAL_VISIBILITY}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS btree_gin;
EOSQL

echo "  [temporal] create [${POSTGRES_DB_TEMPORAL}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_TEMPORAL}" WITH OWNER "${POSTGRES_USER_TEMPORAL}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [temporal] init database completed..."
