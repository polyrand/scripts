# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"



# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

alias vbrc='nvim ~/.bashrc'
alias vbp='nvim ~/.bash_profile'
alias valias='nvim ~/.aliases'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias fd='fdfind'

alias path='echo -e ${PATH//:/\\n}'
alias snip='~/Projects/sniplib/sniplib.sh ~/Projects/sniplib/snips'
alias chmox='chmod +x'
alias kpull='kaggle kernels pull'
alias listkernels='conda run -n dev jupyter kernelspec list'

alias getread='cp ~/dotfiles/README.md $(pwd)'
alias gettask='cp ~/Projects/scripts/Taskfile/Taskfile .'
alias b='bat'
alias l='ls'
alias ls='exa --group-directories-first'
alias la='ls -la'
alias ll="ls -l"

alias lsr='ls -la | rg -i'

# Always use color output for `ls`
# alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
alias frg='fd | rg -i'
alias his='history | rg -i'
alias vim='nvim'
alias v='nvim'
alias vom='nvim'
alias acc='source .venv/bin/activate'
alias mkpip='bash ~/Projects/scripts/mkpip.sh'
alias condarm='conda env remove --name'
alias createpy='bash ~/Projects/scripts/condacreate.sh'
alias createdev='bash ~/Projects/scripts/condacreate_dev.sh'
alias active='conda activate'
alias dac='conda deactivate'
alias dev='conda activate dev'

alias et='exiftool'
alias etr='exiftool -all='

alias update="brew update && brew upgrade && brew upgrade --cask; echo [+] Brew Updated"
alias updatepip="pip3 list --not-required --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install --upgrade --upgrade-strategy only-if-needed; echo [+] Pip updated"
# check --outdated --not-required # alias update="brew update && brew upgrade && brew cask upgrade; echo [+] Brew Updated; pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U; echo [+] Pip updated"
alias updatevim="nvim --headless +PlugClean +PlugUpdate +PlugUpgrade +UpdateRemotePlugins +CocUpdateSync +qall && echo 'NVim Updated' "
alias localip="ipconfig getifaddr en0"
alias portstcp='netstat -tulan -p tcp'
alias portsudp='netstat -tulan -p udp'

alias g='git'
cleanblank='awk NF'
alias syncro='rsync -Pavzh'

alias ca='bat'
alias c='cat'

alias tarr='tar -czvf'
alias untarr='tar xzvf'
alias rf='rm -rf'

alias rsn='rsync -aP -e ssh'  # -r for recursive; -a option is a combination flag. --exclude="*.odc"
# It stands for “archive” and syncs recursively and preserves symbolic links, special and device files, modification times, group, owner, and permissions.
#

# tmux
alias tnew='tmux new-session -s'
alias tls='tmux ls'
alias tat='tmux attach-session -t'
alias tkill='tmux kill-session -t'


alias please='sudo $(history -p !!)'
alias run='./Taskfile'

alias k='kubectl'
alias ka='kubectl apply -f .'
alias kd='kubectl delete -f .'
alias kak='kubectl apply -k .'
alias kdk='kubectl delete -k .'

alias bkhist='cat ~/.history >> ~/historybk && sort -u ~/historybk -o ~/historybk'


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}


#function o() {
#	if [ $# -eq 0 ]; then
#		open .;
#	else
#		open "$@";
#	fi;
#}

function mkd () { mkdir -p "$@" && cd "$@"; }

function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
    else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}


function extract() {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}


function sal() {
    source ~/.bashrc
    source ~/.bash_profile
    source ~/.bash_prompt
    source ~/.functions
    source ~/.aliases
}

function img64() {
    convert "$1" INLINE:PNG:- | pbcopy
}

function enc() {
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -a -in "$1" -out "$1".enc
}

function dec() {
    openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -a -in "$1" -out "$1".new
}

function encshare() {
    tmpfile1="$(openssl rand -hex 32)".zip
    echo "$tmpfile1"
    tmpfile2="$(openssl rand -hex 32)".enc
    echo "$tmpfile2"
    zip -e -r "$tmpfile1" "$1"
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -a -in "$tmpfile1" -out "$tmpfile2"
    rm "$tmpfile1"
    base64 -i "$tmpfile2" > encryptedstring.txt
    rm "$tmpfile2"
}

function decshare() {
    tmpfile1="$(openssl rand -hex 32)".zip
    tmpfile2="$(openssl rand -hex 32)".enc
    cat "$1" | base64 -d > "$tmpfile2"
    openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -a -in "$tmpfile2" -out "$tmpfile1"
    rm "$tmpfile2"
    unzip "$tmpfile1"
    rm "$tmpfile1"
}


function pushupdate() {
    if [[ $@ ]]; then
        message="$1"
    else
        message="update"
    fi
    git add --all &&
    git commit -m "$message" &&
    git push; #origin master;
}

function updategit() {
    if [ $# -eq 0 ]; then
        ls | xargs -I{} git -C {} pull
    elif [ $1 == 'parallel' ]; then
        ls | xargs -P10 -I{} git -C {} pull
    elif [ $1 == 'force' ]; then
        ls | xargs -P10 -I{} git -C {} fetch --all
        ls | xargs -P10 -I{} git -C {} reset --hard origin/master
    fi;
}

function check() {
    ping -c 10 www.google.es
}

function relinkenv() {
    for folder in `find ~/.virtualenvs -type d -mindepth 1 -maxdepth 1`;
	do
		gfind $folder -type l -xtype l -delete
		virtualenv $folder
	done
}

function back() {
    nohup "$1" &>/dev/null &
}

# cat + ripgrep
function cr() {
    if [ $# != 2 ]; then
        echo "Two (2) arguments needed!"
    else
        cat "$1" | rg -i "$2";
    fi;


}


function rmkernel(){
    conda activate dev && yes y | jupyter kernelspec uninstall "$1"
    conda deactivate
}


# Usage: mv oldfilename
# If you call mv without the second parameter it will prompt you to edit the filename on command line.
# Original mv is called when it's called with more than one argument.
# It's useful when you want to change just a few letters in a long name.
#
# Also see:
# - imv from renameutils
# - Ctrl-W Ctrl-Y Ctrl-Y (cut last word, paste, paste)

function mv() {
  if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
    command mv "$@"
    return
  fi

  read -ei "$1" newfilename
  command mv -v -- "$1" "$newfilename"
}


function cleanpy() {
  find . -name '*.pyc' -exec rm -f {} +
  find . -name '*.pyo' -exec rm -f {} +
  find . -name '*~' -exec rm -f {} +
  find . -name '__pycache__' -exec rm -fr {} +
}

function mksshed() {
    ssh-keygen -t ed25519 -a 100 -f ~/.ssh/"$1" -q -N ""
}

function mksshrsa() {
    ssh-keygen -t ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/"$1" -q -N ""
}

function ksub() {
    local image_version="$1"
    sd "version: \"\d+\"" "version: \"$image_version\"" deployment.yaml
    local part1='image: fdcreg.azurecr.io/firstderm/(.*):\d+'
    local part2="image: fdcreg.azurecr.io/firstderm/\$1:$image_version"
    sd "$part1" "$part2" deployment.yaml

    # sed -E -i "s/(version:\s)\"9042\"/$image_version/" deployment.yaml
}

function ssht () {
    ssh "$1" -t "tmux new-session -s $2 || tmux attach-session -t $2"
    # ssh "$1" -t 'tmux new -A "$2"
}


function csv () {
    if [ $2 ]; then
        xsv sample "$2" "$1" | xsv table
    else
        xsv table "$1"
    fi
}

f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

export _virtualenvs_directory="~/.virtualenvs"
# https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
function workon() {
    source "$_virtualenvs_directory"/"$1"/bin/activate
}

_workon_completions() {
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi

    # Displaying each entry in a new line (not working?)
    # local IFS=$'\n'

    COMPREPLY=($(compgen -W "$(ls $_virtualenvs_directory/ | awk '{print $1}')" "${COMP_WORDS[1]}"))
}
complete -F _workon_completions workon
# compgen -f $_virtualenvs_directory/ | awk -F/ '{print $NF}'

function dockcon() {

    if [[ "$1" == "unset" ]]; then
        if [[ -f docker_connection.pid ]]; then
            echo "removing docker_connection file"
            kill "$(cat docker_connection.pid)"
            rm docker_connection.pid
        else
            echo "docker_connection file not found!"
        fi
        unset DOCKER_HOST
        return
    fi
    PORT=$(( ( RANDOM % 10000 )  + 27000 ))  # port between 27000 - (27000 + 10000)
    ssh -NL localhost:$PORT:/var/run/docker.sock "$1" & echo $! > docker_connection.pid
    export DOCKER_HOST="tcp://localhost:$PORT"
}
