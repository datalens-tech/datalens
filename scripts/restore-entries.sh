#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

RESTORE_FILE="./datalens_db.dump"

if [ -f "${RESTORE_FILE}" ]; then
  echo ""
  echo "Restore UnitedStorage tables from [${RESTORE_FILE}] dump file..."
  echo ""
else
  echo "Dump file [${RESTORE_FILE}] not found, exit..."
  exit 1
fi

docker --log-level error compose exec -T postgres sh -c 'pg_restore \
  --disable-triggers \
  --username ${POSTGRES_USER} --dbname ${POSTGRES_DB_US}' <"${RESTORE_FILE}"

EXIT="$?"

if [ "${EXIT}" != "0" ]; then
  echo "Restore error, exit..."
  exit "${EXIT}"
else
  echo "Restore success..."
  echo ""
fi

echo "Fix connections passwords..."
NULL_PASSWORD=$(docker --log-level error compose exec -T postgres sh -c 'python /init/crypto.py ${CONTROL_API_CRYPTO_KEY} null')

docker --log-level error compose exec -T postgres sh -c 'psql \
  --username ${POSTGRES_USER} --dbname ${POSTGRES_DB_US}' <<-EOSQL
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{password,cypher_text}', '"${NULL_PASSWORD}"', true) WHERE unversioned_data #> '{password,cypher_text}' IS NOT NULL;
EOSQL
echo ""

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ]; then
  echo "Restore demo data..."

  POSTGRES_DB_DEMO=$(docker --log-level error compose exec -T postgres sh -c 'echo ${POSTGRES_DB_DEMO}')
  POSTGRES_USER=$(docker --log-level error compose exec -T postgres sh -c 'echo ${POSTGRES_USER}')

  docker --log-level error compose exec -T postgres sh -c 'psql \
  --username ${POSTGRES_USER}' 2>/dev/null <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

  echo ""
  echo "Restart demo data service..."
  docker --log-level error compose up -d demo
  echo ""
fi

echo "Restart UnitedStorage service..."
docker --log-level error compose restart us
exit 0
