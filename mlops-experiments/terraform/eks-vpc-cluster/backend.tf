terraform {
  backend "s3" {
    bucket  = "mlops-tfstate-pikachu-2026"
    key     = "eks-vpc-cluster/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}