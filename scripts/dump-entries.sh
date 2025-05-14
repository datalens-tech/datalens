#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo ""
echo "Start dump UnitedStorage entries..."
echo "  - workbooks"
echo "  - collections"
echo "  - entries"
echo "  - revisions"
echo "  - links"

DUMP_FILE="${1}"

if [ -z "${DUMP_FILE}" ]; then
  DUMP_FILE="./datalens_db.dump"
fi

if docker compose ps --services postgres | grep -q -s postgres; then
  docker --log-level error compose exec -T postgres /init/us-dump.sh >"${DUMP_FILE}"
else
  echo ""
  echo "Running dump command for external PostgreSQL..."
  echo ""
  docker --log-level error compose run -T --rm --entrypoint /init/us-dump.sh postgres >"${DUMP_FILE}"
fi

EXIT="$?"

echo ""

if [ "${EXIT}" != "0" ]; then
  echo "Dump error, exit..."
  exit "${EXIT}"
else
  echo ""
  echo "Dump done, saved at [${DUMP_FILE}]"
  exit 0
fi
