/*
Production Environment - Outputs
Exports critical infrastructure identifiers and connection information.

These outputs are useful for:
1. Configuring kubectl and other CLI tools
2. Obtaining database connection strings
3. Getting ALB DNS names for DNS configuration
4. Providing information for deployment pipelines
*/

# ============================================================================
# NETWORKING OUTPUTS
# ============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.subnet.private_subnet_ids
}

# ============================================================================
# SECURITY OUTPUTS
# ============================================================================

output "security_group_ids" {
  description = "Map of security group IDs"
  value       = module.security_group.security_group_ids
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value       = module.iam.role_arns
}

# ============================================================================
# CONTAINER SERVICES OUTPUTS
# ============================================================================

output "ecr_repository_urls" {
  description = "Map of ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded cluster CA certificate"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_group_ids" {
  description = "Map of node group IDs"
  value       = module.node_group.node_group_ids
}

# ============================================================================
# APPLICATION SERVICES OUTPUTS
# ============================================================================

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.alb_zone_id
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = module.alb.alb_arn
}

output "target_group_arns" {
  description = "Map of target group ARNs"
  value       = module.alb.target_group_arns
}

output "rds_database_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.db_instance_endpoints["postgres"]
  sensitive   = true
}

output "rds_database_name" {
  description = "RDS database name"
  value       = var.db_name
}

output "rds_username" {
  description = "RDS database username"
  value       = var.db_username
  sensitive   = true
}

# ============================================================================
# OBSERVABILITY OUTPUTS
# ============================================================================

output "log_group_names" {
  description = "Map of CloudWatch log group names"
  value       = module.cloudwatch.log_group_names
}

output "log_group_arns" {
  description = "Map of CloudWatch log group ARNs"
  value       = module.cloudwatch.log_group_arns
}

# ============================================================================
# KUBECTL CONFIGURATION
# ============================================================================

output "configure_kubectl_command" {
  description = "Command to configure kubectl to access the EKS cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.aws_region}"
}

output "kubectl_version_check" {
  description = "Command to verify kubectl connection"
  value       = "kubectl cluster-info"
}

# ============================================================================
# DEPLOYMENT SUMMARY
# ============================================================================

output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    aws_region           = var.aws_region
    environment          = var.environment
    project_name         = var.project_name
    eks_cluster_name     = module.eks.cluster_id
    kubernetes_version   = var.kubernetes_version
    desired_node_count   = var.desired_capacity
    alb_endpoint         = module.alb.alb_dns_name
    database_host        = split(":", module.rds.db_instance_endpoints["postgres"])[0]
    database_name        = var.db_name
    vpc_cidr             = module.vpc.vpc_cidr_block
    availability_zones   = var.availability_zones
  }
}
