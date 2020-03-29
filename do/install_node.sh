#!/usr/bin/env bash

sudo apt update

cd ~
# curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh

# sudo bash nodesource_setup.sh

curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt install -y nodejs

sudo apt install -y build-essential