#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ -z "${POSTGRES_HOST}" ]; then POSTGRES_HOST="localhost"; fi
if [ -z "${POSTGRES_PORT}" ]; then POSTGRES_PORT="5432"; fi
if [ -z "${POSTGRES_USER_US}" ]; then POSTGRES_USER_US="${POSTGRES_USER}"; fi
if [ -z "${POSTGRES_PASSWORD_US}" ]; then POSTGRES_PASSWORD_US="${POSTGRES_PASSWORD}"; fi

export PGPASSWORD="${POSTGRES_PASSWORD_US}"

pg_dump \
  --host "${POSTGRES_HOST}" \
  --port "${POSTGRES_PORT}" \
  --username "${POSTGRES_USER_US}" \
  --dbname "${POSTGRES_DB_US}" \
  --inserts \
  --format c \
  --on-conflict-do-nothing \
  --data-only \
  --table entries \
  --table revisions \
  --table workbooks \
  --table collections \
  --table links 2>/tmp/us-dump.stderror.log
