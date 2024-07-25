#!/bin/bash

# chmod +x ./scripts/load-images.sh
# ./scripts/load-images.sh

file=${1:-"datalens-images.gz"}

gzip -cd ${file} | docker load
