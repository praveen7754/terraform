# Subnet Module

Manages public and private subnets within a VPC across multiple availability zones.

## Overview

This module creates and configures AWS subnets with the following capabilities:

- Public subnet creation with automatic public IP assignment
- Private subnet creation for internal resources
- Multi-AZ distribution for high availability
- Flexible subnet naming and tagging
- DNS hostname configuration

## Features

- **Multi-AZ Support**: Distributes subnets across availability zones
- **Public/Private Split**: Separate configurations for public and private subnets
- **Automatic IP Assignment**: Optional automatic public IP assignment for public subnets
- **DNS Support**: Configurable DNS hostname support per subnet

## Usage

### Basic Example

```hcl
module "subnet" {
  source = "../modules/subnet"

  vpc_id               = module.vpc.vpc_id
  availability_zones   = ["us-east-1a", "us-east-1b"]
  map_public_ip_on_launch = true
  environment          = "production"
  project_name         = "myproject"

  public_subnets = {
    public_az1 = {
      cidr_block = "10.0.1.0/24"
      az_index   = 0
    }
    public_az2 = {
      cidr_block = "10.0.2.0/24"
      az_index   = 1
    }
  }

  private_subnets = {
    private_az1 = {
      cidr_block = "10.0.11.0/24"
      az_index   = 0
    }
    private_az2 = {
      cidr_block = "10.0.12.0/24"
      az_index   = 1
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
| `vpc_id` | VPC ID to create subnets in | string | - | yes |
| `availability_zones` | AZ list for subnet distribution | list(string) | - | yes |
| `public_subnets` | Public subnet configs | map(object) | `{}` | no |
| `private_subnets` | Private subnet configs | map(object) | `{}` | no |
| `enable_dns_hostnames_in_subnets` | Enable DNS hostnames | bool | `true` | no |
| `map_public_ip_on_launch` | Auto-assign public IPs | bool | `true` | no |
| `environment` | Environment name | string | - | yes |
| `project_name` | Project name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `all_subnet_ids` | Combined list of all subnet IDs |
| `public_subnet_arns` | ARNs of public subnets |
| `private_subnet_arns` | ARNs of private subnets |
| `public_subnet_cidrs` | CIDR blocks of public subnets |
| `private_subnet_cidrs` | CIDR blocks of private subnets |

## Resources Created

- `aws_subnet`: Individual subnet resources
- Route table associations (via separate module)

## Best Practices

1. **CIDR Planning**: Use non-overlapping CIDR blocks for subnets
2. **AZ Distribution**: Distribute subnets across at least 2 AZs for HA
3. **Public/Private**: Segregate public-facing resources in public subnets
4. **Naming**: Use descriptive names indicating tier (public/private) and AZ

## Limitations

- Route table associations handled by route-table module
- NAT Gateway configuration handled by nat-gateway module
- Network ACLs not yet implemented (TODO)

## Dependencies

- VPC module for VPC ID
- Route table module for associations

## Future Enhancements

- [ ] Network ACL configurations
- [ ] IPv6 subnet support
- [ ] Automatic CIDR block calculation
- [ ] Subnet group templates for RDS/ElastiCache
