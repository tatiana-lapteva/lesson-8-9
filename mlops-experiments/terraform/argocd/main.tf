terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

data "aws_eks_cluster" "cluster" {
  name = "goit"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "goit"
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

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.0"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [file("${path.module}/../../argocd/values/argocd-values.yaml")]
}

resource "null_resource" "wait_gor_argocd" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/../../argocd/application.yaml"
  }
}