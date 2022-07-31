#!/bin/sh
cd ../../src/backend/merger
go get github.com/dipankardas011/Merge-PDF/src/backend/merger
go build -v .

go test -v .