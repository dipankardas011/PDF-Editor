# How to Make [*Dev*]

Use the two PDFs `01.pdf` and `02.pdf` from testFiles/ for testing purposes

```sh
cd backEnd/merger

docker build --target dev -t <image> .

docker run -it --rm --publish 80:8080 -v ${PWD}:/go/src <image>

# then go
localhost:80
```

# For Testing
```sh
cd backEnd/merger

docker build --target test -t <image> .

docker run --rm <image>

```

> ⚠️**NOTE** : Before you commit remove any executable generated during you testing and development

# Error codes

Code | Description
-|-
501 | unable to load template html
502 | merge error
503 | unable to clean