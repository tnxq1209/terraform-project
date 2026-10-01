module "networking" {
  source = "./modules/networking"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  common_tags        = local.common_tags
}

module "EC2" {

  source          = "./modules/ec2"
  subnet_id       = module.networking.public_subnet_id
  instance_type   = local.instance_type
  public_key_name = var.public_key_name
  public_key_path = var.public_key_path
  user_data_file  = "${path.root}/userdata.sh"
  vpc_id          = module.networking.vpc_id
  region          = var.region
  common_tags     = local.common_tags
  security_groups = local.security_groups
  ingress_rules   = local.ingress_rules
}