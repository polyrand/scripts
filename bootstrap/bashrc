# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.

function completion_exports () {

    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
    [[ -r "/etc/profile.d/bash_completion.sh" ]] && . "/etc/profile.d/bash_completion.sh"
    
    # if [ -d $(brew --prefix)/etc/bash_completion.d/ ]; then
    #     for f in $(brew --prefix)/etc/bash_completion.d/*; do
    #         . "$f"
    #     done
    # fi
    
    if [ -d /etc/profile.d/bash_completion.d/ ]; then
        for f in /etc/profile.d/bash_completion.d/*; do
            . "$f"
        done
    fi

    if [ -d /etc/bash_completion.d/ ]; then
        for f in /etc/bash_completion.d/*; do
            . "$f"
        done
    fi
    
    for al in $(git config --get-regexp '^alias\.' | cut -f 1 -d ' ' | cut -f 2 -d '.'); do
        alias g$al="git $al"
    
        # complete_func=_git_$(__git_aliased_command $al)
        # function_exists $complete_fnc && __git_complete g$al $complete_func
    done

    # source <(kubectl completion bash)
}


. ~/z.sh

# # virtualenv and virtualenvwrapper
function vvv () {
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    source /usr/local/bin/virtualenvwrapper.sh
}



# >>> conda initialize >>>
function ccc () {
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/Users/r/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/r/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/r/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/r/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
# <<< conda initialize <<<

# completion exports before to have docker-machine available
completion_exports
base_exports
# vvv
# ccc
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/dotfiles/z.sh ] && source ~/dotfiles/z.sh


# Created by `userpath` on 2020-01-06 11:30:41
export PATH="$PATH:/Users/r/.local/bin"

eval "$(direnv hook bash)"
eval "$(pyenv init - --no-rehash bash)"  # faster with --no-rehash bash

export PATH="$HOME/.cargo/bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export HISTFILE=~/.history
export HISTIGNORE='ls:bg:fg:history:his:exit:clear'
export HISTCONTROL='erasedups:ignoreboth'
export HISTSIZE=-1
export HISTFILESIZE=-1

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# export PROMPT_COMMAND='history -a' # & tput cup 0 0'
export EDITOR='nvim'
export SHELL='/usr/local/bin/bash'
export MANPAGER="less -X"

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Save multi-line commands as one command
shopt -s cmdhist

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null


if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    # Changed these colors to fit Solarized theme
    MAGENTA=$(tput setaf 125)
    ORANGE=$(tput setaf 166)
    GREEN=$(tput setaf 64)
    PURPLE=$(tput setaf 61)
    WHITE=$(tput setaf 244)
  else
    MAGENTA=$(tput setaf 5)
    ORANGE=$(tput setaf 4)
    GREEN=$(tput setaf 2)
    PURPLE=$(tput setaf 1)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
else
  MAGENTA="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  BOLD=""
  RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

export PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"
# TOLASTLINE=$(tput cup 9999 0)
# PS1="\[$TOLASTLINE\]$PS1"
export PS2="\[$ORANGE\]→ \[$RESET\]"
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1

