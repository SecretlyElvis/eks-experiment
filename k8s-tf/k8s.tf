 data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = ver.bucket
    key    = "eks-experiment.tfstate"
    region = var.region
  }
}

# TODO: replace attributes with references to previous state file
provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.terraform_remote_state.remote.outputs.p2-host
  token                  = data.terraform_remote_state.remote.outputs.p2-token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.remote.outputs.p2-ca-cert)
}

resource "kubernetes_persistent_volume" "jenkins-fs" {
  metadata {
    name = "jenkins-dev-pv"
  }
  spec {
    storage_class_name = "efs-sc"
    persistent_volume_reclaim_policy = "Retain"
    capacity = {
      storage = "2048Gi"
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
