/*
Route Table Module - Outputs
*/

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = [for rt in aws_route_table.private : rt.id]
}

output "all_route_table_ids" {
  description = "List of all route table IDs"
  value       = concat([aws_route_table.public.id], [for rt in aws_route_table.private : rt.id])
}
