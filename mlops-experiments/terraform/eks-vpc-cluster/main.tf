module "vpc" {
  source = "./vpc"

  aws_region   = var.aws_region
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./eks"

  aws_region      = var.aws_region
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
}