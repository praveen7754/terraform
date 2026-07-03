# Internet Gateway Module

Manages Internet Gateway resources for providing public connectivity to VPC resources.

## Overview

This module creates and configures an AWS Internet Gateway with attachment to VPC.

## Features

- Internet Gateway creation and attachment
- Automatic route table configuration for public subnets
- Consistent tagging and naming

## Usage

```hcl
module "igw" {
  source = "../modules/internet-gateway"

  vpc_id      = module.vpc.vpc_id
  igw_name    = "main"
  environment = "production"

  tags = {
    Terraform = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_id` | VPC ID for attachment | string | - | yes |
| `igw_name` | Name of IGW | string | - | yes |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `internet_gateway_id` | IGW resource ID |
| `internet_gateway_arn` | IGW ARN |

## Resources Created

- `aws_internet_gateway`: IGW resource
- `aws_internet_gateway_attachment`: Attaches IGW to VPC

## Future Enhancements

- [ ] Multiple IGW support
- [ ] Route table management integration
