terraform {
  required_version = ">= 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.56.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  backend "s3" {
    bucket = "project-state-winters-backend"
    key    = "jump_server/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.region
}