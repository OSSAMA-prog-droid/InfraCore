terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # BUG IC-01: S3 backend has no DynamoDB table for state locking.
  # Without a lock, two engineers running `terraform apply` simultaneously
  # will both read the same state, make conflicting changes, and corrupt it.
  # Fix: add dynamodb_table = "axiom-terraform-state-lock"
  backend "s3" {
    bucket = "axiom-terraform-state"
    key    = "production/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
