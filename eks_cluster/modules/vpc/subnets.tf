#SUBNET
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = local.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public_ip
  tags = merge(
    {
      Name = each.key
      Type = each.value.type
    },
    var.common_tags
  )
}

resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = local.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public_ip
  tags = merge(
    {
      Name = each.key
      Type = each.value.type
    },
    var.common_tags
  )
}