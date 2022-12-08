#!/bin/bash

if [ -d "logs" ]
then
	echo -e "\e[01;32m Starting server \e[0m"
else
	mkdir -p logs
	sudo apt install -y gdb
fi

ulimit -c unlimited
set -o pipefail

while true; do ./canary 2>&1 | awk '{ print strftime("%F %T - "), 
$0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")" done;
