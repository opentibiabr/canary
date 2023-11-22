#!/bin/bash

MYSQL_BACKUP_ACTIVED=false
MYSQL_USER=otservbr
MYSQL_PASS=pass
MYSQL_DATABASE=dbname

function do_mysql_backup {
	data=$(date +"%F_%H-%M-%S")
	backup_name="mysql_backup_$data.sql"
	mysqldump -u $MYSQL_USER -p$MYSQL_PASS --single-transaction --databases $MYSQL_DATABASE --compress --result-file=mysql_backup/$backup_name
}

if [ "$MYSQL_BACKUP_ACTIVED" = true ]; then
	if [ ! -d "mysql_backup" ]; then
		mkdir -p mysql_backup
	fi
fi

if [ -d "logs" ]; then
	echo -e "\e[01;32m Starting server with gdb enabled \e[0m"
	find console/ -name "*.log" -mtime +3 -print -exec gzip -f {} \;
else
	mkdir -p logs
	sudo apt install -y gdb
fi

ulimit -c unlimited
set -o pipefail

while true; do

	if [ "$MYSQL_BACKUP_ACTIVED" = true ]; then
		do_mysql_backup
		find mysql_backup/ -name "*.sql" -mtime +3  -print -exec gzip -f {} \;
	fi

	gdb --batch -return-child-result --command=gdb_debug --args ./canary 2>&1 | awk '{ print strftime("%F %T - "), $0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"

	if [ $? -eq 0 ]; then
		echo -e "\e[0;31m Exit code 0, wait 30 seconds... \e[0m"
		sleep 30
	else
		echo -e "\e[0;31m Restarting the server in 5 seconds "The log file is stored in the logs folder" \e[0m"
		echo -e "\e[01;31m If you want to shut down the server, press CTRL + C... \e[0m"
		sleep 30
	fi
done;
