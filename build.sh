#!/bin/sh

# building the docker images
backend_docker_build() {
  cd src/backend && docker build -t backend:pdf . --no-cache
}

frontend_docker_build() {
  cd ../frontend && docker build -t frontend:pdf . --no-cache
}

backend_docker_build


frontend_docker_build

docker images | grep pdf | head -n2