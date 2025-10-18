#!/usr/bin/env bash

selected=$(find ~/dev -type d -mindepth 1 -maxdepth 1 | fzf --delimiter=/ --with-nth=-1 --header="Select a project to open in a tmux session")

if [[ -z "$selected" ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr ":,. " "----")

switch_to() {
  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t $selected_name
  else
    tmux switch-client -t $selected_name
  fi
}

if tmux has-session -t $selected_name 2> /dev/null; then
  switch_to
else
  tmux new-session -ds $selected_name -c $selected
  switch_to
fi


