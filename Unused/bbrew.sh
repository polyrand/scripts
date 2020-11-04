#!/usr/bin/env bash

export SANS_ANACONDA="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# added by Anaconda3 4.4.0 installer
export PATH="/Applications/anaconda/bin:$SANS_ANACONDA"

alias perseus="export PATH="\$SANS_ANACONDA" && echo Medusa decapitated."
alias medusa="export PATH="/Applications/anaconda/bin:\$SANS_ANACONDA" && echo Perseus defeated."

brew () {
  perseus
  command brew "$@"
  medusa
}
