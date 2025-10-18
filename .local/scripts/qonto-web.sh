#!/usr/bin/env bash

# directories=$(fd . --type directory --min-depth=1 --max-depth=1 ~/dev/qonto-web/packages ~/dev/qonto-web/apps)
directories=$(find ~/dev/qonto-web/packages ~/dev/qonto-web/apps -type d -mindepth 1 -maxdepth 1)

selected=$(echo -e "$directories" | fzf --delimiter=/ --with-nth=-2,-1 --header="Select a directory to open in tmux" --preview="ls -l {}" --preview-window=right:70% --query="$1")

if [[ -z "$selected" ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr ":,. " "----")

windows_list=$(tmux list-windows -a)

if echo "$windows_list" | grep "$selected_name"; then
  session_name=$(echo "$windows_list" | grep "$selected_name" | awk -F':' '{print $1}')
  window_index=$(echo "$windows_list" | grep "$selected_name" | awk -F':' '{print $2}')
  if [[ "$session_name" == "$(tmux display-message -p '#S')" ]]; then
    tmux select-window -t $selected_name
  else
    tmux switch-client -t $session_name:$window_index
  fi
else
  new_or_current=$(echo -e "new\ncurrent" | fzf --header="New window or current?")

  if [[ -z "$new_or_current" ]]; then
    exit 0
  fi

  if [[ "$new_or_current" == "new" ]]; then
    tmux new-window -n $selected_name -c $selected
    tmux send-keys "nvim" C-m
  else
    tmux send-keys "cd $selected && nvim" C-m
  fi
fi

