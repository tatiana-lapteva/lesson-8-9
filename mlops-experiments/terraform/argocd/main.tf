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
      aws eks update-kubeconfig --region us-east-1 --name goit --profile default
      kubectl apply -f ${path.module}/../../argocd/application.yaml
    EOT
  }
}

