FROM golang:1.18-alpine
RUN apk add qpdf
WORKDIR /app
COPY . /app
RUN go get -d
RUN rm -rf uploads/
RUN go build -o backend
CMD ["./backend"]
# EXPOSE ${PORT}
EXPOSE 8080
