#! /usr/bin/env bash

set +x

. /common.sh

wait_for_zitadel() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2

  set +e
  while true; do
    curl -s --fail -o /dev/null \
      "$ZITADEL_URL/auth/v1/users/me" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN"
    if [[ $? -eq 0 ]]; then
      break
    fi
    print_info "Waiting for Zitadel to become ready"
    sleep 1
  done
  print_info "Zitadel is ready"
  set -e
}

handle_zitadel_request_response() {
  PARSED_RESPONSE=$1
  FUNCTION_NAME=$2
  RESPONSE=$3

  if [[ $PARSED_RESPONSE == "null" ]]; then
    print_error "Failed calling $FUNCTION_NAME: $(echo "$RESPONSE" | jq -r '.message')"
    exit 1
  fi
  sleep 1
}

set_custom_login_text() {
  print_info "Setting custom login text"

  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2

  RESPONSE=$(curl -sS -X PUT "$ZITADEL_URL/admin/v1/text/login/ru" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
    -d '{
      "initMfaPromptText": {
        "skipButtonText": "пропустить",
        "nextButtonText": "далее"
      }
    }'
  )
}

create_project() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2
  PROJECT_NAME=$3

  print_info "Creating project $PROJECT_NAME"

  RESPONSE=$(
    curl -sS -X POST "$ZITADEL_URL/management/v1/projects" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"name": "'"$PROJECT_NAME"'"}'
  )

  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.id')
  handle_zitadel_request_response "$PARSED_RESPONSE" "create_new_project_project_id" "$RESPONSE"
  PROJECT_ID="$PARSED_RESPONSE"
}

create_application() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2

  APPLICATION_NAME=$3
  BASE_REDIRECT_URL=$4
  LOGOUT_URL=$5
  ZITADEL_DEV_MODE=$6

  GRANT_TYPES='["OIDC_GRANT_TYPE_AUTHORIZATION_CODE","OIDC_GRANT_TYPE_REFRESH_TOKEN"]'

  print_info "Creating application $APPLICATION_NAME"

  RESPONSE=$(
    curl -sS -X POST "$ZITADEL_URL/management/v1/projects/$PROJECT_ID/apps/oidc" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
    "name": "'"$APPLICATION_NAME"'",
    "redirectUris": [
      "'"$BASE_REDIRECT_URL"'"
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

create_service_user() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2
  USERNAME=$3

  RESPONSE=$(
    curl -sS -X POST "$ZITADEL_URL/management/v1/users/machine" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
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
  SERVICE_USER_ID="$PARSED_RESPONSE"
}

create_service_user_secret() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2
  USER_ID=$3

  RESPONSE=$(
    curl -sS -X PUT "$ZITADEL_URL/management/v1/users/$USER_ID/secret" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{}'
  )
  SERVICE_USER_CLIENT_ID=$(echo "$RESPONSE" | jq -r '.clientId')
  handle_zitadel_request_response "$SERVICE_USER_CLIENT_ID" "create_service_user_secret_id" "$RESPONSE"
  SERVICE_USER_CLIENT_SECRET=$(echo "$RESPONSE" | jq -r '.clientSecret')
  handle_zitadel_request_response "$SERVICE_USER_CLIENT_SECRET" "create_service_user_secret" "$RESPONSE"
}

delete_admin_service_user() {
  ZITADEL_URL=$1
  ZITADEL_ACCESS_TOKEN=$2

  RESPONSE=$(
    curl -sS -X GET "$ZITADEL_URL/auth/v1/users/me" \
      -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
  )
  USER_ID=$(echo "$RESPONSE" | jq -r '.user.id')
  handle_zitadel_request_response "$USER_ID" "delete_auto_service_user_get_user" "$RESPONSE"

  RESPONSE=$(
      curl -sS -X DELETE "$ZITADEL_URL/admin/v1/members/$USER_ID" \
        -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
  )
  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.details.changeDate')
  handle_zitadel_request_response "$PARSED_RESPONSE" "delete_auto_service_user_remove_instance_permissions" "$RESPONSE"

  RESPONSE=$(
      curl -sS -X DELETE "$ZITADEL_URL/management/v1/orgs/me/members/$USER_ID" \
        -H "Authorization: Bearer $ZITADEL_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
  )

  print_info "$RESPONSE"
  PARSED_RESPONSE=$(echo "$RESPONSE" | jq -r '.details.changeDate')
  handle_zitadel_request_response "$PARSED_RESPONSE" "delete_auto_service_user_remove_org_permissions" "$RESPONSE"
  DELETED_CHANGE_DATE="$PARSED_RESPONSE"
}

SECRETS_FOLDER="/data/secrets"
ZITADEL_MACHINEKEY_FOLDER="/data/zitadel_machinekey"
ZITADEL_MACHINEKEY_TOKEN_PATH="$ZITADEL_MACHINEKEY_FOLDER/zitadel-admin-sa.token"

ZITADEL_URL="http://localhost:8085"
EXTERNAL_UI_URL="http://localhost:8080"

if [ -z "$ZITADEL_DEV_MODE" ]; then
  print_error "ZITADEL_DEV_MODE is not set"
  exit 1
fi


main() {
  ZITADEL_INITIALIZED=$(get_secret "$SECRETS_FOLDER" "ZITADEL_INITIALIZED")
  if [ "$ZITADEL_INITIALIZED" = "true" ]; then
    print_info "Zitadel is already initialized"
    exit 0
  fi

  ensure_curl
  ensure_jq

  print_info "Waiting for Zitadel to become ready"
  wait_for_file "$ZITADEL_MACHINEKEY_TOKEN_PATH"
  ZITADEL_MACHINEKEY_TOKEN=$(cat "$ZITADEL_MACHINEKEY_TOKEN_PATH")

  if [ "$ZITADEL_MACHINEKEY_TOKEN" = "null" ]; then
    print_error "ZITADEL_MACHINEKEY_TOKEN is empty"
    exit 1
  fi

  wait_for_zitadel "$ZITADEL_URL" "$ZITADEL_MACHINEKEY_TOKEN"
  set_custom_login_text "$ZITADEL_URL" "$ZITADEL_MACHINEKEY_TOKEN"

  create_project "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" "DataLens"
  set_secret "$SECRETS_FOLDER" "ZITADEL_PROJECT_ID" "$PROJECT_ID"

  create_application "$ZITADEL_URL" \
    "$ZITADEL_ACCESS_TOKEN" \
    "Charts" \
    "$EXTERNAL_UI_URL/api/auth/callback" \
    "$EXTERNAL_UI_URL/auth" \
    "$ZITADEL_DEV_MODE"
  set_secret "$SECRETS_FOLDER" "ZITADEL_APP_ID" "$APP_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_APP_CLIENT_ID" "$APP_CLIENT_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_APP_CLIENT_SECRET" "$APP_CLIENT_SECRET"

  print_info "Creating charts service user"
  SERVICE_USER_NAME="charts"
  create_service_user "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" $SERVICE_USER_NAME
  create_service_user_secret "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_CHARTS_SERVICE_USER_NAME" "$SERVICE_USER_NAME"
  set_secret "$SECRETS_FOLDER" "ZITADEL_CHARTS_SERVICE_USER_ID" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_CHARTS_SERVICE_USER_CLIENT_ID" "$SERVICE_USER_CLIENT_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_CHARTS_SERVICE_USER_CLIENT_SECRET" "$SERVICE_USER_CLIENT_SECRET"

  print_info "Creating us service user"
  SERVICE_USER_NAME="us"
  create_service_user "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" $SERVICE_USER_NAME
  create_service_user_secret "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_US_SERVICE_USER_NAME" "$SERVICE_USER_NAME"
  set_secret "$SECRETS_FOLDER" "ZITADEL_US_SERVICE_USER_ID" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_US_SERVICE_USER_CLIENT_ID" "$SERVICE_USER_CLIENT_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_US_SERVICE_USER_CLIENT_SECRET" "$SERVICE_USER_CLIENT_SECRET"

  print_info "Creating bi service user"
  SERVICE_USER_NAME="bi"
  create_service_user "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" $SERVICE_USER_NAME
  create_service_user_secret "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_BI_SERVICE_USER_NAME" "$SERVICE_USER_NAME"
  set_secret "$SECRETS_FOLDER" "ZITADEL_BI_SERVICE_USER_ID" "$SERVICE_USER_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_BI_SERVICE_USER_CLIENT_ID" "$SERVICE_USER_CLIENT_ID"
  set_secret "$SECRETS_FOLDER" "ZITADEL_BI_SERVICE_USER_CLIENT_SECRET" "$SERVICE_USER_CLIENT_SECRET"

  print_info "Deleting admin service user"
  delete_admin_service_user "$ZITADEL_URL" "$ZITADEL_ACCESS_TOKEN"
  if [ "$DELETED_CHANGE_DATE" = "null" ]; then
      print_info "Failed deleting admin service user"
      print_info "Please remove it manually"
  fi

  print_info "Cleaning up machine_key folder"
  rm -rf "$ZITADEL_MACHINEKEY_FOLDER"

  set_secret "$SECRETS_FOLDER" "ZITADEL_INITIALIZED" "true"
  print_info "Zitadel has been successfully initialized."
}

main
