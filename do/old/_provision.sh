#!/usr/bin/env bash

# source: https://github.com/altocodenl/acpic/blob/master/provision.sh

if [ "$2" != "confirm" ] ; then
   echo "Must add 'confirm'"
   exit 1
fi
if [ "$1" == "prod" ] ; then
   HOST="rick@165.22.21.234"
# elif [ "$1" == "dev" ] ; then
#    HOST="root@207.154.244.76"
else
   echo "Must specify environment (dev|prod)"
   exit 1
fi

ssh $HOST apt update
ssh $HOST DEBIAN_FRONTEND=noninteractive apt upgrade -y --with-new-pkgs
ssh $HOST apt install fail2ban -y
# ssh $HOST apt install htop sysstat -y
# ssh $HOST "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -"
# ssh $HOST apt install nodejs -y
ssh $HOST apt install build-essential -y
ssh $HOST apt install nginx -y
ssh $HOST apt autoremove -y
ssh $HOST apt clean
ssh $HOST shutdown -r now

# ssh $HOST mkdir /root/files
# ssh $HOST '(mkdir /tmp/mon && cd /tmp/mon && curl -L# https://github.com/tj/mon/archive/master.tar.gz | tar zx --strip 1 && make install && rm -rf /tmp/mon)'
# ssh $HOST npm install -g mongroup
# ssh $HOST apt install vim -y
# ssh $HOST wget https://raw.githubusercontent.com/fpereiro/vimrc/master/vimrc
# ssh $HOST mv vimrc .vimrc
# ssh $HOST apt install redis-server -y
# ssh $HOST apt install imagemagick -y
