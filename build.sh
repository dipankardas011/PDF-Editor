#!/bin/sh


BACKEND='dipugodocker/pdf-editor:backend'
FRONTEND='dipugodocker/pdf-editor:frontend'

# building the docker images
backend_docker_build_dev() {
  echo 'Building Dev [Backend]'
  cd src/backend/merger && docker build --target dev -t $BACKEND .
}

frontend_docker_build_dev() {
  echo 'Building Dev [Frontend]'
  cd ../../frontend && docker build --target dev -t $FRONTEND .
}


# building the docker images
backend_docker_build_prod() {
  echo 'Building Prod [Backend]'
  cd src/backend/merger && docker build --target prod -t $BACKEND . --no-cache
}

frontend_docker_build_prod() {
  echo 'Building Prod [Frontend]'
  cd ../../frontend && docker build --target prod -t $FRONTEND . --no-cache
}

# building the docker images
backend_docker_build_test() {
  echo 'Building Test [Backend]'
  cd src/backend/merger && docker build --target test -t $BACKEND . --no-cache
}

frontend_docker_build_test() {
  echo 'Building Test [Frontend]'
  cd ../../frontend && docker build --target test -t $FRONTEND . --no-cache
}


echo 'Enter 0 for prod, 1 for dev, 2 for test'

read choice

if [[ $choice -eq 0 ]]
then
  backend_docker_build_prod
  frontend_docker_build_prod
elif [[ $choice -eq 1 ]]
then
  backend_docker_build_dev
  frontend_docker_build_dev
elif [[ $choice -eq 2 ]]
then
  backend_docker_build_test
  frontend_docker_build_test
else
  echo 'Invalid request'
  return 1
fi

echo 'docker container ps'

docker images | grep pdf | head -n2