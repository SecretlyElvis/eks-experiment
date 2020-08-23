# **CI/CD Stand-Alone Cluster in EKS**

![Overview diagram](./images/Overview.jpeg)

*Planned Components:*
- Single Jenkins instance (will expand to 2 in final implementation)
- EFS Mountpoint for Jenkins
- Nexus Instance
- S3 Bucket for Nexus object store (can also be EFS)
- Jenkins/Nexus deployed via Helm Charts

#### Prerequisites
- S3 bucket for state files
- Machine with Docker client installed
- AWS account with appropraite permissions for infrastructure deployment
## **Utilizing this Repo**
Clone repo and change to directory just above `eks-experiment`
1. **Run Docker Container with Terraform 13 / Kubectl / AWS CLI**

`docker run -u 1000:1000 -v $(pwd)/eks-experiment:/opt/app/eks -it secretlyelvis/tf-k8s-aws:T13`

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
4. **Install the EFS CSI driver into the cluster**

*Instructions TBD*

5. **Complete EKS Configuration**
```
./tf-run init k8s
./tf-run plan k8s
./tf-run apply
```
6. **Install Jenkins and Nexus**

*Instructions TBD*

### TODO
- [ ] add NFS inbound rules to cluster security groups
- [ ] EFS CSI driver install instructions
- [ ] configuration of Jenkins
- [ ] S3 bucket for Nexus
- [ ] configuration for Nexus