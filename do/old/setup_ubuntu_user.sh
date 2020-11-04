#!/usr/bin/env bash

adduser "r"

usermod -aG sudo "r"


rsync --archive --chown="r":"r" ~/.ssh /home/"r"

ufw allow OpenSSH

ufw enable