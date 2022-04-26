# Helm plugin
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/pdf-editor-web)](https://artifacthub.io/packages/search?repo=pdf-editor-web)

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:
```
helm repo add <alias> https://dipankardas011.github.io/PDF-Editor/
helm install my-pdf-editor-helm pdf-editor-web/pdf-editor-helm --version 0.1.0

```
If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
<alias>` to see the charts.

To install the <chart-name> chart:
```
kubectl create ns pdf
helm repo add pdf-editor-web https://dipankardas011.github.io/PDF-Editor/
helm install my-pdf-editor-helm pdf-editor-web/pdf-editor-helm --version 0.1.0
```
To uninstall the chart:

    helm delete my-pdf-editor-helm
