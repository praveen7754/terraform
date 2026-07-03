# Security Group Module

Manages AWS security groups and their ingress/egress rules.

## Overview

This module creates security groups with customizable ingress and egress rules for different application tiers.

## Features

- Multiple security group management
- Flexible ingress/egress rule configuration
- CIDR block and security group-based rules
- Consistent tagging

## Usage

```hcl
module "security_group" {
  source = "../modules/security-group"

  vpc_id      = module.vpc.vpc_id
  environment = "production"

  security_groups = {
    alb = {
      name        = "alb-sg"
      description = "Security group for ALB"
      ingress_rules = [
        {
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
          description     = "Allow HTTP"
        }
      ]
      egress_rules = []
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
| `vpc_id` | VPC ID | string | - | yes |
| `security_groups` | SG configurations | map(object) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `security_group_ids` | Map of SG names to IDs |
| `security_group_arns` | Map of SG names to ARNs |

## Resources Created

- `aws_security_group`: Security group resources
- `aws_security_group_rule`: Ingress and egress rules

## Best Practices

1. **Principle of Least Privilege**: Open only necessary ports
2. **Separation of Concerns**: Use different SGs for different tiers
3. **Documentation**: Add descriptions to all rules
4. **Review**: Regularly audit and update rules

## Future Enhancements

- [ ] Predefined rule templates
- [ ] Rule validation
- [ ] Automatic documentation
