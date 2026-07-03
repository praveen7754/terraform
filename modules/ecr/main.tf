/*
ECR Module - Main Configuration
Manages Elastic Container Registry repositories for Docker images.
*/

# Create ECR repositories
resource "aws_ecr_repository" "main" {
  for_each = var.repositories

  name                 = each.value.name
  image_tag_mutability = each.value.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  encryption_configuration {
    encryption_type = each.value.encryption_type
  }

  force_delete = each.value.force_delete

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-${each.value.name}"
    }
  )
}

# Create lifecycle policies for ECR repositories
resource "aws_ecr_lifecycle_policy" "main" {
  for_each = {
    for name, repo in var.repositories :
    name => repo if repo.lifecycle_policy != null
  }

  repository = aws_ecr_repository.main[each.key].name
  policy     = each.value.lifecycle_policy

  depends_on = [aws_ecr_repository.main]
}
