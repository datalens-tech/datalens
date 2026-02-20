#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

# shellcheck disable=SC2001
PORTS=$(echo "${PORTS}" | tr '\n' ' ')
CHILD_PID=()

close() {
  for PID in "${CHILD_PID[@]}"; do
    if kill -0 "${PID}" 2>/dev/null; then
      kill -TERM "${PID}" 2>/dev/null || true
    fi
  done
  exit 0
}

trap close SIGTERM SIGINT SIGQUIT

for PORT in ${PORTS}; do
  FROM=$(echo "${PORT}" | cut -d":" -f 1)
  IP=$(echo "${PORT}" | cut -d":" -f 2)
  TO=$(echo "${PORT}" | cut -d":" -f 3)
  socat "tcp-listen:${FROM},fork,reuseaddr" "tcp-connect:${IP}:${TO}" &
  CHILD_PID+=($!)
done

ps aux
wait
