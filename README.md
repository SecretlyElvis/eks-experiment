# **CI/CD Stand-Alone POC Cluster in EKS**

![Overview diagram](./images/Overview.jpeg)

#### Prerequisites
- S3 bucket for state files
- Machine with Docker client installed
- AWS account with appropraite permissions for infrastructure deployment
## **Utilizing this Repo**
Clone repo and change to directory just above `eks-experiment`
1. **Run Docker Container with Terraform 13 / Kubectl / AWS CLI**

`docker run -u 1000:1000 -v $(pwd)/eks-experiment:/opt/app/eks -it secretlyelvis/tf-k8s-aws:v13`

2. **Initialize AWS Credentials**
```
aws configure set aws_access_key_id "<ACCESS_KEY>"
aws configure set aws_secret_access_key "<SECRET_KEY>"
aws configure set default.region "ap-southeast-2"
```
3. **Change to Code Directory and Deploy Base Infrastructure**
```
cd eks
./tf-run init aws
./tf-run plan aws
./tf-run apply
```
Record the 'cluster_name' and 'region' details from the Terraform output.  To review output again, enter:

`terraform output`

4. **Configure kubectl and install EFS CSI driver**
```
aws eks --region <region> update-kubeconfig --name <cluster name>
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.0"
```
5. **Complete EKS Configuration -- Terraform Option**
```
rm -rf .terraform
./tf-run init k8s
./tf-run plan k8s
./tf-run apply
```
6. **Complete EKS Configuration -- Kubernetes Option**

In file 'pv.yml' replace "EFS_FSID" with output of 'jenkins-fs_fsid', then run:

`kubectl apply -f ./pv.yml`

7. **Deploy Jenkins and Nexus via Helm**

*Instructions TBD*

### TODO
- [ ] configuration of Jenkins
- [ ] configuration for Nexus

### SIX-WEEK PLAN

Areas of Work:

* Integration with testing platform 
* Migration of existing pipelines from each of our CI technologies (GitHub Actions, CodeDeploy, TravisCI) 
* Single Sign-On Integration
* Automation of deployment (from scrath and with pre-existing EFS mounts) 
