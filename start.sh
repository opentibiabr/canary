#!/bin/bash

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
	canary 2>&1 | awk '{ print strftime("%F %T - "),
	$0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"
	# Verificar se a tecla 'q' foi pressionada
    read -t 1 -N 1 input
    if [[ $input = "q" ]]; then
        break
    fi
	sleep 2
done
