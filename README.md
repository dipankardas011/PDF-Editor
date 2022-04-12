# Online PDF Editor 🥳

website that can edit PDF's

[![Golang and Docker CI](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CI.yaml/badge.svg?branch=main)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CI.yaml) [![pages-build-deployment](https://github.com/dipankardas011/PDF-Editor/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/pages/pages-build-deployment)

### Tech Stack
* GO
* Docker
* HTML
<!--  redis DB -->


## Current Deployment is on Heroku

# Website
![](./coverpage.png)

# Website Link
[Click Here](https://pdf-editor-tool.herokuapp.com/)

## WORK 🚧
Work | Status
-|-
Backend | ✅
Database | 🚧


# Flow of the program using Graphs
```mermaid
flowchart LR;
    XX[START]:::white-->web{Website};
    web{Website}-->B{file1 uploaded};
    web{Website}-->C{file2 uploaded};
    DD{Download Link}-->web{Website};

    classDef green color:#022e1f,fill:#00f500;
    classDef red color:#022e1f,fill:#f11111;
    classDef white color:#022e1f,fill:#fff;
    classDef black color:#fff,fill:#000;

    B--upload 1-->S[GO Server]:::green;
    C--upload 2-->S[GO Server]:::green;

    S[GO server]-->DD{Download Link}

```

# How to Run

```bash
./Runner.sh
```

## connect to the redis db `UNDER DEVELOPMENT`

```bash
docker ps
docker exec it <container id> bash
redis-cli
```

## connect to the frontend

```url
localhost:80
```

Happy Coding 🥳

<!-- ```bash
heroku container:login
heroku create -a <Application name>
heroku container:push web -a <Application name>
heroku container:release web -a <Application name>
``` -->
