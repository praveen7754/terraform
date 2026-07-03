/*
Subnet Module - Input Variables
Defines all input variables for subnet configuration with descriptions and validation rules.
*/

variable "vpc_id" {
  description = "ID of the VPC to create subnets in"
  type        = string
  # TODO: Add validation: must be non-empty string
}

variable "availability_zones" {
  description = "List of availability zones for subnet distribution"
  type        = list(string)
  # TODO: Add validation: must contain 2-3 zones
}

variable "public_subnets" {
  description = "Map of public subnet configurations with CIDR blocks"
  type = map(object({
    cidr_block = string
    az_index   = number
  }))
  default = {}
}

variable "private_subnets" {
  description = "Map of private subnet configurations with CIDR blocks"
  type = map(object({
    cidr_block = string
    az_index   = number
  }))
  default = {}
}

variable "enable_dns_hostnames_in_subnets" {
  description = "Enable DNS hostnames for instances in subnets"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Automatically assign public IPs to instances in public subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to subnet resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}
