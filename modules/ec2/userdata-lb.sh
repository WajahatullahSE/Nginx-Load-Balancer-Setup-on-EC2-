#!/bin/bash
(
  # Wait until yum is free
  while fuser /var/run/yum.pid >/dev/null 2>&1; do
    echo "Waiting for yum lock to be released..."
    sleep 60
  done

  yum clean all
  yum makecache -y
  yum update -y

  # Install nginx via Amazon Linux Extras
  yes | amazon-linux-extras install nginx1

  systemctl enable nginx
  systemctl start nginx

  echo "NGINX installation completed successfully."
) &
