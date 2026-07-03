/*
Subnet Module - Main Configuration
This file contains resources for creating and managing public and private subnets.
*/

# Create public subnets
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = var.availability_zones[each.value.az_index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-public-subnet-${each.value.az_index + 1}"
      Tier = "Public"
    }
  )

  depends_on = []
}

# Create private subnets
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = var.availability_zones[each.value.az_index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-subnet-${each.value.az_index + 1}"
      Tier = "Private"
    }
  )

  depends_on = []
}
