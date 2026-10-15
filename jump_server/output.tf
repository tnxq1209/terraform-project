output "instance_id" {
  value = module.EC2.instance_id
}

output "instance_public_ip" {
  value = module.EC2.public_ip
}

output "public_dns" {
  value = module.EC2.public_dns
}

output "ubuntu_ami" {
  value = module.EC2.ubuntu_ami
}

output "ubuntu_ami_name" {
  value = module.EC2.ubuntu_ami_name
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnet_id" {
  value = data.aws_subnets.default.ids[0]
}