#!/bin/bash

# chmod +x ./scripts/load-images.sh

file=${1:-"docker-images.gz"}

gzip -cd ${file} | docker load
