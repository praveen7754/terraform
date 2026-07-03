/*
CloudWatch Module - Input Variables
*/

variable "log_groups" {
  description = "Map of CloudWatch log group configurations"
  type = map(object({
    name              = string
    retention_in_days = number
    kms_key_id        = string
  }))
  default = {}
}

variable "alarms" {
  description = "Map of CloudWatch alarm configurations"
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = string
  }))
  default = {}
}

variable "dashboards" {
  description = "Map of CloudWatch dashboard configurations"
  type = map(object({
    dashboard_name = string
    dashboard_body = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags for CloudWatch resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
