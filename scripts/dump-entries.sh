#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo ""
echo "Start dump UnitedStorage tables:"
echo "  - workbooks"
echo "  - collections"
echo "  - entries"
echo "  - revisions"
echo "  - links"
echo ""

docker compose -f docker-compose.yml exec -T postgres pg_dump --inserts --on-conflict-do-nothing -Fc -a \
  --table entries \
  --table revisions \
  --table workbooks \
  --table collections \
  --table links \
  -U pg-us-user pg-us-db 2>/dev/null >./datalens_db.dump || echo "Dump error, exit..."

echo ""
echo "Dump done, saved at [./datalens_db.dump]"
