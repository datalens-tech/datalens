#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DB_NOTIFY}" != "1" ] && [ "${INIT_DB_NOTIFY}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_NOTIFY}" ]; then POSTGRES_USER_NOTIFY="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_NOTIFY}" ]; then POSTGRES_PASSWORD_NOTIFY="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [notify] init database..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_NOTIFY}" != "${POSTGRES_USER}" ]; then
  echo "  [notify] create [${POSTGRES_USER_NOTIFY}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_NOTIFY}" WITH PASSWORD '${POSTGRES_PASSWORD_NOTIFY}'
EOSQL
fi

echo "  [notify] create [${POSTGRES_DB_NOTIFY}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_NOTIFY}" WITH OWNER "${POSTGRES_USER_NOTIFY}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [notify] create [${POSTGRES_DB_NOTIFY_PGBOSS}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_NOTIFY_PGBOSS}" WITH OWNER "${POSTGRES_USER_NOTIFY}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [notify] create [${POSTGRES_DB_NOTIFY_CSAT}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_NOTIFY_CSAT}" WITH OWNER "${POSTGRES_USER_NOTIFY}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  [notify] init database completed..."
