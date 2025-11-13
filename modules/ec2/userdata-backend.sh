#!/bin/bash
sudo systemctl disable packagekit
sudo systemctl stop packagekit  
yum update -y
sleep w0  
amazon-linux-extras install -y nginx1  
systemctl start nginx
systemctl enable nginx

