# data "terraform_remote_state" "remote" {
#  backend = "s3"
#  config = {
#    bucket = "example-s3-terraform"
#    key    = "aws-provider.tfstate"
#    region = "us-east-1"
#  }
#}

#resource "kubernetes_persistent_volume" "example" {
#  metadata {
#    name = "example-efs-pv"
#  }
#  spec {
#    storage_class_name = "efs-sc"
#    persistent_volume_reclaim_policy = "Retain"
#    capacity = {
#      storage = "2Gi"
#    }
#    access_modes = ["ReadWriteMany"]
#    persistent_volume_source {
#      nfs {
#        path = "/"
#        server = data.terraform_remote_state.remote.outputs.efs_example_fsid
#      }
#    }
#  }
#}
