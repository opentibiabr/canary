#!/bin/bash

BIN_PATH=${1:-"./canary"}

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
	echo -e "\e[01;32m Starting server \e[0m"
	find console/ -name "*.log" -mtime +3 -print -exec gzip -f {} \;
else
	mkdir -p logs
fi

if [ ! -f "config.lua" ]; then
	echo -e "\e[01;33m config.lua file not found, new file will be created \e[0m"
	cp config.lua.dist config.lua && ./docker/config.sh --env docker/.env
fi

ulimit -c unlimited
set -o pipefail

while true; do
	if [ "$MYSQL_BACKUP_ACTIVED" = true ]; then
		do_mysql_backup
		find mysql_backup/ -name "*.sql" -mtime +3  -print -exec gzip -f {} \;
	fi

	sleep 2
	"$BIN_PATH" 2>&1 | awk '{ print strftime("%F %T - "),
	$0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"
	# Verificar se a tecla 'q' foi pressionada
    read -t 1 -N 1 -r input
    if [[ "$input" == "q" ]]; then
        break
    fi
done
