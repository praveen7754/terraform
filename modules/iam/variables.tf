/*
IAM Module - Input Variables
*/

variable "roles" {
  description = "Map of IAM role configurations"
  type = map(object({
    name               = string
    description        = string
    assume_role_policy = string
  }))
  default = {}
}

variable "policies" {
  description = "Map of IAM policy configurations"
  type = map(object({
    name   = string
    policy = string
  }))
  default = {}
}

variable "role_policy_attachments" {
  description = "Map of role to policy attachments"
  type = map(list(string))
  default = {}
}

variable "tags" {
  description = "Tags for IAM resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
