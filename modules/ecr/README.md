# ECR Module

Manages AWS Elastic Container Registry (ECR) repositories for container image storage.

## Overview

This module creates and configures ECR repositories with lifecycle policies and image scanning.

## Features

- ECR repository creation
- Image tag mutability configuration
- Scan on push for vulnerabilities
- Lifecycle policies for image retention
- Encryption support

## Usage

```hcl
module "ecr" {
  source = "../modules/ecr"

  environment = "production"

  repositories = {
    api_service = {
      name                 = "api-service"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
      force_delete         = false
      lifecycle_policy     = jsonencode({
        rules = [{
          rulePriority = 1
          action = {
            type = "expire"
          }
          selection = {
            tagStatus     = "untagged"
            countType     = "sinceImagePushed"
            countUnit     = "days"
            countNumber   = 30
          }
        }]
      })
    }
  }

  tags = {
    Terraform = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `repositories` | Repository configurations | map(object) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `repository_urls` | Map of repository URLs |
| `repository_arns` | Map of repository ARNs |
| `repository_names` | Repository names |

## Resources Created

- `aws_ecr_repository`: ECR repositories
- `aws_ecr_lifecycle_policy`: Lifecycle policies
- `aws_ecr_repository_policy`: Access policies

## Best Practices

1. **Immutable Tags**: Use IMMUTABLE for production images
2. **Scanning**: Enable scan on push for security
3. **Lifecycle Policies**: Clean up old untagged images
4. **Encryption**: Use encryption for sensitive images

## Future Enhancements

- [ ] Cross-region replication
- [ ] Registry mirroring
- [ ] Automated image scanning reports
