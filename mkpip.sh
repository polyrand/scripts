#!/usr/bin/env bash

# usage
if [[ $1 == 'h' ]]; then
    echo "Usage: mkpip [NAME] [envrc]? [kernel/nokernel]? [ln]?
Example: mkpip nlp envrc nokernel noln"
    exit 1
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
pip install --upgrade pip
pip install --upgrade pip-tools setuptools
pip install --upgrade ipykernel black flake8 pycodestyle pydocstyle flake8-bugbear mypy bandit pytest isort autoflake

# vscode settings
if [[ ! -d .vscode ]]; then
    mkdir .vscode

    interpreter='{
    "python.pythonPath": ".venv/bin/python"
}'

    echo "$interpreter" >> .vscode/settings.json
fi

# nvim settings
# "python.pythonPath": "$(pwd)/.venv/bin/python"
if [[ ! -f .vim/coc-settings.json ]]; then

    [ -d .vim ] || mkdir .vim

    interpreter='{
    "python.pythonPath": ".venv/bin/python"
}'

    echo "$interpreter" >> .vim/coc-settings.json
fi

# .envrc
# nested if's, not much but honest work
if [[ $2 == 'envrc' ]]; then
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
    ln -s $(pwd)/.venv ~/.virtualenvs/"$NAME"
fi


