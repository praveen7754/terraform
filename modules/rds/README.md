# RDS Module

Manages AWS Relational Database Service (RDS) instances and configurations.

## Overview

This module creates and configures RDS database instances with subnet groups, security groups, and backups.

## Features

- Multiple RDS instance support
- Multi-AZ deployment
- Automated backups
- Storage encryption
- Security group configuration
- Database parameter and option groups

## Usage

```hcl
module "rds" {
  source = "../modules/rds"

  db_subnet_group_name = "main"
  db_subnet_ids        = module.subnet.private_subnet_ids
  security_group_ids   = [module.security_group.security_group_ids["rds"]]
  environment          = "production"

  db_instances = {
    postgres = {
      engine               = "postgres"
      engine_version       = "15.2"
      instance_class       = "db.t3.micro"
      allocated_storage   = 20
      storage_type        = "gp3"
      storage_encrypted   = true
      multi_az            = true
      db_name             = "myapp"
      username            = "admin"
      password            = var.db_password
      backup_retention_days = 30
      backup_window       = "03:00-04:00"
      maintenance_window  = "mon:04:00-mon:05:00"
      skip_final_snapshot = false
      deletion_protection = true
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
| `db_instances` | Database configurations | map(object) | `{}` | no |
| `db_subnet_group_name` | Subnet group name | string | - | yes |
| `db_subnet_ids` | Subnet IDs | list(string) | - | yes |
| `security_group_ids` | Security group IDs | list(string) | `[]` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_endpoints` | Database endpoints |
| `db_instance_arns` | Database ARNs |
| `db_instance_names` | Database names |
| `db_subnet_group_name` | Subnet group name |

## Resources Created

- `aws_db_instance`: RDS instances
- `aws_db_subnet_group`: Subnet groups

## Best Practices

1. **Multi-AZ**: Enable for production databases
2. **Encryption**: Always enable storage encryption
3. **Backups**: Configure appropriate retention periods
4. **Secrets**: Use AWS Secrets Manager for passwords
5. **Maintenance**: Schedule maintenance windows appropriately

## Future Enhancements

- [ ] Read replicas
- [ ] Secrets Manager integration
- [ ] Parameter group templates
- [ ] Option group templates
