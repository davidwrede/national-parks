#!/bin/bash -xe

DOCKER_CID=$(docker ps | grep "core/mongodb" | awk '{print $1}')
MONGO_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DOCKER_CID)

docker run -it -p 8080:8080 dwrede/national-parks --peer ${MONGO_IP} --bind database:mongodb.default
