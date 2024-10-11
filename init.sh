#!/bin/bash

ENV_FILE_PATH=".env"

load_env() {
  set -a
  [ -f "${ENV_FILE_PATH}" ] && source "${ENV_FILE_PATH}"
  set +a
}

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

check_docker() {
  if ! command -v docker &>/dev/null; then
    echo "docker is not installed or not in PATH, please install with your package manager. e.g. sudo apt install docker.io" >/dev/stderr
    exit 1
  fi
}

check_jq() {
  if ! command -v jq &>/dev/null; then
    echo "jq is not installed or not in PATH, please install with your package manager. e.g. sudo apt install jq" >/dev/stderr
    exit 1
  fi
}

check_curl() {
  if ! command -v curl &>/dev/null; then
    echo "curl is not installed or not in PATH, please install with your package manager. e.g. sudo apt install curl" >/dev/stderr
    exit 1
  fi
}

curl() {
  CURL=$(which curl)

  if [ "${SELF_SIGNED_CERT}" == "true" ]; then
    ${CURL} --cacert "./certs/zitadel.${DOMAIN}.crt" "$@"
  else
    ${CURL} "$@"
  fi
}

write_env() {
  if grep -q -s "${1}=" "${ENV_FILE_PATH}"; then
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
  if grep -q -s "${1}=" "${ENV_FILE_PATH}"; then
    ENV_CONTENT=$(cat "${ENV_FILE_PATH}")
    echo "$ENV_CONTENT" | grep -v "${1}=" >"${ENV_FILE_PATH}"
  fi
  return 0
}

check_installed() {
  if [ ! -z "${INIT_COMPLETED}" ]; then
    echo "DataLens init was completed previously. In order to reinstall it, please remove all docker container and .env file manually" >/dev/stderr
    return 0
  else
    return 1
  fi
}

generate_secret() {
  ENV_KEY=$1
  ENV_LENGTH=$2
  FORMAT=$3
  if [ "${FORMAT}" == "base64" ]; then
    PASS="\"$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH} | openssl base64)\""
  elif [ "${FORMAT}" == "special" ]; then
    PASS="$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH})_"
  else
    PASS="$(openssl rand -base64 ${ENV_LENGTH} | tr -dc a-zA-Z0-9 | head -c ${ENV_LENGTH})"
  fi
  write_env "${ENV_KEY}" "$PASS"
}

start_zitadel() {
  echo "Docker compose Zitadel start"

  COMPOSE_UP_SERVICES="zitadel"

  ZITADEL_EXTERNALPORT=8085 ZITADEL_EXTERNALDOMAIN=localhost $(get_docker_compose_command) -f docker-compose.zitadel.yml up -d ${COMPOSE_UP_SERVICES}

  echo "Docker compose Zitadel finish"
}

wait_pat() {
  PAT_PATH=$1
  set +e
  while true; do
    if [ -f "$PAT_PATH" ]; then
      break
    fi
    printf ". "
    sleep 1
  done
  echo " done"
  set -e
}

wait_api() {
  INSTANCE_URL=$1
  PAT=$2
  set +e
  while true; do
    curl -s --fail -o /dev/null "$INSTANCE_URL/auth/v1/users/me" -H "Authorization: Bearer $PAT" && break
    printf ". "
    sleep 1
  done
  echo " done"
  set -e
}

handle_zitadel_request_response() {
  PARSED_RESPONSE=$1
  FUNCTION_NAME=$2
  RESPONSE=$3
  if [ "$PARSED_RESPONSE" == "null" ]; then
    echo "ERROR calling $FUNCTION_NAME:" $(echo "$RESPONSE" | jq -r '.message') >/dev/stderr
    exit 1
  fi
  sleep 1
}

set_custom_login_text() {
  INSTANCE_URL=$1
  PAT=$2

  RESPONSE=$(
    curl -sS -X PUT "$INSTANCE_URL/admin/v1/text/login/ru" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -H "Authorization: Bearer $PAT" \
      -d '{
      "initMfaPromptText": {
        "skipButtonText": "Пропустить",
        "nextButtonText": "Далее"
      }
    }'
  )
}

create_new_project() {
  INSTANCE_URL=$1
  PAT=$2
  PROJECT_NAME=$3

  RESPONSE=$(
    curl -sS "$INSTANCE_URL/management/v1/projects/_search" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{"queries":[{"nameQuery": {"name": "'"$PROJECT_NAME"'","method": "TEXT_QUERY_METHOD_EQUALS"}}]}'
  )

  PROJECT_ID=$(echo "$RESPONSE" | jq -r '.result[0].id')

  if [ ! "${PROJECT_ID}" == "null" ]; then
    echo ${PROJECT_ID}
    return 0
  fi

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/management/v1/projects" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{"name": "'"$PROJECT_NAME"'"}'
  )

  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.id')
  handle_zitadel_request_response "$PARSED_RESPONSE" "create_new_project_project_id" "$RESPONSE"
  echo "$PARSED_RESPONSE"
}

create_new_application() {
  INSTANCE_URL=$1
  PAT=$2
  APPLICATION_NAME=$3
  BASE_REDIRECT_URL1=$4
  LOGOUT_URL=$5
  ZITADEL_DEV_MODE=$6

  RESPONSE=$(
    curl -sS "$INSTANCE_URL/management/v1/projects/$PROJECT_ID/apps/_search" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{"queries":[{"nameQuery": {"name": "'"$APPLICATION_NAME"'","method": "TEXT_QUERY_METHOD_EQUALS"}}]}'
  )

  APP_ID=$(echo "$RESPONSE" | jq -r '.result[0].id')

  if [ ! "${APP_ID}" == "null" ]; then
    curl -sS -L -X DELETE "$INSTANCE_URL/management/v1/projects/${PROJECT_ID}/apps/${APP_ID}" \
      -H "Accept: application/json" \
      -H "Authorization: Bearer $PAT" &>/dev/null
  fi

  GRANT_TYPES='["OIDC_GRANT_TYPE_AUTHORIZATION_CODE","OIDC_GRANT_TYPE_REFRESH_TOKEN"]'

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/management/v1/projects/$PROJECT_ID/apps/oidc" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{
    "name": "'"$APPLICATION_NAME"'",
    "redirectUris": [
      "'"$BASE_REDIRECT_URL1"'"
    ],
    "postLogoutRedirectUris": [
       "'"$LOGOUT_URL"'"
    ],
    "RESPONSETypes": [
      "OIDC_RESPONSE_TYPE_CODE"
    ],
    "grantTypes": '"$GRANT_TYPES"',
    "appType": "OIDC_APP_TYPE_WEB",
    "authMethodType": "OIDC_AUTH_METHOD_TYPE_POST",
    "version": "OIDC_VERSION_1_0",
    "devMode": '"$ZITADEL_DEV_MODE"',
    "accessTokenType": "OIDC_TOKEN_TYPE_BEARER",
    "idTokenRoleAssertion": true,
    "idTokenUserinfoAssertion": true,
    "accessTokenRoleAssertion": true,
    "skipNativeAppSuccessPage": true
  }'
  )

  APP_ID=$(echo "$RESPONSE" | jq -r '.appId')
  handle_zitadel_request_response "$APP_ID" "create_new_application_app_id" "$RESPONSE"

  APP_CLIENT_ID=$(echo "$RESPONSE" | jq -r '.clientId')
  handle_zitadel_request_response "$APP_CLIENT_ID" "create_new_application_client_id" "$RESPONSE"

  APP_CLIENT_SECRET=$(echo "$RESPONSE" | jq -r '.clientSecret')
  handle_zitadel_request_response "$APP_CLIENT_SECRET" "create_new_application_client_secret" "$RESPONSE"
}

update_settings() {
  INSTANCE_URL=$1
  PAT=$2

  RESPONSE=$(
    curl -sS -X PUT "$INSTANCE_URL/admin/v1/settings/oidc" \
      -H "Authorization: Bearer $PAT" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-raw '{
         "accessTokenLifetime": "86400s",
         "idTokenLifetime": "43200s",
         "refreshTokenIdleExpiration": "1209600s",
         "refreshTokenExpiration": "1209600s"
      }'
  )
}

create_user_roles() {
  INSTANCE_URL=$1
  PAT=$2
  PROJECT_ID=$3

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/management/v1/projects/$PROJECT_ID/roles/_bulk" \
      -H "Authorization: Bearer $PAT" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-raw '{
        "roles": [
            {
              "key": "datalens.editor",
              "display_name": "datalens.editor"
            },
            {
              "key": "datalens.admin",
              "display_name": "datalens.admin"
            }
          ]
      }'
  )
}

find_admin_user() {
  INSTANCE_URL=$1
  PAT=$2

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/v2beta/users" \
      -H "Authorization: Bearer $PAT" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-raw '{
        "query": {
          "offset": "0",
          "limit": 100,
          "asc": true
        },
          "queries": [
            {
              "emailQuery": {
                "emailAddress": "admin@",
                "method": "TEXT_QUERY_METHOD_CONTAINS"
              }
            }
          ]
      }'
  )

  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.result[0].userId')
  handle_zitadel_request_response "$PARSED_RESPONSE" "find_admin_user" "$RESPONSE"
  echo "$PARSED_RESPONSE"
}

grant_user_role() {
  INSTANCE_URL=$1
  PAT=$2
  PROJECT_ID=$3
  USER_ID=$4
  ROLE=$5

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/management/v1/users/$USER_ID/grants" \
      -H "Authorization: Bearer $PAT" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-raw '{
        "projectId": "'$PROJECT_ID'",
        "roleKeys": [
          "'$ROLE'"
        ]
      }'
  )
}

create_service_user() {
  INSTANCE_URL=$1
  PAT=$2
  USERNAME=$3

  RESPONSE=$(
    curl -sS "$INSTANCE_URL/management/v1/users/_search" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{"queries":[{"userNameQuery": {"userName": "'"$USERNAME"'","method": "TEXT_QUERY_METHOD_EQUALS"}}]}'
  )

  USER_ID=$(echo "$RESPONSE" | jq -r '.result[0].id')

  if [ ! "${USER_ID}" == "null" ]; then
    echo "${USER_ID}"
    return 0
  fi

  RESPONSE=$(
    curl -sS -X POST "$INSTANCE_URL/management/v1/users/machine" \
      -H "Authorization: Bearer $PAT" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-raw '{
         "userName": "'"$USERNAME"'",
         "name": "'"$USERNAME"'",
         "description": "'"$USERNAME"'",
         "accessTokenType": "ACCESS_TOKEN_TYPE_BEARER"
      }'
  )

  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.userId')
  handle_zitadel_request_response "$PARSED_RESPONSE" "create_service_user" "$RESPONSE"
  echo "$PARSED_RESPONSE"
}

create_service_user_secret() {
  INSTANCE_URL=$1
  PAT=$2
  USER_ID=$3

  RESPONSE=$(
    curl -sS -X PUT "$INSTANCE_URL/management/v1/users/$USER_ID/secret" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json" \
      -d '{}'
  )
  SERVICE_USER_CLIENT_ID=$(echo "$RESPONSE" | jq -r '.clientId')
  handle_zitadel_request_response "$SERVICE_USER_CLIENT_ID" "create_service_user_secret_id" "$RESPONSE"
  SERVICE_USER_CLIENT_SECRET=$(echo "$RESPONSE" | jq -r '.clientSecret')
  handle_zitadel_request_response "$SERVICE_USER_CLIENT_SECRET" "create_service_user_secret" "$RESPONSE"
}

delete_admin_service_user() {
  INSTANCE_URL=$1
  PAT=$2

  RESPONSE=$(
    curl -sS -X GET "$INSTANCE_URL/auth/v1/users/me" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json"
  )
  USER_ID=$(echo "$RESPONSE" | jq -r '.user.id')
  handle_zitadel_request_response "$USER_ID" "delete_auto_service_user_get_user" "$RESPONSE"

  RESPONSE=$(
    curl -sS -X DELETE "$INSTANCE_URL/admin/v1/members/$USER_ID" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json"
  )
  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.details.changeDate')
  handle_zitadel_request_response "$PARSED_RESPONSE" "delete_auto_service_user_remove_instance_permissions" "$RESPONSE"

  RESPONSE=$(
    curl -sS -X DELETE "$INSTANCE_URL/management/v1/orgs/me/members/$USER_ID" \
      -H "Authorization: Bearer $PAT" \
      -H "Content-Type: application/json"
  )

  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.details.changeDate')
  handle_zitadel_request_response "$PARSED_RESPONSE" "delete_auto_service_user_remove_org_permissions" "$RESPONSE"
  echo "$PARSED_RESPONSE"
}

start_compose() {
  DOCKER_COMPOSE_CONFIG=docker-compose.zitadel.yml

  if [ "${USE_DOCKER_VOLUMES}" == "true" ]; then
    export VOLUME_ZITADEL="db-zitadel"
    export VOLUME_US="db-us"
    export VOLUME_DEMO="db-demo"
  fi

  $(get_docker_compose_command) -f ${DOCKER_COMPOSE_CONFIG} up -d
}

install_zitadel() {
  check_docker
  check_jq
  check_curl

  INSTANCE_URL="http://localhost:8085"
  BASE_REDIRECT_URL="http://localhost:8080"

  ZITADEL_DEV_MODE=true

  if [ -z "${ZITADEL_CONFIG_DIR}" ]; then
    ZITADEL_CONFIG_DIR=./zitadel
  fi

  MACHINEKEY_TOKEN_DIR="${ZITADEL_CONFIG_DIR}/machinekey"
  MACHINEKEY_TOKEN_PATH=$MACHINEKEY_TOKEN_DIR/zitadel-admin-sa.token

  rm -rf "$MACHINEKEY_TOKEN_DIR"
  rm -f .env

  echo "Creating machinekey folder"

  mkdir -p "$MACHINEKEY_TOKEN_DIR"
  chmod -R 777 "$ZITADEL_CONFIG_DIR"

  echo "Generate secrets"
  generate_secret ZITADEL_MASTERKEY 32
  generate_secret ZITADEL_COOKIE_SECRET 32
  generate_secret US_MASTER_TOKEN 32

  if [ "${USE_DOCKER_VOLUMES}" == "true" ]; then
    write_env USE_DOCKER_VOLUMES "${USE_DOCKER_VOLUMES}"
    export VOLUME_ZITADEL="db-zitadel"
    export VOLUME_US="db-us"
    export VOLUME_DEMO="db-demo"
  fi

  start_zitadel

  if [ ! -z "${ZITADEL_ADMIN_ACCESS_TOKEN}" ]; then
    PAT="${ZITADEL_ADMIN_ACCESS_TOKEN}"
  else
    printf "Waiting Admin's PAT to be created "
    wait_pat "$MACHINEKEY_TOKEN_PATH"

    echo "Reading Admin's PAT"

    PAT=$(cat $MACHINEKEY_TOKEN_PATH)

    if [ "$PAT" = "null" ]; then
      echo "Failed getting PAT"
      exit 1
    fi
  fi

  write_env ZITADEL_ADMIN_ACCESS_TOKEN "${PAT}"

  printf "Waiting for Zitadel to become ready "
  wait_api "$INSTANCE_URL" "$PAT"

  echo "Updating customizations"
  set_custom_login_text "$INSTANCE_URL" "$PAT"

  echo "Updating settings"
  update_settings "$INSTANCE_URL" "$PAT"

  echo "Creating DataLens project"
  PROJECT_ID=$(create_new_project "$INSTANCE_URL" "$PAT" "DataLens")

  write_env ZITADEL_PROJECT_ID "${PROJECT_ID}" force

  echo "Creating Charts application"
  create_new_application "$INSTANCE_URL" "$PAT" "Charts" "$BASE_REDIRECT_URL/api/auth/callback" "$BASE_REDIRECT_URL/auth" "$ZITADEL_DEV_MODE"

  DL_CLIENT_ID="${APP_CLIENT_ID}"
  DL_CLIENT_SECRET="${APP_CLIENT_SECRET}"

  write_env DL_CLIENT_ID "${DL_CLIENT_ID}" force
  write_env DL_CLIENT_SECRET "${DL_CLIENT_SECRET}" force

  echo "Creating user roles"
  create_user_roles "$INSTANCE_URL" "$PAT" "$PROJECT_ID"

  echo "Granting user datalens.admin role"
  ADMIN_USER=$(find_admin_user "$INSTANCE_URL" "$PAT")
  grant_user_role "$INSTANCE_URL" "$PAT" "$PROJECT_ID" "$ADMIN_USER" "datalens.admin"

  echo "Creating charts service user"
  MACHINE_USER_ID=$(create_service_user "$INSTANCE_URL" "$PAT" "charts")
  create_service_user_secret "$INSTANCE_URL" "$PAT" "$MACHINE_USER_ID"
  CHARTS_SERVICE_CLIENT_SECRET="${SERVICE_USER_CLIENT_SECRET}"
  write_env CHARTS_SERVICE_CLIENT_SECRET "${CHARTS_SERVICE_CLIENT_SECRET}" force

  echo "Creating us service user"
  MACHINE_USER_ID=$(create_service_user "$INSTANCE_URL" "$PAT" "us")
  create_service_user_secret "$INSTANCE_URL" "$PAT" "$MACHINE_USER_ID"
  US_SERVICE_CLIENT_SECRET="${SERVICE_USER_CLIENT_SECRET}"
  write_env US_SERVICE_CLIENT_SECRET "${US_SERVICE_CLIENT_SECRET}" force

  echo "Creating bi service user"
  MACHINE_USER_ID=$(create_service_user "$INSTANCE_URL" "$PAT" "bi")
  create_service_user_secret "$INSTANCE_URL" "$PAT" "$MACHINE_USER_ID"
  BI_SERVICE_CLIENT_SECRET="${SERVICE_USER_CLIENT_SECRET}"
  write_env BI_SERVICE_CLIENT_SECRET "${BI_SERVICE_CLIENT_SECRET}" force

  echo "Deleting admin service user"
  DATE="null"
  DATE=$(delete_admin_service_user "$INSTANCE_URL" "$PAT")
  if [ "$DATE" = "null" ]; then
    echo "Failed deleting admin service user"
    echo "Please remove it manually"
  fi

  rm -rf "$ZITADEL_CONFIG_DIR"

  write_env INIT_COMPLETED "true"

  echo "DataLens has been successfully installed"
}

load_env

if check_installed; then
  start_compose
else
  install_zitadel
  start_compose
fi
