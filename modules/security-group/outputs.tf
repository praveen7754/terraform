/*
Security Group Module - Outputs
*/

output "security_group_ids" {
  description = "Map of security group names to IDs"
  value       = { for name, sg in aws_security_group.main : name => sg.id }
}

output "security_group_arns" {
  description = "Map of security group names to ARNs"
  value       = { for name, sg in aws_security_group.main : name => sg.arn }
}
