#!/bin/bash
set -ex
sudo yum update -y
sudo yum install -y nodejs

sudo npm install yarn -g
sudo npm install pm2 -g