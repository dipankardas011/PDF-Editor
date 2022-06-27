# FROM golang:1.18-alpine
FROM node:18-alpine3.15
LABEL MAINTAINER="dipankar das <dipsonu10@hotmail.com>"
RUN apk add curl
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD [ "node", "server.js" ]
EXPOSE 80