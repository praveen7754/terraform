/*
Route 53 Module - Input Variables
*/

variable "hosted_zones" {
  description = "Map of Route 53 hosted zone configurations"
  type = map(object({
    name            = string
    private_zone    = bool
    vpc_id          = string
    vpc_region      = string
    comment         = string
  }))
  default = {}
}

variable "dns_records" {
  description = "Map of DNS record configurations"
  type = map(object({
    zone_name   = string
    name        = string
    type        = string
    ttl         = number
    records     = list(string)
    alias_name  = string
    alias_zone_id = string
    routing_policy = string # simple, weighted, latency, failover, etc.
  }))
  default = {}
}

variable "tags" {
  description = "Tags for Route 53 resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
