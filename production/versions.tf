/*
Production Environment - Version Constraints
Specifies required Terraform and provider versions.
*/

terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }

  # Cloud backend configuration (optional)
  # Uncomment and configure if using Terraform Cloud/Enterprise
  # cloud {
  #   organization = "your-organization"
  #   hostname     = "app.terraform.io"
  #
  #   workspaces {
  #     name = "production"
  #   }
  # }
}
