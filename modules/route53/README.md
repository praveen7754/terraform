# Route 53 Module

Manages AWS Route 53 DNS and routing policy resources.

## Overview

This module creates and configures Route 53 hosted zones, DNS records, and health checks.

## Features

- Hosted zone management (public and private)
- DNS record creation with multiple routing policies
- Health check configuration
- Support for alias records

## Usage

```hcl
module "route53" {
  source = "../modules/route53"

  environment = "production"

  hosted_zones = {
    main = {
      name       = "example.com"
      private_zone = false
      vpc_id     = null
      vpc_region = null
      comment    = "Main domain"
    }
  }

  dns_records = {
    www = {
      zone_name = "example.com"
      name      = "www.example.com"
      type      = "A"
      ttl       = 300
      records   = []
      alias_name = module.alb.alb_dns_name
      alias_zone_id = module.alb.alb_zone_id
      routing_policy = "simple"
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
| `hosted_zones` | Hosted zone configs | map(object) | `{}` | no |
| `dns_records` | DNS record configs | map(object) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `hosted_zone_ids` | Hosted zone IDs |
| `hosted_zone_nameservers` | Nameservers |
| `record_fqdns` | Record FQDNs |

## Resources Created

- `aws_route53_zone`: Hosted zones
- `aws_route53_record`: DNS records
- `aws_route53_health_check`: Health checks

## Best Practices

1. **TTL**: Set appropriate TTLs based on change frequency
2. **Health Checks**: Configure for failover scenarios
3. **Routing Policies**: Choose policy based on requirements
4. **Private Zones**: Use for internal DNS

## Future Enhancements

- [ ] Traffic policy support
- [ ] Advanced health checks
- [ ] Geolocation routing
