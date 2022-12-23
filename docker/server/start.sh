#!/bin/bash

DB_HOST="${SERVER_DB_HOST:-127.0.0.1}"
DB_USER="${SERVER_DB_USER:-canary}"
DB_PASSWORD="${SERVER_DB_PASSWORD:-canary}"
DB_DATABASE="${SERVER_DB_DATABASE:-canary}"
OT_SERVER_IP="${SERVER_IP:-127.0.0.1}"
OT_SERVER_LOGIN_PORT="${SERVER_LOGIN_PORT:-7171}"
OT_SERVER_GAME_PORT="${SERVER_GAME_PORT:-7172}"
OT_SERVER_STATUS_PORT="${SERVER_STATUS_PORT:-7171}"

echo ""
echo "===== Print Variables ====="
echo ""

echo "DB_HOST:[$DB_HOST]"
echo "DB_USER:[$DB_USER]"
echo "DB_PASSWORD:[$DB_PASSWORD]"
echo "DB_DATABASE:[$DB_DATABASE]"
echo "OT_SERVER_IP:[$OT_SERVER_IP]"
echo "OT_SERVER_LOGIN_PORT:[$OT_SERVER_LOGIN_PORT]"
echo "OT_SERVER_GAME_PORT:[$OT_SERVER_GAME_PORT]"
echo "OT_SERVER_STATUS_PORT:[$OT_SERVER_STATUS_PORT]"

echo ""
echo "================================"
echo ""

echo ""
echo "===== Wait for the DB to be Up ====="
echo ""

until mysql -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" --port="$DB_PORT" -e "SHOW DATABASES;"
do
	echo "DB offline, trying again"
	sleep 5s
done

echo ""
echo "================================"
echo ""

echo ""
echo "===== Create Database and Import schema ====="
echo ""

mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST -e "CREATE DATABASE $DB_DATABASE;"
mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST -e "SHOW DATABASES;"
mysql -u $DB_USER -p$DB_PASSWORD -h $DB_HOST -D $DB_DATABASE < schema.sql

echo ""
echo "================================"
echo ""

sed -i '/mysqlHost = .*$/c\mysqlHost = "'$DB_HOST'"' config.lua
sed -i '/mysqlUser = .*$/c\mysqlUser = "'$DB_USER'"' config.lua
sed -i '/mysqlPass = .*$/c\mysqlPass = "'$DB_PASSWORD'"' config.lua
sed -i '/mysqlDatabase = .*$/c\mysqlDatabase = "'$DB_DATABASE'"' config.lua
sed -i '/ip = .*$/c\ip = "'$OT_SERVER_IP'"' config.lua
sed -i '/loginProtocolPort = .*$/c\loginProtocolPort = '$OT_SERVER_LOGIN_PORT'' config.lua
sed -i '/gameProtocolPort = .*$/c\gameProtocolPort = '$OT_SERVER_GAME_PORT'' config.lua
sed -i '/statusProtocolPort = .*$/c\statusProtocolPort = '$OT_SERVER_STATUS_PORT'' config.lua

echo ""
echo "===== Server Configuration ====="
echo ""

cat config.lua

echo ""
echo "================================"
echo ""

echo ""
echo "===== Start Server ====="
echo ""

ulimit -c unlimited
canary

