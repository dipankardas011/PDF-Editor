#!/bin/bash
kubectl apply -k deploy/cluster/backend
kubectl apply -k deploy/cluster/frontend
kubectl apply -f deploy/cluster/monitoring/prometheus-deploy.yml

helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace

kubectl apply -f deploy/policy