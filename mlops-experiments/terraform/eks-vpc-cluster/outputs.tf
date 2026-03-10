output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC id"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Public subnet IDs"
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS endpoint"
}

output "cluster_arn" {
  value       = module.eks.cluster_arn
  description = "EKS ARN"
}