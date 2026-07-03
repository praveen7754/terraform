/*
VPC Module - Input Variables
Defines all input variables for VPC configuration with descriptions and validation rules.
*/

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  # TODO: Add validation rule: no special characters, alphanumeric with hyphens only
}

variable "cidr_block" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
  # TODO: Add validation: must be valid CIDR notation
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostname resolution in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for monitoring and security"
  type        = bool
  default     = true
}

variable "flow_logs_retention" {
  description = "CloudWatch Logs retention period in days"
  type        = number
  default     = 7
  # TODO: Add validation: must be between 1 and 3653
}

variable "tags" {
  description = "Tags to apply to VPC and related resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
  # TODO: Add validation: enum of allowed values
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}
