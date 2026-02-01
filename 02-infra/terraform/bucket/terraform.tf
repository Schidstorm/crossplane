terraform {
  required_version = ">= 1.0.0"
  
  backend "kubernetes" {
    secret_suffix    = "tfstate"
    namespace        = "crossplane-system"
    in_cluster_config = true
  }
}
