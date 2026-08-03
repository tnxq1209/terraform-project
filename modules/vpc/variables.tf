variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr      = string
    az        = string
    public_ip = bool
    type      = string
  }))
}
variable "private_subnets" {
  type = map(object({
    cidr        = string
    az          = string
    public_ip   = bool
    type        = string
    nat_gateway = string
  }))
}

variable "common_tags" {
  type = map(string)
}

#-------------------locals------------------------

locals {
  public_subnet = {
    for key, subnet in aws_subnet.public_subnets :
    key => subnet
    if var.public_subnets[key].type == "public"
  }
  private_subnet = {
    for key, subnet in aws_subnet.private_subnets :
    key => subnet
    if var.private_subnets[key].type == "private"
  }
  vpc_id                 = aws_vpc.proj_vpc.id
  public_route_table_ids = aws_route_table.public_rt.id
  private_route_table_ids = {
    for name, route_table in aws_route_table.private_rt :
    name => route_table.id
  }
  eip_id = {
    for name, eip in aws_eip.nat :
    name => eip.id
  }
  igw_id = aws_internet_gateway.proj_igw.id
  nat_id = {
    for name, nat in aws_nat_gateway.nat :
    name => nat.id
  }
}
