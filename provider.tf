terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
  backend "s3" {
    bucket = "proj-winters-backend"
    key    = "proj/backend/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.project.region
}