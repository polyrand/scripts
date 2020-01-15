#!/usr/bin/env bash


if [ $# -eq 0 ]; then
    echo "Usage: condacreate [NAME] [VERSION] ¿alias?
Example: condacreate nlp 3.7"
    exit 1
fi

NAME=$1
VERSION=$2

echo "Creating environment with name: $NAME"
echo "Using Python version: $VERSION"


conda create --name "$NAME" python="$VERSION"

# basic libs
conda install --name "$NAME" -c conda-forge numpy pandas ipython black flake8 matplotlib pycodestyle pydocstyle flake8-bugbear more-itertools jupyterlab mypy bandit

# jupyter lab extensions
conda run -n "$NAME" jupyter labextension install @jupyterlab/toc --no-build
conda run -n "$NAME" jupyter labextension install @jupyterlab/celltags --no-build
conda run -n "$NAME" jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
conda run -n "$NAME" jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build
conda install --name "$NAME" -c conda-forge jupyterlab-git

conda install --name "$NAME" -c conda-forge jupyterlab_code_formatter

conda run -n "$NAME" jupyter serverextension enable --py jupyterlab_code_formatter

conda run -n "$NAME" jupyter lab build

if [[ $3 == 'alias' ]]; then
    echo "alias $NAME='conda activate $NAME'" >> ~/dotfiles/.condalias
# else
#     ffmpeg -ss "$START" -t "$LENGTH" -i dl.mp4 -an -vf "setpts=(1/"$SPEED")*PTS" "$NAME".mp4
fi


# youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --no-playlist -o 'dl.%(ext)s' $ID
# echo " ===> Removing files..."
# rm dl.mp4
# echo " ===> Done! "
