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

# Search attributes are passed via SEARCH_ATTRIBUTES as a comma-separated list
# of entries in the [namespace:name:type] format
echo "  [temporal-init-namespaces] start init temporal search attributes..."

IFS=',' read -ra INIT_SEARCH_ATTRIBUTES <<<"${SEARCH_ATTRIBUTES}"

for SA in "${INIT_SEARCH_ATTRIBUTES[@]}"; do
  [ -z "${SA}" ] && continue

  IFS=':' read -r SA_NAMESPACE SA_NAME SA_TYPE <<<"${SA}"

  if [ -z "${SA_NAMESPACE}" ] || [ -z "${SA_NAME}" ] || [ -z "${SA_TYPE}" ]; then
    echo "  [temporal-init-namespaces] invalid search attribute [${SA}], expected format [namespace:name:type], skip..."
    continue
  fi

  echo "  [temporal-init-namespaces] ensuring search attribute [${SA_NAME}] (${SA_TYPE}) in namespace [${SA_NAMESPACE}]..."

  if ! temporal operator namespace describe "${SA_NAMESPACE}"; then
    echo "  [temporal-init-namespaces] namespace [${SA_NAMESPACE}] does not exist, skip search attribute [${SA_NAME}]..."
    continue
  fi

  if temporal operator search-attribute list --namespace "${SA_NAMESPACE}" | grep -q "${SA_NAME}"; then
    echo "  [temporal-init-namespaces] search attribute [${SA_NAME}] already exists in [${SA_NAMESPACE}], skip..."
  else
    echo "  [temporal-init-namespaces] create search attribute [${SA_NAME}] in [${SA_NAMESPACE}]..."
    temporal operator search-attribute create --namespace "${SA_NAMESPACE}" --name "${SA_NAME}" --type "${SA_TYPE}"
    echo "  [temporal-init-namespaces] search attribute [${SA_NAME}] in [${SA_NAMESPACE}] creation complete..."
  fi
done

echo "  [temporal-init-namespaces] finish init temporal search attributes..."
