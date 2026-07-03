/*
ALB Module - Main Configuration
Manages Application Load Balancer resources for routing traffic.
*/

# Create Application Load Balancer
resource "aws_lb" "main" {
  name_prefix        = substr(replace("${var.alb_name}-${var.environment}-", "_", "-"), 0, 6)
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb"
    }
  )
}

# Create target groups
resource "aws_lb_target_group" "main" {
  for_each = var.target_groups

  name_prefix = substr(replace(each.key, "_", "-"), 0, 6)
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.value.name}"
    }
  )
}

# Create default listener (HTTP)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = try(values(aws_lb_target_group.main)[0].arn, null)
  }

  depends_on = [aws_lb_target_group.main]
}
