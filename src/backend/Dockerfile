FROM golang:1.18-alpine
RUN apk add qpdf
WORKDIR /go/src
COPY . .
RUN rm -rf uploads/
RUN go get -d
RUN go build -o backend
CMD ["./backend"]
# EXPOSE ${PORT}
EXPOSE 8080
