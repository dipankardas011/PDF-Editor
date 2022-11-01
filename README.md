# Web-based PDF Editor 🥳

Website that can edit PDF's to give you a Merged or a Rotated version of it

[![Golang and Docker CI](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CI.yaml/badge.svg?branch=main)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CI.yaml) [![pages-build-deployment](https://github.com/dipankardas011/PDF-Editor/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/pages/pages-build-deployment) [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/pdf-editor-web)](https://artifacthub.io/packages/search?repo=pdf-editor-web) [![CodeQL](https://github.com/dipankardas011/PDF-Editor/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/codeql-analysis.yml) [![\[Stable\](Backend-merger) Docker Signed Image Release](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-backend-merge.yaml/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-backend-merge.yaml) [![\[Stable\](Backend-rotate) Docker Signed Image Release](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-backend-rotate.yaml/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-backend-rotate.yaml) [![\[Stable\](Frontend) Stable Docker Signed Image Release](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-frontend.yaml/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/CD-frontend.yaml) [![Datree-policy-Checks](https://github.com/dipankardas011/PDF-Editor/actions/workflows/Datree-CD.yaml/badge.svg?branch=main)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/Datree-CD.yaml) [![ImageScan [Aqua Trivy]](https://github.com/dipankardas011/PDF-Editor/actions/workflows/imageScan.yaml/badge.svg)](https://github.com/dipankardas011/PDF-Editor/actions/workflows/imageScan.yaml) [![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/dipankardas011/PDF-Editor)[![CircleCI](https://dl.circleci.com/status-badge/img/gh/dipankardas011/PDF-Editor/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/dipankardas011/PDF-Editor/tree/main)


## Software Requirement Specification

[Link for entire Documentation about this project](https://docs.google.com/document/d/e/2PACX-1vQvfAZFG0Tw9MAXtXXXDDGFZ6967Iz9CK1rTE9Gl-cR8fKF268qoggKPIUhKGD3fWszGFEUfwoKYC9D/pub)

[Project Board For Current Status](https://github.com/users/dipankardas011/projects/2/views/1)

~Jenkins server -> [URL](http://ec2-XX-XX-XX-XX.compute-1.amazonaws.com:8080/)~
> **Note**

> User: `guest`
> Pass: `77777`

> (Available till 15th Sep '22) Due to 💰 had to stop the instance

Stage | Tags | Links | Status
--|--|--|--
Production | `1.0` | https://pdf-web-editor.azurewebsites.net/, http://70f4921e-d7ff-4641-aa81-efe510f687ac.lb.civo.com | ✅
Alpha | `latest` ; `1.0` | http://44.209.39.161/ | ✅

> A Humble request! 🙏 don't expoit the resources I have used here

> Release Cycle of ~1 Month

### Tech Stack
* GO
* Docker & Docker-Compose
* HTML
* K8s
* Helm
* ArgoCD
* Terraform
* Flux
* Prometheus

# Website
![](./coverpage.png)


# How to Run

## Kustomize install
```bash
kubectl apply -k deploy/cluster/backend
kubectl apply -k deploy/cluster/frontend
```

---


## Helm plugin

### Usage


```bash
kubectl create ns pdf
helm repo add pdf-editor-web https://dipankardas011.github.io/PDF-Editor/
helm install my-pdf-editor-helm pdf-editor-web/pdf-editor-helm --version 0.1.0
```
To uninstall the chart:

    helm delete my-pdf-editor-helm

---

## From Source Code
```bash
cd deploy/cluster/
kubectl create ns pdf
helm install <Release Name> ./pdf-editor-helm
helm uninstall <Release Name> ./pdf-editor-helm
```

---

## ArgoRollouts
```
# using Argo-CD to deploy
deploy the path deploy/rollouts
With namespace set to pdf-editor-ns
```

# How to Run

```bash
make run
```

# How to Dev

```bash
cd src/
skaffold dev
```

# How to Test

```bash
# Integration testing
make unit-test
# Integration testing
make integration-test
```


# To View the page visit

```url
http://localhost
```

# More Info
<details>
<summary><kbd>Production Cluster</kbd></summary>
<h3>Civo Dashboard</h3>

![image](https://user-images.githubusercontent.com/65275144/199149205-3c34da17-6b68-46ec-b2ce-737d09dc132c.png)

<h3>Youtube Video</h3>
    
[![IMAGE ALT TEXT](http://img.youtube.com/vi/bstJHtv0L_s/0.jpg)](http://www.youtube.com/watch?v=bstJHtv0L_s "Video Title")
    
</details>

# Blog Post on this project
[![](./coverpage.png)](https://blog.kubesimplify.com/about-my-pdf-editor-project)


# Decission Tree

# Trace
![](./trace.png)

## Frontend -> Backend-Merger
```mermaid
flowchart LR;
    XX[START]:::white--/merger-->web{Website};
    web{Website}-->B{Upload PDF1};
    web{Website}-->C{Upload PDF2};
    DD{Download Link}-->web{Website};

    classDef green color:#022e1f,fill:#00f500;
    classDef red color:#022e1f,fill:#f11111;
    classDef white color:#022e1f,fill:#fff;
    classDef black color:#fff,fill:#000;
    classDef BLUE color:#fff,fill:#00f;

    B--Upload PDF-1-->S[GO Server]:::green;
    C--Upload PDF-2-->S[GO Server]:::green;

    S[GO server]-->DD{Merged PDF available}
    web--/merger/download-->dd{Download};
    dd--->YY[END]:::BLUE;
```

## Frontend -> Backend-Rotator
```mermaid
flowchart LR;
    XX[START]:::white--/rotator-->web{Website};
    web{Website}-->B{Upload PDF};
    web{Website}-->C{Additional Parameters};
    DD{Download Link}-->web{Website};

    classDef green color:#022e1f,fill:#00f500;
    classDef red color:#022e1f,fill:#f11111;
    classDef white color:#022e1f,fill:#fff;
    classDef black color:#fff,fill:#000;
    classDef BLUE color:#fff,fill:#00f;

    B--Upload PDF-->S[GO Server]:::green;
    C--upload Params-->S[GO Server]:::green;

    S[GO server]-->DD{Rotated PDF available}
    web--/rotator/download-->dd{Download};
    dd--->YY[END]:::BLUE;

```

[**Changelog link**](./CHANGELOG.md)

[**Code Of Conduct**](./code-of-conduct.md)

[**Contributing Guidelines**](./CONTRIBUTING.md)

Happy Coding 👍🏼🥳


<a href = "https://github.com/dipankardas011/PDF-Editor/graphs/contributors"><img src = "https://contrib.rocks/image?repo=dipankardas011/PDF-Editor"/></a>

Made with [contributors-img](https://contrib.rocks).
