#!/usr/bin/env bash

# Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -o errexit
# Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
set -o pipefail
# Attempt to use undefined variable outputs error message, and forces an exit
set -o nounset
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


# Exit trap
# This runs at the end or, thanks to 'errexit', upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then log "ERROR ($_RC)"; else log "SUCCESS"; fi
    log "#################### END ####################"
}
trap on_exit EXIT


# usage
print_usage() {
    echo "
Example: mkc --yes -n nlp -k
-y | --yes [CREATE THE ENVIRONMENT]
-n | --name [NAME OF THE ENVIRONMENT]
-v | --version [python version]
-f | --full [install basics like pip-tools, black, ipykernel, flake8, etc.]
-c | --config [CREATE CONFIG FILES FOR vim/vscode]
-e | --envrc [CREATE AN .envrc file]
-k | --kernel [CREATE A JUPYTER KERNEL FOR THE ENV]
"
    exit 0
}

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


log "==================== BEGIN ===================="

log "Activating conda"

ccc

CREATE=NO
ENVRC=NO
CONFIG=NO
KERNEL=NO
FULL=NO

# source: https://stackoverflow.com/a/14203146
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -n|--name)
    NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--version)
    VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -y|--yes)  # actually create the env
    CREATE=YES
    shift # past argument
    ;;
    -f|--full)  # actually create the env
    FULL=YES
    shift # past argument
    ;;
    -e|--envrc)
    ENVRC=YES
    shift # past argument
    ;;
    -c|--config)
    CONFIG=YES
    shift # past argument
    ;;
    -k|--kernel)
    KERNEL=YES
    shift # past argument
    ;;
    -h|--help)
    print_usage
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


if [[ ${CREATE} == YES ]]; then
    log "creating environment"

    mamba create -c conda-forge --name "${NAME}" python="${VERSION}"
    
    if [[ ${FULL} == YES ]]; then
        log "installing extra packages"
        mamba install --name "${NAME}" -c conda-forge ipykernel black flake8 pycodestyle pydocstyle flake8-bugbear mypy bandit pytest isort autoflake pip-tools
    fi
fi

if [[ ${CONFIG} == YES ]]; then
    log "creating config files for vscode"
    # vscode settings
    if [[ ! -d .vscode ]]; then
        mkdir .vscode
    
    interpreter=$(cat <<EOF
{
    "python.pythonPath": "/Users/r/miniconda3/envs/${NAME}/bin/python3"
}
EOF
)

        echo "$interpreter" >> .vscode/settings.json
    fi

    log "creating config files for nvim"
    # nvim settings
    # "python.pythonPath": "$(pwd)/.venv/bin/python"
    if [[ ! -f .vim/coc-settings.json ]]; then
    
        [ -d .vim ] || mkdir .vim
    
    interpreter=$(cat <<EOF
{
    "python.pythonPath": "/Users/r/miniconda3/envs/${NAME}/bin/python3"
}
EOF
)

        echo "$interpreter" >> .vim/coc-settings.json
    fi
fi

if [[ ${ENVRC} == YES ]]; then
    log "creating .envrc file"
    # .envrc
    # nested if's, not much but honest work
    if hash direnv 2>/dev/null; then
        envrcconfig="
layout conda $NAME
"
        echo "$envrcconfig" >> .envrc && direnv allow
    fi
    log "envrc set up"
fi

if [[ ${KERNEL} == YES ]]; then
    log "adding kernel to jupyter"

    conda run -n "${NAME}" ipython kernel install --user --name="${NAME}"

    log "kernel added"
fi
