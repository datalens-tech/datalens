#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_AUTH}" != "1" ] && [ "${INIT_DB_AUTH}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_AUTH}" ]; then POSTGRES_USER_AUTH="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_AUTH}" ]; then POSTGRES_PASSWORD_AUTH="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [auth] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_AUTH}" != "${POSTGRES_USER}" ]; then
  echo "  [auth] create [${POSTGRES_USER_AUTH}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_AUTH}" WITH PASSWORD '${POSTGRES_PASSWORD_AUTH}'
EOSQL
fi

echo "  [auth] create [${POSTGRES_DB_AUTH}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_AUTH}" WITH OWNER "${POSTGRES_USER_AUTH}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [auth] add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_AUTH}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_AUTH}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  [auth] init database completed..."
