#!/bin/bash -e

CANARY_DB_HOST="${CANARY_DB_HOST:-db}"
CANARY_DB_PORT="${CANARY_DB_PORT:-3306}"
CANARY_DB_USER="${CANARY_DB_USER:-canary}"
CANARY_DB_PASSWORD="${CANARY_DB_PASSWORD:-canary}"
CANARY_DB_NAME="${CANARY_DB_NAME:-canary}"
CANARY_SERVER_NAME="${CANARY_SERVER_NAME:-OpenTibiaBR Canary}"
CANARY_SERVER_IP="${CANARY_SERVER_IP:-127.0.0.1}"
CANARY_LOGIN_PORT="${CANARY_LOGIN_PORT:-7171}"
CANARY_GAME_PORT="${CANARY_GAME_PORT:-7172}"
CANARY_STATUS_PORT="${CANARY_STATUS_PORT:-7171}"
CANARY_STATUS_TIMEOUT="${CANARY_STATUS_TIMEOUT:-5000}"
CANARY_TEST_ACCOUNTS="${CANARY_TEST_ACCOUNTS:-false}"
CANARY_DATA_PACK="${CANARY_DATA_PACK:-data-otservbr-global}"
CANARY_MAP_URL="${CANARY_MAP_URL:-https://github.com/opentibiabr/canary/releases/download/v3.5.0/otservbr.otbm}"

validate_identifier() {
	local name="$1"
	local value="$2"
	if [[ -z "$value" || "$value" == *[!A-Za-z0-9_]* ]]; then
		echo "Invalid ${name}: '${value}'. Use only letters, numbers, and underscores." >&2
		exit 1
	fi
}

mysql_cmd() {
	MYSQL_PWD="$CANARY_DB_PASSWORD" mysql \
		--protocol=tcp \
		--default-character-set=utf8mb4 \
		-u "$CANARY_DB_USER" \
		-h "$CANARY_DB_HOST" \
		--port="$CANARY_DB_PORT" \
		"$@"
}

mysqldump_cmd() {
	MYSQL_PWD="$CANARY_DB_PASSWORD" mysqldump \
		--protocol=tcp \
		--default-character-set=utf8mb4 \
		-u "$CANARY_DB_USER" \
		-h "$CANARY_DB_HOST" \
		--port="$CANARY_DB_PORT" \
		"$@"
}

validate_identifier "CANARY_DB_NAME" "$CANARY_DB_NAME"

echo ""
echo "===== Canary Docker Configuration ====="
echo ""
echo "CANARY_DB_HOST:[$CANARY_DB_HOST]"
echo "CANARY_DB_PORT:[$CANARY_DB_PORT]"
echo "CANARY_DB_USER:[$CANARY_DB_USER]"
echo "CANARY_DB_PASSWORD:[********]"
echo "CANARY_DB_NAME:[$CANARY_DB_NAME]"
echo "CANARY_SERVER_NAME:[$CANARY_SERVER_NAME]"
echo "CANARY_SERVER_IP:[$CANARY_SERVER_IP]"
echo "CANARY_LOGIN_PORT:[$CANARY_LOGIN_PORT]"
echo "CANARY_GAME_PORT:[$CANARY_GAME_PORT]"
echo "CANARY_STATUS_PORT:[$CANARY_STATUS_PORT]"
echo "CANARY_STATUS_TIMEOUT:[$CANARY_STATUS_TIMEOUT]"
echo "CANARY_TEST_ACCOUNTS:[$CANARY_TEST_ACCOUNTS]"
echo "CANARY_DATA_PACK:[$CANARY_DATA_PACK]"
echo "CANARY_MAP_URL:[$CANARY_MAP_URL]"
echo ""
echo "======================================="
echo ""

echo ""
echo "===== OTBR Global Data Pack ====="
echo ""

if [ "$CANARY_DATA_PACK" = "data-otservbr-global" ] && [ ! -f data-otservbr-global/world/otservbr.otbm ]; then
	echo "Downloading OTBR map..."
	curl -Lkf "$CANARY_MAP_URL" -o data-otservbr-global/world/otservbr.otbm
	echo "Done"
else
	echo "Map download skipped"
fi

echo ""
echo "================================"
echo ""

echo ""
echo "===== Wait For The DB To Be Up ====="
echo ""

until mysql_cmd -e "SELECT 1;" >/dev/null 2>&1; do
	echo "DB offline, trying again"
	sleep 5s
done

echo ""
echo "================================"
echo ""

echo ""
echo "===== Ensure Canary Database ====="
echo ""

if mysql_cmd -e "USE \`$CANARY_DB_NAME\`;" >/dev/null 2>&1; then
	echo "Database '$CANARY_DB_NAME' exists"
else
	echo "Creating database '$CANARY_DB_NAME'"
	mysql_cmd -e "CREATE DATABASE \`$CANARY_DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
fi

echo ""
echo "================================"
echo ""

echo ""
echo "===== Ensure Canary Schema ====="
echo ""

if mysql_cmd -D "$CANARY_DB_NAME" -e 'SHOW TABLES LIKE "server_config";' | grep -q server_config; then
	echo "Existing Canary schema detected"
	echo "Saving database backup to /data/${CANARY_DB_NAME}.sql"
	mysqldump_cmd "$CANARY_DB_NAME" >"/data/${CANARY_DB_NAME}.sql"
else
	echo "Importing Canary schema"
	mysql_cmd -D "$CANARY_DB_NAME" <schema.sql

	echo ""
	echo "===== Test Accounts ====="
	echo ""

	if [ "$CANARY_TEST_ACCOUNTS" = "true" ]; then
		echo "Creating test accounts..."
		mysql_cmd -D "$CANARY_DB_NAME" </canary/01-test_account.sql
		mysql_cmd -D "$CANARY_DB_NAME" </canary/02-test_account_players.sql
	else
		echo "Test account creation skipped"
	fi

	echo ""
	echo "================================"
	echo ""
fi

echo ""
echo "================================"
echo ""

echo ""
echo "===== Resolve Advertised Server IP ====="
echo ""

if [ "$CANARY_SERVER_IP" = "auto" ]; then
	echo "IP discovery enabled"
	CANARY_SERVER_IP=$(curl -Lfs https://ifconfig.me/ip)
	echo "Discovered IP: $CANARY_SERVER_IP"
else
	echo "IP discovery disabled"
fi

echo ""
echo "================================"
echo ""

echo ""
echo "===== Apply Server Configuration ====="
echo ""

sed -i "/mysqlHost = .*$/c\mysqlHost = \"$CANARY_DB_HOST\"" config.lua
sed -i "/mysqlUser = .*$/c\mysqlUser = \"$CANARY_DB_USER\"" config.lua
sed -i "/mysqlPass = .*$/c\mysqlPass = \"$CANARY_DB_PASSWORD\"" config.lua
sed -i "/mysqlPort = .*$/c\mysqlPort = $CANARY_DB_PORT" config.lua
sed -i "/mysqlDatabase = .*$/c\mysqlDatabase = \"$CANARY_DB_NAME\"" config.lua
sed -i "/serverName = .*$/c\serverName = \"$CANARY_SERVER_NAME\"" config.lua
sed -i "/ip = .*$/c\ip = \"$CANARY_SERVER_IP\"" config.lua
sed -i "/loginProtocolPort = .*$/c\loginProtocolPort = $CANARY_LOGIN_PORT" config.lua
sed -i "/gameProtocolPort = .*$/c\gameProtocolPort = $CANARY_GAME_PORT" config.lua
sed -i "/statusProtocolPort = .*$/c\statusProtocolPort = $CANARY_STATUS_PORT" config.lua
sed -i "/statusTimeout = .*$/c\statusTimeout = $CANARY_STATUS_TIMEOUT" config.lua
sed -i "/dataPackDirectory = .*$/c\dataPackDirectory = \"$CANARY_DATA_PACK\"" config.lua

echo "config.lua updated"

echo ""
echo "================================"
echo ""

if [ -d "/data/server/" ]; then
	echo ""
	echo "===== Copy Server Configuration And Data Pack To Shared Folder ====="
	echo ""

	cp config.lua /data/server/
	cp -r data/ /data/server/
	cp -r "$CANARY_DATA_PACK"/ /data/server/

	echo ""
	echo "================================"
	echo ""
fi

echo ""
echo "===== Start Server ====="
echo ""

ulimit -c unlimited
exec canary
