resource "aws_nat_gateway" "nat" {
  for_each      = local.public_subnet
  allocation_id = local.eip_id[each.key]
  subnet_id     = each.value.id
  tags = merge(
    {
      Name = "${each.key}-nat"
    },
    var.common_tags
  )
  depends_on = [local.igw_id]
}