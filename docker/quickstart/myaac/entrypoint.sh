#!/usr/bin/env bash
set -euo pipefail

: "${CANARY_DB_HOST:=db}"
: "${CANARY_DB_PORT:=3306}"
: "${CANARY_DB_NAME:=canary}"
: "${CANARY_DB_USER:=canary}"
: "${CANARY_DB_PASSWORD:=canary}"
: "${CANARY_SERVER_NAME:=OpenTibiaBR Canary}"
: "${CANARY_SERVER_IP:=127.0.0.1}"
: "${CANARY_SERVER_LOCATION:=BRA}"
: "${CANARY_LOGIN_PORT:=7171}"
: "${CANARY_GAME_PORT:=7172}"
: "${CANARY_STATUS_PORT:=7173}"
: "${CANARY_STATUS_TIMEOUT:=5000}"
: "${CANARY_DATA_PACK:=data-otservbr-global}"

escape_lua() {
	printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

require_uint() {
	local name="$1"
	local value="$2"
	if [[ ! "$value" =~ ^[0-9]+$ ]]; then
		echo "Invalid ${name}: '${value}'. Use only unsigned integer values." >&2
		exit 1
	fi
}

require_uint "CANARY_DB_PORT" "$CANARY_DB_PORT"
require_uint "CANARY_LOGIN_PORT" "$CANARY_LOGIN_PORT"
require_uint "CANARY_GAME_PORT" "$CANARY_GAME_PORT"
require_uint "CANARY_STATUS_PORT" "$CANARY_STATUS_PORT"
require_uint "CANARY_STATUS_TIMEOUT" "$CANARY_STATUS_TIMEOUT"

mkdir -p /canary/data/XML
cat > /canary/config.lua <<EOF
serverName = "$(escape_lua "$CANARY_SERVER_NAME")"
ip = "$(escape_lua "$CANARY_SERVER_IP")"
loginProtocolPort = ${CANARY_LOGIN_PORT}
gameProtocolPort = ${CANARY_GAME_PORT}
statusProtocolPort = ${CANARY_STATUS_PORT}
statusTimeout = ${CANARY_STATUS_TIMEOUT}
worldType = "pvp"
dataPackDirectory = "$(escape_lua "$CANARY_DATA_PACK")"
mysqlHost = "$(escape_lua "$CANARY_DB_HOST")"
mysqlPort = ${CANARY_DB_PORT}
mysqlUser = "$(escape_lua "$CANARY_DB_USER")"
mysqlPass = "$(escape_lua "$CANARY_DB_PASSWORD")"
mysqlDatabase = "$(escape_lua "$CANARY_DB_NAME")"
passwordType = "sha1"
EOF

cat > /canary/data/XML/vocations.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<vocations>
	<vocation id="0" name="None" fromvoc="0" />
	<vocation id="1" name="Sorcerer" fromvoc="1" />
	<vocation id="2" name="Druid" fromvoc="2" />
	<vocation id="3" name="Paladin" fromvoc="3" />
	<vocation id="4" name="Knight" fromvoc="4" />
	<vocation id="5" name="Master Sorcerer" fromvoc="1" />
	<vocation id="6" name="Elder Druid" fromvoc="2" />
	<vocation id="7" name="Royal Paladin" fromvoc="3" />
	<vocation id="8" name="Elite Knight" fromvoc="4" />
</vocations>
EOF

cat > /canary/data/XML/groups.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<groups>
	<group id="1" name="player" access="0" maxdepotitems="0" maxvipentries="0" />
	<group id="6" name="god" access="1" maxdepotitems="0" maxvipentries="200" />
</groups>
EOF

php /usr/local/bin/myaac-bootstrap.php
chown -R www-data:www-data /var/www/html/config.local.php /var/www/html/system/cache /var/www/html/system/logs /var/www/html/system/php_sessions

exec "$@"
