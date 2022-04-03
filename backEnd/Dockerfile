FROM golang:latest
RUN apt-get update && \
    apt-get -y upgrade
RUN apt install qpdf -y
RUN mkdir /app 
ADD . /app
WORKDIR /app
RUN go get -d
RUN go build -o main .
CMD ["/app/main"]
EXPOSE 8080
