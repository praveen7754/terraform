/*
IAM Module - Main Configuration
Manages IAM roles, policies, and users for AWS resource access control.
*/

# Create IAM roles
resource "aws_iam_role" "main" {
  for_each = var.roles

  name        = each.value.name
  description = each.value.description

  assume_role_policy = each.value.assume_role_policy

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Create custom IAM policies
resource "aws_iam_policy" "main" {
  for_each = var.policies

  name   = each.value.name
  policy = each.value.policy

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "main" {
  for_each = {
    for name, attachments in var.role_policy_attachments :
    name => attachments
  } if length(var.role_policy_attachments) > 0

  role       = each.key
  policy_arn = each.value

  depends_on = [
    aws_iam_role.main,
    aws_iam_policy.main
  ]
}
