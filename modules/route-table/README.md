# Route Table Module

Manages route tables and routing configuration for VPC subnets.

## Overview

This module creates and configures route tables with routes to Internet Gateways and NAT Gateways.

## Features

- Public route table with IGW routes
- Private route tables with NAT Gateway routes
- Flexible subnet associations
- Multi-AZ support

## Usage

```hcl
module "route_table" {
  source = "../modules/route-table"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.subnet.public_subnet_ids
  private_subnet_ids    = module.subnet.private_subnet_ids
  internet_gateway_id   = module.igw.internet_gateway_id
  nat_gateway_ids       = module.nat_gateway.nat_gateway_ids
  environment           = "production"

  tags = {
    Terraform = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_id` | VPC ID | string | - | yes |
| `public_subnet_ids` | Public subnet IDs | list(string) | `[]` | no |
| `private_subnet_ids` | Private subnet IDs | list(string) | `[]` | no |
| `internet_gateway_id` | IGW ID | string | `null` | no |
| `nat_gateway_ids` | NAT Gateway IDs | list(string) | `[]` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `public_route_table_id` | Public route table ID |
| `private_route_table_ids` | Private route table IDs |
| `all_route_table_ids` | All route table IDs |

## Resources Created

- `aws_route_table`: Public and private route tables
- `aws_route`: Routes to IGW and NAT Gateways
- `aws_route_table_association`: Subnet associations

## Future Enhancements

- [ ] VPC peering routes
- [ ] VPN gateway routes
- [ ] Custom routes management
