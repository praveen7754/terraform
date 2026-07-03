# ACM Module

Manages AWS Certificate Manager (ACM) certificates for SSL/TLS encryption.

## Overview

This module creates and configures SSL/TLS certificates with automatic validation.

## Features

- Certificate request and import
- DNS and email validation
- Wildcard certificate support
- Multi-domain (SAN) support
- Automatic renewal

## Usage

```hcl
module "acm" {
  source = "../modules/acm"

  environment    = "production"
  hosted_zone_id = module.route53.hosted_zone_ids["main"]

  certificates = {
    main = {
      domain_name = "example.com"
      subject_alternative_names = [
        "*.example.com",
        "www.example.com"
      ]
      validation_method = "DNS"
      tags = {
        Environment = "production"
      }
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
| `certificates` | Certificate configs | map(object) | `{}` | no |
| `hosted_zone_id` | Route 53 zone ID | string | `null` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `certificate_arns` | Certificate ARNs |
| `certificate_domain_names` | Domain names |
| `certificate_statuses` | Validation statuses |

## Resources Created

- `aws_acm_certificate`: SSL/TLS certificates
- `aws_acm_certificate_validation`: Certificate validation

## Best Practices

1. **DNS Validation**: Prefer DNS over email validation
2. **Wildcard Certificates**: Use for multiple subdomains
3. **SAN**: Include all required domains
4. **Expiry**: Monitor certificate expiry dates

## Future Enhancements

- [ ] Certificate import
- [ ] Renewal tracking
- [ ] Monitoring and alerts
