### ALB Ingress Controller Test Application Deployment/Tear Down

To apply directly:

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$VERSION/docs/examples/2048/2048-namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$VERSION/docs/examples/2048/2048-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$VERSION/docs/examples/2048/2048-service.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$VERSION/docs/examples/2048/2048-ingress.yaml

As of 23-Nov-2020, 'v2.0.0' was the latest $VERSION available

If using local YAML files, order to deploy:

* Namespace
* Deployment 
* Service 
* Ingress 

Verify ingress was created (may take a few minutes):
curl -o 2048-ingress.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v2.0.0/docs/examples/2048/2048-ingress.yaml

If no ingress is created, check the logs:
kubectl logs -n kube-system deployment.apps/aws-load-balancer-controller

Order to destroy:
* Namespace 

-- or --

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/$VERSION/docs/examples/2048/2048-namespace.yaml
