#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IS_RESTORE_DEMO="false"
IS_FIX_CONNECTIONS_DISABLED="false"
IS_FIX_CRYPTO_KEY_DISABLED="false"
RESTORE_FILE="/tmp/datalens_db.dump"

# parse args
for _ in "$@"; do
  case ${1} in
  --disable-fix-connections)
    IS_FIX_CONNECTIONS_DISABLED="true"
    shift # past argument with no value
    ;;
  --disable-fix-crypto-key)
    IS_FIX_CRYPTO_KEY_DISABLED="true"
    shift # past argument with no value
    ;;
  --demo)
    IS_RESTORE_DEMO="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

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

RESTORE_ARGS=""
if [ "${IS_FIX_CONNECTIONS_DISABLED}" != "true" ]; then
  RESTORE_ARGS="${RESTORE_ARGS} --fix-connections"
fi
if [ "${IS_FIX_CRYPTO_KEY_DISABLED}" != "true" ]; then
  RESTORE_ARGS="${RESTORE_ARGS} --fix-crypto-key"
fi
if [ "${IS_RESTORE_DEMO}" == "true" ]; then
  RESTORE_ARGS="${RESTORE_ARGS} --demo"
fi

docker --log-level error compose exec postgres /init/us-restore.sh --root-user ${RESTORE_ARGS}

EXIT="$?"

if [ "${EXIT}" != "0" ]; then
  echo "Restore error, exit..."
  exit "${EXIT}"
else
  echo "Restore success..."
  echo ""
fi

echo "Restart UnitedStorage service..."
docker --log-level error compose restart us
