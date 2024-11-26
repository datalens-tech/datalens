#!/bin/bash
set -e

export PGPASSWORD="${POSTGRES_PASSWORD}"

psql -v ON_ERROR_STOP=1 --host="$POSTGRES_HOST" --port="$POSTGRES_PORT" --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" </init/demo-data.sql
