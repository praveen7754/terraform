/*
Production Environment - Input Variables
Defines all variables for the production environment configuration.

These variables can be overridden via:
1. terraform.tfvars file
2. -var command-line flags
3. TF_VAR_* environment variables
*/

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
  # TODO: Add validation rule for AWS region format
}

variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
  default     = "production"
  # TODO: Add validation: enum of "production", "staging", "development"
}

variable "project_name" {
  description = "Name of the project for resource naming and tagging"
  type        = string
  # TODO: Add validation: alphanumeric and hyphens only
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
  # TODO: Add validation for CIDR format
}

variable "availability_zones" {
  description = "List of availability zones for resource distribution"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  # TODO: Add validation: minimum 2 AZs
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# EKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.27"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "main"
}

# Node Group Configuration
variable "node_instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
  # TODO: Add validation for valid EC2 instance types
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 3
  # TODO: Add validation: minimum 1
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
  # TODO: Add validation: minimum 1
}

variable "max_capacity" {
  description = "Maximum number of worker nodes for auto-scaling"
  type        = number
  default     = 10
  # TODO: Add validation: must be >= desired_capacity
}

# RDS Configuration
variable "db_engine" {
  description = "Database engine (postgres, mysql, mariadb, oracle, sqlserver)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.2"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "myapp"
  sensitive   = false
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
  sensitive   = false
  # TODO: Use AWS Secrets Manager instead
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

# Backup Configuration
variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
  # TODO: Add validation: 1-35 days for most engines
}

# Monitoring
variable "enable_cluster_logging" {
  description = "Enable EKS cluster logging"
  type        = bool
  default     = true
}

variable "enable_rds_monitoring" {
  description = "Enable RDS enhanced monitoring"
  type        = bool
  default     = true
}

# Tagging
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "production"
  }
}

# DNS Configuration
variable "domain_name" {
  description = "Domain name for Route 53 (optional)"
  type        = string
  default     = null
}

variable "certificate_domain" {
  description = "Domain for SSL certificate (optional)"
  type        = string
  default     = null
}

# ALB Configuration
variable "enable_alb" {
  description = "Enable Application Load Balancer"
  type        = bool
  default     = true
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = true
}

# Security
variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs for network monitoring"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "CloudWatch Logs retention period for VPC Flow Logs"
  type        = number
  default     = 7
}

variable "enable_ebs_encryption" {
  description = "Enable EBS encryption by default"
  type        = bool
  default     = true
}

# TODO: Add more variables as needed for complete infrastructure configuration
