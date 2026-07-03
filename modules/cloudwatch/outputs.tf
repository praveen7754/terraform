/*
CloudWatch Module - Outputs
*/

output "log_group_names" {
  description = "Map of log group names"
  value       = { for name, lg in aws_cloudwatch_log_group.main : name => lg.name }
}

output "log_group_arns" {
  description = "Map of log group ARNs"
  value       = { for name, lg in aws_cloudwatch_log_group.main : name => lg.arn }
}

output "alarm_arns" {
  description = "Map of alarm names to ARNs"
  value       = { for name, alarm in aws_cloudwatch_metric_alarm.main : name => alarm.arn }
}

output "dashboard_names" {
  description = "Map of dashboard names"
  value       = { for name, dashboard in aws_cloudwatch_dashboard.main : name => dashboard.dashboard_name }
}
