/*
ALB Module - Outputs
*/

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB (for Route 53)"
  value       = aws_lb.main.zone_id
}

output "target_group_arns" {
  description = "Map of target group names to ARNs"
  value       = { for name, tg in aws_lb_target_group.main : name => tg.arn }
}

output "target_group_names" {
  description = "Map of target group names"
  value       = { for name, tg in aws_lb_target_group.main : name => tg.name }
}
