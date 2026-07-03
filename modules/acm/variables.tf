/*
ACM Module - Input Variables
*/

variable "certificates" {
  description = "Map of ACM certificate configurations"
  type = map(object({
    domain_name            = string
    subject_alternative_names = list(string)
    validation_method      = string # DNS or EMAIL
    tags                   = map(string)
  }))
  default = {}
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for DNS validation (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for ACM resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
