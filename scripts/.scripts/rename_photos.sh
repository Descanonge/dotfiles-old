#!/bin/bash

# Take a folder of photos, rename them by the date it was taken

# YYYY-MM-DD-HHMMSS.

# Add _# to duplicates

folder="$1"

if [ "$folder" == "" ]; then
	echo "Must provide a folder as argument"
	exit 1
fi

for file in `find $folder/ -maxdepth 1 -type f -printf '%P\n'`; do

	if ! grep -q "JPEG" <<< $(file -b $folder/$file | cut -d ',' -f1); then
		continue
	fi

	date=$(identify -format %[EXIF:DateTime] $folder/$file)

	if [[ "$date" == "" ]]; then
		continue
	fi

	filename=$(echo $date | sed -e 's/\([0-9][0-9][0-9][0-9]\):\([0-9][0-9]\):\([0-9][0-9]\) \([0-9][0-9]\):\([0-9][0-9]\):\([0-9][0-9]\)/\1-\2-\3-\4\5\6/')

	if [[ "$(echo $file | head -c 17)" == "$(echo $filename | head -c 17)" ]]; then
		continue
	fi

	double=false

	if [[ -f "$folder/$filename.jpg" ]]; then
		double=true
		count=0
	fi
	
	for duplicate in `find $folder -maxdepth 1 -type f -name "$filename\_*.jpg"`; do
		newCount=$(echo -n $duplicate | tail -c 5 | head -c 1)

		if (( $newCount >= $count )); then
			count=$newCount
		fi

	done

	count=$(($count+1))

	if [[ "$double" == "true" ]]; then
		filename="${filename}_${count}"
	fi

	filename="$filename.jpg"

	echo $filename

	mv -n "$folder/$file" "$folder/$filename"

done

