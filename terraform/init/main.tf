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
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "tf-state-bucket-dfc6c0983037317f8f493e49b667e17e"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}