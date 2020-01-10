#!/bin/bash
#Backup personnal documents, intended to be done weekly
#Backup files are listed in ~/.config/documentsToBak.list

input="/home/clement/.config/documentsToBak.list"
output=""
while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ ${line:0:1} != "#" ]]; then
		output="$output $line"
	fi
done < "$input"

size=$(du -kc $output | tail -n 1 | cut -f 1)k
size_print=$(du -hc $output | tail -n 1 | cut -f 1)
bakfile="/media/clement/My Passport/Backups/docs_$(date +\%m-\%d).tar.gz"

echo "$size_print to compress"

if [ -d '/media/clement/My Passport' ]; then
	tar -chPf - $output 2>"/media/clement/My Passport/Backups/backup_doc.log" | pv -s $size | gzip > "$bakfile"
	rm "/media/clement/My Passport/Backups/backup_doc.log"
else
	echo "My Passport not connected"
fi