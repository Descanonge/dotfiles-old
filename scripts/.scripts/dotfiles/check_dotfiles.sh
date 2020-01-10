#!/bin/bash

# Check if modifications were made in the git worktree of dotfiles

DOTFILES="$HOME/.dotfiles"

status="$(git --git-dir="$DOTFILES/.git" --work-tree="$DOTFILES" \
    status --porcelain)"

if [ ! -z "$status" ]; then
    echo "changed"
fi
    
