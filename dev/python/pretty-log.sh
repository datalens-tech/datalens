#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

${RUN_DEV} | python /opt/dev/pretty-log.py
