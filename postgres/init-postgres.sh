#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo "Prepare database..."

if [ -z "${POSTGRES_USER_COMPENG}" ]; then POSTGRES_USER_COMPENG="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_USER_AUTH}" ]; then POSTGRES_USER_AUTH="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_USER_DEMO}" ]; then POSTGRES_USER_DEMO="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_COMPENG}" ]; then POSTGRES_PASSWORD_COMPENG="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_PASSWORD_AUTH}" ]; then POSTGRES_PASSWORD_AUTH="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_PASSWORD_DEMO}" ]; then POSTGRES_PASSWORD_DEMO="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_USER_COMPENG}" != "${POSTGRES_USER}" ]; then
  echo "  create [${POSTGRES_USER_COMPENG}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_COMPENG}" WITH PASSWORD '${POSTGRES_PASSWORD_COMPENG}';
EOSQL
fi
if [ "${POSTGRES_USER_AUTH}" != "${POSTGRES_USER}" ]; then
  echo "  create [${POSTGRES_USER_AUTH}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_AUTH}" WITH PASSWORD '${POSTGRES_PASSWORD_AUTH}'
EOSQL
fi
if [ "${POSTGRES_USER_US}" != "${POSTGRES_USER}" ]; then
  echo "  create [${POSTGRES_USER_US}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_US}" WITH PASSWORD '${POSTGRES_PASSWORD_US}'
EOSQL
fi

echo "  create [${POSTGRES_DB_COMPENG}] database..."
echo "  create [${POSTGRES_DB_AUTH}] database..."
echo "  create [${POSTGRES_DB_US}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_COMPENG}" WITH OWNER "${POSTGRES_USER_COMPENG}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_AUTH}" WITH OWNER "${POSTGRES_USER_AUTH}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_US}" WITH OWNER "${POSTGRES_USER_US}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ]; then
  echo "  create [${POSTGRES_DB_DEMO}] database..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER_DEMO}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

  echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_DEMO}] database..."
  psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_DEMO}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

  if [ "${POSTGRES_USER_DEMO}" != "${POSTGRES_USER}" ]; then
    echo "  create [${POSTGRES_USER_DEMO}] user..."
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_DEMO}" WITH PASSWORD '${POSTGRES_PASSWORD_DEMO}'
EOSQL
  fi
fi

echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_COMPENG}] database..."
psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_COMPENG}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_AUTH}] database..."
psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_AUTH}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_US}] database..."
psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_US}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
