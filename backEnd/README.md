# How to Make

[**STATUS**]
`Alpha`

Place 2 pdf `01.pdf` and `02.pdf` from testFiles/ for testing purposes

```shell
cd backEnd/

docker build -t backend .

docker run -it --rm -p 80:8080 -v ${PWD}:/app backend
docker run -it --rm -p 80:8080 backend

# then go 
localhost:80

# OR

# go to the root dir and run the shell script
./Runner.sh
```

# Error codes

Code | Description
-|-
501 | unable to load template html
502 | merge error
503 | unable to clean