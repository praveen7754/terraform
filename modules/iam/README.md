# IAM Module

Manages AWS Identity and Access Management (IAM) roles, policies, and access control.

## Overview

This module creates and manages IAM roles and policies for service principals and resource access.

## Features

- IAM role creation with trust relationships
- Custom policy creation and attachment
- Support for AWS managed policies
- Flexible policy attachment patterns

## Usage

```hcl
module "iam" {
  source = "../modules/iam"

  environment = "production"

  roles = {
    eks_cluster = {
      name        = "eks-cluster-role"
      description = "Role for EKS cluster"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
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
| `roles` | Role configurations | map(object) | `{}` | no |
| `policies` | Policy configurations | map(object) | `{}` | no |
| `role_policy_attachments` | Role to policy attachments | map(list) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `role_arns` | Map of role names to ARNs |
| `role_names` | Map of role names |
| `policy_arns` | Map of policy names to ARNs |
| `policy_names` | Map of policy names |

## Resources Created

- `aws_iam_role`: IAM roles
- `aws_iam_policy`: Custom IAM policies
- `aws_iam_role_policy_attachment`: Policy attachments

## Best Practices

1. **Principle of Least Privilege**: Grant only necessary permissions
2. **Service Principals**: Use specific service principals in trust policies
3. **AWS Managed Policies**: Use when appropriate instead of custom policies
4. **Policy Review**: Regularly audit and update policies

## Future Enhancements

- [ ] AWS managed policy library
- [ ] Policy validation
- [ ] Role assumption tracking
