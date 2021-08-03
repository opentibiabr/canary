#!/bin/bash

DB_HOST="${SERVER_DB_HOST:-127.0.0.1}"
DB_USER="${SERVER_DB_USER:-canary}"
DB_PASSWORD="${SERVER_DB_PASSWORD:-canary}"
DB_DATABASE="${SERVER_DB_DATABASE:-canary}"

echo ""
echo "===== Print Variables ====="
echo ""

echo "DB_HOST:[$DB_HOST]"
echo "DB_USER:[$DB_USER]"
echo "DB_PASSWORD:[$DB_PASSWORD]"
echo "DB_DATABASE:[$DB_DATABASE]"

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

