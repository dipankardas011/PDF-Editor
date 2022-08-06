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

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/'$(tput init)"
hello=$(curl -X GET http://localhost:$PORT | grep -i "PDF Editor" | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint'/'$(tput init)"
  docker rm -f frontend backend-merge
  docker network rm xyz
  exit 1

else
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint'/'$(tput init)"
fi

echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/merge/clear'$(tput init)"

hello=$(curl -X GET http://localhost:$PORT/merge/clear | grep -i "Cleared the data!!" | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint'/merge/clear'$(tput init)"
  docker rm -f frontend backend-merge
  docker network rm xyz
  exit 1

else
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint'/merge/clear'$(tput init)"
fi

echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/merger'$(tput init)"

hello=$(curl -X GET http://localhost:$PORT/merger | grep -i "PDF Merger" | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint'/merger'$(tput init)"
  docker rm -f frontend backend-merge
  docker network rm xyz
  exit 1

else
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint'/merger'$(tput init)"
fi


echo "Clean up"
echo -e "\n$(tput setaf 4)$(tput bold)Cleanup Started$(tput init)"
docker rm -f frontend backend-merge
docker network rm xyz
exit 0