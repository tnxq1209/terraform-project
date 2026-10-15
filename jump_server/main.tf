resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/hosts.ini"

  content = templatefile(
    "${path.module}/ansible/inventory/hosts.ini.tftpl",
    {
      instance_public_ip   = module.EC2.public_ip["jumpserver"]
      ssh_private_key_file = var.ssh_private_key_file
    }
  )
}

# main.tf

data "aws_s3_bucket" "state" {
  bucket = var.s3_bucket_name
}

module "EC2" {
  source          = "./modules/ec2"
  subnet_id       = data.aws_subnets.default.ids[0]
  instance_type   = local.instance_type
  public_key_name = var.public_key_name
  public_key_path = var.public_key_path
  vpc_id          = data.aws_vpc.default.id
  region          = var.region
  bucket_arn      = data.aws_s3_bucket.state.arn
  common_tags     = local.common_tags
  security_groups = local.security_groups
  ingress_rules   = local.ingress_rules
}