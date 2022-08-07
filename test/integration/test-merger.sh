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


Call_Cleanup() {
  echo -e "\n================================================================"
  echo -e "\n$(tput setaf 3)$(tput bold)Cleanup Started$(tput init)"
  docker rm -f frontend backend-merge
  docker network rm xyz
  echo -e "$(tput setaf 2)$(tput bold) ✓ [DONE] Cleanup$(tput init)"
}

counterEndpoints=0

NO_OF_ENDPOINTS=5

sleep 2
echo -e "\n$(tput setaf 3)$(tput bold)Testing all Endpoints$(tput init)"
echo -e "\n$(tput setaf 3)$(tput bold)- /$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /about$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /merger$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /rotator$(tput init)"
echo -e "\n$(tput setaf 3)$(tput bold)- /merge/clear$(tput init)"
# echo -e "$(tput setaf 3)$(tput bold)- /merge/clear$(tput init)"
# echo -e "$(tput setaf 3)$(tput bold)- /merge/clear$(tput init)"


# @@ ALL GENERAL INDEX FILE TESTING WITH THEIR ENDPOINTS

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint /$(tput init)"
hello=$(curl -X GET http://localhost:$PORT | grep -e '<a class="navbar.*" href="#">PDF Editor.*<\/a>' | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /$(tput init)"
fi

echo "----------------------------------------------------------------"


echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint /about$(tput init)"
hello=$(curl -X GET http://localhost:$PORT/about | grep -e '<a class="navbar.*" href="#">PDF Editor.*<\/a>' | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /about$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /about$(tput init)"
fi


echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint /merger$(tput init)"

hello=$(curl -X GET http://localhost:$PORT/merger | grep -e '<a class="navbar.*" href="#">PDF Merge.*<\/a>' | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merger$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /merger$(tput init)"
fi


echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint /rotator$(tput init)"

hello=$(curl -X GET http://localhost:$PORT/rotator | grep -e '<a class="navbar.*" href="#">PDF Rotate.*<\/a>' | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /rotator$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /rotator$(tput init)"
fi


echo "----------------------------------------------------------------"

# @@ TESTING ALL MERGER ENDPOINTS

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/merge/clear'$(tput init)"

hello=$(curl -X GET http://localhost:$PORT/merge/clear | grep -ie "<div.*;alert-success.*>Cleared the data!!.*<\/div>" | wc -l)

if [[ $hello -eq 0 ]]
then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merge/clear$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /merge/clear$(tput init)"
fi

echo -e "\n----------------------------------------------------------------"

if [[ $counterEndpoints != $NO_OF_ENDPOINTS ]]; then
  echo -e "\n$(tput setaf 1)$(tput bold) ✗ $(($NO_OF_ENDPOINTS - $counterEndpoints))/$NO_OF_ENDPOINTS [Failed] the test of Endpoints$(tput init)"
  Call_Cleanup
  exit 1
else
  echo -e "\n$(tput setaf 2)$(tput bold) ✓ $counterEndpoints/$NO_OF_ENDPOINTS [PASSED] the test of Endpoints$(tput init)"
fi


Call_Cleanup
exit 0