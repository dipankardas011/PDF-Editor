FROM golang:latest as web
RUN apt-get update && \
    apt-get -y upgrade
RUN apt install qpdf -y
WORKDIR /app
COPY . /app
RUN go get -d
RUN go build -o main .
CMD ["/app/main"]
EXPOSE 8080
