# CloudWatch Module

Manages AWS CloudWatch resources for monitoring, logging, and alerting.

## Overview

This module creates and configures CloudWatch log groups, alarms, and dashboards for infrastructure monitoring.

## Features

- Log group creation with retention policies
- Metric alarm configuration
- Dashboard creation
- Namespace and metric management

## Usage

```hcl
module "cloudwatch" {
  source = "../modules/cloudwatch"

  environment = "production"

  log_groups = {
    eks_cluster = {
      name              = "/aws/eks/cluster"
      retention_in_days = 7
      kms_key_id        = null
    }
  }

  alarms = {
    high_cpu = {
      alarm_name          = "high-cpu"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 80.0
      alarm_description   = "Alert when CPU exceeds 80%"
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
| `log_groups` | Log group configs | map(object) | `{}` | no |
| `alarms` | Alarm configurations | map(object) | `{}` | no |
| `dashboards` | Dashboard configs | map(object) | `{}` | no |
| `environment` | Environment name | string | - | yes |
| `tags` | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `log_group_names` | Log group names |
| `log_group_arns` | Log group ARNs |
| `alarm_arns` | Alarm ARNs |
| `dashboard_names` | Dashboard names |

## Resources Created

- `aws_cloudwatch_log_group`: Log groups
- `aws_cloudwatch_metric_alarm`: Alarms
- `aws_cloudwatch_dashboard`: Dashboards

## Best Practices

1. **Retention**: Set appropriate retention policies to manage costs
2. **Alarms**: Configure alarms for critical metrics
3. **Dashboards**: Create dashboards for operational visibility
4. **Logs**: Stream logs from applications and infrastructure

## Future Enhancements

- [ ] Log subscription filters
- [ ] Custom metric creation
- [ ] Anomaly detection
- [ ] Log insights templates
