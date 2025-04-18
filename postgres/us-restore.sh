#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IS_FIX_DLS="false"
IS_RESTORE_DEMO="false"
IS_ROOT_USER="false"
IS_FIX_CONNECTIONS="false"
IS_FIX_CRYPTO_KEY="false"
IS_RESET_PASSWORDS="false"
IS_RESET_CRYPTO_KEY="false"
RESTORE_FILE="/tmp/datalens_db.dump"

# parse args
for _ in "$@"; do
  case ${1} in
  --fix-dls)
    IS_FIX_DLS="true"
    shift # past argument with no value
    ;;
  --fix-connections)
    IS_FIX_CONNECTIONS="true"
    shift # past argument with no value
    ;;
  --fix-crypto-key)
    IS_FIX_CRYPTO_KEY="true"
    shift # past argument with no value
    ;;
  --reset-passwords)
    IS_RESET_PASSWORDS="true"
    shift # past argument with no value
    ;;
  --reset-crypto-key)
    IS_RESET_CRYPTO_KEY="true"
    shift # past argument with no value
    ;;
  --demo)
    IS_RESTORE_DEMO="true"
    shift # past argument with no value
    ;;
  --root-user)
    IS_ROOT_USER="true"
    shift # past argument with no value
    ;;
  --file)
    RESTORE_FILE="${2}"
    shift # past argument
    shift # past value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo ""
echo "Start restore UnitedStorage entries..."

if [ -z "${POSTGRES_HOST}" ]; then POSTGRES_HOST="localhost"; fi
if [ -z "${POSTGRES_PORT}" ]; then POSTGRES_PORT="5432"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi

if [ "${IS_ROOT_USER}" == "true" ]; then
  POSTGRES_USER_US="${POSTGRES_USER}"
  POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"
fi

export PGPASSWORD="${POSTGRES_PASSWORD_US}"

if [ "${IS_RESET_PASSWORDS}" == "true" ]; then
  echo "  only fix connections passwords without restore..."
  NULL_PASSWORD=$(python /init/crypto.py "${CONTROL_API_CRYPTO_KEY}" null)

  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" <<-EOSQL
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{password,cypher_text}', '"${NULL_PASSWORD}"', true) WHERE unversioned_data #> '{password,cypher_text}' IS NOT NULL;
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{token,cypher_text}', '"${NULL_PASSWORD}"', true) WHERE unversioned_data #> '{token,cypher_text}' IS NOT NULL;
EOSQL
  exit 0
fi

if [ "${IS_RESET_CRYPTO_KEY}" == "true" ]; then
  echo "  only fix crypto key id without restore..."

  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" <<-EOSQL
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{password,key_id}', '"KEY"', true) WHERE unversioned_data #> '{password,key_id}' IS NOT NULL;
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{token,key_id}', '"KEY"', true) WHERE unversioned_data #> '{token,key_id}' IS NOT NULL;
EOSQL
  exit 0
fi

if [ -f "${RESTORE_FILE}" ]; then
  echo "  file exist"
else
  echo "  file [${RESTORE_FILE}] not found, exit..."
  exit 1
fi

pg_restore \
  --host "${POSTGRES_HOST}" \
  --port "${POSTGRES_PORT}" \
  --disable-triggers \
  --username "${POSTGRES_USER_US}" \
  --dbname "${POSTGRES_DB_US}" \
  <"${RESTORE_FILE}"

if [ "${IS_FIX_CONNECTIONS}" == "true" ]; then
  echo "  fix connections passwords..."
  NULL_PASSWORD=$(python /init/crypto.py "${CONTROL_API_CRYPTO_KEY}" null)

  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" <<-EOSQL
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{password,cypher_text}', '"${NULL_PASSWORD}"', true) WHERE unversioned_data #> '{password,cypher_text}' IS NOT NULL;
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{token,cypher_text}', '"${NULL_PASSWORD}"', true) WHERE unversioned_data #> '{token,cypher_text}' IS NOT NULL;
EOSQL
fi

if [ "${IS_FIX_CRYPTO_KEY}" == "true" ]; then
  echo "  fix crypto key id..."

  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" <<-EOSQL
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{password,key_id}', '"KEY"', true) WHERE unversioned_data #> '{password,key_id}' IS NOT NULL;
  UPDATE entries SET unversioned_data = jsonb_set(unversioned_data, '{token,key_id}', '"KEY"', true) WHERE unversioned_data #> '{token,key_id}' IS NOT NULL;
EOSQL
fi

if [ "${IS_FIX_DLS}" == "true" ]; then
  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" <<-EOSQL
  -- workbooks
  INSERT INTO public.dls_nodes (scope, identifier, realm)
  SELECT 'workbook' AS scope, encode_id(workbooks.workbook_id) AS identifier, 'common' AS realm FROM public.workbooks LEFT JOIN public.dls_nodes ON encode_id(workbooks.workbook_id) = dls_nodes.identifier AND dls_nodes.scope = 'workbook' WHERE dls_nodes.identifier IS NULL
  ON CONFLICT (identifier) DO NOTHING;
  INSERT INTO public.dls_node_config (node_id, node_identifier, realm, scope)
  SELECT dls_nodes.id AS node_id, dls_nodes.identifier AS node_identifier, 'common' AS realm, 'workbook' AS scope FROM public.dls_nodes LEFT JOIN public.dls_node_config ON dls_nodes.id = dls_node_config.node_id AND dls_node_config.scope = 'workbook' WHERE dls_node_config.node_id IS NULL AND dls_nodes.scope = 'workbook'
  ON CONFLICT (node_identifier) DO NOTHING;
  -- collections
  INSERT INTO public.dls_nodes (scope, identifier, realm)
  SELECT 'collection' AS scope, encode_id(collections.collection_id) AS identifier, 'common' AS realm FROM public.collections LEFT JOIN public.dls_nodes ON encode_id(collections.collection_id) = dls_nodes.identifier AND dls_nodes.scope = 'collection' WHERE dls_nodes.identifier IS NULL
  ON CONFLICT (identifier) DO NOTHING;
  INSERT INTO public.dls_node_config (node_id, node_identifier, realm, scope)
  SELECT dls_nodes.id AS node_id, dls_nodes.identifier AS node_identifier, 'common' AS realm, 'collection' AS scope FROM public.dls_nodes LEFT JOIN public.dls_node_config ON dls_nodes.id = dls_node_config.node_id AND dls_node_config.scope = 'collection' WHERE dls_node_config.node_id IS NULL AND dls_nodes.scope = 'collection'
  ON CONFLICT (node_identifier) DO NOTHING;
EOSQL
fi

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ] || [ "${IS_RESTORE_DEMO}" == "true" ]; then
  echo "  restore demo database..."

  if [ -z "${POSTGRES_USER_DEMO}" ]; then POSTGRES_USER_DEMO="${POSTGRES_USER}"; fi
  if [ -z "${POSTGRES_PASSWORD_DEMO}" ]; then POSTGRES_PASSWORD_DEMO="${POSTGRES_PASSWORD}"; fi

  export PGPASSWORD="${POSTGRES_PASSWORD}"

  if [ "${POSTGRES_USER_DEMO}" != "${POSTGRES_USER}" ]; then
    echo "  create [${POSTGRES_USER_DEMO}] user..."
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<-EOSQL || true
  CREATE USER "${POSTGRES_USER_DEMO}" WITH PASSWORD '${POSTGRES_PASSWORD_DEMO}'
EOSQL
  fi

  echo "  create [${POSTGRES_DB_DEMO}] database..."
  psql --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER}" 2>/dev/null <<-EOSQL || true
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER_DEMO}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

  echo "  add [pg_trgm,btree_gin,btree_gist,uuid-ossp] extensions to [${POSTGRES_DB_DEMO}] database..."
  psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_DEMO}" --username "${POSTGRES_USER}" <<-EOSQL || true
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

  if [ "${IS_RESTORE_DEMO}" == "true" ]; then
    echo "  seed demo data"
    INIT_DEMO_DATA="true" /init/seed-demo-data.sh
  fi
fi
