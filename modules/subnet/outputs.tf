/*
Subnet Module - Outputs
Exports subnet resource identifiers and attributes for use by other modules.
*/

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "all_subnet_ids" {
  description = "Combined list of all subnet IDs (public + private)"
  value       = concat([for subnet in aws_subnet.public : subnet.id], [for subnet in aws_subnet.private : subnet.id])
}

output "public_subnet_arns" {
  description = "ARNs of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}

output "private_subnet_arns" {
  description = "ARNs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.arn]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}
