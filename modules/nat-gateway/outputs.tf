/*
NAT Gateway Module - Outputs
*/

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = [for ng in aws_nat_gateway.main : ng.id]
}

output "nat_gateway_public_ips" {
  description = "Public IPs associated with NAT Gateways"
  value       = [for eip in aws_eip.nat : eip.public_ip]
}

output "nat_gateway_private_ips" {
  description = "Private IPs of NAT Gateways"
  value       = [for ng in aws_nat_gateway.main : ng.private_ip]
}
