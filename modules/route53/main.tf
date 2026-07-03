/*
Route 53 Module - Main Configuration
Manages AWS Route 53 DNS and routing policy resources.
*/

# Create hosted zones
resource "aws_route53_zone" "main" {
  for_each = var.hosted_zones

  name              = each.value.name
  comment           = each.value.comment
  private_zone      = each.value.private_zone

  dynamic "vpc" {
    for_each = each.value.private_zone ? [1] : []
    content {
      vpc_id     = each.value.vpc_id
      vpc_region = each.value.vpc_region
    }
  }

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Create DNS records
resource "aws_route53_record" "main" {
  for_each = var.dns_records

  zone_id = aws_route53_zone.main[each.value.zone_name].zone_id
  name    = each.value.name
  type    = each.value.type

  # Use either alias or standard records
  dynamic "alias" {
    for_each = each.value.alias_name != null ? [1] : []
    content {
      name                   = each.value.alias_name
      zone_id                = each.value.alias_zone_id
      evaluate_target_health = false
    }
  }

  ttl     = each.value.alias_name == null ? each.value.ttl : null
  records = each.value.alias_name == null ? each.value.records : null

  depends_on = [aws_route53_zone.main]
}
