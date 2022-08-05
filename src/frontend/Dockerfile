FROM node:16-alpine3.15 as prod
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
RUN apk add curl
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN chown 1000 -R /app/
USER 1000
CMD [ "node", "server.js" ]
EXPOSE 80

FROM node:18-alpine3.15 as dev
RUN apk add curl
WORKDIR /app
COPY package.json .
RUN npm install

FROM node:16 as test
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run test

