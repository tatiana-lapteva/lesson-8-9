terraform {
    required_version = ">= 1.5.0"
    
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "> 5.0, < 6.0"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "> 2.29, < 3.0"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "> 2.13, < 3.0"
        }
    }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket  = var.eks_state_bucket
    key     = var.eks_state_key
    region  = var.eks_state_region
    profile = var.aws_profile
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}