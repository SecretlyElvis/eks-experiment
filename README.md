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
Record the `cluster_name`, `region` and `pstorage-fs_dns` from the Terraform output for later steps.

To review output again:
`terraform output`

4. **Configure 'kubectl' to utilize EKS Cluster**

`aws eks --region <region> update-kubeconfig --name <cluster name>`

5. **Deploy Jenkins**

Create a namespace for the Jenkins DEV deployment:

`kubectl create namespace jenkins-dev`

Replace `<EFS_URL>` in the file `helm/jenkins/pv-jenkins.yml` with `pstorage-fs_dns` value from Terraform.

Deploy PersistentVolume for Jenkins DEV:

`kubectl apply -f helm/jenkins/pv-jenkins.yml`

Deploy Service Account and Cluster Role for Jenkins DEV:

`kubectl apply -f helm/jenkins/sa-jenkins.yml`

Update the `installPlugins:` section of `helm/jenkins/values-jenkins.yml` to add any desired plugins during install.

Configure Helm and deploy `jenkinsci/jenkins` chart:
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm install jenkins-dev -n jenkins-dev -f helm/jenkins/values-jenkins.yml jenkinsci/jenkins
```
The server can take several minutes to start up as modules are installed.  Check status with:

`kubectl get pods -n jenkins-dev`

Retrieve the generated 'admin' user password for initial access:
```
path="{.data.jenkins-admin-password}"
secret=$(kubectl get secret -n jenkins jenkins -o jsonpath=$path)
echo $(echo $secret | base64 --decode)
```

5. **Deploy Nexus**

TBD

#### TODO

- Ingress configuration through LoadBalancer (ClusterIP on individual pods?)
- Jenkins access to Nexus pod/namespace within Kubernetes
- Security review