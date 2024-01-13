jinja2 ./templates/docker-compose.j2 versions-config.json --format=json > ./docker-compose.yml
jinja2 ./templates/docker-compose-dev.j2 versions-config.json --format=json > ./docker-compose-dev.yml