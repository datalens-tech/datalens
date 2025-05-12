#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo "Start auto PostgreSQL init script..."

echo "  setup variables..."

if [ -z "${POSTGRES_USER_COMPENG}" ]; then POSTGRES_USER_COMPENG="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi

if [ -z "${POSTGRES_PASSWORD_COMPENG}" ]; then POSTGRES_PASSWORD_COMPENG="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  echo "Detected external PostgreSQL endpoint..."

  echo "  host: ${POSTGRES_HOST}"
  echo "  port: ${POSTGRES_PORT}"

  RETRIES="10"

  for RETRY in $(seq 1 $RETRIES); do
    if pg_isready --quiet -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -t 10; then
      echo "External PostgreSQL endpoint is available, continue..."
      break
    fi
    sleep 1
  done

  if [ "${RETRY}" == "${RETRIES}" ]; then
    echo "External PostgreSQL endpoint is not available, exit..."
    exit 1
  fi

  if [ "${INIT_EXTERNAL_POSTGRES}" != "1" ] && [ "${INIT_EXTERNAL_POSTGRES}" != "true" ]; then
    # only demo data seed if needed
    /init/seed-demo-data.sh || exit 1
    exit 0
  fi

  echo "  init full setup external PostgreSQL..."
fi

echo "  prepare database..."

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
fi

export PGPASSWORD="${POSTGRES_PASSWORD}"

if [ "${POSTGRES_USER_COMPENG}" != "${POSTGRES_USER}" ]; then
  echo "  create [${POSTGRES_USER_COMPENG}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_COMPENG}" WITH PASSWORD '${POSTGRES_PASSWORD_COMPENG}';
EOSQL
fi
if [ "${POSTGRES_USER_US}" != "${POSTGRES_USER}" ]; then
  echo "  create [${POSTGRES_USER_US}] user..."
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE USER "${POSTGRES_USER_US}" WITH PASSWORD '${POSTGRES_PASSWORD_US}'
EOSQL
fi

echo "  create [${POSTGRES_DB_COMPENG}] database..."
echo "  create [${POSTGRES_DB_US}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_COMPENG}" WITH OWNER "${POSTGRES_USER_COMPENG}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_US}" WITH OWNER "${POSTGRES_USER_US}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_COMPENG}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_COMPENG}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_US}] database..."
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_US}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

# additional databases
/init/init-db-auth.sh
/init/init-db-meta-manager.sh
/init/init-db-temporal.sh

# demo database and demo data
/init/init-db-demo.sh
/init/seed-demo-data.sh &

if [ -f "/init/post-init/post-init.sh" ]; then
  echo "  run post init script in background..."
  /init/post-init/post-init.sh &
fi

echo "Finish PostgreSQL init script"
