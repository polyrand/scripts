#!/usr/bin/env bash

sudo apt update
sudo apt -y install software-properties-common
sudo tee -a /etc/apt/sources.list.d/nginx.list <<EOF 
deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx
EOF
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt update
sudo apt remove nginx nginx-common nginx-full nginx-core
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot  
sudo apt update
sudo apt install certbot python-certbot-nginx letsencrypt
sudo apt install  
sudo apt update  
# systemctl status nginx

echo "Now set up your nginx configuration."


# sudo crontab -e: M H * * * sudo certbot renew


# source: https://stackoverflow.com/a/21549836

# print.sh



# The print.sh file now contains:
# 
# #!/bin/bash
# echo $PWD
# echo /home/user

#   location / {
#       proxy_pass http://127.0.0.1:PORT/;
#       proxy_set_header X-Forwarded-For $remote_addr;
#    }