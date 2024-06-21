#! /usr/bin/env bash

. /common.sh

SECRETS_FOLDER="/data/secrets"
ZITADEL_MACHINEKEY_FOLDER="/data/zitadel_machinekey"

main() {
  ensure_folder "$SECRETS_FOLDER"
  ensure_secret "$SECRETS_FOLDER" "ZITADEL_MASTER_KEY"
  ensure_secret "$SECRETS_FOLDER" "ZITADEL_COOKIE_SECRET"
  ensure_secret "$SECRETS_FOLDER" "US_MASTER_TOKEN"

  ensure_folder "$ZITADEL_MACHINEKEY_FOLDER"
}

main
