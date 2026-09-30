#!/usr/bin/env bash

# Create a new worktree and tmux session
# Usage: wt-session <branch-name> [base-branch]

set -e

if [[ -z "$1" ]]; then
    echo "Usage: wt-session <branch-name> [base-branch]"
    exit 1
fi

branch_name="$1"
base_branch="${2:-}"
session_name=$(echo "$branch_name" | tr ":,. /" "------")

# Create worktree and get its path
if [[ -n "$base_branch" ]]; then
    worktree_output=$(wt switch -c --base "$base_branch" --format json "$branch_name" 2>/dev/null)
else
    worktree_output=$(wt switch -c --format json "$branch_name" 2>/dev/null)
fi

# Extract path from JSON output
worktree_path=$(echo "$worktree_output" | jq -r '.path // empty' 2>/dev/null)

# Fallback: derive path manually if JSON parsing fails
if [[ -z "$worktree_path" ]]; then
    # Get git root and derive worktree path (worktrunk uses ~/repo.branch-name pattern)
    git_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    repo_name=$(basename "$git_root")
    worktree_path="$HOME/$repo_name.$branch_name"
fi

# Function to switch to tmux session
switch_to() {
    if [[ -z "$TMUX" ]]; then
        tmux attach-session -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

# Check if session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
    switch_to
else
    tmux new-session -ds "$session_name" -c "$worktree_path"
    switch_to
fi
