chart-template/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   └── _helpers.tpl


helm install my-release ./eks-service-chart-template --set image.repository=my-repo/image-name --set image.tag=my-tag