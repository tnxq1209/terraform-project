#Route Table Association
resource "aws_route_table_association" "proj_public_rta" {
  for_each       = local.public_subnet
  subnet_id      = each.value.id
  route_table_id = local.public_route_table_ids
}
resource "aws_route_table_association" "proj_private_rta" {
  for_each       = local.private_subnet
  subnet_id      = each.value.id
  route_table_id = local.private_route_table_ids[each.key]
}