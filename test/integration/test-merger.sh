#!/bin/bash

# create container backend
cd ../../src/backend/merger
docker build --target prod -t backend .

# create container frontend
cd ../../frontend
docker build --target prod -t frontend .

# create a isolated network
docker network create xyz

docker run --rm \
  -d \
  --net xyz \
  --name backend-merge \
  -p 8080 \
  backend

docker run --rm \
  -d \
  --net xyz \
  --name frontend \
  -p $PORT:80 \
  frontend

sleep 5

# test the curl
curl -X GET http://localhost:$PORT

echo "Clean up"

docker rm -f frontend backend-merge
docker network rm xyz
