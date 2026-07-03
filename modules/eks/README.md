# EKS Module

Manages AWS Elastic Kubernetes Service (EKS) cluster and control plane.

## Overview

This module creates and configures an EKS cluster with add-ons, logging, and networking configuration.

## Features

- EKS cluster creation
- Kubernetes version management
- Add-on management (VPC-CNI, kube-proxy, CoreDNS, EBS-CSI)
- Cluster logging and monitoring
- Security group configuration
- Public/private endpoint access

## Usage

```hcl
module "eks" {
  source = "../modules/eks"

  cluster_name        = "main"
  cluster_version     = "1.27"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnet.all_subnet_ids
  security_group_ids  = [module.security_group.security_group_ids["eks"]]
  cluster_role_arn    = module.iam.role_arns["eks_cluster"]
  enable_logging      = true
  environment         = "production"

  tags = {
    Terraform = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Cluster name | string | - | yes |
| `cluster_version` | Kubernetes version | string | `1.27` | no |
| `vpc_id` | VPC ID | string | - | yes |
| `subnet_ids` | Subnet IDs | list(string) | - | yes |
| `security_group_ids` | Security group IDs | list(string) | `[]` | no |
| `cluster_role_arn` | Cluster IAM role ARN | string | - | yes |
| `enable_cluster_autoscaling` | Enable autoscaler | bool | `true` | no |
| `enable_logging` | Enable cluster logging | bool | `true` | no |
| `log_types` | Log types to enable | list(string) | See defaults | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | Cluster ID |
| `cluster_arn` | Cluster ARN |
| `cluster_endpoint` | API endpoint |
| `cluster_certificate_authority_data` | CA certificate (sensitive) |
| `cluster_security_group_id` | Cluster security group ID |

## Resources Created

- `aws_eks_cluster`: The EKS cluster
- `aws_eks_addon`: EKS add-ons
- `aws_cloudwatch_log_group`: Cluster logging

## Best Practices

1. **Logging**: Always enable cluster logging for diagnostics
2. **Add-ons**: Keep add-ons up to date
3. **RBAC**: Implement proper RBAC policies
4. **Network Policy**: Use network policies for pod-to-pod communication

## Future Enhancements

- [ ] Auto-upgrade configuration
- [ ] OIDC provider setup
- [ ] Advanced add-on configuration
