#!/usr/bin/env bash

# https://medium.com/adorableio/simple-note-taking-with-fzf-and-vim-2a647a39cfa
# Modified from https://gist.github.com/BaseCase/c45299e4f8474119881d708a4b728fbf


set -e

main() {
  previous_file="$1"
  file_to_edit=`select_file $previous_file`

  if [ -n "$file_to_edit" ] ; then
    "$EDITOR" "$file_to_edit"
    main "$file_to_edit"
  fi
}

select_file() {
  given_file="$1"
  fzf --preview="bat {}" --preview-window=right:70%:wrap --query="$given_file"
}

main ""
