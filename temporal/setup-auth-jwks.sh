#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if ! echo -n "${TEMPORAL_AUTH_PUBLIC_KEY}" | sed 's|\\n|\n|g' | openssl rsa -pubin - -text -noout &>/dev/null; then
  echo "  [temporal-auth] error, not a valid RSA public key, exit..." >&2
  exit 1
fi

echo "  [temporal-auth] extract modulus (n) and convert to base64url..." >&2
MODULUS_BASE64URL=$(
  echo -n "${TEMPORAL_AUTH_PUBLIC_KEY}" | sed 's|\\n|\n|g' | openssl rsa -pubin - -modulus -noout |
    sed 's/Modulus=//' |
    xxd -r -p |
    openssl enc -base64 -A |
    tr -d '\n' |
    tr '+/' '-_' |
    tr -d '='
)

echo "  [temporal-auth] extract exponent (e) to dec..." >&2
EXPONENT_DEC=$(echo -n "${TEMPORAL_AUTH_PUBLIC_KEY}" | sed 's|\\n|\n|g' | openssl rsa -pubin - -text -noout | grep "Exponent:" | awk '{print $2}')
EXPONENT_BIN=$(printf '%x' "${EXPONENT_DEC}")

echo "  [temporal-auth] convert exponent to hex and then to base64url..." >&2

# ensure even number of characters
EXPONENT_LENGTH="${#EXPONENT_BIN}"
EXPONENT_MOD=$((EXPONENT_LENGTH % 2))
if [ "${EXPONENT_MOD}" -eq 1 ]; then
  EXPONENT_BIN="0${EXPONENT_BIN}"
fi

EXPONENT_BASE64URL=$(
  echo -n "${EXPONENT_BIN}" |
    xxd -r -p |
    openssl enc -base64 -A |
    tr '+/' '-_' |
    tr -d '='
)

echo "  [temporal-auth] export jwks data: ${POSTGRES_HOST}" >&2

JWKS_DATA="{
  \"keys\": [{
    \"kty\": \"RSA\",
    \"alg\": \"RS256\",
    \"use\": \"sig\",
    \"kid\": \"temporal\",
    \"n\": \"${MODULUS_BASE64URL}\",
    \"e\": \"${EXPONENT_BASE64URL}\"
  }]
}"

echo -n "${JWKS_DATA}"
