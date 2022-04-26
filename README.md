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


## WORK 🚧
Work | Status
-|-
Backend | ✅
Database | 🚧
CI/CD | ✅
AWS Terraform | ✅

# Kustomize install
```bash
cd cluster/pdf-editor-kustomize

kubectl apply -k ./prod/ # or ./dev/

```

# Helm plugin

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add <alias> https://dipankardas011.github.io/PDF-Editor/

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
<alias>` to see the charts.

To install the <chart-name> chart:

    helm repo add pdf-editor-web https://dipankardas011.github.io/PDF-Editor/
    helm install my-pdf-editor-helm pdf-editor-web/pdf-editor-helm --version 0.1.0

To uninstall the chart:

    helm delete my-pdf-editor-helm

## From Source Code
```bash
cd cluster/
kubectl create ns pdf
helm install <Release Name> ./pdf-editor-helm
helm uninstall <Release Name> ./pdf-editor-helm
```

# AWS Terraform
![](./coverpageAWS.png)
```bash
cd IAC/AWS
terraform init
terraform apply
# here you have to provide your access key and secret key to the input
# go to 
<Elastic ip>:8080
```

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

Happy Coding 👍🏼🥳


<a href = "https://github.com/dipankardas011/PDF-Editor/graphs/contributors">
<img src = "https://contrib.rocks/image?repo=dipankardas011/PDF-Editor"/>
</a>
Made with [contributors-img](https://contrib.rocks).
