#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

RUN_WATCHDOG_DEV=${RUN_DEV}

if [ "${PRETTY_LOG}" == "true" ]; then
  RUN_WATCHDOG_DEV="/opt/dev/pretty-log.sh"
fi

exec 'python' \
  '-m' 'watchdog.watchmedo' 'auto-restart' \
  '--patterns' '*.py;*.ini;*.yaml' \
  '--recursive' \
  '--kill-after' '1' \
  '--directory' '/src' \
  '--' "${RUN_WATCHDOG_DEV}"
