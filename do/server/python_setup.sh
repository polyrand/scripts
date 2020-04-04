#!/usr/bin/env bash


sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install python3.7
sudo apt update
sudo apt -y upgrade
sudo apt -y install python3-pip
sudo apt -y install python3.7-venv

echo "alias mkenv='python3 -m venv .venv'" >> ~/.bash_aliases
echo "alias acc='source .venv/bin/activate'" >> ~/.bash_aliases
echo "alias reloadnginx='sudo systemctl reload nginx'" >> ~/.bash_aliases
echo "alias checknginx='sudo nginx -t'" >> ~/.bash_aliases
echo "alias pm2npm='pm2 start npm -- start'" >> ~/.bash_aliases

# sudo apt -y install python3-venv

# sudo apt -y install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools