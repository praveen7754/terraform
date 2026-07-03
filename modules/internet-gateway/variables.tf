/*
Internet Gateway Module - Input Variables
*/

variable "vpc_id" {
  description = "ID of the VPC to attach Internet Gateway"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "tags" {
  description = "Tags for Internet Gateway resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
