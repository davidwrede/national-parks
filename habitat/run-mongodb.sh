#!/bin/bash -xe

docker run -it -p 27017:27017 -e HAB_MONGODB="$(cat mongo.toml)" dwrede/mongodb
