# **Basic CI/CD Stand-Alone POC Cluster in EKS**

![Overview diagram](./images/Overview.jpeg)

#### Prerequisites
- S3 bucket for Terraform state files (configured in 'terraform/backendd.tfvars')
- Local machine with command line terminal and Docker client installed
- AWS account with appropraite permissions for infrastructure deployment
## **Utilizing this Repo**
Clone repo and change to directory just above `eks-experiment`
1. **Run Docker Container with Terraform 13.x / Kubectl / Helm / AWS CLI**

`docker run -u 1000:1000 -v $(pwd)/eks-experiment:/opt/app/eks -it secretlyelvis/devops-poc:tf13`

2. **Initialize AWS Credentials**
```
aws configure set aws_access_key_id "<ACCESS_KEY>"
aws configure set aws_secret_access_key "<SECRET_KEY>"
aws configure set default.region "ap-southeast-2"
```
3. **Deploy Base Infrastructure**
```
cd terraform
./tf-run init aws/
./tf-run plan aws/
./tf-run apply
```
Record the `cluster_name`, `region`, `pstorage-fs_fsid` and `alb-policy-arn` from the Terraform output for later steps.

4. **Configure 'kubectl' to utilize EKS Cluster**

`aws eks --region <region> update-kubeconfig --name <cluster name>`

5. **Install Required Kubernetes Components**

- Install EFS CSI driver:

`kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.0"`

- **Install AWS ALB Ingress Controller**

- Create an IAM OIDC provider and associate it with your cluster:

```
eksctl utils associate-iam-oidc-provider \
    --region <region-code> \
    --cluster <my-cluster> \
    --approve
```

- The following command creates several components to be used by the Load Balancer Controller:
  - IAM Role
  - Kubernetes Service Account named 'aws-load-balancer-controller' (in the 'kube-system' namespace)
  - Cluster Role
  - Cluster Role Binding

Replace `<aln-policy-arn>` with the value from Terraform output above.

```
eksctl create iamserviceaccount \
  --cluster=<my-cluster> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=<alb-policy-arn>> \
  --override-existing-serviceaccounts \
  --approve
```

- Install the TargetGroupBinding custom resource definitions: 

`kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"`

- Install the `eks-charts` Helm repository and install the AWS load balancer controller: 

```
helm repo add eks https://aws.github.io/eks-charts

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  -n kube-system
```

- Verify that the conroller is installed:

`kubectl get deployment -n kube-system aws-load-balancer-controller`

_You should see something similar to:_

```
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   1/1     1            1           84s
```

6. **Deploy Jenkins (Charts)**

- Create a namespace for the Jenkins DEV deployment:

`kubectl create namespace jenkins-dev`

- Deploy PersistentVolume for Jenkins DEV:

Make the following replacements in file `helm/jenkins/jenkins-pv.yml`:

  `<FS_ID>` --> `pstorage-fs_fsid` value from Terraform (*e.g. 'fs-04be623c'*)

  `<FSAP_ID>` --> `pstorage-jenkins_apid` (*e.g. 'fsap-055e6d74b33a0ed6a'*)

`kubectl apply -f helm/jenkins/jenkins-pv.yml`

- Deploy Service Account and Cluster Role for Jenkins DEV:

`kubectl apply -f helm/jenkins/jenkins-sa.yml`

- Configure Helm and deploy `jenkinsci/jenkins` chart:

Optional: update the `installPlugins:` section of `helm/jenkins/jenkins-values.yml` to add any desired plugins during install.
```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm install jenkins-dev -n jenkins-dev -f helm/jenkins/jenkins-values.yml jenkinsci/jenkins
```
The server can take several minutes to start up as modules are installed.  Check status with:

`kubectl get pods -n jenkins-dev`

- Retrieve the generated 'admin' user password for initial access:
```
path="{.data.jenkins-admin-password}"
secret=$(kubectl get secret -n jenkins-dev jenkins-dev -o jsonpath=$path)
echo $(echo $secret | base64 -d)
```

7. **Deploy Nexus (YAML)**

- Create a namespace for the Nexus PRD deployment:

`kubectl create namespace nexus-prd`

Make the following replacements in file `helm/jenkins/nexus-pv.yml`:

  `<FS_ID>` --> `pstorage-fs_fsid` value from Terraform (*e.g. 'fs-04be623c'*)

  `<FSAP_ID>` --> `pstorage-nexus_apid` (*e.g. 'fsap-055e6d74b33a0ed6a'*)

`kubectl apply -f helm/jenkins/nexus-pv.yml`

#### TODO

- Ingress configuration through ALB Controller
- Jenkins access to Nexus pod/namespace within Kubernetes
- Security improvements
- Enable cluster-level logging?