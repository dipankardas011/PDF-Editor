# How to Make

[**STATUS**]
`Dev`

Place 2 pdf `01.pdf` and `02.pdf` for testing purposes

```shell
cd backend/

docker build -t backend .

docker run -it --rm -p 8080:8080 -v ${PWD}:/app backend
```