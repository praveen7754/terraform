/*
NAT Gateway Module - Main Configuration
Manages NAT Gateway resources for private subnet outbound connectivity.
*/

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = var.number_of_nat_gateways
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.nat_gateway_name}-${var.environment}-eip-${count.index + 1}"
    }
  )

  depends_on = []
}

# Create NAT Gateways
resource "aws_nat_gateway" "main" {
  count         = var.number_of_nat_gateways
  subnet_id     = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  allocation_id = aws_eip.nat[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.nat_gateway_name}-${var.environment}-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_eip.nat]
}
