/*
CloudWatch Module - Main Configuration
Manages CloudWatch resources for monitoring, logging, and alerting.
*/

# Create CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "main" {
  for_each = var.log_groups

  name              = each.value.name
  retention_in_days = each.value.retention_in_days
  kms_key_id        = each.value.kms_key_id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Create CloudWatch Metric Alarms
resource "aws_cloudwatch_metric_alarm" "main" {
  for_each = var.alarms

  alarm_name          = each.value.alarm_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description

  tags = merge(
    var.tags,
    {
      Name = each.value.alarm_name
    }
  )
}

# Create CloudWatch Dashboards
resource "aws_cloudwatch_dashboard" "main" {
  for_each = var.dashboards

  dashboard_name = each.value.dashboard_name
  dashboard_body = each.value.dashboard_body
}
