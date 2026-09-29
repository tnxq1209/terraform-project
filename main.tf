module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  common_tags     = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_issuer       = module.eks.oidc_issuer
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = "devboard-eks"
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = values(module.vpc.private_subnet_ids)
  ebs_csi_role_arn = module.iam.ebs_csi_role_arn
}