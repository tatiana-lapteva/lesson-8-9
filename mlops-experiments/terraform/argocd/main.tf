resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.0"
  namespace        = var.argocd_namespace
  create_namespace = false
  wait             = true
  timeout          = 600
  cleanup_on_fail  = true  

  set {
    name  = "crds.keep"
    value = "false"       
  }

  values = [file("${path.module}/../../argocd/values/argocd-values.yaml")]
  depends_on = [kubernetes_namespace.argocd]
}

resource "null_resource" "argocd_root_app" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${data.terraform_remote_state.eks.outputs.cluster_name} --profile ${var.aws_profile}
      kubectl wait --for=condition=available deployment/argocd-server -n ${var.argocd_namespace} --timeout=300s
      kubectl apply -f ${path.module}/../../argocd/application.yaml
    EOT
  }
}

