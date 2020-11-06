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