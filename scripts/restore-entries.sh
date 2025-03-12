#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

RESTORE_FILE="${1}"

if [ -z "${RESTORE_FILE}" ]; then
  RESTORE_FILE="./datalens_db.dump"
fi

if [ -f "${RESTORE_FILE}" ]; then
  echo ""
  echo "Restore UnitedStorage tables from [${RESTORE_FILE}] dump file..."
  echo ""
else
  echo "Dump file [${RESTORE_FILE}] not found, exit..."
  exit 1
fi

docker --log-level error compose cp "${RESTORE_FILE}" "postgres:/tmp/datalens_db.dump"

echo ""

docker --log-level error compose exec --env "INIT_DEMO_DATA=${INIT_DEMO_DATA}" postgres /init/us-restore.sh --root-user

EXIT="$?"

if [ "${EXIT}" != "0" ]; then
  echo "Restore error, exit..."
  exit "${EXIT}"
else
  echo "Restore success..."
  echo ""
fi

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ]; then
  echo ""
  echo "Restart demo data service..."
  docker --log-level error compose up -d demo
  echo ""
fi

echo "Restart UnitedStorage service..."
docker --log-level error compose restart us
exit 0
