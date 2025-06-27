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
IS_AUTH_ENABLED="true"

IS_UP="false"
IS_HELP="false"

DOMAIN=""
IP=""
IS_HTTPS="false"

POSTGRES_CERT=""
IS_POSTGRES_EXTERNAL="false"
IS_POSTGRES_SSL="false"

IS_TEMPORAL_ENABLED="true"
IS_TEMPORAL_AUTH_ENABLED="true"
IS_WORKBOOK_EXPORT_ENABLED="true"

IS_RUN_INIT_DEMO_DATA="false"

IS_LEGACY_DOCKER_COMPOSE="false"
IS_ALWAYS_IMAGE_PULL="true"

YANDEX_MAP_TOKEN=""

# parse args
for _ in "$@"; do
  case ${1} in
  --help)
    IS_HELP="true"
    shift # past argument with no value
    ;;
  --hc)
    IS_HC_ENABLED="true"
    shift # past argument with no value
    ;;
  --yandex-map)
    IS_YANDEX_MAP_ENABLED="true"
    shift # past argument with no value
    ;;
  --yandex-map-token)
    export YANDEX_MAP_TOKEN="${2}"
    shift # past argument
    shift # past value
    ;;
  --demo)
    IS_RUN_INIT_DEMO_DATA="true"
    shift # past argument with no value
    ;;
  --disable-demo)
    IS_DEMO_ENABLED="false"
    shift # past argument with no value
    ;;
  --disable-workbook-export)
    IS_WORKBOOK_EXPORT_ENABLED="false"
    shift # past argument with no value
    ;;
  --disable-always-image-pull)
    IS_ALWAYS_IMAGE_PULL="false"
    shift # past argument with no value
    ;;
  --disable-auth)
    IS_AUTH_ENABLED="false"
    shift # past argument with no value
    ;;
  --disable-temporal)
    IS_TEMPORAL_ENABLED="false"
    IS_WORKBOOK_EXPORT_ENABLED="false"
    shift # past argument with no value
    ;;
  --disable-temporal-auth)
    IS_TEMPORAL_AUTH_ENABLED="false"
    shift # past argument with no value
    ;;
  --postgres-external)
    IS_POSTGRES_EXTERNAL="true"
    shift # past argument with no value
    ;;
  --postgres-ssl)
    IS_POSTGRES_SSL="true"
    shift # past argument with no value
    ;;
  --postgres-cert)
    POSTGRES_CERT="${2}"
    shift # past argument
    shift # past value
    ;;
  --ip)
    IP="${2}"
    shift # past argument
    shift # past value
    ;;
  --domain)
    DOMAIN="${2}"
    shift # past argument
    shift # past value
    ;;
  --https)
    IS_HTTPS="true"
    shift # past argument with no value
    ;;
  --up)
    IS_UP="true"
    shift # past argument with no value
    ;;
  --legacy-docker-compose)
    IS_LEGACY_DOCKER_COMPOSE="true"
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
  if grep -v "^#" "${ENV_FILE_PATH}" 2>/dev/null | grep -q -s "^${1}="; then
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
    echo "$ENV_CONTENT" | grep -v "^${1}=" >"${ENV_FILE_PATH}"
  fi
  return 0
}

gen_sec() {
  ENV_KEY=$1
  ENV_LENGTH=$2
  FORMAT=$3

  if [ "${FORMAT}" == "base64" ]; then
    # shellcheck disable=SC2086
    PASS=$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH} | openssl enc -base64 -A)
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
echo "🚀 DataLens auto production Docker Compose file generator..."

if [ "${IS_HELP}" == "true" ]; then
  echo ""
  echo "Usage: ./init.sh [--hc] [--domain <domain>] [--https] [--disable-demo] [--disable-auth] [--up]"
  echo ""
  echo "  --hc - enable Highcharts library"
  echo "  --yandex-map - enable Yandex Maps visualization type"
  echo "  --yandex-map-token <token> - provide token for Yandex Maps API"
  echo "  --disable-demo - disable demo data initialization"
  echo "  --disable-workbook-export - disable workbook export to JSON feature"
  echo "  --disable-auth - disable authentication service"
  echo "  --disable-temporal - disable temporal workflow service"
  echo "  --disable-temporal-auth - disable JWT auth for temporal service"
  echo "  --disable-always-image-pull - disable always pull policy for images at deployment"
  echo "  --postgres-external - disable built-in PostgreSQL service"
  echo "  --postgres-ssl - set SSL mode to [verify-full] for PostgreSQL connection"
  echo "  --postgres-cert <path> - set path to SSL certificate file for PostgreSQL connection"
  echo "  --demo - run demo data initialization script for external PostgreSQL database"
  echo "  --ip <ip> - set custom ip address for deployment"
  echo "  --domain <domain> - set custom domain for deployment"
  echo "  --https - enable https mode for ui container endpoint"
  echo "  --up - automatically start services with production configuration"
  echo ""
  exit 0
fi

echo
echo "Loading environment file..."
echo "  file: ${ENV_FILE_PATH}"
load_env

echo ""
echo "Available script arguments:"
echo "  --hc - enable Highcharts library"
echo "  --yandex-map - enable Yandex Maps visualization type"
echo "  --yandex-map-token <token> - provide token for Yandex Maps API"
echo "  --disable-demo - disable demo data initialization"
echo "  --disable-workbook-export - disable workbook export to JSON feature"
echo "  --disable-auth - disable authentication service"
echo "  --disable-temporal - disable temporal workflow service"
echo "  --disable-temporal-auth - disable JWT auth for temporal service"
echo "  --disable-always-image-pull - disable always pull policy for images at deployment"
echo "  --postgres-external - disable built-in PostgreSQL service"
echo "  --postgres-ssl - set SSL mode to [verify-full] for PostgreSQL connection"
echo "  --postgres-cert <path> - set path to SSL certificate file for PostgreSQL connection"
echo "  --demo - run demo data initialization script for external PostgreSQL database"
echo "  --ip <ip> - set custom ip address for deployment"
echo "  --domain <domain> - set custom domain for deployment"
echo "  --https - enable https mode for ui container endpoint"
echo "  --up - automatically start services with production configuration"

echo ""
echo "Generating secrets..."
echo "  - POSTGRES_PASSWORD"
gen_sec POSTGRES_PASSWORD 32
echo "  - US_MASTER_TOKEN"
gen_sec US_MASTER_TOKEN 32
echo "  - CONTROL_API_CRYPTO_KEY"
gen_sec CONTROL_API_CRYPTO_KEY 32 base64

COMPOSE_UP_SERVICES="control-api data-api us ui"

if [ "${IS_POSTGRES_EXTERNAL}" != "true" ]; then
  COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} postgres"
fi

# shellcheck disable=SC2236
if [ ! -z "${POSTGRES_CERT}" ] && [ -f "${POSTGRES_CERT}" ]; then
  export POSTGRES_TLS_ENABLED="true"
  export POSTGRES_TLS_DISABLE_HOST_VERIFICATION="false"
  export POSTGRES_TLS_CA_FILE="/certs/postgres-ca.crt"
  export POSTGRES_ARGS="?sslmode=verify-full&sslrootcert=/certs/postgres-ca.crt"
  write_env POSTGRES_TLS_ENABLED "true"
  write_env POSTGRES_TLS_DISABLE_HOST_VERIFICATION "false"
  write_env POSTGRES_TLS_CA_FILE "/certs/postgres-ca.crt"
  write_env POSTGRES_ARGS "\"${POSTGRES_ARGS}\""
elif [ "${IS_POSTGRES_SSL}" == "true" ]; then
  export POSTGRES_TLS_ENABLED="true"
  export POSTGRES_TLS_DISABLE_HOST_VERIFICATION="false"
  export POSTGRES_ARGS="?sslmode=verify-full"
  write_env POSTGRES_TLS_ENABLED "true"
  write_env POSTGRES_TLS_DISABLE_HOST_VERIFICATION "false"
  write_env POSTGRES_ARGS "\"${POSTGRES_ARGS}\""
fi

if [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
  echo "  - EXPORT_DATA_VERIFICATION_KEY"
  gen_sec EXPORT_DATA_VERIFICATION_KEY 32
fi

if [ "${IS_TEMPORAL_ENABLED}" == "true" ] && [ "${IS_TEMPORAL_AUTH_ENABLED}" == "true" ]; then
  echo "  - TEMPORAL_AUTH [RSA 4096]"
  gen_sec TEMPORAL_AUTH 4096 rsa

  remove_env TEMPORAL_AUTH_ENABLED
  unset TEMPORAL_AUTH_ENABLED
else
  export TEMPORAL_AUTH_ENABLED="false"

  export TEMPORAL_AUTH_PUBLIC_KEY="-"
  export TEMPORAL_AUTH_PRIVATE_KEY="-"

  write_env TEMPORAL_AUTH_ENABLED "false"
fi

if [ "${IS_TEMPORAL_ENABLED}" == "true" ]; then
  COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} temporal"
fi

if [ "${IS_AUTH_ENABLED}" == "true" ]; then
  echo "  - AUTH_ADMIN_PASSWORD"
  gen_sec AUTH_ADMIN_PASSWORD 16
  echo "  - AUTH_MASTER_TOKEN"
  gen_sec AUTH_MASTER_TOKEN 32
  echo "  - AUTH_TOKEN [RSA 4096]"
  gen_sec AUTH_TOKEN 4096 rsa

  echo ""
  echo "Admin user password: $(get_env AUTH_ADMIN_PASSWORD)"

  remove_env AUTH_ENABLED
  remove_env AUTH_TYPE
  unset AUTH_ENABLED
  unset AUTH_TYPE

  COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} auth"
else
  export AUTH_ENABLED="false"
  export AUTH_TYPE="NONE"

  export AUTH_TOKEN_PUBLIC_KEY="-"
  export AUTH_TOKEN_PRIVATE_KEY="-"

  write_env AUTH_ENABLED "false"
  write_env AUTH_TYPE "NONE"
fi

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

if [ "${IS_WORKBOOK_EXPORT_ENABLED}" != "true" ]; then
  export EXPORT_WORKBOOK_ENABLED="0"
  write_env EXPORT_WORKBOOK_ENABLED "0"
else
  COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} meta-manager ui-api"
fi

# shellcheck disable=SC2236
if [ ! -z "${DOMAIN}" ]; then
  if [ "${IS_HTTPS}" == "true" ]; then
    UI_APP_ENDPOINT="https://${DOMAIN}"
  else
    UI_APP_ENDPOINT="http://${DOMAIN}"
  fi
elif [ ! -z "${IP}" ]; then
  if [ "${IS_HTTPS}" == "true" ]; then
    UI_APP_ENDPOINT="https://${IP}"
  else
    UI_APP_ENDPOINT="http://${IP}"
  fi
fi
# shellcheck disable=SC2236
if [ ! -z "${UI_APP_ENDPOINT}" ]; then
  write_env UI_APP_ENDPOINT "\"${UI_APP_ENDPOINT}\"" force
fi

if [ "${IS_ALWAYS_IMAGE_PULL}" != "true" ]; then
  export IMAGE_PULL_POLICY="missing"
fi

if [ "${IS_RUN_INIT_DEMO_DATA}" == "true" ]; then
  echo ""
  echo "Running demo data initialization for external PostgreSQL..."

  docker --log-level error compose run --rm --entrypoint /init/seed-demo-data.sh postgres

  exit 0
fi

echo ""
echo "Generating Docker Compose configuration to [docker-compose.production.yaml] file..."

cat docker-compose.yaml >docker-compose.tmp.yaml

if [ "${IS_POSTGRES_EXTERNAL}" == "true" ]; then
  COMPOSE_CONFIG=$(cat docker-compose.tmp.yaml)

  # shellcheck disable=SC2236
  if [ ! -z "${POSTGRES_CERT}" ] && [ -f "${POSTGRES_CERT}" ]; then
    # shellcheck disable=SC2001
    COMPOSE_CONFIG=$(echo "${COMPOSE_CONFIG}" | sed "s|    volumes: \[\]|    volumes:\n      - ${POSTGRES_CERT}:/certs/postgres-ca.crt|g")
  fi

  COMPOSE_CONFIG=$(echo "${COMPOSE_CONFIG}" |
    sed 's|$|_\\n_|g' | tr -d '\n' |
    sed 's|depends_on:_\\n_      postgres:_\\n_        condition: service_healthy_\\n_    ||g' |
    sed 's|_\\n_|\n|g')

  echo "${COMPOSE_CONFIG}" >docker-compose.tmp.yaml
fi

if [ "${IS_LEGACY_DOCKER_COMPOSE}" == "true" ]; then
  docker-compose -f docker-compose.tmp.yaml config >docker-compose.production.yaml
else
  # shellcheck disable=SC2086
  docker --log-level error compose -f docker-compose.tmp.yaml config ${COMPOSE_UP_SERVICES} >docker-compose.production.yaml
fi

rm -rf docker-compose.tmp.yaml

if [ "${IS_UP}" == "true" ]; then
  echo ""
  echo "Starting Docker Compose services with production configuration..."
  echo ""

  if [ "${IS_LEGACY_DOCKER_COMPOSE}" == "true" ]; then
    docker-compose -f docker-compose.production.yaml up --remove-orphans --detach
  else
    docker --log-level error compose -f docker-compose.production.yaml up --remove-orphans --detach
  fi
fi

echo ""
echo "Secrets and variables have been saved to [${ENV_FILE_PATH}] file."
echo ""
