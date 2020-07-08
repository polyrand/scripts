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
    echo "Usage: mkpip [NAME] [envrc]? [kernel/nokernel]? [ln]?
Example: mkpip nlp envrc nokernel noln
-n | --name [NAME OF THE ENVIRONMENT]
-c | --config [CREATE CONFIG FILES FOR vim/vscode]
-e | --envrc [CREATE AN .envrc file]
-k | --kernel [CREATE A JUPYTER KERNEL FOR THE ENV]
-l | --link [CREATE SYMLINK TO ~/.virtualenvs]
"
    exit 1
}

log "==================== BEGIN ===================="

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
    -e|--envrc)
    ENVRC=YES
    shift # past argument
    ;;
    -c|--config)
    CONFIG=YES
    shift # past argument
    ;;
    -l|--link)
    LINK=YES
    shift # past argument
    ;;
    -k|--kernel)
    KERNEL=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "ENVIRONMENT NAME  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "LIBRARY PATH    = ${LIBPATH}"
echo "DEFAULT         = ${DEFAULT}"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

NAME=$1

# create cenv folder named .venv
python3 -m venv .venv

# activate env
source .venv/bin/activate

# make sure we are using the right pip/python
echo "Pip location:"
pip_cmd=$(command -v pip)
echo "$pip_cmd"

current=$(pwd)
pip_path="$current/.venv/bin/pip"
echo "$pip_path"

if [[ "$pip_cmd" -ef "$pip_path" ]]; then
    echo "paths match"
else
    exit 1
fi

echo "Python location"
command -v python

# basic libs
pip install --upgrade pip wheel
pip install --upgrade pip-tools setuptools
pip install --upgrade ipykernel black flake8 pycodestyle pydocstyle flake8-bugbear mypy bandit pytest isort autoflake

# vscode settings
if [[ ! -d .vscode ]]; then
    mkdir .vscode

interpreter=$(cat <<EOF
{
    "python.pythonPath": "$(pwd)/.venv/bin/python"
}
EOF
)

    # interpreter='{
    # "python.pythonPath": ".venv/bin/python"
# }'

    echo "$interpreter" >> .vscode/settings.json
fi

# nvim settings
# "python.pythonPath": "$(pwd)/.venv/bin/python"
if [[ ! -f .vim/coc-settings.json ]]; then

    [ -d .vim ] || mkdir .vim

interpreter=$(cat <<EOF
{
    "python.pythonPath": "$(pwd)/.venv/bin/python"
}
EOF
)

    # interpreter='{
    # "python.pythonPath": ".venv/bin/python"
# }'

    echo "$interpreter" >> .vim/coc-settings.json
fi

# .envrc
# nested if's, not much but honest work
if [[ $2 == 'envrc' ]]; then
    echo "setting up envrc"
    if hash direnv 2>/dev/null; then
        envrcconfig='
export VIRTUAL_ENV=.venv
layout python-venv
    '
    echo "$envrcconfig" >> .envrc & direnv allow
    fi
fi

if [[ $3 == 'kernel' ]]; then
    echo "Enabling kernel env for Jupyter"
    ipython kernel install --user --name="$NAME"
fi


if [[ $4 == 'ln' ]]; then
    echo "Creating symlink of virtualenv to ~/.virtualenvs"
    ln -s "$(pwd)"/.venv ~/.virtualenvs/"$NAME"
fi


# Help message (extracted from script headers)
usage() { grep '^#/' "$0" | cut --characters=4-; exit 0; }
REGEX='(^|\W)(-h|--help)($|\W)'
[[ "$*" =~ $REGEX ]] && usage || true
