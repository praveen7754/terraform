/*
RDS Module - Input Variables
*/

variable "db_instances" {
  description = "Map of RDS instance configurations"
  type = map(object({
    engine                 = string
    engine_version         = string
    instance_class         = string
    allocated_storage      = number
    storage_type          = string
    storage_encrypted     = bool
    multi_az              = bool
    db_name               = string
    username              = string
    password              = string # TODO: Use random_password instead
    backup_retention_days = number
    backup_window         = string
    maintenance_window    = string
    skip_final_snapshot   = bool
    deletion_protection   = bool
  }))
  default = {}
}

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
}

variable "db_subnet_ids" {
  description = "Subnet IDs for DB placement"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for DB"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for RDS resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}
