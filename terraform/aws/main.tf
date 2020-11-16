variable "region" {
  default     = "ap-southeast-2"
  description = "AWS region for infrastructure"
}

terraform {
  required_version = ">= 0.13"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key = "eks-experiment.tfstate"
  }
}

provider "aws" {
  region = var.region
}

locals {
  cluster_name = "devops-poc-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}