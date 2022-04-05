# How to Make

[**STATUS**]
`Dev`

Place 2 pdf `01.pdf` and `02.pdf` for testing purposes

```shell
cd backend/
docker build -t backend .
# powershell
docker run -it --rm -p 9000:8080 -v ${PWD}:/home backend
# bash
docker run -it --rm -p 9000:8080 -v $PWD:/home backend
```