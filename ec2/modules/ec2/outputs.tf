output "instance_id" {
  description = "Instance ID for all EC2 instances"
  value ={
      for name, instance in aws_instance.ubuntu :
      name => instance.id
    }
}

output "public_ip" {
  description = "Public DNS names"
  value = {
      for name, instance in aws_instance.ubuntu :
      name => instance.public_ip
    }
}

output "public_dns" {
  description = ""
  value = {
      for name, instance in aws_instance.ubuntu :
      name => instance.public_dns
    }
}

output "ubuntu_ami" {
  value = data.aws_ami.ubuntu.id
}

output "ubuntu_ami_name" {
  value = data.aws_ami.ubuntu.name
}