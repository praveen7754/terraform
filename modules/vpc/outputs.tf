/*
VPC Module - Outputs
Exports VPC resource identifiers and attributes for use by other modules.
*/

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "vpc_main_route_table_id" {
  description = "ID of the main route table"
  value       = aws_vpc.main.main_route_table_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = null # Created separately in internet-gateway module
}

output "flow_logs_group_name" {
  description = "CloudWatch Logs group name for VPC Flow Logs"
  value       = try(aws_cloudwatch_log_group.vpc_flow_logs[0].name, null)
}
