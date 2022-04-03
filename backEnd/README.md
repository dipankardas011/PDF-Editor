# How to Make

[**STATUS**]
`Dev`
```shell
docker build -t backend .
# powershell
docker run -it --rm -p 9000:8080 -v ${PWD}:/home backend
# bash
docker run -it --rm -p 9000:8080 -v $PWD:/home backend
```