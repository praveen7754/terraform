/*
Route 53 Module - Outputs
*/

output "hosted_zone_ids" {
  description = "Map of hosted zone names to IDs"
  value       = { for name, hz in aws_route53_zone.main : name => hz.zone_id }
}

output "hosted_zone_nameservers" {
  description = "Map of hosted zone names to nameservers"
  value       = { for name, hz in aws_route53_zone.main : name => hz.name_servers }
}

output "record_fqdns" {
  description = "Map of record names to FQDNs"
  value       = { for name, record in aws_route53_record.main : name => record.fqdn }
}
