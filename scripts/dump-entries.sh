#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo ""
echo "Dump UnitedStorage tables:"
echo "  - workbooks"
echo "  - collections"
echo "  - entries"
echo "  - revisions"
echo "  - links"
echo ""

docker --log-level error compose exec -T postgres sh -c 'pg_dump \
  --inserts \
  --format c \
  --on-conflict-do-nothing \
  --data-only \
  --table entries \
  --table revisions \
  --table workbooks \
  --table collections \
  --table links \
  --username ${POSTGRES_USER} ${POSTGRES_DB_US}' >./datalens_db.dump

EXIT="$?"

if [ "${EXIT}" != "0" ]; then
  echo "Dump error, exit..."
  exit "${EXIT}"
else
  echo ""
  echo "Dump done, saved at [./datalens_db.dump]"
  exit 0
fi
