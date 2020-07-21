#!/usr/bin/env bash

set -x
set -o errexit
set -o pipefail
set -o nounset

export DEBIAN_FRONTEND=noninteractive
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:oisf/suricata-stable
sudo apt install -y suricata


python3.7 -m venv "$HOME/.venv"
source "$HOME/.venv/bin/activate"
pip install --upgrade suricata-update
sudo suricata-update enable-source oisf/trafficid
sudo suricata-update enable-source et/open
sudo suricata-update

sudo systemctl stop suricata
sudo rm /var/run/suricata.pid
sudo suricata -D -c /etc/suricata/suricata.yaml -i eth0
sudo systemctl restart suricata
# reload rules
# kill -USR2 $(pidof suricata)
