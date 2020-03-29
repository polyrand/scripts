#!/usr/bin/env bash

sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update
sudo apt install python-certbot-nginx -y


# sudo crontab -e: M H * * * sudo certbot renew


#   location / {
#       proxy_pass http://127.0.0.1:PORT/;
#       proxy_set_header X-Forwarded-For $remote_addr;
#    }