FROM golang:1.18-bullseye
RUN apt-get update && apt-get -y upgrade
RUN apt install qpdf -y
RUN apt auto-remove curl -y
WORKDIR /app
COPY . /app
RUN go get -d
RUN rm -rf uploads/
RUN go build -o backend
CMD ["./backend"]
# EXPOSE ${PORT}
EXPOSE 8080
