/*
Production Environment - Provider Configuration
Configures the AWS provider for the production environment.

The AWS credentials are loaded from:
1. Environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
2. AWS CLI configuration: ~/.aws/credentials and ~/.aws/config
3. IAM role (if running on EC2, ECS, or Lambda)
*/

provider "aws" {
  # TODO: Replace with your AWS region
  region = var.aws_region

  # Tags applied to all resources created by this provider
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Terraform   = "true"
      ManagedBy   = "Terraform"
      CreatedAt   = timeadd(timestamp(), "0s")
    }
  }
}

# Configure the default provider behavior
# Retry transient errors
provider "aws" {
  skip_requesting_account_id = false
}
