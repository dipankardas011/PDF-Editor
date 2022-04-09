FROM golang:latest
RUN apt-get update && \
    apt-get -y upgrade
RUN apt install qpdf -y
WORKDIR /app
COPY . /app
RUN go get -d
RUN go build -o backend
CMD ["./backend"]
EXPOSE 80
