#!/bin/bash

sudo su - admin

cd /home/admin

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

mkdir main
cd main
cat << EOF > docker-compose.yml
version: '1.0'
services:
  backend:
    image: docker.io/dipugodocker/pdf-editor:backend
    container_name: backend
    ports:
      - "8080"
    networks:
      - pdf-editor
    volumes:
      - db_data:/app/

  frontend:
    depends_on:
      - backend
    image: docker.io/dipugodocker/pdf-editor:frontend
    container_name: frontend
    ports:
      - "80:80"
    networks:
      - pdf-editor

networks:
  pdf-editor:

volumes:
  db_data:
EOF

sudo docker compose up -d