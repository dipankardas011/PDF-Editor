```sh
helm upgrade --install loki-stack grafana/loki-stack \\n    --set fluent-bit.enabled=true,promtail.enabled=false
kubectl create -f deploy.yml
```
