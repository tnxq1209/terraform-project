terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
  backend "s3" {
    bucket = "project-state-winters-backend"
    key    = "project/backend/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.project.region
}