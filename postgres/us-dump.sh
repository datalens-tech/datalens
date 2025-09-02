#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo "" >&2
echo "Start dump UnitedStorage entries..." >&2

if [ -z "${POSTGRES_HOST}" ]; then POSTGRES_HOST="localhost"; fi
if [ -z "${POSTGRES_PORT}" ]; then POSTGRES_PORT="5432"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi
if [ -z "${POSTGRES_DUMP_FORMAT}" ]; then POSTGRES_DUMP_FORMAT="custom"; fi

POSTGRES_DUMP_ARGS=""
if [ -z "${POSTGRES_DUMP_ARGS}" ]; then
  POSTGRES_DUMP_ARGS=""
fi
if [ "${POSTGRES_DUMP_SKIP_CONFLICT}" == "true" ] || [ "${POSTGRES_DUMP_SKIP_CONFLICT}" == "1" ]; then
  POSTGRES_DUMP_ARGS="${POSTGRES_DUMP_ARGS} --on-conflict-do-nothing"
fi

export PGPASSWORD="${POSTGRES_PASSWORD_US}"

echo "Checking for e2e-entry in keys..." >&2
E2E_ENTRIES=$(psql \
  --host "${POSTGRES_HOST}" \
  --port "${POSTGRES_PORT}" \
  --username "${POSTGRES_USER_US}" \
  --dbname "${POSTGRES_DB_US}" \
  -t \
  -c "SELECT key FROM entries WHERE key LIKE '%e2e-entry%' AND key NOT LIKE '%__trash/%';")

if [ -n "$E2E_ENTRIES" ]; then
  echo "WARNING: Found keys containing 'e2e-entry':" >&2
  echo "$E2E_ENTRIES" >&2
  echo "These entries might be test entries and should be delete before dump create." >&2
fi

if [ "${POSTGRES_DUMP_CLEAR_META}" == "true" ] || [ "${POSTGRES_DUMP_CLEAR_META}" == "1" ]; then
  POSTGRES_DUMP_FORMAT="plain"
  # shellcheck disable=SC2086
  pg_dump \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" \
    --inserts \
    --column-inserts \
    --format "${POSTGRES_DUMP_FORMAT}" \
    --data-only \
    --table entries \
    --table revisions \
    --table workbooks \
    --table collections \
    --table links \
    ${POSTGRES_DUMP_ARGS} | grep -Ev "^(--|SET|SELECT pg_catalog.set_config|pg_dump:|\\\\restrict|\\\\unrestrict)"
else
  # shellcheck disable=SC2086
  pg_dump \
    --host "${POSTGRES_HOST}" \
    --port "${POSTGRES_PORT}" \
    --username "${POSTGRES_USER_US}" \
    --dbname "${POSTGRES_DB_US}" \
    --inserts \
    --column-inserts \
    --format "${POSTGRES_DUMP_FORMAT}" \
    --data-only \
    --table entries \
    --table revisions \
    --table workbooks \
    --table collections \
    --table links \
    ${POSTGRES_DUMP_ARGS}
fi
