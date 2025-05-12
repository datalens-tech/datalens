#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${INIT_DEMO_DATA}" != "1" ] && [ "${INIT_DEMO_DATA}" != "true" ]; then
  exit 0
fi

if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_USER_DEMO}" ]; then POSTGRES_USER_DEMO="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_PASSWORD_DEMO}" ]; then POSTGRES_PASSWORD_DEMO="${POSTGRES_PASSWORD}"; fi

if [ "${POSTGRES_HOST}" != "localhost" ]; then
  export PGHOST="${POSTGRES_HOST}"
  export PGPORT="${POSTGRES_PORT}"
else
  POSTGRES_HOST="postgres"
  export PGPORT="${POSTGRES_PORT}"
fi

echo "  [demo] start demo data migration..."

# shellcheck disable=SC2236
if [ ! -z "${US_ENDPOINT}" ]; then
  echo "  [demo] us endpoint: ${US_ENDPOINT}"

  echo "  [demo] sleep ${DEMO_DATA_SLEEP} seconds..."
  sleep "${DEMO_DATA_SLEEP}"

  RETRIES="30"
  echo "  [demo] retries: ${RETRIES}"

  for RETRY in $(seq 1 $RETRIES); do
    if curl --output /dev/null --silent --head --fail "${US_ENDPOINT}/ping-db"; then
      echo "  [demo] us /ping-db success, continue..."
      break
    fi

    echo "  [demo] sleep 3 second..."
    sleep 3
  done

  echo "  [demo] retry: ${RETRY}"

  if [ "${RETRY}" == "${RETRIES}" ]; then
    echo "  [demo] error [${US_ENDPOINT}/ping-db], exit..."
    exit 1
  fi
fi

echo "  [demo] import demo data..."
echo "  [demo] postgres host: ${POSTGRES_HOST}"
echo "  [demo] postgres port: ${POSTGRES_PORT}"

export PGPASSWORD="${POSTGRES_PASSWORD_DEMO}"

psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER_DEMO}" --dbname "${POSTGRES_DB_DEMO}" </init/demo-data/demo-data.sql || exit 1

echo "  [demo] import us demo entries..."

export PGPASSWORD="${POSTGRES_PASSWORD_US}"

FERNET_POSTGRES_PASSWORD=$(python /init/crypto.py "${CONTROL_API_CRYPTO_KEY}" "${POSTGRES_PASSWORD_DEMO}")

if [ "${HC}" == "1" ]; then
  echo "  [demo] mode: hc"
  # shellcheck disable=SC2002
  cat /init/demo-data/us-hc-data.sql |
    sed "s|{{DEMO_DATA_NAME}}|${DEMO_DATA_NAME}|" |
    sed "s|{{POSTGRES_HOST}}|${POSTGRES_HOST}|" |
    sed "s|{{POSTGRES_PORT}}|${POSTGRES_PORT}|" |
    sed "s|{{POSTGRES_DB}}|${POSTGRES_DB_DEMO}|" |
    sed "s|{{POSTGRES_USER}}|${POSTGRES_USER_DEMO}|" |
    sed "s|{{POSTGRES_PASSWORD}}|${FERNET_POSTGRES_PASSWORD}|" |
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER_US}" --dbname "${POSTGRES_DB_US}" || exit 1
else
  echo "  [demo] mode: d3"
  # shellcheck disable=SC2002
  cat /init/demo-data/us-d3-data.sql |
    sed "s|{{DEMO_DATA_NAME}}|${DEMO_DATA_NAME}|" |
    sed "s|{{POSTGRES_HOST}}|${POSTGRES_HOST}|" |
    sed "s|{{POSTGRES_PORT}}|${POSTGRES_PORT}|" |
    sed "s|{{POSTGRES_DB}}|${POSTGRES_DB_DEMO}|" |
    sed "s|{{POSTGRES_USER}}|${POSTGRES_USER_DEMO}|" |
    sed "s|{{POSTGRES_PASSWORD}}|${FERNET_POSTGRES_PASSWORD}|" |
    psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER_US}" --dbname "${POSTGRES_DB_US}" || exit 1
fi

if [ "${IS_FIX_DLS}" == "true" ]; then
  echo "  [demo] fix dls permissions..."

  psql -v ON_ERROR_STOP=1 \
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

echo "  [demo] finish demo data migration..."
