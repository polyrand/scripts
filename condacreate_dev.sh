#!/usr/bin/env bash

set -e
set -x

if [ $# -eq 0 ]; then
    echo "Usage: condacreate_dev.sh [NAME] [VERSION] ¿alias?
Example: condacreate nlp 3.7"
    exit 1
fi

NAME=$1
VERSION=$2

echo "Creating environment with name: $NAME"
echo "Using Python version: $VERSION"


conda create --name "$NAME" python="$VERSION"

# basic libs
conda install --name "$NAME" -c conda-forge nodejs=13.13.0
conda install -y --name "$NAME" -c conda-forge ipython jupyterlab nb_conda_kernels black isort ipywidgets widgetsnbextension
# jupyter lab extensions
conda run -n "$NAME" jupyter labextension install @jupyterlab/toc --no-build
conda run -n "$NAME" jupyter labextension install @jupyterlab/celltags --no-build
conda run -n "$NAME" jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
conda run -n "$NAME" jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build
conda run -n "$NAME" jupyter labextension install @aquirdturtle/collapsible_headings --no-build
# conda install -y --name "$NAME" -c conda-forge jupyterlab-git

conda install -y --name "$NAME" -c conda-forge jupyterlab_code_formatter

conda run -n "$NAME" jupyter serverextension enable --py jupyterlab_code_formatter

conda run -n "$NAME" jupyter lab build

if [[ "$3" == 'alias' ]]; then
    echo "alias $NAME='conda activate $NAME'" >> ~/dotfiles/.condalias
fi
