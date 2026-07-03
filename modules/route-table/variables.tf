/*
Route Table Module - Input Variables
*/

variable "vpc_id" {
  description = "VPC ID for route table creation"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for route table association"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for route table association"
  type        = list(string)
  default     = []
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID for public routes"
  type        = string
  default     = null
}

variable "nat_gateway_ids" {
  description = "NAT Gateway IDs for private routes"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for route table resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
