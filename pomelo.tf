// # aws
// provider "aws" {
//   region = "ap-southeast-1"
// }

// # vpc
// resource "aws_vpc" "prod-vpc" {
//   cidr_block = "10.0.0.0/16"
//   enable_dns_hostnames = true
//   enable_dns_support   = true
//   tags = {
//     Name = "production"
//   }
// } 
// # vpc
// /* 
// data "aws_availability_zones" "available" {}
// module "vpc" {
//   source  = "terraform-aws-modules/vpc/aws"
//   version = "2.77.0"
//   name                 = "prod-vpc"
//   cidr                 = "10.0.0.0/16"
//   azs                  = data.aws_availability_zones.available.names
//   public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
//   private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
//   enable_dns_hostnames = true
//   enable_dns_support   = true
// }
//  */


// # key
// resource "aws_key_pair" "generated_key" {
//   key_name   = "main_key"
//   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl930zF/qnYNpWbaU9JHXIpo+nrTmDg60aANipDvnjaJIzB0bJDej0YOTE17sKah/Ht8hkpRduzVfym5W+b6dwu8cXah7Y/p9DQcxXz9ttKQ7SrVcOKkD8/wnaNYcp5EnSu1DAya3XsG1NIQNqVav4jxG+pcGqPqJNnn/CDTfrGiE87DxQr0s2qBFVyu/RZryVO0dKwegYmGYDaybL5vC3CprvumsAa0aDB2Plyjn0zHGIldrFZIccoAigXjLq8w9Bz6GwxWu3Ea0jDviMB0PtAPICpKHOmwRaHLcVoDDQfivFFI1fOVfdBYXjKTu3uNT7HJqPYVjPYpdZNdrel2EAH0tt5DDjoNkygfKrBxmYgeDCLQO0EAqszWKNRCi84JBYS4Wf1Ki3QMfXxi57fjmwmPTzjgqMapSwdMFfN+w7gzwsRu3zyDB2CmcD7s/fgs4sOg6eIdNdZAmhkfWu0RoSfEdaPL5Nhf/JoGn/DeGsz1FXnlI+aqP6MVmG0OuKZis="
// }

// # gateway
// resource "aws_internet_gateway" "gw" {
//   vpc_id = aws_vpc.prod-vpc.id
// }

// # route table
// resource "aws_route_table" "prod-route-table" {
//   vpc_id = aws_vpc.prod-vpc.id
//   route {
//     cidr_block = "0.0.0.0/0"
//     gateway_id = aws_internet_gateway.gw.id
//   }
//   route {
//     ipv6_cidr_block = "::/0"
//     gateway_id = aws_internet_gateway.gw.id
//   }
//   tags = {
//     Name = "Prod"
//   }
// }

// # subnet
// data "aws_availability_zones" "available" {
//   state = "available"
// }
// resource "aws_subnet" "public-subnet-1" {
//   vpc_id            = aws_vpc.prod-vpc.id
//   cidr_block        = "10.0.1.0/24"
//   map_public_ip_on_launch = true
//   availability_zone = data.aws_availability_zones.available.names[0]
//   tags = {
//     Name = "public-subnet"
//   }
// }
// resource "aws_subnet" "private-subnet-a" {
//   vpc_id            = aws_vpc.prod-vpc.id
//   cidr_block        = "10.0.4.0/24"
//   availability_zone = "ap-southeast-1a"
//   tags = {
//     Name = "private-subnet-a"
//   }
// }
// resource "aws_subnet" "private-subnet-b" {
//   vpc_id            = aws_vpc.prod-vpc.id
//   cidr_block        = "10.0.5.0/24"
//   availability_zone = "ap-southeast-1b"
//   tags = {
//     Name = "private-subnet-b"
//   }
// }

// # subnet - route table
// resource "aws_route_table_association" "subrt" {
//   subnet_id      = aws_subnet.public-subnet-1.id
//   route_table_id = aws_route_table.prod-route-table.id
// }

// # security group
// resource "aws_security_group" "web_traffic" {
//   vpc_id      = aws_vpc.prod-vpc.id
//   name = "allow_web_traffic"
//   description = "Allow Web inbound traffic"
//   egress {
//     from_port   = 0
//     to_port     = 0
//     protocol    = "-1"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//   ingress {
//     description = "HTTPS"
//     from_port   = 443
//     to_port     = 443
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//   ingress {
//     description = "HTTP"
//     from_port   = 80
//     to_port     = 80
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//   ingress {
//     description = "SSH"
//     from_port   = 22
//     to_port     = 22
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//   tags = {
//     Name = "allow_web"
//   }
// }

// # network interface
// resource "aws_network_interface" "web-server-nic" {
//   subnet_id       = aws_subnet.public-subnet-1.id
//   private_ips     = ["10.0.1.50"]
//   security_groups = [aws_security_group.web_traffic.id]
// }

// # elastic ip
// resource "aws_eip" "web_ip" {
//   vpc = true
// 	instance = aws_instance.web.id
//   depends_on = [aws_internet_gateway.gw]
// }

// # web server
// resource "aws_instance" "web" {
//   ami = "ami-018c1c51c7a13e363"
//   subnet_id = aws_subnet.public-subnet-1.id
//   instance_type = "t2.micro"
//   vpc_security_group_ids = [aws_security_group.web_traffic.id]
//   user_data = file("server-script.sh")
//   key_name      = aws_key_pair.generated_key.key_name
//   tags = {
// 	  Name = "web server"
//   }
// }

// resource "aws_instance" "api" {
//   ami = "ami-018c1c51c7a13e363"
//   subnet_id = aws_subnet.private-subnet-a.id
//   instance_type = "t2.micro"
//   vpc_security_group_ids = [aws_security_group.web_traffic.id]
//   tags = {
// 	  Name = "api server"
//   }
// }

// # db subnet
// resource "aws_db_subnet_group" "db-subnet" {
//   name       = "db-subnet-group"
//   subnet_ids = [aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id]
//   tags = {
//     Name = "db subnet"
//   }
// }

// # db sg
// resource "aws_security_group" "rds" {
//   name   = "sg_rds"
//   vpc_id = aws_vpc.prod-vpc.id

//   ingress {
//     from_port   = 5432
//     to_port     = 5432
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   egress {
//     from_port   = 5432
//     to_port     = 5432
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   tags = {
//     Name = "sg_rds"
//   }
// }


// # db
// resource "aws_db_instance" "rds" {
//   name                   = "myDB"
//   identifier             = "my-first-rds"
//   instance_class         = "db.t3.micro"
//   engine                 = "postgres"
//   engine_version         = "13.1"
//   username               = "pomelo"
//   password               = "hashicorp"
//   allocated_storage      = 20
//   skip_final_snapshot    = true
//   port                   = 5432
//   db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
//   vpc_security_group_ids = [aws_security_group.rds.id]
// }


// output "public_ip" {
//   value = aws_eip.web_ip.domain
// }

// output "private_ip" {
//   value = aws_db_instance.rds.address
// }


# log
# module "log_metric_filter" {
#   source  = "terraform-aws-modules/cloudwatch/aws//modules/log-metric-filter"
#   version = "~> 2.0"

#   log_group_name = "my-application-logs"

#   name    = "error-metric"
#   pattern = "ERROR"

#   metric_transformation_namespace = "MyApplication"
#   metric_transformation_name      = "ErrorCount"
# }