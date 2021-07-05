#!/bin/bash
set -ex
sudo yum update
sudo yum install -y nodejs
sudo npm install pm2 -g