#!/bin/bash

DOCKER_REPO="https://raw.githubusercontent.com/alsted/bullet_train_docker/main"

echo "alsted fork"

# install and execute and alternate configuration script
curl -o "bin/configure" "$DOCKER_REPO/bin/configure"
bin/configure

# install docker configuration
curl -o "Dockerfile" "$DOCKER_REPO/Dockerfile"
curl -o "docker-compose.yml" "$DOCKER_REPO/docker-compose.yml"
curl -o "bin/docker-entrypoint-web" "$DOCKER_REPO/docker-entrypoint-web"

# puma should not listen to localhost only
sed -i '' 's/-p 3000/-p 3000 -b 0.0.0.0/' Procfile.dev

# commit changes
git fetch
git add .
git commit origin -m "Added docker"

# build image
docker compose build

# replay instructions from configure
echo "Next you can run `docker compose run web bin/setup` and then `docker compose up`."
