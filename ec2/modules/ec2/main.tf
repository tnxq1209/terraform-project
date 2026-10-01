# key pair
resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = var.public_key_name
  public_key = file(var.public_key_path)
}

# EC2 Instance.
resource "aws_instance" "ubuntu" {
  for_each = var.instance_type
  
  ami = data.aws_ami.ubuntu.id #AMI id

  instance_type = each.value # instance type

  subnet_id = var.subnet_id # Subnet id so terraform knows inside which subnet the EC2 instance should be created.

  vpc_security_group_ids = [  # VPC id so terraform knows inside which vpc should the EC2 instance should be created.
    aws_security_group.terra_sg[each.key].id
  ]

  key_name = aws_key_pair.ec2_ssh_key.key_name
  user_data = file(var.user_data_file)
  tags = merge(

    var.common_tags,

    {
        Name = each.key
    }

)
  region = var.region
}