output "argocd_namespace" {
  description = "Namespace де встановлено Argo CD"
  value       = kubernetes_namespace.argo.metadata[0].name
}

output "argocd_helm_version" {
  description = "Версія встановленого Helm-чарту Argo CD"
  value       = helm_release.argocd.version
}

output "eks_cluster_name" {
  description = "Назва EKS кластера (з remote state)"
  value       = data.terraform_remote_state.eks.outputs.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint EKS кластера"
  value       = data.aws_eks_cluster.cluster.endpoint
}