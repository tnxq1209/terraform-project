module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  common_tags     = local.common_tags
}