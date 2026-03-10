variable "aws_region" {
  type        = string
  description = "Default region"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile"
  default     = "default"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "goit"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.31"
}