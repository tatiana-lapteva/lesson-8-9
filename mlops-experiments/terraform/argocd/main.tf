resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_namespace" "application" {
  metadata {
    name = "application"

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

  values = [file("${path.module}/../../argocd/values/argocd-values.yaml")]
  depends_on = [kubernetes_namespace.argo]
}


resource "kubernetes_manifest" "argocd_root_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "goit-argo"
      namespace = var.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.argocd_app_repo_url
        targetRevision = var.argocd_app_revision
        path           = var.argocd_app_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        retry = {
          limit = 3
          backoff = {
            duration    = "10s"
            factor      = 2
            maxDuration = "3m"
          }
        }
        syncOptions = [
          "CreateNamespace=true",
          "ServerSideApply=true"
        ]
      }
    }
  }

  depends_on = [helm_release.argocd]
}