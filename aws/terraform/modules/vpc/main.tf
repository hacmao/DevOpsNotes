# VPC
data "aws_availability_zones" "az" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
  map("Name", "vpc-${var.tags["system"]}-${var.tags["environment"]}"), var.tags)
}

# Subnet

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.tags["system"]}-${var.tags["environment"]}-public-${count.index + 1}"
    environment = lookup(var.tags, "environment")
    system      = lookup(var.tags, "system")
  }
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + length(aws_subnet.public))
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.tags["system"]}-${var.tags["environment"]}-private-${count.index + 1}"
    environment = lookup(var.tags, "environment")
    system      = lookup(var.tags, "system")
  }
}

# internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-internet_gateway"), var.tags)
}

# elastic IP 1a for natgateway
//resource "aws_eip" "nat_1a" {
//  vpc = true
//  tags = merge(
//  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-eip_1a"), var.tags)
//}

# elastic IP 1c for natgateway
//resource "aws_eip" "nat_1c" {
//  vpc = true
//  tags = merge(
//  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-eip_1c"), var.tags)
//}

# NAT gateway
//resource "aws_nat_gateway" "nat_1a" {
//  subnet_id     = aws_subnet.public[0].id
//  allocation_id = aws_eip.nat_1a.id
//  tags = merge(
//  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-nat_1a"), var.tags)
//}

//resource "aws_nat_gateway" "nat_1c" {
//  subnet_id     = aws_subnet.public[1].id
//  allocation_id = aws_eip.nat_1c.id
//  tags = merge(
//  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-nat_1c"), var.tags)
//}

# Route table for public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-routetable_public"), var.tags)
}

# Route for public

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.gw.id
}

# Route table association for public

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route table for private 1a

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id
  tags = merge(
  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-routetable_private_1a"), var.tags)
}

# Route table for private 1c

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id
  tags = merge(
  map("Name", "${var.tags["system"]}-${var.tags["environment"]}-routetable_private_1c"), var.tags)
}

# Route for private

//resource "aws_route" "private_1a" {
//  destination_cidr_block = "0.0.0.0/0"
//  route_table_id         = aws_route_table.private_1a.id
//  nat_gateway_id         = aws_nat_gateway.nat_1a.id
//}
//
//resource "aws_route" "private_1c" {
//  destination_cidr_block = "0.0.0.0/0"
//  route_table_id         = aws_route_table.private_1c.id
//  nat_gateway_id         = aws_nat_gateway.nat_1c.id
//}

# Route table association for private

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private_1c.id
}
