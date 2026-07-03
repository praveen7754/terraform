/*
Node Group Module - Outputs
*/

output "node_group_ids" {
  description = "Map of node group names to IDs"
  value       = { for name, ng in aws_eks_node_group.main : name => ng.id }
}

output "node_group_arns" {
  description = "Map of node group names to ARNs"
  value       = { for name, ng in aws_eks_node_group.main : name => ng.arn }
}

output "node_group_status" {
  description = "Status of node groups"
  value       = { for name, ng in aws_eks_node_group.main : name => ng.status }
}
