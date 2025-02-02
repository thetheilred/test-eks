provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-bucket-dfc6c0983037317f8f493e49b667e17e"
    key = "tfstate/eks/terraform.tfstate"
    region = "us-east-1"
  }
}