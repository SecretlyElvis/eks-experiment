 data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = "neuralessence-terraform-state"
    key    = "eks-experiment.tfstate"
    region = "ap-southeast-2"
  }
}

resource "kubernetes_persistent_volume" "example" {
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
