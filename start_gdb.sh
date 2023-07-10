#!/bin/bash

if [ -d "logs" ]
then
	echo -e "\e[01;32m Starting server with gdb enabled \e[0m"
else
	mkdir -p logs
	sudo apt install -y gdb
fi

ulimit -c unlimited
set -o pipefail


while true; do gdb --batch -return-child-result --command=gdb_debug --args ./canary 2>&1 | awk '{ print strftime("%F %T - "), 
$0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"

if [ $? -eq 0 ]; then
		echo -e "\e[0;31m Exit code 0, wait 30 seconds... \e[0m"
		sleep 30
	else
		echo -e "\e[0;31m Restarting the server in 5 seconds "The log file is stored in the logs folder" \e[0m"
		echo -e "\e[01;31m If you want to shut down the server, press CTRL + C... \e[0m"
		sleep 30
	fi
done;
