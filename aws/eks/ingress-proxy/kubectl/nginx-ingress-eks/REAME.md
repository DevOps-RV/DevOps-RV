kubectl create namespace ingress-nginx
kubectl apply -f nginx-controller.yaml
kubectl apply -f alb-router.yaml
kubectl apply -f ingress-service-a.yaml