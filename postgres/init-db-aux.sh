#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_AUX}" != "1" ] && [ "${INIT_DB_AUX}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_AUX}" ]; then POSTGRES_USER_AUX="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_AUX}" ]; then POSTGRES_PASSWORD_AUX="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [aux] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_AUX}" != "${POSTGRES_USER}" ]; then
  echo "  [aux] create [${POSTGRES_USER_AUX}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_AUX}" WITH PASSWORD '${POSTGRES_PASSWORD_AUX}'
EOSQL
fi

echo "  [aux] create [${POSTGRES_DB_AUX}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_AUX}" WITH OWNER "${POSTGRES_USER_AUX}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [aux] add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_AUX}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_AUX}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  [aux] init database completed..."
