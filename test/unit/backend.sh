#!/bin/sh
cd ../../src/backend/
go get backend
go build -v .

go test -v .