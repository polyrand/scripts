#!/usr/bin/env bash


if [[ $1 == 'h' ]]; then
    echo "Usage: mkpip [NAME] kernel/nokernel (anything that != 'kernel' really)
Example: mkpip nlp nok"
    exit 1
fi

NAME=$1

python3 -m venv .venv

source .venv/bin/activate

echo "Pip location:"
command -v pip

echo "Python location"
command -v python

# basic libs
python -m pip install --upgrade pip
python -m pip install --upgrade pip-tools setuptools
python -m pip install --upgrade ipykernel black flake8 pycodestyle pydocstyle flake8-bugbear mypy bandit pytest isort autoflake

mkdir .vscode

interpreter="{
    'python.pythonPath': '.venv/bin/python'
}"

echo "$interpreter" >> .vscode/settings.json

if [[ $2 == 'kernel' ]]; then
    echo "Enabling kernel env for Jupyter"
    ipython kernel install --user --name="$NAME"
fi
