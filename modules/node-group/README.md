# Node Group Module

Manages EKS managed node groups for Kubernetes worker nodes.

## Overview

This module creates and configures EKS managed node groups with auto-scaling capabilities.

## Features

- Multiple node group support
- Instance type flexibility
- Spot and on-demand capacity
- Labels and taints configuration
- Auto-scaling support

## Usage

```hcl
module "node_group" {
  source = "../modules/node-group"

  cluster_name   = module.eks.cluster_id
  node_role_arn  = module.iam.role_arns["node_group"]
  subnet_ids     = module.subnet.private_subnet_ids
  environment    = "production"

  node_groups = {
    general = {
      desired_size   = 3
      min_size       = 2
      max_size       = 10
      instance_types = ["t3.medium"]
      disk_size      = 100
      capacity_type  = "ON_DEMAND"
      labels = {
        workload = "general"
      }
      taints = []
      tags   = {}
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
| `cluster_name` | EKS cluster name | string | - | yes |
| `node_groups` | Node group configs | map(object) | `{}` | no |
| `node_role_arn` | Node IAM role ARN | string | - | yes |
| `subnet_ids` | Subnet IDs | list(string) | - | yes |
| `security_group_ids` | Security group IDs | list(string) | `[]` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `node_group_ids` | Map of node group IDs |
| `node_group_arns` | Map of node group ARNs |
| `node_group_status` | Node group status |

## Resources Created

- `aws_eks_node_group`: Managed node groups

## Best Practices

1. **Multiple Node Groups**: Use different groups for different workload types
2. **Spot Instances**: Use for non-critical workloads to reduce costs
3. **Scaling**: Set appropriate min/max based on workload
4. **Taints**: Use taints for workload isolation

## Future Enhancements

- [ ] Custom AMI support
- [ ] Launch template customization
- [ ] Cluster autoscaler integration
