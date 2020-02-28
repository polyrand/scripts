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
echo $(which pip)

echo "Python location"
echo $(which python)

# basic libs
python -m pip install --upgrade pip
python -m pip install --upgrade pip-tools
python -m pip install --upgrade ipykernel black flake8 pycodestyle pydocstyle flake8-bugbear mypy bandit pytest

if [[ $2 == 'kernel' ]]; then
    echo "Enabling kernel env for Jupyter"
    ipython kernel install --user --name="$NAME"
fi
