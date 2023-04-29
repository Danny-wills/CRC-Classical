# create eip for nat gateway1
resource "aws_eip" "nat_eip1" {
  vpc      = true

  tags = {
    "name" = "${var.project_name}-nat-eip1"
  }
}
# create eip for nat gateway2
resource "aws_eip" "nat_eip2" {
  vpc      = true

  tags = {
    "name" = "${var.project_name}-nat-eip2"
  }
}
# create nat gateway1
resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = var.public_subnet1_id
  depends_on = [var.internet_gateway]
  tags = {
    "name" = "${var.project_name}-nat-gw1"
  }
}
# create nat gateway2
resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = var.public_subnet1_id
  depends_on = [var.internet_gateway]
    tags = {
    "name" = "${var.project_name}-nat-gw2"
  }
}
# creat route table for private subnet1
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id
  }

  tags = {
    Name = "${var.project_name}-private-rt1"
  }
}
# creat route table for private subnet2
resource "aws_route_table" "private_rt2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw2.id
  }

  tags = {
    Name = "${var.project_name}-private-rt2"
  }
}
# associate subnets with private route table
resource "aws_route_table_association" "priv_sub1" {
  subnet_id      = var.private_subnet1_id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "priv_sub2" {
  subnet_id      = var.private_subnet2_id
  route_table_id = aws_route_table.private_rt2.id
}