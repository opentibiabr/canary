#!/bin/bash

DB_HOST="${SERVER_DB_HOST:-127.0.0.1}"
DB_USER="${SERVER_DB_USER:-canary}"
DB_PASSWORD="${SERVER_DB_PASSWORD:-canary}"
DB_DATABASE="${SERVER_DB_DATABASE:-canary}"

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

