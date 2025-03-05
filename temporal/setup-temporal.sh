#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo "  [temporal-setup] start temporal setup..."
echo "  [temporal-setup] postgres host: ${POSTGRES_HOST}"
echo "  [temporal-setup] postgres port: ${POSTGRES_PORT}"
echo "  [temporal-setup] postgres user: ${POSTGRES_USER}"
echo "  [temporal-setup] postgres temporal database: ${POSTGRES_DB}"
echo "  [temporal-setup] postgres temporal visibility database: ${POSTGRES_DB_VISIBILITY}"

echo "  [temporal-setup] waiting postgres to start..."

export PGPASSWORD="${POSTGRES_PASSWORD}"

RETRIES="10"

for RETRY in $(seq 1 $RETRIES); do
  if pg_isready --quiet -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -t 10; then
    echo "  [temporal-setup] postgres server is available, continue..."
    break
  fi
  sleep 1
done

if [ "${RETRY}" == "${RETRIES}" ]; then
  echo "  [temporal-setup] postgres server is not available, exit..."
  exit 1
fi

export SQL_PASSWORD="${POSTGRES_PASSWORD}"

echo "  [temporal-setup] setup initial temporal schema"
temporal-sql-tool \
  --plugin "${DB}" \
  --endpoint "${POSTGRES_HOST}" \
  --user "${POSTGRES_USER}" \
  --port "${POSTGRES_PORT}" \
  --database "${POSTGRES_DB}" \
  --connect-attributes "${POSTGRES_CONNECT_ATTRIBUTES}" \
  --tls="${POSTGRES_TLS_ENABLED}" \
  --tls-disable-host-verification="${POSTGRES_TLS_DISABLE_HOST_VERIFICATION}" \
  setup-schema -v 0.0

echo "  [temporal-setup] update temporal schema"
temporal-sql-tool \
  --plugin postgres12 \
  --endpoint "${POSTGRES_HOST}" \
  --user "${POSTGRES_USER}" \
  --port "${POSTGRES_PORT}" \
  --database "${POSTGRES_DB}" \
  --connect-attributes "${POSTGRES_CONNECT_ATTRIBUTES}" \
  --tls="${POSTGRES_TLS_ENABLED}" \
  --tls-disable-host-verification="${POSTGRES_TLS_DISABLE_HOST_VERIFICATION}" \
  update-schema -d /etc/temporal/schema/temporal

echo "  [temporal-setup] setup initial temporal visibility schema"
temporal-sql-tool \
  --plugin "${DB}" \
  --endpoint "${POSTGRES_HOST}" \
  --user "${POSTGRES_USER}" \
  --port "${POSTGRES_PORT}" \
  --database "${POSTGRES_DB_VISIBILITY}" \
  --connect-attributes "${POSTGRES_CONNECT_ATTRIBUTES}" \
  --tls="${POSTGRES_TLS_ENABLED}" \
  --tls-disable-host-verification="${POSTGRES_TLS_DISABLE_HOST_VERIFICATION}" \
  setup-schema -v 0.0

echo "  [temporal-setup] update temporal visibility schema"
temporal-sql-tool \
  --plugin postgres12 \
  --endpoint "${POSTGRES_HOST}" \
  --user "${POSTGRES_USER}" \
  --port "${POSTGRES_PORT}" \
  --database "${POSTGRES_DB_VISIBILITY}" \
  --connect-attributes "${POSTGRES_CONNECT_ATTRIBUTES}" \
  --tls="${POSTGRES_TLS_ENABLED}" \
  --tls-disable-host-verification="${POSTGRES_TLS_DISABLE_HOST_VERIFICATION}" \
  update-schema -d /etc/temporal/schema/visibility

/etc/temporal/init-namespaces.sh &

echo "  [temporal-setup] finish temporal setup..."
