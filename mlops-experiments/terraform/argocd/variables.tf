variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region (має відповідати регіону EKS)"
  type        = string
  default     = "us-east-1"
}

variable "eks_state_bucket" {
  description = "S3 bucket з remote state EKS"
  type        = string
  default     = "mlops-tfstate-pikachu-2026"
}

variable "eks_state_key" {
  description = "S3 key для remote state EKS"
  type        = string
  default     = "eks-vpc-cluster/terraform.tfstate"
}

variable "eks_state_region" {
  description = "Регіон бакета з remote state EKS"
  type        = string
  default     = "us-east-1"
}

variable "argocd_namespace" {
  description = "Namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Версія Helm-чарту Argo CD"
  type        = string
  default     = "7.7.5"
}

variable "argocd_app_repo_url" {
  description = "Git репозиторій з ArgoCD Applications"
  type        = string
  default     = "https://github.com/tatiana-lapteva/lesson-8-9.git"
}

variable "argocd_app_revision" {
  description = "Git гілка або тег для ArgoCD Application"
  type        = string
  default     = "main"
}

variable "argocd_app_path" {
  description = "Шлях до applications у репозиторії"
  type        = string
  default     = "mlops-experiments/argocd/applications"
}

