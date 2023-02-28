terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = [var.CredentialsDir]
}