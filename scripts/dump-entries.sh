#!/bin/bash

# chmod +x ./scripts/dump-entries.sh
# ./scripts/dump-entries.sh

get_docker_compose_command() {
  if command -v docker-compose &>/dev/null; then
    echo "docker-compose"
    return 0
  elif command -v docker compose &>/dev/null; then
    echo "docker compose"
    return 0
  else
    echo "Compose plugin for docker is not installed. e.g. sudo apt install docker-compose-plugin" >/dev/stderr
    exit 1
  fi
}

mkdir -p ./backup

echo "Start dump tables: workbooks, collections, entries, revisions, links..."

$(get_docker_compose_command) -f docker-compose.yml exec -T pg-us pg_dump --inserts --on-conflict-do-nothing -Fc -a \
  --table entries \
  --table revisions \
  --table workbooks \
  --table collections \
  --table links \
  -U us us-db-ci_purgeable 2>/dev/null >./backup/pg_us_open_source_db.dump || echo "Dump error, exit..."

echo "Dump done, saved at [./backup/pg_us_open_source_db.dump]"
