resource "aws_efs_file_system" "jenkins-fs" {
  creation_token = "${local.cluster_name}-jenkins-fs"

  tags = {
    Name = "${local.cluster_name}-jenkins-fs"
  }
}

resource "aws_efs_mount_target" "jenkins-fs-mnt" {
  count = length(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.jenkins-fs.id
  subnet_id = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.all_worker_mgmt.id]
}