/*
NAT Gateway Module - Input Variables
*/

variable "public_subnet_ids" {
  description = "List of public subnet IDs for NAT Gateway placement"
  type        = list(string)
}

variable "number_of_nat_gateways" {
  description = "Number of NAT Gateways to create for HA"
  type        = number
  default     = 1
  # TODO: Add validation: should be 1 for dev, 2+ for production
}

variable "nat_gateway_name" {
  description = "Base name for NAT Gateway resources"
  type        = string
}

variable "tags" {
  description = "Tags for NAT Gateway resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
