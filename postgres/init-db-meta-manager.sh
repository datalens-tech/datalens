#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_META_MANAGER}" != "1" ] && [ "${INIT_DB_META_MANAGER}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_META_MANAGER}" ]; then POSTGRES_USER_META_MANAGER="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_META_MANAGER}" ]; then POSTGRES_PASSWORD_META_MANAGER="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [meta-manager] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_META_MANAGER}" != "${POSTGRES_USER}" ]; then
  echo "  [meta-manager] create [${POSTGRES_USER_META_MANAGER}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_META_MANAGER}" WITH PASSWORD '${POSTGRES_PASSWORD_META_MANAGER}'
EOSQL
fi

echo "  [meta-manager] create [${POSTGRES_DB_META_MANAGER}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_META_MANAGER}" WITH OWNER "${POSTGRES_USER_META_MANAGER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [meta-manager] add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_META_MANAGER}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_META_MANAGER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  [meta-manager] init database completed..."
