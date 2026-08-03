locals {

  public_subnets = {

    public-1 = {
      cidr      = "10.0.1.0/24"
      az        = "us-east-1a"
      public_ip = true
      type      = "public"
    },

    public-2 = {
      cidr      = "10.0.2.0/24"
      az        = "us-east-1b"
      public_ip = true
      type      = "public"
    }
  }
  private_subnets = {
    private-1 = {
      cidr        = "10.0.11.0/24"
      az          = "us-east-1a"
      public_ip   = false
      type        = "private"
      nat_gateway = "public-1"
    },

    private-2 = {
      cidr        = "10.0.12.0/24"
      az          = "us-east-1b"
      public_ip   = false
      type        = "private"
      nat_gateway = "public-2"
    }

  }

  common_tags = {
    Project     = var.project.name
    Environment = var.project.environment
  }

}