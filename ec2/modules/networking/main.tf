# creating a VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.common_tags,
    {
        Name = "terra-vpc"
    }
  )
}

#SUBNET
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

#Internet Gate Way
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {
    Name = "terra-igw"
  }
}

#Route Table
resource "aws_route_table" "terra_public_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name = "terra-public-rt"
  }
}

#Route Table Association
resource "aws_route_table_association" "terra_public_rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.terra_public_rt.id
}