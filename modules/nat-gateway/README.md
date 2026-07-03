# NAT Gateway Module

Manages NAT Gateway resources for providing outbound internet access to private subnets.

## Overview

This module creates and configures AWS NAT Gateways with Elastic IPs.

## Features

- NAT Gateway creation with Elastic IP allocation
- Multi-AZ support for high availability
- Automatic placement in public subnets

## Usage

```hcl
module "nat_gateway" {
  source = "../modules/nat-gateway"

  public_subnet_ids        = module.subnet.public_subnet_ids
  number_of_nat_gateways   = 2
  nat_gateway_name         = "main"
  environment              = "production"

  tags = {
    Terraform = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `public_subnet_ids` | Public subnet IDs for NAT | list(string) | - | yes |
| `number_of_nat_gateways` | Number of NAT Gateways | number | `1` | no |
| `nat_gateway_name` | Name for NAT Gateway | string | - | yes |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `nat_gateway_ids` | NAT Gateway IDs |
| `nat_gateway_public_ips` | EIP addresses |
| `nat_gateway_private_ips` | NAT Gateway private IPs |

## Resources Created

- `aws_eip`: Elastic IPs for NAT Gateways
- `aws_nat_gateway`: NAT Gateway resources

## Best Practices

1. **HA Deployment**: Use multiple NAT Gateways in different AZs
2. **Cost Optimization**: Use single NAT for dev/test, multi for production
3. **Monitoring**: Monitor NAT Gateway bandwidth and connections

## Future Enhancements

- [ ] NAT Instance support
- [ ] Connection monitoring
- [ ] Bandwidth thresholds
