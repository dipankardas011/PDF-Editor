#!/bin/sh
echo "Running Tests for backend"
echo -e "\n$(tput setaf 5)$(tput bold)Running Tests for backend-merge$(tput init)"

cd ../../src/backend/merger
docker build --target test -t xyz . --no-cache
docker run --rm xyz

echo -e "\n$(tput setaf 5)$(tput bold)Running Tests for backend-rotate$(tput init)"

cd ../rotator
docker build --target test -t xyz . --no-cache
docker run --rm xyz

echo -e "\n$(tput setaf 5)$(tput bold)Running Tests for frontend$(tput init)"
cd ../../frontend
docker build --target test -t xyz . --no-cache
docker run --rm xyz

echo -e "\n$(tput setaf 2)$(tput bold)Cleaning Docker image generated$(tput init)"
docker rmi -f xyz