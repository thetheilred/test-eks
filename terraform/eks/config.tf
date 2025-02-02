provider "aws" {
  region = "us-east-1"
  profile = "sandbox"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}