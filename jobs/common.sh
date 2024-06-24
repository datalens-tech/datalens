print_info() {
  echo "INFO::$1" > /dev/stdout
}

print_error() {
  echo "ERROR::$1" > /dev/stderr
}

ensure_openssl() {
  if ! command -v openssl &> /dev/null; then
    apt-get update
    apt-get install -y openssl
  fi
}

ensure_curl() {
  if ! command -v curl &> /dev/null; then
    apt-get update
    apt-get install -y curl
  fi
}

ensure_jq() {
  if ! command -v jq &> /dev/null; then
    apt-get update
    apt-get install -y jq
  fi
}

ensure_folder() {
  FOLDER=$1

  if [ ! -d "$FOLDER" ]; then
    mkdir -p "$FOLDER"
  fi
}

set_secret() {
  SECRETS_FOLDER=$1
  SECRET_KEY=$2
  SECRET_VALUE=$3

  if [ -z "$SECRETS_FOLDER" ]; then
    print_error "SECRETS_FOLDER parameter should not be empty"
    exit 1
  fi

  if [ -z "$SECRET_KEY" ]; then
   print_error "SECRET_KEY parameter should not be empty"
    exit 1
  fi

  if [ -z "$SECRET_VALUE" ]; then
    print_error "SECRET_VALUE parameter should not be empty"
    exit 1
  fi

  echo -n "$SECRET_VALUE" > "$SECRETS_FOLDER/$SECRET_KEY"
  echo "$SECRET_KEY=$SECRET_VALUE" >> "$SECRETS_FOLDER/.env"
}

get_secret() {
  SECRETS_FOLDER=$1
  SECRET_KEY=$2

  if [ -z "$SECRET_KEY" ]; then
    print_error "SECRET_KEY parameter should not be empty"
    exit 1
  fi

  cat "$SECRETS_FOLDER/$SECRET_KEY"
}

generate_random_base64() {
  ensure_openssl > /dev/stderr
  LENGTH=$1

  if [ -z "$LENGTH" ]; then
    print_error "LENGTH parameter should not be empty"
    exit 1
  fi

  openssl rand -base64 $LENGTH | head -c "$LENGTH"
}

ensure_secret() {
  SECRETS_FOLDER=$1
  SECRET_KEY=$2
  SECRET_LENGTH=$3
  if [ -z "$SECRET_LENGTH" ]; then
    SECRET_LENGTH=32
  fi

  if [ ! -f "$SECRETS_FOLDER/$SECRET_KEY" ]; then
    set_secret "$SECRETS_FOLDER" "$SECRET_KEY" "$(generate_random_base64 "$SECRET_LENGTH")"
  fi
}

wait_for_file() {
  FILE_PATH=$1

  if [ -z "$FILE_PATH" ]; then
    print_error "FILE_PATH parameter should not be empty"
    exit 1
  fi

  while [ ! -f "$FILE_PATH" ]; do
    print_info "Waiting for $FILE_PATH to be created"
    sleep 1
  done
}
