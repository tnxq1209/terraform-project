output "vpc_id" {
    value = aws_vpc.terra_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}