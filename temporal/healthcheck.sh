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

if [ "${TEMPORAL_AUTH_ENABLED}" == "true" ]; then
  echo "[temporal] auth enabled, preparing jwt token for healthcheck..."

  HEADER='{"alg":"RS256","typ":"JWT","kid":"temporal"}'
  PAYLOAD='{"sub":"admin","iat":'$(date +%s)',"permissions":["temporal-system:admin"]}'

  HEADER_BASE64URL=$(echo -n "${HEADER}" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')
  PAYLOAD_BASE64URL=$(echo -n "${PAYLOAD}" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')
  UNSIGNED_JWT="${HEADER_BASE64URL}.${PAYLOAD_BASE64URL}"

  PRIVATE_KEY_FILE="/tmp/temporal-auth-private-key-${RANDOM}.pem"
  # shellcheck disable=SC2001
  echo "${TEMPORAL_AUTH_PRIVATE_KEY}" | sed 's|\\n|\n|g' >"${PRIVATE_KEY_FILE}"
  SIGN_JWT=$(
    echo -n "${UNSIGNED_JWT}" |
      openssl dgst -sha256 -sign "${PRIVATE_KEY_FILE}" |
      openssl enc -base64 -A |
      tr '+/' '-_' |
      tr -d '='
  )
  rm -rf "${PRIVATE_KEY_FILE}"

  TEMPORAL_AUTH_TOKEN="${UNSIGNED_JWT}.${SIGN_JWT}"
fi

# check temporal
if ! temporal operator cluster health --api-key "${TEMPORAL_AUTH_TOKEN}" | grep -q -s SERVING; then
  echo "[temporal-healthcheck] temporal cluster is not ready, exit..."
  exit 1
fi

# check temporal namespaces
IFS=',' read -ra INIT_NAMESPACES <<<"${NAMESPACES}"

for NS in "${INIT_NAMESPACES[@]}"; do
  if ! temporal operator namespace describe -n "${NS}" --api-key "${TEMPORAL_AUTH_TOKEN}" >/dev/null; then
    echo "[temporal-healthcheck] temporal namespace [${NS}] is not found, exit..."
    exit 1
  fi
done
