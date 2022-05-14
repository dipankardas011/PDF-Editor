# How to Make [*Dev*]

Use the two PDFs `01.pdf` and `02.pdf` from testFiles/ for testing purposes

```sh
cd backEnd/

docker build --target=dev -t <image> .

docker run -it --rm --publish 80:8080 -v ${PWD}:/app <image>

# then go 
localhost:80
```

# For Testing
```sh
cd backEnd/

docker build --target=test -t <image> .

docker run -it --rm <image>

```

> ⚠️**NOTE** : Before you commit remove any executable generated during you testing and development

# To check for the ports
```bash
cd backEnd/
docker build -t xyz .
docker run -it -e PORT=9000 --publish 80:9000 xyz
```

# Error codes

Code | Description
-|-
501 | unable to load template html
502 | merge error
503 | unable to clean