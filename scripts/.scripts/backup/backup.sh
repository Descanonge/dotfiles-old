#!/bin/bash
# Creates a backup file, arguments are list of pathes to files

for var in "$@"
do
	cp -r "$var" "$var".bak
done