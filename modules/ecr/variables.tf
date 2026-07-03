/*
ECR Module - Input Variables
*/

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repositories" {
  description = "Map of ECR repository configurations"
  type = map(object({
    name                  = string
    image_tag_mutability  = string
    scan_on_push          = bool
    encryption_type       = string
    force_delete          = bool
    lifecycle_policy      = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags for ECR resources"
  type        = map(string)
  default     = {}
}
