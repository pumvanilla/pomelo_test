#!/bin/bash
cd /home/ec2-user/web
pm2 --name web-server start npm -- start