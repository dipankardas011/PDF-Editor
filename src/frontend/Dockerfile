# FROM golang:1.18-alpine
FROM node:18-alpine3.15 as prod
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
RUN apk add curl
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD [ "node", "server.js" ]
EXPOSE 80

FROM node:18-alpine3.15 as dev
RUN apk add curl
WORKDIR /app
COPY package.json .
RUN npm install

FROM node:18-alpine3.15 as test
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
RUN apk add curl
WORKDIR /app
COPY package.json .
COPY . .
#RUN npm test
