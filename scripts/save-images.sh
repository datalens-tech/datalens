#!/bin/bash

# chmod +x ./scripts/save-images.sh
# ./scripts/save-images.sh

get_docker_compose_command() {
  if command -v docker-compose &>/dev/null; then
    echo "docker-compose"
    return 0
  elif command -v docker compose &>/dev/null; then
    echo "docker compose"
    return 0
  else
    echo "Compose plugin for docker is not installed. e.g. sudo apt install docker-compose-plugin" >/dev/stderr
    exit 1
  fi
}

file=${1:-"docker-compose.yml"}

if [ ! -z ${file} ] && [ -f ${file} ]; then
    echo -e "\nPulling images...\n"
    images=`grep image: ${file} | awk '{print $2}'`
    $(get_docker_compose_command) -f ${file} pull

    echo -e "\nSaving images...\n"
    docker save ${images} | gzip > datalens-images.gz

    echo "Images saved to datalens-images.gz"
else
  echo "Incorrect file path"
fi
