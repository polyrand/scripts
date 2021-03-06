#!/usr/bin/env bash


if [ $# -eq 0 ]; then
    echo "Usage: condacreate [NAME] [VERSION]
Example: condacreate nlp 3.7"
    exit 1
fi

NAME=$1
VERSION=$2

echo "Creating environment with name: $NAME"
echo "Using Python version: $VERSION"


mamba create --name "$NAME" python="$VERSION"

# basic libs
mamba install -y --name "$NAME" -c conda-forge ipykernel black flake8 flake8-bugbear mypy bandit

# echo "Enabling kernel env for Jupyter"
# conda run -n "$NAME" ipython kernel install --user --name="$NAME"

# if [[ $3 == 'alias' ]]; then
#     echo "alias $NAME='conda activate $NAME'" >> ~/dotfiles/.condalias
# fi
