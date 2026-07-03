/*
ALB Module - Input Variables
*/

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB placement"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB placement"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for ALB"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "target_groups" {
  description = "Map of target group configurations"
  type = map(object({
    name        = string
    port        = number
    protocol    = string
    target_type = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags for ALB resources"
  type        = map(string)
  default     = {}
}
