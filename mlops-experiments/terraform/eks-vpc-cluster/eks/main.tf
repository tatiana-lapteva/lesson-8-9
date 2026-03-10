module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }



  eks_managed_node_groups = {
  example = {
    instance_types = ["t3.micro"]
    min_size       = 1
    max_size       = 1
    desired_size   = 1
    subnet_ids = var.subnet_ids
    ami_type = "AL2023_x86_64_STANDARD"

    cloudinit_pre_nodeadm = [
      {
        content_type = "application/node.eks.aws"
        content      = <<-EOT
          ---
          apiVersion: node.eks.aws/v1alpha1
          kind: NodeConfig
          spec:
            kubelet:
              config:
                maxPods: 110
              flags:
                - "--max-pods=110"
        EOT
      }
    ]
  }
}

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"

  configuration_values = jsonencode({
    replicaCount = 1
  })

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [module.eks]
}