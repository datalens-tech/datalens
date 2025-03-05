#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ -z "${POSTGRES_DB_COMPENG}" ]; then
  POSTGRES_DB_COMPENG="pg-compeng-db"
fi
if [ -z "${POSTGRES_DB_AUTH}" ]; then
  POSTGRES_DB_AUTH="pg-auth-db"
fi
if [ -z "${POSTGRES_DB_US}" ]; then
  POSTGRES_DB_US="pg-us-db"
fi
if [ -z "${POSTGRES_DB_DEMO}" ]; then
  POSTGRES_DB_DEMO="pg-demo-db"
fi
if [ -z "${INIT_DEMO_DATA}" ]; then
  INIT_DEMO_DATA="true"
fi

echo "Prepare database..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_COMPENG}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_AUTH}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_US}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

  psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_DEMO}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
fi

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_COMPENG}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_AUTH}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_US}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

if [ "${INIT_DEMO_DATA}" != "1" ] && [ "${INIT_DEMO_DATA}" != "true" ]; then
  exit 0
fi

echo "Start demo data migration..."

# shellcheck disable=SC2236
if [ ! -z "${US_ENDPOINT}" ]; then
  echo "  us endpoint: ${US_ENDPOINT}"

  if [ -z "${INIT_SLEEP}" ]; then
    INIT_SLEEP='10'
  fi

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

export PGPASSWORD="${POSTGRES_PASSWORD}"

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

echo "  fix permissions..."
psql -v ON_ERROR_STOP=1 --host="${POSTGRES_HOST}" --port="${POSTGRES_PORT}" --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_US}" </init/fix-dls.sql || exit 1

echo "Finish demo data migration..."
