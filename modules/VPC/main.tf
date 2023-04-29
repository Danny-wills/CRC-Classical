# create vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# get availability zones
data "aws_availability_zones" "available"{}

# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# create public subnet1
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1"
  }
}
# create public subnet2
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}
# create public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}
# associate subnets with public route table
resource "aws_route_table_association" "pub_sub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "pub_sub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# create private subnet1
resource "aws_subnet" "private_sub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}private-subnet-1"
  }
}
# create private subnet2
resource "aws_subnet" "private_sub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}private-subnet-2"
  }
}

