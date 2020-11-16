resource "aws_security_group" "devops-poc-app-sg" {
  name_prefix = "devops-poc-app-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Inbound SSH"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/16",
    ]
  }

  ingress {
    description = "Inbound NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"

    cidr_blocks = [
      "10.0.0.0/16",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Inbound SSH"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "192.168.0.0/16",
    ]
  }

  ingress {
    description = "Inbound NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    description = "Inbound HTTP"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Inbound Jenkins DEV"
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Inbound Nexus PRD"
    from_port = 8081
    to_port   = 8081
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Inbound Docker Registry"
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
