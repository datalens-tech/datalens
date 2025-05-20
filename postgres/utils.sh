#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IS_ROOT_USER="false"
IS_RESET_ADMIN_PASSWORD="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --reset-admin-password)
    IS_RESET_ADMIN_PASSWORD="true"
    shift # past argument with no value
    ;;
  --root-user)
    IS_ROOT_USER="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo ""
echo "PostgreSQL DataLens utils..."

if [ -z "${POSTGRES_HOST}" ]; then POSTGRES_HOST="localhost"; fi
if [ -z "${POSTGRES_PORT}" ]; then POSTGRES_PORT="5432"; fi

if [ -z "${POSTGRES_USER_AUTH}" ]; then POSTGRES_USER_AUTH="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_AUTH}" ]; then POSTGRES_PASSWORD_AUTH="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi

if [ "${IS_ROOT_USER}" == "true" ]; then
  POSTGRES_USER_AUTH="${POSTGRES_USER}"
  POSTGRES_PASSWORD_AUTH="${POSTGRES_PASSWORD}"
  POSTGRES_USER_US="${POSTGRES_USER}"
  POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"
fi

if [ "${IS_RESET_ADMIN_PASSWORD}" == "true" ]; then
  export PGPASSWORD="${POSTGRES_PASSWORD_AUTH}"

  echo "  reset admin password..."

  PASSWORD_LENGTH=32

  PASSWORD_VALUE=$(openssl rand -base64 "${PASSWORD_LENGTH}" | tr -dc a-zA-Z0-9 | head -c "${PASSWORD_LENGTH}")

  SALT=$(openssl rand 16)
  SALT_HEX=$(echo -n "${SALT}" | od -A n -t x1 -v | tr -d ' \n')
  SALT_BASE64URL=$(echo -n "${SALT}" | openssl enc -base64 -A | tr '+/' '-_' | tr -d '=')

  echo "  new admin password: ${PASSWORD_VALUE}"

  KEY_LENGTH=64
  COST_ITERATIONS=16384
  BLOCK_SIZE=8
  PARALLELIZATION=1
  MAX_MEMORY_BYTES=33554432

  KEY_BASE64URL=$(
    openssl kdf -keylen "${KEY_LENGTH}" \
      -kdfopt "pass:${PASSWORD_VALUE}" -kdfopt "hexsalt:${SALT_HEX}" \
      -kdfopt "n:${COST_ITERATIONS}" -kdfopt "r:${BLOCK_SIZE}" -kdfopt "p:${PARALLELIZATION}" \
      -kdfopt "maxmem_bytes:${MAX_MEMORY_BYTES}" \
      -binary scrypt | openssl enc -base64 -A | tr '+/' '-_' | tr -d '='
  )

  PASSWORD_HASH="${SALT_BASE64URL}:${KEY_BASE64URL}"

  psql \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_AUTH}" \
    --dbname "${POSTGRES_DB_AUTH}" <<-EOSQL
  UPDATE auth_users SET password = '${PASSWORD_HASH}' WHERE login = 'admin';
EOSQL
  exit 0
fi
