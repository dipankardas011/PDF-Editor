# How to Make

[**STATUS**]
`Alpha`

Place 2 pdf `01.pdf` and `02.pdf` for testing purposes

```shell
cd backEnd/

docker build -t backend .

docker run -it --rm -p 80:8080 -v ${PWD}:/app backend
docker run -it --rm -p 80:8080 backend
```