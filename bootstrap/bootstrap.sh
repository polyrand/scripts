#!/usr/bin/env bash
#/ PATH=./node_modules/.bin:$PATH
#/ https://www.tldp.org/LDP/abs/html/options.html
# Similar to -v (Print each command to stdout before executing it), but expands commands
# set -o xtrace
# set -o verbose
# Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -o errexit
# apply to subprocesses too
shopt -s inherit_errexit 2>/dev/null || true
# Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
set -o pipefail
# Attempt to use undefined variable outputs error message, and forces an exit
# set -o nounset
# makes iterations and splitting less surprising
IFS=$'\n\t'
# full path current folder
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# full path of the script.sh (including the name)
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
# name of the script
__base="$(basename ${__file} .sh)"
# full path of the parent folder
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# Log function
# This disables and re-enables debug trace mode (only if it was already set)
# Sources: https://superuser.com/a/1338887/922762 --  https://github.com/Kurento/adm-scripts/blob/master/bash.conf.sh
shopt -s expand_aliases  # This trick requires enabling aliases in Bash
BASENAME="$(basename "$0")"  # Complete file name
echo_and_restore() {
    echo "[${BASENAME}] $(cat -)"
    # shellcheck disable=SC2154
    case "$flags" in (*x*) set -x; esac
}
alias log='({ flags="$-"; set +x; } 2>/dev/null; echo_and_restore) <<<'

fail () { echo $1 >&2; exit 1; }

# Exit trap
# This runs at the end or, thanks to 'errexit', upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then log "ERROR ($_RC)"; else log "SUCCESS"; fi
    log "#################### END ####################"
}
trap on_exit EXIT

# [[ $(id -u) = 0 ]] || [[ -z $SUDO_USER ]] || fail "Please run 'sudo $0'"
[[ $(id -u) = 0 ]] || fail "Please run 'sudo $0'"

export _BLE_SUPPRESS_ERRORS=0
export _BLE_NAV=''
_BLE_FINISHED=0
touch ~/.blealready
export _BLE_ALREADY=~/.blealready # store already run commands
test ${#_BLE_ALREADY} || fail "_BLE_ALREADY tempfile can not be created"

export _BLE_ALREADY_2=/root/.blealready # store already run commands
test ${#_BLE_ALREADY_2} || fail "_BLE_ALREADY tempfile can not be created"

absolute_path() {
  local path
  if egrep -e '^\s*\//' <<< $1; then
    # $1 is an absolute path or a command (without a path)
    path=$1
  else
    # $1 is a relative path
    path="$(cd $(dirname $1); pwd)/$(basename $1)"
  fi
  test ${#path} -gt 0 || fail "absolute_path empty on '$1'"
  echo "$path"
}

ble_print_fail() {
  echo -e "\n\033[1;37;45m ${_BLE_NAV} \033[1;37;41m $* \033[0m\n" >&2
}

ble_serialize_command() {
  oldIFS=$IFS
  # IFS=$'\t'; echo -e "$PWD\t$*"
  IFS=$'\t'; echo -e "$*"
  IFS=$oldIFS
}

ble_exit() {
  _BLE_FINISHED=1
  exit $1
}

ble_handle_exitstatus() {
  local ex=$1; shift
  if ((ex==43)); then
    ble_exit 43  # 43 == halt
  elif ((ex>0 && ex!=42 && _BLE_SUPPRESS_ERRORS==0)); then
    ble_print_fail "command '$@' failed with exit code $ex (CWD is $PWD)"
    return 42    # 42 == error handled from now on (no more error messages in parents)
  else
    return $ex   # 0 or another status when errors output is SUPPRESSed
  fi
}

unless_already() {
  local cmd=$1; shift
  # local path=`absolute_path "$cmd"`
  # local scmd=`ble_serialize_command "$path" "$@"`
  local scmd=`ble_serialize_command "$cmd"`
  # if ! grep -q "$scmd" < ${B} || ! grep -q "$scmd" < ${B2}; then
  if ! grep -q "$scmd" < ${_BLE_ALREADY}; then
    "$cmd"
    export _BLE_ALREADY=~/.blealready # store already run commands
    export _BLE_ALREADY_2=/root/.blealready # store already run commands
    echo "$scmd" >> "${_BLE_ALREADY}" || fail "can't write to _BLE_ALREADY file (${_BLE_ALREADY})"
    echo "$scmd" >> "${_BLE_ALREADY_2}" || fail "can't write to _BLE_ALREADY file (${_BLE_ALREADY_2})"
    # if ! "$path" "$@"; then
    #   ble_handle_exitstatus $? "$@"
    # fi
  else
    echo "Command: $scmd already executed. Skipping..."
  fi
}


log "==================== BEGIN ===================="


# if sudo bash -c '[[ -e /root/.blealready && -e ~/.blealready ]]'; then
#     cd
#     sudo bash -c 'cat /root/.blealready $(pwd)/.blealready | sort | uniq > tmpfile && mv tmpfile $(pwd)/.blealready'
# fi

setup_user() {
    [[ $(id -u) = 0 ]] || [[ -z $SUDO_USER ]] || fail "Please run 'sudo $0'"
    
    [[ -z $NEWHOST ]] && read -e -p "Enter hostname to set: " NEWHOST
    [[ $NEWHOST = *.*.* ]] || fail "hostname must contain two '.'s"
    hostname "$NEWHOST"
    echo "$NEWHOST" > /etc/hostname
    grep -q "$NEWHOST" /etc/hosts || echo "127.0.0.1 $NEWHOST" >> /etc/hosts
    
    if [[ $SUDO_USER = "root" ]] || [[ $USER = "root" ]]; then
      echo "You are running as root, so let's create a new user for you"
      [[ $NEWUSER ]] && SUDO_USER=$NEWUSER || read -e -p "Please enter the username for your new user: " SUDO_USER
      echo "Setting up user: $SUDO_USER"
      [[ -n $SUDO_USER ]] || fail "Empty username not permitted"
      adduser "$SUDO_USER" --gecos ''
      usermod -aG sudo "$SUDO_USER"
      HOME=/home/$SUDO_USER
      touch ~/.blealready
      export _BLE_ALREADY=~/.blealready # store already run commands
      echo "$SUDO_USER  ALL=(ALL:ALL) ALL" >> /etc/sudoers
      cp -r "$PWD" ~/
      chown -R "$SUDO_USER":"$SUDO_USER" ~/
    fi
    [[ -z $EMAIL ]] && read -e -p "Enter your email address: " EMAIL
    
    if [[ $NEWPASS ]]; then
      echo "$SUDO_USER:$NEWPASS" | chpasswd
    else
      read -e -p "We recommend setting your password. Set it now? [y/n] " -i y
      [[ $REPLY = y* ]] && passwd "$SUDO_USER"
    fi
    echo 'Defaults        timestamp_timeout=3600' >> /etc/sudoers
}
unless_already setup_user

set_home() {
  [[ $NEWUSER ]] && SUDO_USER=$NEWUSER || read -e -p "Please enter the username to set home in current script: " SUDO_USER
  echo "Setting home to: $SUDO_USER"
  [[ -n $SUDO_USER ]] || fail "Empty username not permitted"
  HOME=/home/$SUDO_USER

}
set_home


touch ~/.blealready
export _BLE_ALREADY=~/.blealready # store already run commands
test ${#_BLE_ALREADY} || fail "_BLE_ALREADY tempfile can not be created"

setup_ssh () {
    if [[ ! -s ~/.ssh/authorized_keys ]]; then
      [[ -z $PUB_KEY ]] && read -e -p "Please paste your public key here: " PUB_KEY
      mkdir -p ~/.ssh
      chmod 700 ~/.ssh
      echo "$PUB_KEY" > ~/.ssh/authorized_keys
      chmod 600 ~/.ssh/authorized_keys
    fi
}
unless_already setup_ssh

[[ -z $AUTO_REBOOT ]] && read -e -p "Reboot automatically when required for upgrades? [y/n] " -i y AUTO_REBOOT

add_apt_sources() {
    CODENAME=$(lsb_release -cs)
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    cat >> /etc/apt/sources.list << EOF
deb https://cli.github.com/packages $CODENAME main
deb http://ppa.launchpad.net/apt-fast/stable/ubuntu $CODENAME main
deb http://archive.ubuntu.com/ubuntu/ $CODENAME main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $CODENAME-security main restricted universe multiverse
EOF
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C99B11DEB97541F0 1EE2FF37CA8DA16B
    apt update
}
unless_already add_apt_sources

setup_swap() {
    # A swap file can be helpful if you don't have much RAM (i.e <1G)
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    if swapon /swapfile; then
      echo "/swapfile swap swap defaults 0 0" | tee -a /etc/fstab
    else
      echo "Your administrator has disabled adding a swap file. This is just FYI, it is not an error."
      rm -f /swapfile
    fi
}


setup_z () {
    sudo wget -O ~/z.sh \
        https://raw.githubusercontent.com/rupa/z/master/z.sh
    chmod +x ~/z.sh
}
unless_already setup_z

setup_main() {
    export DEBIAN_FRONTEND=noninteractive
    apt -qy install apt-fast
    cp logrotate.conf apt-fast.conf /etc/
    cp journald.conf /etc/systemd/
    cp 50unattended-upgrades 10periodic /etc/apt/apt.conf.d/
    cat >> /etc/apt/apt.conf.d/50unattended << EOF
Unattended-Upgrade::Mail "$EMAIL";
EOF
    [[ $AUTO_REBOOT = y* ]] && echo 'Unattended-Upgrade::Automatic-Reboot "true";' >> /etc/apt/apt.conf.d/50unattended

    chown root:root /etc/{logrotate,apt-fast}.conf /etc/systemd/journald.conf /etc/apt/apt.conf.d/{50unattended-upgrades,10periodic}
    
    apt-fast -qy install python
    apt-fast -qy install vim-nox exiftool jq whois shellcheck neovim python3-neovim python3-powerline fail2ban direnv ripgrep fzf fd-find rsync ubuntu-drivers-common python3-pip ack lsyncd wget bzip2 ca-certificates git build-essential \
      software-properties-common curl grep sed dpkg libglib2.0-dev zlib1g-dev lsb-release tmux less htop exuberant-ctags openssh-client python-is-python3 \
      python3-pip python3-dev dos2unix gh pigz ufw bash-completion ubuntu-release-upgrader-core unattended-upgrades cpanminus pipx libmime-lite-perl \
      opensmtpd mailutils cron
    env DEBIAN_FRONTEND=noninteractive APT_LISTCHANGES_FRONTEND=mail apt-fast full-upgrade -qy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'
    sudo apt -qy autoremove
    
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cat << 'EOF' >> ~/.ssh/config
Host *
  ServerAliveInterval 60
  StrictHostKeyChecking no

Host github.com
  User git
  Port 22
  Hostname github.com
  TCPKeepAlive yes
  IdentitiesOnly yes
EOF
    chmod 600 ~/.ssh/config
    chown -R "$SUDO_USER":"$SUDO_USER" ~/.ssh
    
    
    perl -ni.bak -e 'print unless /^\s*(PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|ChallengeResponseAuthentication)/' /etc/ssh/sshd_config
    cat << 'EOF' >> /etc/ssh/sshd_config
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitEmptyPasswords no
PermitRootLogin no
EOF
    systemctl reload ssh
    # This is often used to setup passwordless sudo; so disable it
    rm -f /etc/sudoers.d/90-cloud-init-users
}
unless_already setup_main


setup_docker() {
    log "Installing docker"
    export DEBIAN_FRONTEND=noninteractive
    dpkg --remove docker docker-engine docker.io containerd runc
    # sudo apt --yes --purge remove $pkgToRemoveList
    
    # install a few prerequisite packages which let apt use packages over HTTPS
    sudo apt-fast -qy install apt-transport-https ca-certificates curl software-properties-common gnupg-agent
    
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
    sudo apt -y install docker-ce docker-ce-cli containerd.io
    
    # If you want to avoid typing sudo whenever you run the docker command,
    # add your username to the docker group
    # sudo groupadd docker
    log "Adding username to docker group"
    sudo usermod -aG docker "${SUDO_USER}"
    
    # log "activate the changes to groups"
    # newgrp docker
    
    # To apply the new group membership, log out of the server and back in, or type the following
    # su - ${USER}
    
    # Confirm that your user is now added to the docker group
    # id -nG
    
    # Check that it’s running
    # sudo systemctl status docker
    
    log "install compose THE VERSION IS HARDCODED"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
}
unless_already setup_docker



setup_ufw() {
    # Enable firewall and allow ssh
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw --force enable
    sudo wget -O /usr/local/bin/ufw-docker \
        https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
    chmod +x /usr/local/bin/ufw-docker
    ufw-docker install
    sudo systemctl restart ufw
}
unless_already setup_ufw

python -m pip install pip -Uq

install_pipx() {
    python -m pip install --user pipx
    python -m pipx ensurepath
}
# unless_already install_pipx

echo 'We need to reboot your machine to ensure kernel upgrades are installed'
echo 'First, make sure you can login in a new terminal, and that you can run `sudo -i`.'
echo "Open a new terminal, and login as $SUDO_USER"
[[ -z $REBOOT ]] && read -e -p 'When you have confirmed you can login and run `sudo -i`, type "y" to reboot. ' REBOOT
[[ $REBOOT = y* ]] && shutdown -r now || echo You chose not to reboot now. When ready, type: shutdown -r now
