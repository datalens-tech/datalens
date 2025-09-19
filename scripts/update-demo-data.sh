#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

IS_CLEAR_DELETED="false"
IS_CLEAR_REVISIONS="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --hc)
    HC="true"
    shift # past argument with no value
    ;;
  --clear-deleted)
    IS_CLEAR_DELETED="true"
    shift # past argument with no value
    ;;
  --clear-revisions)
    IS_CLEAR_REVISIONS="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo ""
echo "Start dump UnitedStorage entries..."
echo "  - workbooks"
echo "  - collections"
echo "  - entries"
echo "  - revisions"
echo "  - links"

DEMO_FILE="us-d3-data.sql"
if [ "${HC}" == "1" ] || [ "${HC}" == "true" ]; then
  HC="true"
  DEMO_FILE="us-hc-data.sql"
fi

COMPOSE_FILE=$(readlink -f "${SCRIPT_DIR}/../docker-compose.yaml")
DUMP_FILE=$(readlink -f "${SCRIPT_DIR}/../postgres/demo-data/${DEMO_FILE}")

echo "  hc: ${HC}"
echo "  dump file: ${DUMP_FILE}"

if [ "${IS_CLEAR_DELETED}" = "true" ]; then
  echo "+ clear deleted entries automatically..."
fi
if [ "${IS_CLEAR_REVISIONS}" = "true" ]; then
  echo "+ clear not actual entries revisions automatically..."
fi

echo ""
echo "========================"

echo "BEGIN;" >"${DUMP_FILE}"

docker --log-level error compose -f "${COMPOSE_FILE}" exec \
  --env "POSTGRES_DUMP_CLEAR_META=true" \
  --env "POSTGRES_DUMP_SKIP_CONFLICT=true" \
  -T postgres \
  /init/us-dump.sh |
  sed -E 's|"cypher_text": "[^"]+"|"cypher_text": "{{POSTGRES_PASSWORD}}"|' |
  sed -E 's|"host": "[^"]+"|"host": "{{POSTGRES_HOST}}"|' |
  sed -E 's|"port": [^,]+,|"port": {{POSTGRES_PORT}},|' |
  sed -E 's|"db_name": "[^"]+"|"db_name": "{{POSTGRES_DB}}"|' |
  sed -E 's|"username": "[^"]+"|"username": "{{POSTGRES_USER}}"|' \
    >>"${DUMP_FILE}"

EXIT="$?"

echo "COMMIT;" >>"${DUMP_FILE}"

echo ""
echo "========================"

if [ "${IS_CLEAR_DELETED}" = "true" ]; then
  echo ""
  echo "Clear deleted entries..."

  DUMP=$(cat "${DUMP_FILE}")
  DELETED_ENTRIES=$(
    echo "${DUMP}" |
      { grep ' public.entries ' || true; } |
      { grep '__trash/' || true; } |
      { grep -oE '__trash/[0-9]+_' || true; } |
      sed 's|__trash/||' |
      sed 's|_||' |
      tr -d ' ' |
      sort |
      uniq
  )

  IFS=$'\n'
  for DELETED_ENTRY in ${DELETED_ENTRIES}; do
    echo "  clear deleted entry: ${DELETED_ENTRY}"
    DUMP=$(echo "${DUMP}" | { grep -v ", ${DELETED_ENTRY}, " || true; } | { grep -v "(${DELETED_ENTRY}, " || true; })
  done
  unset IFS

  echo "${DUMP}" >"${DUMP_FILE}"
fi

if [ "${IS_CLEAR_REVISIONS}" = "true" ]; then
  echo ""
  echo "Clear not actual revisions..."

  DUMP=$(cat "${DUMP_FILE}")
  ENTRIES=$(
    echo "${DUMP}" |
      grep ' public.entries ' |
      grep -oE ", '[0-9]+/" |
      sed "s|, '||" |
      sed 's|/||' |
      tr -d ' ' |
      sort |
      uniq
  )

  IFS=$'\n'
  for ENTRY in ${ENTRIES}; do
    echo "  entry: ${ENTRY}"
    REVISIONS=$(echo "${DUMP}" | { grep " public.revisions " || true; } | { grep ", ${ENTRY}, " || true; } | sed 's|INSERT INTO public.revisions .*VALUES|VALUES|' | sed "s|''||g" | sed -E "s|VALUES \('[^']+',||")
    REVISIONS_COUNT=$(echo "${REVISIONS}" | wc -l | tr -d ' ')
    echo "  revisions count: ${REVISIONS_COUNT}"

    if [ "${REVISIONS_COUNT}" == "0" ] || [ "${REVISIONS_COUNT}" == "1" ]; then
      continue
    fi
    echo "  clear revisions..."
    for REVISION in ${REVISIONS}; do
      REVISION_ID=$(echo "${REVISION}" | { grep -oE ", [0-9]+," || true; } | sed 's|,||g' | tr -d ' ')

      ENTRY_REVISION=$(echo "${DUMP}" | { grep ' public.entries ' || true; } | { grep ", ${REVISION_ID}, " || true; } | tr -d ' ')
      if [ ! -z "${ENTRY_REVISION}" ]; then
        echo "  actual revision id: ${REVISION_ID}"
        continue
      fi

      echo "  clear revision id: ${REVISION_ID}"
      DUMP=$(echo "${DUMP}" | { grep -v ", ${REVISION_ID}, " || true; })
    done
  done
  unset IFS

  echo "${DUMP}" >"${DUMP_FILE}"
fi

DELETED_ENTRIES=$(cat "${DUMP_FILE}" | { grep "__trash/" || true; })

if [ -n "${DELETED_ENTRIES}" ]; then
  ENTRIES_KEYS=$(echo "${DELETED_ENTRIES}" | sed -E "s|INSERT INTO ([^ ]+) .*'([^']*__trash/[^']*)'.*|\1 - \2|" | sed 's|^|  - |')

  echo ""
  echo "⚠️ WARNING: Found deleted entries:" >&2
  echo "${ENTRIES_KEYS}" >&2
fi

# remove empty lines
sed '/^$/N;/^\n$/D' "${DUMP_FILE}" >"${DUMP_FILE}.tmp" && mv "${DUMP_FILE}.tmp" "${DUMP_FILE}"

if [ "${EXIT}" != "0" ]; then
  echo "Dump error, exit..."
  exit "${EXIT}"
else
  echo ""
  echo "Demo data dump done, saved at [${DUMP_FILE}]"
  exit 0
fi
