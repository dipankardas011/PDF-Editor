#!/bin/bash

cd backEnd/
pwd
docker build -t dipugodocker/pdf-editor:$version .
docker run --rm -d -p 80:80 dipugodocker/pdf-editor:$version
sleep 5
