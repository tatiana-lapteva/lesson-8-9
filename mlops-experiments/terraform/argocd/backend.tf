terraform {
  backend "s3" {
    bucket  = "mlops-tfstate-pikachu-2026"
    key     = "argocd/terraform.tfstate"  
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}