resource "aws_eip" "nat" {
  for_each = local.public_subnet
  domain   = "vpc"
  tags = merge(
    {
      Name = "${each.key}-eip"
    },
    var.common_tags
  )
}