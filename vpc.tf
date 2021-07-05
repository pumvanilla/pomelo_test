# vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "production"
  }
} 
# vpc
/* 
data "aws_availability_zones" "available" {}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"
  name                 = "prod-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}
 */

# gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  // ipv4
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  // ipv6
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "Prod"
  }
}

# subnet
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private-subnet-a" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "private-subnet-a"
  }
}
resource "aws_subnet" "private-subnet-b" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "private-subnet-b"
  }
}

# subnet - route table
resource "aws_route_table_association" "subrt" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# network interface
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.public-subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.web_traffic.id]
}

# db subnet
resource "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id]
  tags = {
    Name = "db subnet"
  }
}
