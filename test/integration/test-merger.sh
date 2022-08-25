#!/bin/bash

# All the global variables
counterEndpoints=0
NO_OF_ENDPOINTS=6
PORT=9090
isUploadSuccess=1

# create container backend
cd ../../src/backend/merger
docker build --target prod -t backend .

# create container frontend
cd ../../frontend

# making the upload button act like upload button
sed -i "s/(isSuccessfull).*merge.*res.send(storeError)/res.send(ccc2)/g" server.js
sed -i "s/(isSuccessfull).*rotate.*res.send(storeError)/res.send(ccc1)/g" server.js


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

cd ../../test/integration

Call_Cleanup() {
  echo -e "\n================================================================"
  echo -e "\n$(tput setaf 3)$(tput bold)Cleanup Started$(tput init)"
  docker rm -f frontend backend-merge
  cd ../../src/frontend/
  # making the upload button act like both upload and download
  sed -i "s/res.send(ccc2)/(isSuccessfull) ? res.redirect('\/merge\/download') : res.send(storeError)/g" server.js
  sed -i "s/res.send(ccc1)/(isSuccessfull) ? res.redirect('\/rotate\/download') : res.send(storeError)/g" server.js
  cd -
  docker network rm xyz
  rm -f merged.pdf
  echo -e "$(tput setaf 2)$(tput bold) ✓ [DONE] Cleanup$(tput init)"
}


sleep 2
echo -e "\n$(tput setaf 3)$(tput bold)Testing all Endpoints$(tput init)"
echo -e "\n$(tput setaf 3)$(tput bold)- /$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /about$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /merger$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /rotator$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /merge/upload$(tput init)"
echo -e "$(tput setaf 3)$(tput bold)- /merge/download$(tput init)"


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


# @@ TESTING ALL MERGER ENDPOINTS

echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/merge/upload'$(tput init)"
flag=0
echo -e "\n$(tput setaf 6)$(tput bold)  ↕ Upload file 01.pdf$(tput init)"

hello=$(curl --raw --form "myFile=@${PWD}/resources/01.pdf" --form "myFile=@${PWD}/resources/02.pdf" http://localhost:${PORT}/merge/upload | grep -e '<div.*;alert-success role="alert">Uploaded.*<\/div>' | wc -l)
if [[ $hello -eq 0 ]]; then
  echo -e "\n$(tput setaf 1)$(tput bold)  ↕ ✗ [Failed] to upload 01.pdf & 02.pdf$(tput init)"
  flag=1
else
  echo -e "\n$(tput setaf 6)$(tput bold)  ↕ ✓ [Passed] to upload 01.pdf & 02.pdf$(tput init)"
fi


if [[ $flag -eq 1 ]]; then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merge/upload$(tput init)"
else
  counterEndpoints=$((counterEndpoints+1))
  isUploadSuccess=0
  echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /merge/upload$(tput init)"
fi

echo "----------------------------------------------------------------"

echo -e "\n$(tput setaf 5)$(tput bold)Testing Endpoint '/merge/upload & /merge/download'$(tput init)"

if [[ $isUploadSuccess -eq 1 ]]; then
  echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merge/upload so [FAILED]$(tput init)"
else
  hello=$(curl --raw --output merged.pdf -X GET http://localhost:$PORT/merge/download && cat merged.pdf | head -n 5 | grep -be "%PDF.*" | wc -l) # return value is stored in hello
  # hello=$(curl --raw --output merged.pdf --form "myFile=@${PWD}/resources/01.pdf" --form "myFile=@${PWD}/resources/02.pdf" -L http://localhost:$PORT/merge/upload && cat merged.pdf | head -n 5 | grep -be "%PDF.*" | wc -l) # return value is stored in hello
  size01PDF=$(cat resources/01.pdf | tail -n 2 | head -n 1)
  size02PDF=$(cat resources/02.pdf | tail -n 2 | head -n 1)
  sizemergedPDF=$(cat merged.pdf | tail -n 2 | head -n 1)

  # size of merged pdf should be larger than max between the 2 pdfs

  if [[ $size01PDF -gt $size02PDF ]]; then
    if [[ $sizemergedPDF -gt $size01PDF ]] && [[ $hello -gt 0 ]]; then
      counterEndpoints=$((counterEndpoints+1))
      echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /merge/download$(tput init)"
    else
      echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merge/download$(tput init)"
    fi
  else
    if [[ $sizemergedPDF -gt $size02PDF ]] && [[ $hello -gt 0 ]]; then
      counterEndpoints=$((counterEndpoints+1))
      echo -e "\n$(tput setaf 2)$(tput bold)✓ [Passed] the test of Endpoint /merge/download$(tput init)"
    else
      echo -e "\n$(tput setaf 1)$(tput bold)✗ [Failed] the test of Endpoint /merge/download$(tput init)"
    fi
  fi
fi

#
#
# TODO: Add the Failing test cases
#
#


echo -e "\n----------------------------------------------------------------"

if [[ $counterEndpoints != $NO_OF_ENDPOINTS ]]; then
  echo -e "\n$(tput setaf 1)$(tput bold) ✗ $(($NO_OF_ENDPOINTS - $counterEndpoints))/$NO_OF_ENDPOINTS [FAILED] Tests$(tput init)"
  Call_Cleanup
  exit 1
else
  echo -e "\n$(tput setaf 2)$(tput bold) ✓ $counterEndpoints/$NO_OF_ENDPOINTS [PASSED] Tests$(tput init)"
fi

Call_Cleanup
exit 0