#!/bin/sh

# building the docker images
backend_docker_build() {
  # cd src/backend && docker build -t dipugodocker/pdf-editor:backend .
  cd src/backend && docker build -t dipugodocker/pdf-editor:backend . --no-cache
}

frontend_docker_build() {
  # cd ../frontend && docker build -t dipugodocker/pdf-editor:frontend .
  cd ../frontend && docker build -t dipugodocker/pdf-editor:frontend . --no-cache
}

backend_docker_build


frontend_docker_build

docker images | grep pdf | head -n2