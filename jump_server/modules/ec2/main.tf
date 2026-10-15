# EC2 module 
# key pair
resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = var.public_key_name
  public_key = file(var.public_key_path)
}

# EC2 Instance.
resource "aws_instance" "jumpserver" {

  for_each = var.instance_type

  ami = data.aws_ami.ubuntu.id #AMI id

  instance_type = each.value # instance type

  subnet_id = var.subnet_id # Subnet id so terraform knows inside which subnet the EC2 instance should be created.

  vpc_security_group_ids = [ # VPC id so terraform knows inside which vpc should the EC2 instance should be created.
    aws_security_group.default["jumpserver"].id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.jumpserver.name

  key_name = aws_key_pair.ec2_ssh_key.key_name


  tags = merge(
    var.common_tags,
    {
      Name = each.key
    }
  )

}