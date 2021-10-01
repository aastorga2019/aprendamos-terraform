#!/bin/bash

if [[ $(docker ps | grep webserver) ]]; then
  docker rm -f webserver
fi

docker run -d -p 80:80 --name webserver ${DOCKER_IMAGE}
