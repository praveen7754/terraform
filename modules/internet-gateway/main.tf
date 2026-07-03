/*
Internet Gateway Module - Main Configuration
Manages Internet Gateway resources for public connectivity.
*/

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  tags = merge(
    var.tags,
    {
      Name = "${var.igw_name}-${var.environment}-igw"
    }
  )
}

# Attach Internet Gateway to VPC
resource "aws_internet_gateway_attachment" "main" {
  internet_gateway_id = aws_internet_gateway.main.id
  vpc_id              = var.vpc_id

  depends_on = [aws_internet_gateway.main]
}
