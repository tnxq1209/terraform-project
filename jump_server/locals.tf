# Dynamically fetch your current public IP address
data "http" "my_public_ip" {
  url = "https://api.ipify.org"
}

locals {
  # Clean up trailing newlines from the provider's text response
  current_ip = chomp(data.http.my_public_ip.response_body)

  common_tags = {
    Environment = "dev"
    Project     = "terraform-learning"
    ManagedBy   = "Terraform"
    Role        = "jumpserver"
  }

  instance_type = {
    jumpserver = "t3.micro"
  }

  security_groups = {
    jumpserver = "jumpserver-sg"
  }
  ssh_allowed_cidr = "${local.current_ip}/32"
  ingress_rules = [{
    description = "SSH"
    port        = 22
    protocol    = "tcp"
    cidr_blocks = [local.ssh_allowed_cidr]
    }
  ]
}