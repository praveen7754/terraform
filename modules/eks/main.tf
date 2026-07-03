/*
EKS Module - Main Configuration
Manages AWS Elastic Kubernetes Service cluster configuration.
*/

# CloudWatch Log Group for EKS cluster logs
resource "aws_cloudwatch_log_group" "eks" {
  count = var.enable_logging ? 1 : 0

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-${var.environment}-logs"
    }
  )
}

# Create EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # Enable logging
  dynamic "enabled_cluster_log_types" {
    for_each = var.enable_logging ? var.log_types : []
    content {
      type = enabled_cluster_log_types.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-${var.environment}-cluster"
    }
  )

  depends_on = [
    var.cluster_role_arn
  ]
}

# Create EKS Addons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "vpc-cni"
  addon_version            = data.aws_eks_addon_version.vpc_cni.version
  resolve_conflicts_on_create = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Name = "vpc-cni"
    }
  )

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "kube-proxy"
  addon_version            = data.aws_eks_addon_version.kube_proxy.version
  resolve_conflicts_on_create = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Name = "kube-proxy"
    }
  )

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "coredns" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "coredns"
  addon_version            = data.aws_eks_addon_version.coredns.version
  resolve_conflicts_on_create = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Name = "coredns"
    }
  )

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "ebs-csi-driver"
  addon_version            = data.aws_eks_addon_version.ebs_csi.version
  service_account_role_arn = var.cluster_role_arn
  resolve_conflicts_on_create = "OVERWRITE"

  tags = merge(
    var.tags,
    {
      Name = "ebs-csi-driver"
    }
  )

  depends_on = [aws_eks_cluster.main]
}

# Data sources to get latest addon versions
data "aws_eks_addon_version" "vpc_cni" {
  addon_name             = "vpc-cni"
  kubernetes_version     = var.cluster_version
  most_recent            = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name             = "kube-proxy"
  kubernetes_version     = var.cluster_version
  most_recent            = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name             = "coredns"
  kubernetes_version     = var.cluster_version
  most_recent            = true
}

data "aws_eks_addon_version" "ebs_csi" {
  addon_name             = "ebs-csi-driver"
  kubernetes_version     = var.cluster_version
  most_recent            = true
}
