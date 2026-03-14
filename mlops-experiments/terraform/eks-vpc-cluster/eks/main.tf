module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true


  cluster_addons = {
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    coredns = {
      configuration_values = jsonencode({
        replicaCount = 1
      })
    }
    kube-proxy = {}
  }


  eks_managed_node_groups = {
    example = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 5
      desired_size   = 4  
    }
  }


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

