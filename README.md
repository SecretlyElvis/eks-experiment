# **Basic CI/CD Stand-Alone POC Cluster in EKS**

![Overview diagram](./images/Overview.jpeg)

#### Prerequisites
- S3 bucket for Terraform state files (configured in 'terraform/backendd.tfvars')
- Local machine with command line terminal and Docker client installed
- AWS account with appropraite permissions for infrastructure deployment
## **Utilizing this Repo**
Clone repo and change to directory just above `eks-experiment`
1. **Run Docker Container with Terraform 13.x / Kubectl / Helm / AWS CLI**

`docker run -u 1000:1000 -v $(pwd)/eks-experiment:/opt/app/eks -it secretlyelvis/tf-k8s-aws:v13`

2. **Initialize AWS Credentials**
```
aws configure set aws_access_key_id "<ACCESS_KEY>"
aws configure set aws_secret_access_key "<SECRET_KEY>"
aws configure set default.region "ap-southeast-2"
```
3. **Deploy Base Infrastructure**
```
cd terraform
./tf-run init aws
./tf-run plan aws
./tf-run apply
```
Record the `cluster_name` and `region` details from the Terraform output.  To review output again:

`terraform output`

4. **Configure 'kubectl'**

`aws eks --region <region> update-kubeconfig --name <cluster name>`

5. **Deploy Jenkins**

Configure Helm
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
```

`kubectl apply -f ./pv.yml`



5. **Deploy Nexus**


#### Out of Scope
- Security