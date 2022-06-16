FROM golang:1.18-bullseye as dev
RUN apt update
RUN apt install qpdf -y
WORKDIR /app


FROM golang:1.18-bullseye as test
RUN apt-get update
RUN apt install qpdf -y
WORKDIR /app
COPY . /app
RUN go get -d
ENTRYPOINT ["go", "test", "."]

FROM golang:1.18-bullseye as prod
RUN apt-get update && \
    apt-get -y upgrade
RUN apt install qpdf -y
RUN apt auto-remove curl -y
WORKDIR /app
COPY . /app
RUN go get -d
RUN rm -rf uploads/
RUN go build -o backend
CMD ["./backend"]
EXPOSE ${PORT}
