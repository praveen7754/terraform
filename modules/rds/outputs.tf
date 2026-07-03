/*
RDS Module - Outputs
*/

output "db_instance_endpoints" {
  description = "Map of DB instance endpoints"
  value       = { for name, instance in aws_db_instance.main : name => instance.endpoint }
  sensitive   = true
}

output "db_instance_arns" {
  description = "Map of DB instance ARNs"
  value       = { for name, instance in aws_db_instance.main : name => instance.arn }
}

output "db_instance_names" {
  description = "Map of DB instance names"
  value       = { for name, instance in aws_db_instance.main : name => instance.db_name }
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.main.name
}
