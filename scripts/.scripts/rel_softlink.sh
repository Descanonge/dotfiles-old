#!/bin/bash

# Create soft link to target. Ask for destination

target=$1

file=$(zenity --file-selection --filename=$target --directory)
# file="$(realpath --relative-to="$target" $file)"

ln -sr "$target" "$file"
