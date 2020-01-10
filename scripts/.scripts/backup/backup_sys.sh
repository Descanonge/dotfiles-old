#!/bin/bash
#Compress the whole system onto external HDD
# add bool argument to copy file on groshub or not

network=${1:=false}

if [ ! -d "/media/clement/My Passport" ]; then
	echo "'My Passport' not connected"
	exit 0
fi

cd /

size=$(du -kc / \
--exclude=/proc/* \
--exclude=/sys/* \
--exclude=/mnt/* \
--exclude=/media/* \
--exclude=/run \
--exclude=/dev/* \
--exclude=/tmp/* \
--exclude=/var/logs \
--exclude=/var/cache/apt/archives/* \
--exclude=/usr/src/linux-headers* \
--exclude=/home/*/.gvfs \
--exclude=/home/*/.thumbnails \
--exclude=/home/*/.cache \
--exclude=/home/*/.local/share/Trash \
| tail -n 1 | cut -f 1)k
echo "$size to backup"

tar -cpPhf - \
--exclude=/proc/* \
--exclude=/sys/* \
--exclude=/mnt/* \
--exclude=/media/* \
--exclude=/run \
--exclude=/dev/* \
--exclude=/tmp/* \
--exclude=/var/logs \
--exclude=/var/cache/apt/archives/* \
--exclude=/usr/src/linux-headers* \
--exclude=/home/*/.gvfs \
--exclude=/home/*/.thumbnails \
--exclude=/home/*/.cache \
--exclude=/home/*/.local/share/Trash \
2>"/media/clement/My Passport/Backups/backup_sys.log" \
| pv -s $size | gzip > "/media/clement/My Passport/Backups/backup_sys_$(date +\%m-\%d).tar.gz"

if [ "$?" = 0 ]; then
	echo "$(date):log: Archive created succesfully" > "/media/clement/My Passport/Backups/backup_sys.log"
else
	echo "$(date):err: Issue in creating archive" > "/media/clement/My Passport/Backups/backup_sys.log"
	exit 1
fi

if [ $network = true ]; then
	rsync -a --progress -e 'ssh -p 1450' \
'/media/clement/My Passport/backup_sys.tar.gz' clement@groshub.ddns.net:/home/clement/Two/Backups/ \
--log-file="/media/clement/My Passport/backup_sys.rsync.log"
fi
