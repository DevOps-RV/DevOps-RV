# Helm Installation Instructions

## HAProxy Ingress Controller

```bash
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update

helm install haproxy-ingress haproxytech/kubernetes-ingress \
  --namespace haproxy-controller --create-namespace \
  -f haproxy-values.yaml
```

## NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f nginx-values.yaml
```
