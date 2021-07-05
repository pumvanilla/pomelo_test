#!/bin/bash
cd /home/ec2-user/app/web

yarn install

pm2 --name web-server start npm -- start