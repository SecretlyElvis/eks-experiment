variable "region" {
  default     = "ap-southeast-2"
  description = "AWS region"
}

terraform {
  required_version = ">= 0.12"
  
  backend "s3" {
    key = "eks-experiment.tfstate"
  }
}

provider "aws" {
  version = ">= 2.28.1"
  region = var.region
}