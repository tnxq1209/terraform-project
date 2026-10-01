locals {

  common_tags = {
    Environment = "dev"
    Project     = "terraform-learning"
    ManagedBy   = "Terraform"
  }

  security_groups = {
    frontnend = "frontend-sg"
    backnend  = "backend-sg"
    database  = "dataabase-sg"
  }

  instance_type = {
    frontnend = "t3.small"
    backnend  = "t3.small"
    database  = "t2.small"
  }

  ingress_rules = [
    {
      description = "SSH"
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

}