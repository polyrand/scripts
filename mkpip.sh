#!/usr/bin/env bash

# usage
if [[ $1 == 'h' ]]; then
    echo "Usage: mkpip [NAME] kernel/nokernel (anything that != 'kernel' really)
Example: mkpip nlp nok"
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

pip_path="$(pwd)/.venv/bin/pip"

[ "$pip_cmd" == "$pip_path" ] || exit 1

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

if [[ $2 == 'kernel' ]]; then
    echo "Enabling kernel env for Jupyter"
    ipython kernel install --user --name="$NAME"
fi
