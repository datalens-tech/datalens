#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

if [ "${SKIP_NAMESPACES_CREATION}" == "true" ] || [ "${SKIP_NAMESPACES_CREATION}" == "1" ]; then
  exit 0
fi

echo "  [temporal-init-namespaces] start init temporal namespaces..."
echo "  [temporal-init-namespaces] temporal address: ${TEMPORAL_ADDRESS}"

echo "  [temporal-init-namespaces] waiting server to start..."
until temporal operator cluster health | grep -q -s SERVING; do
  echo "  [temporal-init-namespaces] sleep 1 second..."
  sleep 1
done
echo "  [temporal-init-namespaces] server started"

IFS=',' read -ra INIT_NAMESPACES <<<"${NAMESPACES}"

for NS in "${INIT_NAMESPACES[@]}"; do
  echo "  [temporal-init-namespaces] registering namespace: ${NS}"

  if ! temporal operator namespace describe "${NS}"; then
    echo "  [temporal-init-namespaces] create [${NS}] namespace..."
    temporal operator namespace create --retention "${DEFAULT_NAMESPACE_RETENTION}" --description "Namespace for Temporal Server." -n "${NS}"
    echo "  [temporal-init-namespaces] namespace [${NS}] registration complete...."
  else
    echo "  [temporal-init-namespaces] namespace [${NS}] already registered, skip..."
  fi
done

echo "  [temporal-init-namespaces] finish init temporal namespaces..."
