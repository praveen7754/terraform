/*
ECR Module - Outputs
*/

output "repository_urls" {
  description = "Map of repository names to registry URLs"
  value       = { for name, repo in aws_ecr_repository.main : name => repo.repository_url }
}

output "repository_arns" {
  description = "Map of repository names to ARNs"
  value       = { for name, repo in aws_ecr_repository.main : name => repo.arn }
}

output "repository_names" {
  description = "List of repository names"
  value       = [for repo in aws_ecr_repository.main : repo.name]
}
