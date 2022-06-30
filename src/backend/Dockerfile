FROM golang:1.18-alpine as prod
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
RUN apk add qpdf
WORKDIR /go/src
COPY . .
RUN rm -rf uploads/
RUN go get -d
RUN go build -o backend
CMD ["./backend"]
# EXPOSE ${PORT}
EXPOSE 8080


FROM golang:1.18-alpine as dev
RUN apk update
RUN apk add qpdf
WORKDIR /go/src


FROM golang:1.18-alpine as test
RUN apk update
RUN apk add qpdf
WORKDIR /go/src
COPY . .
RUN go get -d
ENTRYPOINT ["go", "test", "."]
