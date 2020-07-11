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

ENVRC=NO

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

# if [[ -n $1 ]]; then
#     echo "Last line of file specified as non-opt/last argument:"
#     tail -1 "$1"
# fi


if [[ -n ${NAME} ]]; then
    echo "${NAME}"
fi


if [[ ${ENVRC} == YES ]]; then
    echo "it is"
else
    echo "it is not"
fi

