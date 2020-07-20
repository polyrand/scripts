#!/usr/bin/env bash

# sudo ufw default deny incoming
# sudo ufw default allow outgoing

sudo ufw allow from 10.20.122.10 to any port 33

# sudo ufw allow from 1111.1111.1111.1111 proto udp to any port 33
# sudo ufw delete allow from 1111.1111.1111.1111 to any port 33
# sudo ufw allow 6000:6007/tcp

# https://www.digitalocean.com/community/tutorials/como-configurar-un-firewall-con-ufw-en-ubuntu-18-04-es
