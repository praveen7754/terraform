/*
Production Environment - Backend Configuration
Defines the remote state backend for Terraform state storage.

Before using this configuration:
1. Create an S3 bucket for Terraform state
2. Create a DynamoDB table for state locking
3. Update the bucket, key, region, and table names below
4. Ensure the backend bucket has versioning and encryption enabled
*/

terraform {
  backend "s3" {
    bucket = "praveen-terraform-state-2026"

    # Path to the state file within the bucket
    key = "production/terraform.tfstate"

    # AWS region where the bucket is located
    region = "us-east-1"

    # Enable encryption for the state file
    encrypt = true

    # DynamoDB table for state locking
    dynamodb_table = "praveen-terraform-state-2026"

    # Skip credential validation during init (optional)
    # skip_credentials_validation = true

    # Skip requesting account ID (optional)
    # skip_requesting_account_id = true

    # Skip metadata API check (optional)
    # skip_metadata_api_check = false
  }
}

# NOTE: After initial setup, run: terraform init
# This will configure the backend and migrate local state to S3 if needed
