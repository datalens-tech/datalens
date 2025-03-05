#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

ENV_FILE_PATH=".env"

IS_HC_ENABLED="false"
IS_YANDEX_MAP_ENABLED="false"
IS_DEMO_ENABLED="true"
IS_UP="false"

YANDEX_MAP_TOKEN=""

# parse args
for _ in "$@"; do
  case ${1} in
  --hc)
    IS_HC_ENABLED="true"
    shift # past argument with no value
    ;;
  --yandex-map)
    IS_YANDEX_MAP_ENABLED="true"
    shift # past argument with no value
    break
    ;;
  --yandex-map-token)
    export YANDEX_MAP_TOKEN="${2}"
    shift # past argument
    shift # past value
    break
    ;;
  --disable-demo)
    IS_DEMO_ENABLED="false"
    shift # past argument with no value
    ;;
  --up)
    IS_UP="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

load_env() {
  set -a
  # shellcheck source=./.env
  # shellcheck disable=SC1091
  [ -f "${ENV_FILE_PATH}" ] && source "${ENV_FILE_PATH}"
  set +a
}

get_env() {
  if grep -v "^#" "${ENV_FILE_PATH}" 2>/dev/null | grep -q -s "${1}="; then
    ENV_VAL=$(grep -v "^#" "${ENV_FILE_PATH}" | grep "${1}=" | sed "s|${1}=||" | tr -d ' ')
    echo "$ENV_VAL"
  fi
  return 0
}

write_env() {
  # shellcheck disable=SC2236
  if [ ! -z "$(get_env "$1")" ]; then
    if [ "$3" == "force" ]; then
      ENV_CONTENT=$(cat "${ENV_FILE_PATH}")
      echo "$ENV_CONTENT" | grep -v "${1}=" >"${ENV_FILE_PATH}"
      echo "${1}=${2}" >>"${ENV_FILE_PATH}"
    fi
    return 0
  else
    echo "${1}=${2}" >>"${ENV_FILE_PATH}"
  fi
  return 0
}

remove_env() {
  # shellcheck disable=SC2236
  if [ ! -z "$(get_env "$1")" ]; then
    ENV_CONTENT=$(cat "${ENV_FILE_PATH}")
    echo "$ENV_CONTENT" | grep -v "${1}=" >"${ENV_FILE_PATH}"
  fi
  return 0
}

gen_sec() {
  ENV_KEY=$1
  ENV_LENGTH=$2
  FORMAT=$3

  if [ "${FORMAT}" == "base64" ]; then
    # shellcheck disable=SC2086
    PASS=$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH} | openssl base64)
    write_env "${ENV_KEY}" "\"${PASS}\""
  elif [ "${FORMAT}" == "rsa" ]; then
    PRIVATE=$(openssl genpkey -algorithm RSA -pkeyopt "rsa_keygen_bits:${ENV_LENGTH}" 2>/dev/null)
    PUBLIC=$(echo "${PRIVATE}" | openssl rsa -pubout 2>/dev/null | sed 's|$|\\n|' | tr -d '\n')
    PRIVATE=$(echo "${PRIVATE}" | sed 's|$|\\n|' | tr -d '\n')
    write_env "${ENV_KEY}_PRIVATE_KEY" "\"${PRIVATE}\""
    write_env "${ENV_KEY}_PUBLIC_KEY" "\"${PUBLIC}\""
  else
    # shellcheck disable=SC2086
    PASS="$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH})"
    write_env "${ENV_KEY}" "${PASS}"
  fi
}

echo ""
echo "Init auto production docker compose file generator..."

echo
echo "Load env file..."
echo "  file: ${ENV_FILE_PATH}"
load_env

echo ""
echo "Additional script args:"
echo "  --hc - enable HighCharts lib"
echo "  --ymap - enable Yandex Map visualization type"
echo "  --disable-demo - disable demo data init"

echo ""
echo "Generate secrets..."
echo "  - POSTGRES_PASSWORD"
gen_sec POSTGRES_PASSWORD 32
echo "  - US_MASTER_TOKEN"
gen_sec US_MASTER_TOKEN 32
echo "  - CONTROL_API_CRYPTO_KEY"
gen_sec CONTROL_API_CRYPTO_KEY 32 base64

if [ "${IS_HC_ENABLED}" == "true" ]; then
  export HC="1"
  write_env HC "1"
fi

if [ "${IS_YANDEX_MAP_ENABLED}" == "true" ]; then
  export YANDEX_MAP_ENABLED="1"
  write_env YANDEX_MAP_ENABLED "1"
  write_env YANDEX_MAP_TOKEN "${YANDEX_MAP_TOKEN}"
fi

if [ "${IS_DEMO_ENABLED}" != "true" ]; then
  export INIT_DEMO_DATA="0"
  write_env INIT_DEMO_DATA "0"
fi

echo ""
echo "Generate docker compose config to [docker-compose.production.yml] file..."

docker --log-level error compose -f docker-compose.yml config >docker-compose.production.yml

if [ "${IS_UP}" == "true" ]; then
  echo ""
  echo "Up production compose file..."
  docker --log-level error compose -f docker-compose.production.yml up -d
fi

echo ""
echo "Secrets and variables saved to [${ENV_FILE_PATH}] file..."
echo ""
