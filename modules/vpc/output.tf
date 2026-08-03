output "vpc_id" {
  value = local.vpc_id
}
output "public_subnet_ids" {
  value = {
    for name, subnet in aws_subnet.public_subnets :
    name => subnet.id
  }
}
output "private_subnet_ids" {
  value = {
    for name, subnet in aws_subnet.private_subnets :
    name => subnet.id
  }
}
output "internet_gateway_id" {
  value = aws_internet_gateway.proj_igw.vpc_id
}
output "nat_gateway_ids" {
  value = {
    for name, nat_gateway in aws_nat_gateway.nat :
    name => nat_gateway.id
  }
}