#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

DEBUG_LOG="./debug.log"

LOG_LINES_LIMIT="10"

# parse args
for _ in "$@"; do
  case ${1} in
  --log-lines-limit)
    LOG_LINES_LIMIT="${2}"
    shift # past argument
    shift # past value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

echo ""
echo "🏗️  getting DataLens deploy information for debug"
echo ""

echo "## DataLens OpenSource Debug Information" >"${DEBUG_LOG}"
# shellcheck disable=SC2129
echo "generated at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting system info..."
# shellcheck disable=SC2129
echo "### system:" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
echo "os: $(uname -s)" >>"${DEBUG_LOG}"
echo "kernel: $(uname -r)" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting docker version..."
echo "### docker:" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
DOCKER_VERSION=$(docker --version)
echo "${DOCKER_VERSION}" >>"${DEBUG_LOG}"
DOCKER_COMPOSE_VERSION=$(docker compose version 2>/dev/null || echo 'not available')
# shellcheck disable=SC2129
echo "${DOCKER_COMPOSE_VERSION}" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

if [ -f "docker-compose.production.yaml" ]; then
  COMPOSE_FILE="docker-compose.production.yaml"
else
  COMPOSE_FILE="docker-compose.yaml"
fi
# shellcheck disable=SC2129
echo "compose file: ${COMPOSE_FILE}" >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting compose file images..."
# shellcheck disable=SC2129
echo "### images:" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"

docker compose -f "${COMPOSE_FILE}" config | grep "image:" | awk '{print $2}' >>"${DEBUG_LOG}"

echo '```' >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting running containers with states..."
# shellcheck disable=SC2129
echo "### containers:" >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
docker compose -f "${COMPOSE_FILE}" ps >>"${DEBUG_LOG}"
echo '```' >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting error logs..."
echo "### error logs (top ${LOG_LINES_LIMIT} per service):" >>"${DEBUG_LOG}"
docker compose -f "${COMPOSE_FILE}" config --services | while read -r SERVICE; do
  echo "#### + ${SERVICE}" >>"${DEBUG_LOG}"
  echo '```' >>"${DEBUG_LOG}"

  ERROR_LOGS=$(docker compose -f "${COMPOSE_FILE}" logs "${SERVICE}" 2>&1 | grep -i -E "error|exception|fail|fatal" | grep -v '"error": null' | grep -v '"name": "gunicorn.error", "levelname": "INFO"' | tail -n "${LOG_LINES_LIMIT}" || echo "no error logs found")
  # shellcheck disable=SC2129
  echo "${ERROR_LOGS}" >>"${DEBUG_LOG}"

  echo '```' >>"${DEBUG_LOG}"
  echo "" >>"${DEBUG_LOG}"
done

echo "  getting environment variables..."
echo "### environment variables (sensitive information masked): " >>"${DEBUG_LOG}"
echo '```sh' >>"${DEBUG_LOG}"

if [ -f ".env" ]; then
  while read -r LINE; do
    if echo "${LINE}" | grep -q "^#" || [ -z "$LINE" ]; then
      echo "${LINE}" >>"${DEBUG_LOG}"
    else
      VAR_NAME=$(echo "${LINE}" | cut -d= -f1)

      if echo "${VAR_NAME}" | grep -q -E "PASSWORD|TOKEN|KEY|SECRET|PRIVATE|CREDENTIAL"; then
        echo "${VAR_NAME}=********" >>"${DEBUG_LOG}"
      else
        echo "${LINE}" >>"${DEBUG_LOG}"
      fi
    fi
  done <.env
else
  echo "no .env file found" >>"${DEBUG_LOG}"
fi

echo '```' >>"${DEBUG_LOG}"
echo "" >>"${DEBUG_LOG}"

echo "  getting versions config..."
if [ -f "versions-config.json" ]; then
  # shellcheck disable=SC2129
  echo "### versions config:" >>"${DEBUG_LOG}"

  echo '```json' >>"${DEBUG_LOG}"
  cat versions-config.json >>"${DEBUG_LOG}"
  echo "" >>"${DEBUG_LOG}"
  echo '```' >>"${DEBUG_LOG}"

  echo "" >>"${DEBUG_LOG}"
fi

echo ""
echo "debug information has been saved to: ${DEBUG_LOG}"
echo ""
