#!/bin/bash

cd db/
pwd
docker build -t dipugodocker/nginxdatabase:$version .
docker run -d dipugodocker/nginxdatabase:$version
sleep 5