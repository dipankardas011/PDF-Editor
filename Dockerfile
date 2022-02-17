FROM node:latest
FROM go:latest
FROM redis:latest

COPY . /app

WORKDIR /app

EXPOSE 8080

CMD [ "echo", "Created the container" ]