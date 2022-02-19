#!/bin/sh

# start the db
echo Starting nginx
export version="v1"
./dbRunner.sh
docker ps
echo Starting frontEnd
./feRunner.sh