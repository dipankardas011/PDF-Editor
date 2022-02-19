#!/bin/bash

cd frontEnd/
pwd
docker build -t dipugodocker/frontend:$version .
docker run -p 8080:80 dipugodocker/frontend:$version
sleep 5