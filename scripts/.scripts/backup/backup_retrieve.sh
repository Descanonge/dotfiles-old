#!/bin/bash
# Creates a backup file, arguments are list of pathes to files

for var in "$@"
do
	if [[ "$var" == *.bak ]]
	then 
		var=${var::-4}
		cp -r "$var".bak "$var"
	fi
done