#!/bin/bash
set -ex
sudo yum update
sudo yum install -y httpd
sudo yum install -y ruby
# sudo systemctl start httpd
# sudo systemctl enable httpd
# echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html

wget https://aws-codedeploy-ap-southeast-1.s3.ap-southeast-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start

sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose