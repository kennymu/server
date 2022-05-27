
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "remote" {
    organization = "example-org-580a9f"

    workspaces {
      name = "app-build"
    }
  }
}

