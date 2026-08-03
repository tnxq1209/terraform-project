#Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.igw_id #2
  }
  tags = merge(
    {
      Name = "public-rt"
    },
    var.common_tags
  )
}

resource "aws_route_table" "private_rt" {
  for_each = local.private_subnet
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = local.nat_id[var.private_subnets[each.key].nat_gateway] #3
  }
  vpc_id = local.vpc_id
  tags = merge(
    {
      Name = "${each.key}-rt"
    },
    var.common_tags
  )
}