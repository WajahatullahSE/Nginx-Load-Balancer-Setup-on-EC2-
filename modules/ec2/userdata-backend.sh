#!/bin/bash
sleep 20    #Delay until the network configuration is done
yum update -y
amazon-linux-extras install -y nginx1  
systemctl start nginx
systemctl enable nginx

