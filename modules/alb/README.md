# ALB Module

Manages Application Load Balancer (ALB) resources for traffic routing.

## Overview

This module creates and configures Application Load Balancers with target groups and listeners.

## Features

- ALB creation and configuration
- Multiple target group support
- HTTP/2 support
- Cross-zone load balancing
- Deletion protection

## Usage

```hcl
module "alb" {
  source = "../modules/alb"

  alb_name       = "main"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.subnet.public_subnet_ids
  security_group_ids = [module.security_group.security_group_ids["alb"]]
  environment    = "production"

  target_groups = {
    eks = {
      name        = "eks-tg"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
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
| `alb_name` | ALB name | string | - | yes |
| `vpc_id` | VPC ID | string | - | yes |
| `subnet_ids` | Subnet IDs | list(string) | - | yes |
| `security_group_ids` | Security group IDs | list(string) | `[]` | no |
| `enable_deletion_protection` | Enable deletion protection | bool | `false` | no |
| `enable_http2` | Enable HTTP/2 | bool | `true` | no |
| `enable_cross_zone_load_balancing` | Enable cross-zone LB | bool | `true` | no |
| `target_groups` | Target group configs | map(object) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `alb_id` | ALB ID |
| `alb_arn` | ALB ARN |
| `alb_dns_name` | ALB DNS name |
| `target_group_arns` | Target group ARNs |
| `target_group_names` | Target group names |

## Resources Created

- `aws_lb`: Application Load Balancer
- `aws_lb_target_group`: Target groups
- `aws_lb_listener`: Listeners

## Best Practices

1. **Cross-Zone**: Enable cross-zone LB for even distribution
2. **Health Checks**: Configure appropriate health check paths
3. **Stickiness**: Use when needed but prefer stateless apps
4. **Logging**: Enable access logs for debugging

## Future Enhancements

- [ ] HTTPS listener configuration
- [ ] WAF integration
- [ ] Access logging
