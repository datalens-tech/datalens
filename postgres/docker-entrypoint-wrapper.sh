#!/bin/bash

set -eo pipefail

if [ "${1:0:1}" = '-' ]; then
  set -- postgres "$@"
fi

if [ "$1" = 'postgres' ]; then
  set -- "$@" -c "max_connections=${POSTGRES_MAX_CONNECTIONS:-200}"
fi

exec /usr/local/bin/docker-entrypoint.sh "$@"
