/*
Security Group Module - Main Configuration
Manages security group resources and inbound/outbound rules.
*/

# Create security groups
resource "aws_security_group" "main" {
  for_each = var.security_groups

  name_prefix = "${each.key}-"
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.value.name}"
    }
  )
}

# Create ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = merge([
    for sg_name, sg_config in var.security_groups : {
      for idx, rule in sg_config.ingress_rules :
      "${sg_name}:ingress:${idx}" => merge(rule, { sg_name = sg_name })
    }
  ]...)

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "cidr_blocks", [])
  security_groups   = lookup(each.value, "security_groups", [])
  security_group_id = aws_security_group.main[each.value.sg_name].id
  description       = lookup(each.value, "description", "")

  depends_on = [aws_security_group.main]
}

# Create egress rules (default: allow all outbound)
resource "aws_security_group_rule" "egress" {
  for_each = merge([
    for sg_name, sg_config in var.security_groups : {
      for idx, rule in sg_config.egress_rules :
      "${sg_name}:egress:${idx}" => merge(rule, { sg_name = sg_name })
    }
  ]...)

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "cidr_blocks", [])
  security_groups   = lookup(each.value, "security_groups", [])
  security_group_id = aws_security_group.main[each.value.sg_name].id
  description       = lookup(each.value, "description", "")

  depends_on = [aws_security_group.main]
}

# Default allow all egress if no explicit rules provided
resource "aws_security_group_rule" "default_egress" {
  for_each = {
    for name, sg in var.security_groups :
    name => sg if length(sg.egress_rules) == 0
  }

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main[each.key].id
  description       = "Allow all outbound traffic"

  depends_on = [aws_security_group.main]
}
