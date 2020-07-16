#!/usr/bin/env bash

sudo tee -a /etc/apt/sources.list.d/caddy-fury.list <<EOF 
deb [trusted=yes] https://apt.fury.io/caddy/ /
EOF

sudo apt update
sudo apt install caddy