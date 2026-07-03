/*
Route Table Module - Main Configuration
Manages route tables and route table associations for network routing.
*/

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-public-rt"
      Type = "Public"
    }
  )
}

# Create route to Internet Gateway for public route table
resource "aws_route" "public_igw" {
  count = var.internet_gateway_id != null ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id

  depends_on = [aws_route_table.public]
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]
}

# Create private route tables (one per NAT Gateway for multi-AZ)
resource "aws_route_table" "private" {
  count  = length(var.nat_gateway_ids) > 0 ? length(var.nat_gateway_ids) : 1
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-rt-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Create routes to NAT Gateways for private route tables
resource "aws_route" "private_nat" {
  count = length(var.nat_gateway_ids) > 0 ? length(var.nat_gateway_ids) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index]

  depends_on = [aws_route_table.private]
}

# Associate private subnets with private route tables (distribute across NAT Gateways)
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index % length(aws_route_table.private)].id

  depends_on = [aws_route_table.private]
}
