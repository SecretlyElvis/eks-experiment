resource "aws_efs_file_system" "pstorage-fs" {
  creation_token = "${local.cluster_name}-jenkins-fs"

  tags = {
    Name = "${local.cluster_name}-pstorage-fs"
  }
}

resource "aws_efs_mount_target" "pstorage-fs-mnt" {
  count = length(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.pstorage-fs.id
  subnet_id = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.all_worker_mgmt.id]
}

# Pre-create subdirectories to use as mount points for Kubernetes PersistentVolumes
# TODO: parameterize as array

# JENKINS_DEV
resource "aws_efs_access_point" "jenkins_dev" {
  file_system_id = aws_efs_file_system.pstorage-fs.id

  posix_user {
    uid = "1000"
    gid = "1000"
    secondary_gids = [
      "0"
    ]
  }

  root_directory {
    path = "jenkins_dev"

    creation_info {
      owner_uid = "1000"
      owner_gid = "1000"
      permissions = "777"
    }
  }
}

# NEXUS_PRD
resource "aws_efs_access_point" "nexus_prd" {
  file_system_id = aws_efs_file_system.pstorage-fs.id

  posix_user {
    uid = "1000"
    gid = "1000"
    secondary_gids = [
      "0"
    ]
  }

  root_directory {
    path = "jenkins_dev"

    creation_info {
      owner_uid = "1000"
      owner_gid = "1000"
      permissions = "777"
    }
  }
}