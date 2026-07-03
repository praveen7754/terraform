/*
Node Group Module - Input Variables
*/

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    desired_size       = number
    min_size          = number
    max_size          = number
    instance_types    = list(string)
    disk_size         = number
    capacity_type     = string # ON_DEMAND or SPOT
    labels            = map(string)
    taints            = list(object({
      key    = string
      value  = string
      effect = string
    }))
    tags = map(string)
  }))
  default = {}
}

variable "node_role_arn" {
  description = "ARN of IAM role for worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for node group placement"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for nodes"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for node group resources"
  type        = map(string)
  default     = {}
}
