#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

HOSTNAME="$(hostname)"
BIND_ON_IP=$(getent hosts "${HOSTNAME}" | cut -d ' ' -f 1)

if [ -z "${TEMPORAL_ADDRESS}" ]; then
  if echo "$BIND_ON_IP" | grep -q -s ":"; then
    # ipv6
    export TEMPORAL_ADDRESS="[${BIND_ON_IP}]:${TEMPORAL_PORT}"
  else
    # ipv4
    export TEMPORAL_ADDRESS="${BIND_ON_IP}:${TEMPORAL_PORT}"
  fi
fi

# check postgres
export PGPASSWORD="${POSTGRES_PASSWORD}"
if ! pg_isready --quiet -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -t 10; then
  echo "[temporal-healthcheck] postgres cluster is not ready, exit..."
  exit 1
fi

# check temporal
if ! temporal operator cluster health | grep -q -s SERVING; then
  echo "[temporal-healthcheck] temporal cluster is not ready, exit..."
  exit 1
fi

# check temporal namespaces
IFS=',' read -ra INIT_NAMESPACES <<<"${NAMESPACES}"

for NS in "${INIT_NAMESPACES[@]}"; do
  if ! temporal operator namespace describe "${NS}"; then
    echo "[temporal-healthcheck] temporal namespace [${NS}] is not found, exit..."
    exit 1
  fi
done
