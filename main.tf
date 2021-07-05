# aws
provider "aws" {
  region = "ap-southeast-1"
}

# web server
resource "aws_instance" "web" {
  ami = "ami-018c1c51c7a13e363"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  // ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  user_data = file("server-script.sh")
  key_name = aws_key_pair.admin.key_name
  tags = {
	  Name = "web server"
  }
}

// set role profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# elastic ip
resource "aws_eip" "web_ip" {
  vpc = true
	instance = aws_instance.web.id
  depends_on = [aws_internet_gateway.gw]
}

// api
resource "aws_instance" "api" {
  ami = "ami-018c1c51c7a13e363"
  subnet_id = aws_subnet.private-subnet-a.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_traffic.id]
  tags = {
	  Name = "api server"
  }
}

# db
resource "aws_db_instance" "rds" {
  name                   = "myDB"
  identifier             = "my-first-rds"
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "pomelo"
  password               = "hashicorp"
  allocated_storage      = 20
  skip_final_snapshot    = true
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}

// code deploy
resource "aws_codedeploy_app" "deployapp" {
  compute_platform = "Server"
  name             = "deployapp"
}

output "public_ip" {
  value = aws_eip.web_ip.public_ip
}
output "public_dns" {
  value = aws_eip.web_ip.public_dns
}
output "api_private_ip" {
  value = aws_instance.api.private_ip
}


