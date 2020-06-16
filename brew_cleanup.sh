#!/usr/bin/env bash

# source: https://github.com/caarlos0/dotfiles/blob/master/bin/brew-cleanup

(cd "$(brew --repo)" && git prune && git gc)
brew cleanup
rm -rf "$(brew --cache)"
