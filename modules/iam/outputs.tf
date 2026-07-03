/*
IAM Module - Outputs
*/

output "role_arns" {
  description = "Map of role names to ARNs"
  value       = { for name, role in aws_iam_role.main : name => role.arn }
}

output "role_names" {
  description = "Map of role names"
  value       = { for name, role in aws_iam_role.main : name => role.name }
}

output "policy_arns" {
  description = "Map of policy names to ARNs"
  value       = { for name, policy in aws_iam_policy.main : name => policy.arn }
}

output "policy_names" {
  description = "Map of policy names"
  value       = { for name, policy in aws_iam_policy.main : name => policy.name }
}
