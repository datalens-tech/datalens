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
IS_DOWN="false"
IS_STOP="false"
IS_HELP="false"
IS_AUTOCOMPLETE="false"

IS_DEV="false"
IS_DEV_ENV="false"
IS_DEV_BUILD="false"
IS_DEV_EXPOSE_PORTS="false"
IS_DEV_NGINX="false"
IS_DEV_ROOT="false"

IS_DEV_UI="false"
IS_DEV_UI_API="false"
IS_DEV_US="false"
IS_DEV_AUTH="false"
IS_DEV_META_MANAGER="false"
IS_DEV_CONTROL_API="false"
IS_DEV_DATA_API="false"

IS_REINIT_DB="false"

IS_UP_UI="true"
IS_UP_UI_API="true"
IS_UP_US="true"
IS_UP_AUTH="true"
IS_UP_META_MANAGER="true"
IS_UP_CONTROL_API="true"
IS_UP_DATA_API="true"

IS_RM_ENV="false"
IS_RM_VOLUMES="false"

DOMAIN=""
IP=""
IS_HTTPS="false"

IS_IPV6="false"
IS_DOCKER_IPV6="false"

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
  --autocomplete)
    IS_AUTOCOMPLETE="true"
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
    IS_UP_AUTH="false"
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
  --ipv6)
    export IS_IPV6="true"
    shift # past argument with no value
    ;;
  --docker-ipv6)
    IS_DOCKER_IPV6="true"
    shift # past argument with no value
    ;;
  --up)
    IS_UP="true"
    shift # past argument with no value
    ;;
  --down)
    IS_DOWN="true"
    shift # past argument with no value
    ;;
  --stop)
    IS_STOP="true"
    shift # past argument with no value
    ;;
  --dev)
    IS_DEV="true"
    shift # past argument with no value
    ;;
  --dev-env)
    IS_DEV_ENV="true"
    shift # past argument with no value
    ;;
  --dev-light)
    IS_DEV="true"
    IS_AUTH_ENABLED="false"
    IS_TEMPORAL_ENABLED="false"
    IS_WORKBOOK_EXPORT_ENABLED="false"
    shift # past argument with no value
    ;;
  --dev-build)
    IS_DEV_BUILD="true"
    shift # past argument with no value
    ;;
  --dev-expose-ports)
    IS_DEV_EXPOSE_PORTS="true"
    shift # past argument with no value
    ;;
  --dev-nginx)
    IS_DEV_NGINX="true"
    shift # past argument with no value
    ;;
  --dev-root)
    IS_DEV_ROOT="true"
    shift # past argument with no value
    ;;
  --dev-ui)
    IS_DEV="true"
    IS_DEV_UI="true"
    shift # past argument with no value
    ;;
  --dev-no-ui)
    IS_DEV="true"
    IS_UP_UI="false"
    shift # past argument with no value
    ;;
  --dev-ui-api)
    IS_DEV="true"
    IS_DEV_UI_API="true"
    shift # past argument with no value
    ;;
  --dev-no-ui-api)
    IS_DEV="true"
    IS_UP_UI_API="false"
    shift # past argument with no value
    ;;
  --dev-us)
    IS_DEV="true"
    IS_DEV_US="true"
    shift # past argument with no value
    ;;
  --dev-no-us)
    IS_DEV="true"
    IS_UP_US="false"
    shift # past argument with no value
    ;;
  --dev-auth)
    IS_DEV="true"
    IS_DEV_AUTH="true"
    shift # past argument with no value
    ;;
  --dev-no-auth)
    IS_DEV="true"
    IS_UP_AUTH="false"
    shift # past argument with no value
    ;;
  --dev-meta-manager)
    IS_DEV="true"
    IS_DEV_META_MANAGER="true"
    shift # past argument with no value
    ;;
  --dev-no-meta-manager)
    IS_DEV="true"
    IS_UP_META_MANAGER="false"
    shift # past argument with no value
    ;;
  --dev-control-api)
    IS_DEV="true"
    IS_DEV_CONTROL_API="true"
    shift # past argument with no value
    ;;
  --dev-no-control-api)
    IS_DEV="true"
    IS_UP_CONTROL_API="false"
    shift # past argument with no value
    ;;
  --dev-data-api)
    IS_DEV="true"
    IS_DEV_DATA_API="true"
    shift # past argument with no value
    ;;
  --dev-no-data-api)
    IS_DEV="true"
    IS_UP_DATA_API="false"
    shift # past argument with no value
    ;;
  --reinit-db)
    IS_REINIT_DB="true"
    shift # past argument with no value
    ;;
  --rm-env | --remove-env)
    IS_RM_ENV="true"
    shift # past argument with no value
    ;;
  --rm-volumes | --remove-volumes)
    IS_RM_VOLUMES="true"
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

init_autocomplete() {
  cat <<'EOF'
#!/bin/bash

_init_sh_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # all available options
    opts="--help --autocomplete --hc --yandex-map --yandex-map-token --demo --disable-demo --disable-workbook-export --disable-always-image-pull --disable-auth --disable-temporal --disable-temporal-auth --postgres-external --postgres-ssl --postgres-cert --ip --domain --https --ipv6 --docker-ipv6 --up --down --stop --dev --dev-env --dev-light --dev-build --dev-expose-ports --dev-nginx --dev-root --dev-ui --dev-no-ui --dev-ui-api --dev-no-ui-api --dev-us --dev-no-us --dev-auth --dev-no-auth --dev-meta-manager --dev-no-meta-manager --dev-control-api --dev-no-control-api --dev-data-api --dev-no-data-api --reinit-db --rm-env --remove-env --rm-volumes --remove-volumes --legacy-docker-compose"
    
    # handle options that require values
    case "${prev}" in
        --yandex-map-token|--postgres-cert|--ip|--domain)
            # these options require a value, don't suggest other options
            return 0
            ;;
        *)
            ;;
    esac
    
    # generate completions
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

# register the completion function
complete -F _init_sh_completions ./init.sh
complete -F _init_sh_completions init.sh

echo "🔋 Options completion for DataLens [init.sh] script has been loaded!"
EOF
}

if [ "${IS_AUTOCOMPLETE}" = "true" ]; then
  # shellcheck disable=SC1090
  source <(init_autocomplete)

  if ! return 0 2>/dev/null; then
    # shellcheck disable=SC2317
    echo "❌ Please enable autocomplete with (source ./init.sh --autocomplete)"
    # shellcheck disable=SC2317
    exit 0
  fi
fi

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

if [ "${IS_HELP}" != "true" ]; then
  echo ""
  echo "🚀 DataLens start initialization..."
else
  echo ""
  echo "🛟 DataLens init script help!"
fi

if [ "${IS_DEV}" == "true" ]; then
  echo ""
  echo "🚧 --- [DEV MODE] --- 🚧"
fi

if [ "${IS_HELP}" == "true" ]; then
  echo ""
  echo "Usage: ./init.sh [--hc] [--domain <domain>] [--https] [--disable-demo] [--disable-auth] [--up]"
  echo ""
  echo "General options:"
  echo "  --help - show this help message"
  echo "  --autocomplete - generate bash completion script, use: source ./init.sh --autocomplete"
  echo ""
  echo "Deployment options:"
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
  echo "Development mode options:"
  echo "  --dev - enable development mode"
  echo "  --dev-env - force use environment file in development mode"
  echo "  --dev-light - disable auth, temporal and workbook export for lighter development setup"
  echo "  --dev-build - rebuild development containers before starting"
  echo "  --dev-expose-ports - expose ports for all containers with socat"
  echo "  --dev-nginx - up nginx with https and self-signed certificates for development mode"
  echo "  --dev-root - run containers with [root] user for development mode, fix write access on linux systems"
  echo "  --dev-<service> - run [ui/ui-api/us/auth/meta-manager/control-api/data-api] service in development mode"
  echo "  --dev-no-<service> - disable up [ui/ui-api/us/auth/meta-manager/control-api/data-api] service"
  echo ""
  echo "Other options:"
  echo "  --reinit-db - force reinitialize database before start"
  echo "  --rm-env | --remove-env - remove environment file"
  echo "  --rm-volumes | --remove-volumes - remove all docker volumes"
  echo "  --ipv6 - enable IPv6 address binding for docker default network"
  echo "  --docker-ipv6 - auto fix docker IPv6 support for linux systems"
  echo "  --legacy-docker-compose - use legacy docker-compose command instead of docker compose"
  echo ""
  exit 0
fi

IS_USE_ENV_AND_SECRETS="false"
if [ "${IS_DEV}" != "true" ] || [ "${IS_DEV_ENV}" == "true" ]; then
  IS_USE_ENV_AND_SECRETS="true"
fi

if [ "${IS_USE_ENV_AND_SECRETS}" == "true" ]; then
  echo
  echo "Loading environment file..."
  echo "  file: ${ENV_FILE_PATH}"
  load_env
else
  echo
  echo "⚠️  Skip loading environment file..."
fi

if [ "${IS_REINIT_DB}" == "true" ]; then
  echo ""
  echo "♻️  Reinit database before start..."
  echo ""

  docker --log-level error compose rm --stop --force postgres us auth meta-manager
  docker --log-level error compose down --volumes postgres us auth meta-manager
fi

if [ "${IS_STOP}" == "true" ]; then
  echo ""
  echo "Stop application..."

  docker --log-level error compose --stop --force
  docker --log-level error compose -f docker-compose.dev.yaml rm --stop --force

  echo ""
  exit 0
fi

if [ "${IS_DOWN}" == "true" ]; then
  echo ""
  echo "Down application and remove containers..."

  docker --log-level error compose down --remove-orphans

  if [ "${IS_RM_ENV}" == "true" ]; then
    echo ""
    echo "Remove [${ENV_FILE_PATH}] file..."
    rm -rf "${ENV_FILE_PATH}"
  fi
  if [ "${IS_RM_VOLUMES}" == "true" ]; then
    echo ""
    echo "Remove all docker volumes..."
    if [ "${IS_DEV}" == "true" ]; then
      docker --log-level error compose -f docker-compose.dev.yaml down --remove-orphans --volumes
    else
      docker --log-level error compose down --remove-orphans --volumes
    fi
  fi
  echo ""
  exit 0
fi

if [ "${IS_USE_ENV_AND_SECRETS}" == "true" ]; then
  echo ""
  echo "🔐 Generating secrets..."
  echo "  - POSTGRES_PASSWORD"
  gen_sec POSTGRES_PASSWORD 32
  echo "  - US_MASTER_TOKEN"
  gen_sec US_MASTER_TOKEN 32
  echo "  - BI_DYNAMIC_US_AUTH [RSA 4096]"
  gen_sec BI_DYNAMIC_US_AUTH 4096 rsa
  echo "  - UI_DYNAMIC_US_AUTH [RSA 4096]"
  gen_sec UI_DYNAMIC_US_AUTH 4096 rsa
  echo "  - CONTROL_API_CRYPTO_KEY"
  gen_sec CONTROL_API_CRYPTO_KEY 32 base64
fi

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
  if [ "${IS_USE_ENV_AND_SECRETS}" == "true" ]; then
    echo "  - EXPORT_DATA_VERIFICATION_KEY"
    gen_sec EXPORT_DATA_VERIFICATION_KEY 32
  fi
fi

if [ "${IS_TEMPORAL_ENABLED}" == "true" ] && [ "${IS_TEMPORAL_AUTH_ENABLED}" == "true" ]; then
  if [ "${IS_USE_ENV_AND_SECRETS}" == "true" ]; then
    echo "  - TEMPORAL_AUTH [RSA 4096]"
    gen_sec TEMPORAL_AUTH 4096 rsa
  fi

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
  if [ "${IS_USE_ENV_AND_SECRETS}" == "true" ]; then
    echo "  - AUTH_ADMIN_PASSWORD"
    gen_sec AUTH_ADMIN_PASSWORD 16
    echo "  - AUTH_MASTER_TOKEN"
    gen_sec AUTH_MASTER_TOKEN 32
    echo "  - AUTH_TOKEN [RSA 4096]"
    gen_sec AUTH_TOKEN 4096 rsa

    echo ""
    echo "Admin credentials:"
    echo "  - login: admin"
    echo "  - password: $(get_env AUTH_ADMIN_PASSWORD)"
  elif [ "${IS_DEV}" == "true" ]; then
    echo ""
    echo "Admin credentials:"
    echo "  - login: admin"
    echo "  - password: admin"
  fi

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

if [ "${IS_DOCKER_IPV6}" == "true" ]; then
  echo ""
  echo "🛠️  Docker daemon check IPv6 support..."
  echo ""
  if [ "$(uname -s)" == "Linux" ]; then
    if [ -f "/etc/docker/daemon.json" ]; then
      echo "  - file [/etc/docker/daemon.json] already exists"
      if grep -q -s '"ipv6": true' /etc/docker/daemon.json; then
        echo "  - config IPv6 fixes already applied, skip fix"
      else
        echo ""
        echo "🚨 Docker daemon IPv6 support not found at config [/etc/docker/daemon.json], need manually fix it before run..."
        echo ""
        exit 1
      fi
    else
      echo "  - create file [/etc/docker/daemon.json] with IPv6 fixes"

      sudo mkdir -p /etc/docker
      echo '{
          "experimental": true,
          "ip6tables": true,
          "ipv6": true,

          "fixed-cidr-v6": "fd00::/80",
          "default-address-pools":[
            {"base": "172.31.0.0/16", "size": 24},
            {"base": "fd00:501::/64", "size": 80}
          ]
        }' | sudo tee /etc/docker/daemon.json &>/dev/null

      echo "  - restart docker daemon"
      sudo systemctl restart docker
    fi
  else
    echo "  - skip daemon fix for non Linux systems"
  fi
fi

if [ "${IS_RUN_INIT_DEMO_DATA}" == "true" ]; then
  echo ""
  echo "Running demo data initialization for external PostgreSQL..."

  docker --log-level error compose run --rm --entrypoint /init/seed-demo-data.sh postgres

  exit 0
fi

if [ "${IS_DEV}" == "true" ]; then
  DOCKER_COMPOSE_VERSION=$(docker compose version --short)
  DOCKER_COMPOSE_VERSION=$(IFS='.' read -r DC_MAJOR DC_MINOR DC_PATCH <<<"${DOCKER_COMPOSE_VERSION}" && printf "%03d%03d%03d" "${DC_MAJOR}" "${DC_MINOR}" "${DC_PATCH}")
  DOCKER_COMPOSE_MIN_BAKE_VERSION="002037001"

  if [ "${DOCKER_COMPOSE_VERSION}" -ge "${DOCKER_COMPOSE_MIN_BAKE_VERSION}" ]; then
    export COMPOSE_BAKE="true"
  fi

  if [ "${IS_USE_ENV_AND_SECRETS}" != "true" ]; then
    export COMPOSE_DISABLE_ENV_FILE=1
    echo ""
    echo "⚠️  Loading environment file for compose is disabled..."
  fi

  if [ "${IS_DEV_ROOT}" == "true" ]; then
    export USER_DEV="root"
    echo ""
    echo "⚠️  Running dev containers with [root] user..."
  fi

  echo ""
  echo "💡 Starting Docker Compose services in dev mode..."
  echo ""

  DIR_REPO_UI="../datalens-ui"
  DIR_REPO_US="../datalens-us"
  DIR_REPO_AUTH="../datalens-auth"
  DIR_REPO_META_MANAGER="../datalens-meta-manager"
  DIR_REPO_BACKEND="../datalens-backend"

  DOCKER_COMPOSE_CONFIG=docker-compose.yaml
  DOCKER_COMPOSE_DEV_CONFIG=docker-compose.dev.yaml

  COMPOSE_UP_SERVICES=""
  COMPOSE_DOWN_SERVICES=""
  COMPOSE_DEV_UP_SERVICES=""
  COMPOSE_LOG_SERVICES=""

  if [ "${IS_POSTGRES_EXTERNAL}" == "true" ]; then
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} postgres"
  else
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} postgres"
  fi

  if [ "${IS_TEMPORAL_ENABLED}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} temporal"
    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} temporal-ui"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} temporal"
  fi

  if [ "${IS_POSTGRES_EXTERNAL}" == "true" ]; then
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} postgres"
  else
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} postgres"
  fi

  if [ "${IS_DEV_NGINX}" == "true" ]; then
    if [ -z "${DOMAIN}" ]; then
      DOMAIN="datalens.local"
    fi
    export UI_APP_ENDPOINT="https://${DOMAIN}"
  fi

  if [ "${IS_DEV_UI}" == "true" ]; then
    echo "  - [ui] check repository exists..."
    if [ ! -d "${DIR_REPO_UI}" ]; then
      echo "  - [ui] path [${DIR_REPO_UI}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-ui.git "${DIR_REPO_UI}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} ui"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} ui"
  elif [ "${IS_UP_UI}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} ui"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} ui"
  fi

  if [ "${IS_DEV_UI_API}" == "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
    echo "  - [ui-api] check repository exists..."
    if [ ! -d "${DIR_REPO_UI}" ]; then
      echo "  - [ui-api] path [${DIR_REPO_UI}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-ui.git "${DIR_REPO_UI}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} ui-api"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} ui-api"
  elif [ "${IS_UP_UI_API}" == "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} ui-api"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} ui-api"
  fi

  if [ "${IS_DEV_US}" == "true" ]; then
    echo "  - [us] check repository exists..."
    if [ ! -d "${DIR_REPO_US}" ]; then
      echo "  - [us] path [${DIR_REPO_US}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-us.git "${DIR_REPO_US}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} us"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} us"
  elif [ "${IS_UP_US}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} us"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} us"
  fi

  if [ "${IS_DEV_AUTH}" == "true" ] && [ "${IS_AUTH_ENABLED}" == "true" ]; then
    echo "  - [auth] check repository exists..."
    if [ ! -d "${DIR_REPO_AUTH}" ]; then
      echo "  - [auth] path [${DIR_REPO_AUTH}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-auth.git "${DIR_REPO_AUTH}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} auth"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} auth"
  elif [ "${IS_UP_AUTH}" == "true" ] && [ "${IS_AUTH_ENABLED}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} auth"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} auth"
  fi

  if [ "${IS_DEV_META_MANAGER}" == "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
    echo "  - [meta-manager] check repository exists..."
    if [ ! -d "${DIR_REPO_META_MANAGER}" ]; then
      echo "  - [meta-manager] path [${DIR_REPO_META_MANAGER}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-meta-manager.git "${DIR_REPO_META_MANAGER}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} meta-manager"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} meta-manager"
  elif [ "${IS_UP_META_MANAGER}" == "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} meta-manager"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} meta-manager"
  fi

  if [ "${IS_DEV_CONTROL_API}" == "true" ]; then
    echo "  - [control-api] check repository exists..."
    if [ ! -d "${DIR_REPO_BACKEND}" ]; then
      echo "  - [control-api] path [${DIR_REPO_BACKEND}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-backend.git "${DIR_REPO_BACKEND}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} control-api"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} control-api"
  elif [ "${IS_UP_CONTROL_API}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} control-api"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} control-api"
  fi

  if [ "${IS_DEV_DATA_API}" == "true" ]; then
    echo "  - [data-api] check repository exists..."
    if [ ! -d "${DIR_REPO_BACKEND}" ]; then
      echo "  - [data-api] path [${DIR_REPO_BACKEND}] not exists, cloning..."
      git clone git@github.com:datalens-tech/datalens-backend.git "${DIR_REPO_BACKEND}"
      echo ""
    fi

    COMPOSE_DEV_UP_SERVICES="${COMPOSE_DEV_UP_SERVICES} data-api"
    COMPOSE_LOG_SERVICES="${COMPOSE_LOG_SERVICES} data-api"
  elif [ "${IS_UP_DATA_API}" == "true" ]; then
    COMPOSE_UP_SERVICES="${COMPOSE_UP_SERVICES} data-api"
  else
    COMPOSE_DOWN_SERVICES="${COMPOSE_DOWN_SERVICES} data-api"
  fi

  echo ""

  if [ -n "${COMPOSE_DOWN_SERVICES}" ]; then
    # shellcheck disable=SC2086
    docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" rm --stop --force ${COMPOSE_DOWN_SERVICES}
    echo ""
  fi

  # shellcheck disable=SC2086
  docker --log-level error compose -f "${DOCKER_COMPOSE_CONFIG}" up -d --remove-orphans ${COMPOSE_UP_SERVICES}

  if [ -n "${COMPOSE_DEV_UP_SERVICES}" ]; then
    if [ "${IS_DEV_BUILD}" == "true" ]; then
      # shellcheck disable=SC2086
      docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" build ${COMPOSE_DEV_UP_SERVICES}
    fi

    # shellcheck disable=SC2086
    docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" up --no-deps -d ${COMPOSE_DEV_UP_SERVICES}
  fi
  
  echo ""
  echo "📌 Running Docker Compose services..."
  echo ""
  echo "  - listen [ui] on: http://localhost:8080"

  if [ "${IS_DEV_EXPOSE_PORTS}" == "true" ]; then
    echo ""
    echo "✈️  Expose all containers ports with socat..."
    echo ""

    EXPOSE_PORTS="5432:postgres:5432 7233:temporal:7233"

    if [ "${IS_DEV_UI_API}" != "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 3040:ui-api:8080"
      export EXPOSE_PORTS_3040="3040"
      echo "  - listen [ui-api] on: http://localhost:3040"
    fi
    if [ "${IS_DEV_US}" != "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 3030:us:8080"
      export EXPOSE_PORTS_3030="3030"
      echo "  - listen [us] on: http://localhost:3030"
    fi
    if [ "${IS_DEV_AUTH}" != "true" ] && [ "${IS_AUTH_ENABLED}" == "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 8088:auth:8080"
      export EXPOSE_PORTS_8088="8088"
      echo "  - listen [auth] on: http://localhost:8088"
    fi
    if [ "${IS_DEV_META_MANAGER}" != "true" ] && [ "${IS_WORKBOOK_EXPORT_ENABLED}" == "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 3050:meta-manager:8080"
      export EXPOSE_PORTS_3050="3050"
      echo "  - listen [meta-manager] on: http://localhost:3050"
    fi
    if [ "${IS_DEV_CONTROL_API}" != "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 8010:control-api:8080"
      export EXPOSE_PORTS_8010="8010"
      echo "  - listen [control-api] on: http://localhost:8010"
    fi
    if [ "${IS_DEV_DATA_API}" != "true" ]; then
      EXPOSE_PORTS="${EXPOSE_PORTS} 8020:data-api:8080"
      export EXPOSE_PORTS_8020="8020"
      echo "  - listen [data-api] on: http://localhost:8020"
    fi

    echo ""

    export EXPOSE_PORTS="${EXPOSE_PORTS}"

    if [ "${IS_DEV_BUILD}" == "true" ]; then
      docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" build socat
    fi
    docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" up --no-deps -d socat
  fi

  if [ "${IS_DEV_NGINX}" == "true" ]; then
    echo ""
    echo "🌐 Up nginx server with HTTPS..."
    echo ""

    if [ ! -f "./dev/certs/${DOMAIN}.crt" ]; then
      openssl req -x509 -batch -subj "/CN=${DOMAIN}/O=DataLens" -addext "subjectAltName=DNS:${DOMAIN}" -nodes -newkey rsa:2048 -sha256 -days 365 -keyout "./dev/certs/${DOMAIN}.key" -out "./dev/certs/${DOMAIN}.crt" &>/dev/null
      # shellcheck disable=SC2086
      rm -rf ./dev/certs/${DOMAIN}.ca.crt && cat ./dev/certs/${DOMAIN}.* >>./dev/certs/${DOMAIN}.ca.crt
    fi

    if [ "${IS_DEV_BUILD}" == "true" ]; then
      docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" build nginx
    fi
    docker --log-level error compose -f "${DOCKER_COMPOSE_DEV_CONFIG}" up --no-deps -d nginx

    echo "  nginx port: 443"
    echo "  domain: ${DOMAIN}"
  fi

  if [ -n "${COMPOSE_LOG_SERVICES}" ]; then
    if [ "$(echo "${COMPOSE_LOG_SERVICES}" | wc -w | tr -d ' ')" == "1" ]; then
      # shellcheck disable=SC2086
      docker --log-level error compose -f "${DOCKER_COMPOSE_CONFIG}" logs --no-log-prefix -f ${COMPOSE_LOG_SERVICES}
    else
      # shellcheck disable=SC2086
      docker --log-level error compose -f "${DOCKER_COMPOSE_CONFIG}" logs -f ${COMPOSE_LOG_SERVICES}
    fi
  fi

  echo ""
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
