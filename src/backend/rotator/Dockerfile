FROM golang:1.18-alpine as prod-stage1
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
WORKDIR /go/src
COPY . .
RUN rm -rf uploads/
RUN go get -d
RUN go build -o rotator-executable

FROM alpine:3.16.1 as prod
RUN apk add qpdf
LABEL MAINTAINER="Dipankar Das <dipankardas0115@gmail.com>"
WORKDIR /go/src
COPY --from=prod-stage1 /go/src/templates .
COPY --from=prod-stage1 /go/src/rotator-executable .
CMD ["./rotator-executable"]
EXPOSE 8081

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