/*
ACM Module - Main Configuration
Manages AWS Certificate Manager resources for SSL/TLS certificates.
*/

# Request SSL/TLS certificates
resource "aws_acm_certificate" "main" {
  for_each = var.certificates

  domain_name            = each.value.domain_name
  subject_alternative_names = each.value.subject_alternative_names
  validation_method      = each.value.validation_method

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    each.value.tags,
    {
      Name = each.value.domain_name
    }
  )
}

# Create Route 53 records for DNS validation (if using DNS validation and hosted_zone_id provided)
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for name, cert in aws_acm_certificate.main :
    name => cert
    if cert.validation_method == "DNS" && var.hosted_zone_id != null
  }

  zone_id = var.hosted_zone_id
  name    = each.value.domain_validation_options[0].resource_record_name
  record  = each.value.domain_validation_options[0].resource_record_value
  type    = each.value.domain_validation_options[0].resource_record_type
  ttl     = 60

  depends_on = [aws_acm_certificate.main]
}

# Validate certificates using DNS records
resource "aws_acm_certificate_validation" "main" {
  for_each = {
    for name, cert in aws_acm_certificate.main :
    name => cert
    if cert.validation_method == "DNS"
  }

  certificate_arn = each.value.arn
  timeouts {
    create = "5m"
  }

  depends_on = [
    aws_route53_record.cert_validation
  ]
}
