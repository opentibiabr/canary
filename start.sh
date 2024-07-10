#!/bin/bash

BIN_PATH=${1:-"./canary"}
if [ -d "logs" ]
then
	echo -e "\e[01;32m Starting server \e[0m"
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
	sleep 2
	"$BIN_PATH" 2>&1 | awk '{ print strftime("%F %T - "),
	$0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"
	# Verificar se a tecla 'q' foi pressionada
    read -t 1 -N 1 -r input
    if [[ "$input" == "q" ]]; then
        break
    fi
done
