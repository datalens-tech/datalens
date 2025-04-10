#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

export POSTGRES_SEEDS="${POSTGRES_HOST}"
export DB_PORT="${POSTGRES_PORT}"
export DBNAME="${POSTGRES_DB}"
export VISIBILITY_DBNAME="${POSTGRES_DB_VISIBILITY}"
export POSTGRES_PWD="${POSTGRES_PASSWORD}"

HOSTNAME="$(hostname)"

BIND_ON_IP=$(getent hosts "${HOSTNAME}" | cut -d ' ' -f 1)
export BIND_ON_IP
echo "[temporal] bind on ip: ${BIND_ON_IP}"

if [ "${BIND_ON_IP}" == "0.0.0.0" ] || [ "${BIND_ON_IP}" == "::0" ]; then
  export TEMPORAL_BROADCAST_ADDRESS="${BIND_ON_IP}"
fi
echo "[temporal] broadcast address: ${TEMPORAL_BROADCAST_ADDRESS}"

if [ -z "${TEMPORAL_ADDRESS}" ]; then
  if echo "$BIND_ON_IP" | grep -q -s ":"; then
    # ipv6
    export TEMPORAL_ADDRESS="[${BIND_ON_IP}]:${TEMPORAL_PORT}"
  else
    # ipv4
    export TEMPORAL_ADDRESS="${BIND_ON_IP}:${TEMPORAL_PORT}"
  fi
fi
echo "[temporal] address: ${TEMPORAL_ADDRESS}"

if [ -z "${TEMPORAL_CLI_ADDRESS}" ]; then
  export TEMPORAL_CLI_ADDRESS="${TEMPORAL_ADDRESS}"
fi

dockerize -template /etc/temporal/config/config_template.yaml:/etc/temporal/config/docker.yaml

/etc/temporal/setup-temporal.sh

exec /etc/temporal/start-temporal.sh
