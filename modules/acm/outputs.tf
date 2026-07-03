/*
ACM Module - Outputs
*/

output "certificate_arns" {
  description = "Map of certificate names to ARNs"
  value       = { for name, cert in aws_acm_certificate.main : name => cert.arn }
}

output "certificate_domain_names" {
  description = "Map of certificate domain names"
  value       = { for name, cert in aws_acm_certificate.main : name => cert.domain_name }
}

output "certificate_statuses" {
  description = "Map of certificate validation statuses"
  value       = { for name, cert in aws_acm_certificate.main : name => cert.status }
}
