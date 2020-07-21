#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

# update your existing list of packages
sudo apt update

sudo apt remove docker docker-engine docker.io containerd runc

# install a few prerequisite packages which let apt use packages over HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg-agent

# add the GPG key for the official Docker repository to your system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# update the package database with the Docker packages from the newly added repo
sudo apt update

# Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
apt-cache policy docker-ce

# install Docker:
sudo apt install docker-ce docker-ce-cli containerd.io

# If you want to avoid typing sudo whenever you run the docker command,
# add your username to the docker group
sudo groupadd docker
sudo usermod -aG docker ${USER}

# activate the changes to groups
newgrp docker

# To apply the new group membership, log out of the server and back in, or type the following
# su - ${USER}

# Confirm that your user is now added to the docker group
id -nG

# Check that it’s running
sudo systemctl status docker

# install compose THE VERSION IS HARDCODED
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
