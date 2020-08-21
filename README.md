# CI/CD Stand-Alone Cluster in EKS

Planned Components:
- Single Jenkins instance (will expand to 2 in final implementation)
- EFS Mountpoint for Jenkins
- Nexus Instance
- S3 Bucket for Nexus object store (can also be EFS)
- Jenkins/Nexus deployed via Helm Charts

Prerequisites

S3 bucket for state files (saved in <FILE>)

## Utilizing this Repo

Change to directory just above 'eks-experiment'

Run Docker container
docker run -u 1000:1000 -v $(pwd)/eks-experiment:/opt/app/eks -it secretlyelvis/tf-k8s-aws:T13

** Docker Container with Terraform 13 / Kubectl / AWS CLI **
tf-run init


