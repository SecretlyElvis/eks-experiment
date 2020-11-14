module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  cluster_version = "1.18"
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "devops-poc"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo devops-poc-worker-group"
      asg_desired_capacity          = 3
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo funky pig"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 0
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}