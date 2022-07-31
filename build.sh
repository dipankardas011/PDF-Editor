#!/bin/sh

# TODO: when removing the tag backend and frontend ensure all the are changed it used everywhere

BACKEND_MERGE='dipugodocker/pdf-editor:backend-merge'
BACKEND_DATABASE='dipugodocker/pdf-editor:backend-db'
BACKEND_ROTATE='dipugodocker/pdf-editor:backend-rotate'
FRONTEND='dipugodocker/pdf-editor:frontend'

# building the docker images
backend_docker_build_dev() {
  echo '[🙂] Building for Devlopment [Backend-merger]'
  cd src/backend/merger && docker build --target dev -t $BACKEND_MERGE .
  echo '[🙂] Building for Devlopment [Backend-rotator]'
  cd ../rotator && docker build --target dev -t $BACKEND_ROTATE .
  echo '[🙂] Building for Devlopment [Backend-database]'
  cd ../db && docker build --target db-prod -t $BACKEND_DATABASE .
}

frontend_docker_build_dev() {
  echo 'Building Dev [Frontend]'
  cd ../../frontend && docker build --target dev -t $FRONTEND .
}


# building the docker images
backend_docker_build_prod() {
  echo '[🏭] Building for Production [Backend-merger]'
  cd src/backend/merger && docker build --target prod -t $BACKEND_MERGE . --no-cache
  echo '[🏭] Building for Production [Backend-rotator]'
  cd ../rotator && docker build --target prod -t $BACKEND_ROTATE . --no-cache
  echo '[🏭] Building for Production [Backend-database]'
  cd ../db && docker build --target db-prod -t $BACKEND_DATABASE . --no-cache
}

frontend_docker_build_prod() {
  echo 'Building Prod [Frontend]'
  cd ../../frontend && docker build --target prod -t $FRONTEND . --no-cache
}

# building the docker images
backend_docker_build_test() {
  echo '[🧪] Building for Testing [Backend-merger]'
  cd src/backend/merger && docker build --target test -t $BACKEND_MERGE . --no-cache
  echo '[🧪] Building for Testing [Backend-rotator]'
  cd ../rotator && docker build --target test -t $BACKEND_ROTATE . --no-cache
  echo '[🧪] Building for Testing [Backend-database]'
  cd ../db && docker build --target db-prod -t $BACKEND_DATABASE . --no-cache
}

frontend_docker_build_test() {
  echo 'Building Test [Frontend]'
  cd ../../frontend && docker build --target test -t $FRONTEND . --no-cache
}


# echo 'Enter 0 for prod, 1 for dev, 2 for test'

# read choice

if [ $# != 1 ]; then
  echo -n "
Help [1 argument required]
0 Production
1 Development
2 Testing
"
  exit 1
fi

choice=$1

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

docker images | grep pdf-editor | head -n4