 data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = "neuralessence-terraform-state"
    key    = "eks-experiment.tfstate"
    region = "ap-southeast-2"
  }
}

provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_persistent_volume" "jenkins-fs" {
  metadata {
    name = "jenkins-efs-pv"
  }
  spec {
    storage_class_name = "efs-sc"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      nfs {
        path = "/"
        server = data.terraform_remote_state.remote.outputs.jenkins-fs_fsid
      }
    }
  }
}
