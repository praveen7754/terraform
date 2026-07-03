/*
EKS Module - Input Variables
*/

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "VPC ID for cluster placement"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for cluster placement"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for cluster"
  type        = list(string)
  default     = []
}

variable "cluster_role_arn" {
  description = "ARN of IAM role for EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaling" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable EKS cluster logging"
  type        = bool
  default     = true
}

variable "log_types" {
  description = "List of log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "tags" {
  description = "Tags for EKS cluster"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
