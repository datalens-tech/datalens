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

export SQL_PLUGIN="${DB}"
export SQL_HOST="${POSTGRES_HOST}"
export SQL_PORT="${POSTGRES_PORT}"
export SQL_USER="${POSTGRES_USER}"
export SQL_PASSWORD="${POSTGRES_PASSWORD}"

export SQL_TLS="${POSTGRES_TLS_ENABLED}"
export SQL_TLS_ENABLED="${POSTGRES_TLS_ENABLED}"
export SQL_TLS_DISABLE_HOST_VERIFICATION="${POSTGRES_TLS_DISABLE_HOST_VERIFICATION}"
if [ -n "${POSTGRES_TLS_CA_FILE}" ]; then
  export SQL_TLS_CA_FILE="${POSTGRES_TLS_CA_FILE}"
fi

if [ -z "${BIND_ON_IP}" ]; then
  HOSTNAME="$(hostname)"
  BIND_ON_IP=$(getent hosts "${HOSTNAME}" | cut -d ' ' -f 1)
  export BIND_ON_IP
fi

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

echo "[temporal] start temp temporal server..."

/etc/temporal/start-temporal.sh &
PID=$!
/etc/temporal/init-namespaces.sh

echo "[temporal] stop temp temporal server..."
kill $PID
wait $PID

if [ "${TEMPORAL_AUTH_ENABLED}" == "true" ]; then
  echo "[temporal] auth enabled, preparing jwks..."

  export TEMPORAL_AUTH_AUTHORIZER="default"
  export TEMPORAL_AUTH_CLAIM_MAPPER="default"
  export TEMPORAL_JWT_KEY_SOURCE1="http://localhost:8080/.well-known/jwks.json"
  export SERVICES="frontend:history:matching:worker:internal-frontend"
  export USE_INTERNAL_FRONTEND="1"

  JWKS_DATA=$(/etc/temporal/setup-auth-jwks.sh)

  while true; do (
    echo -e 'HTTP/1.1 200 OK\r\n'
    echo -e "${JWKS_DATA}"
  ) | nc -lp 8080 &>/dev/null; done &
fi

dockerize -template /etc/temporal/config/config_template.yaml:/etc/temporal/config/docker.yaml

exec /etc/temporal/start-temporal.sh
