#!/usr/bin/env bash

set -x
set -o errexit
set -o pipefail
set -o nounset

export DEBIAN_FRONTEND=noninteractive

sudo apt update

# install caddy
sudo tee -a /etc/apt/sources.list.d/caddy-fury.list <<EOF 
deb [trusted=yes] https://apt.fury.io/caddy/ /
EOF

sudo apt update
sudo apt install -y caddy

sudo apt update

# install other libraries
sudo apt install -y ripgrep
sudo apt install fail2ban

# install node & build-essential
cd ~ || exit
# curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh

# sudo bash nodesource_setup.sh

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y build-essential

# setup pm2
sudo npm install pm2 -g
# sudo chown -R $USER:$(id -gn $USER) ~/.config

# setup python3.7
sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt -y install python3.7
sudo apt update
sudo apt -y upgrade
sudo apt -y install python3-pip
sudo apt -y install python3.7-venv

# setup aliases
echo "alias mkenv='python3 -m venv .venv'" >> ~/.bash_aliases
echo "alias acc='source .venv/bin/activate'" >> ~/.bash_aliases
echo "alias reloadnginx='sudo systemctl reload nginx'" >> ~/.bash_aliases
echo "alias checknginx='sudo nginx -t'" >> ~/.bash_aliases
echo "alias pm2npm='pm2 start npm -- start'" >> ~/.bash_aliases
echo "alias ..='cd ..'" >> ~/.bash_aliases
echo "alias ...='cd ../..'" >> ~/.bash_aliases
echo "alias ufws='sudo ufw status'" >> ~/.bash_aliases
echo "alias tnew='tmux new-session -s'" >> ~/.bash_aliases
echo "alias tls='tmux ls'" >> ~/.bash_aliases
echo "alias tat='tmux attach-session -t'" >> ~/.bash_aliases
echo "alias tkill='tmux kill-session -t'" >> ~/.bash_aliases
