/*
Node Group Module - Main Configuration
Manages EKS managed node groups for Kubernetes worker nodes.
*/

# Create managed node groups
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  version         = null # Use cluster version by default

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  labels = each.value.labels

  dynamic "taint" {
    for_each = each.value.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  tags = merge(
    each.value.tags,
    {
      Name = "${var.cluster_name}-${each.key}-node-group"
    }
  )

  # Ensure proper ordering
  depends_on = []

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}
