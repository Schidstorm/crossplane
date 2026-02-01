provider "aws" {
  shared_credentials_files = ["credentials"]
  region = var.region
}