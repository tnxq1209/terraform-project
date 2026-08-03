# creating a VPC
resource "aws_vpc" "proj_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.common_tags.Project}-vpc"
    },
    var.common_tags
  )
}