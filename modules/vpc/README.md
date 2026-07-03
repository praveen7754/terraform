# VPC Module

Manages the Virtual Private Cloud (VPC) and foundational networking infrastructure.

## Overview

This module creates and configures an AWS VPC with the following capabilities:

- VPC creation with customizable CIDR blocks
- DNS hostname and support resolution
- VPC Flow Logs for network monitoring
- Internet Gateway attachment
- CloudWatch integration for logging

## Features

- **Multi-AZ Ready**: Supports resources across multiple availability zones
- **Flow Logging**: Enables network traffic analysis and security monitoring
- **DNS Configuration**: Supports internal and external DNS resolution
- **Tagging**: Consistent tagging strategy for resource management

## Usage

### Basic Example

```hcl
module "vpc" {
  source = "../modules/vpc"

  vpc_name             = "main"
  cidr_block           = "10.0.0.0/16"
  environment          = "production"
  project_name         = "myproject"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  flow_logs_retention  = 7

  tags = {
    Terraform = "true"
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_name` | Name of the VPC | string | - | yes |
| `cidr_block` | CIDR block for the VPC | string | - | yes |
| `enable_dns_hostnames` | Enable DNS hostname resolution | bool | `true` | no |
| `enable_dns_support` | Enable DNS support | bool | `true` | no |
| `enable_flow_logs` | Enable VPC Flow Logs | bool | `true` | no |
| `flow_logs_retention` | CloudWatch Logs retention in days | number | `7` | no |
| `environment` | Environment name | string | - | yes |
| `project_name` | Project name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the VPC |
| `vpc_arn` | ARN of the VPC |
| `vpc_cidr_block` | CIDR block of the VPC |
| `vpc_name` | Name of the VPC |
| `vpc_main_route_table_id` | ID of the main route table |
| `internet_gateway_id` | ID of the Internet Gateway |
| `flow_logs_group_name` | CloudWatch Logs group name for VPC Flow Logs |

## Resources Created

- `aws_vpc`: The VPC itself
- `aws_internet_gateway`: Internet Gateway for public connectivity
- `aws_internet_gateway_attachment`: Attaches IGW to VPC
- `aws_cloudwatch_log_group`: For VPC Flow Logs storage
- `aws_flow_log`: VPC Flow Logs resource

## Best Practices

1. **CIDR Planning**: Use RFC 1918 private IP address ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
2. **Flow Logs**: Enable for security monitoring and troubleshooting
3. **DNS**: Enable both DNS hostnames and DNS support for proper resolution
4. **Tagging**: Always tag resources for cost allocation and resource management

## Limitations

- IPv6 support not yet implemented (TODO)
- DHCP options customization not yet implemented (TODO)
- VPC peering configuration handled by separate module

## Dependencies

- AWS provider configured with appropriate credentials
- CloudWatch Logs service available in the AWS region

## Future Enhancements

- [ ] IPv6 CIDR block support
- [ ] Custom DHCP options
- [ ] VPC peering templates
- [ ] Endpoint configurations (S3, DynamoDB, etc.)
