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

variable "aws_region" {
  type        = string
  description = "Default Region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC id from vpc module"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for worker nodes"
}

