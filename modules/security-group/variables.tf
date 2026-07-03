/*
Security Group Module - Input Variables
*/

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group creation"
  type        = string
}

variable "security_groups" {
  description = "Map of security group configurations"
  type = map(object({
    name        = string
    description = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      security_groups = list(string)
      description = string
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      security_groups = list(string)
      description = string
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags for security group resources"
  type        = map(string)
  default     = {}
}
