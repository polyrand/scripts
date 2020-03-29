#!/usr/bin/env bash

adduser "$1"

usermod -aG sudo "$1"


rsync --archive --chown="$1":"$1" ~/.ssh /home/"$1"
