FROM golang:1.18-alpine
LABEL MAINTAINER="dipankar das <dipsonu10@hotmail.com>"
RUN apk add curl
WORKDIR /app
COPY . /app
RUN go get -d
RUN go build -o frontend
CMD ["./frontend"]
EXPOSE 80