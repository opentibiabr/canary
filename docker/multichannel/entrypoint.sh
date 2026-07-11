#!/bin/bash
# Multi-channel dev entrypoint (see docker/multichannel/README.md).
#
# Generates this process's config.lua from config.lua.dist plus per-channel
# environment variables, then hands off to the normal start.sh. Kept
# separate from docker/config.sh (the quickstart's own templating script)
# so this example doesn't need to touch that shared contract.
set -euo pipefail

CONFIG_PATH=/srv/canary/config.lua

if [ ! -f "$CONFIG_PATH" ]; then
	cp /srv/canary/config.lua.dist "$CONFIG_PATH"
fi

set_value() {
	# $1 = Lua identifier, $2 = value already formatted as valid Lua (string
	# literal with quotes, or a bare bool/number)
	local key="$1"
	local value="$2"
	if grep -qE "^${key}[[:space:]]*=" "$CONFIG_PATH"; then
		sed -i "s|^${key}[[:space:]]*=.*|${key} = ${value}|" "$CONFIG_PATH"
	else
		printf '%s = %s\n' "$key" "$value" >> "$CONFIG_PATH"
	fi
}

set_value mysqlHost "\"${CANARY_DB_HOST:-db}\""
set_value mysqlUser "\"${CANARY_DB_USER:-canary}\""
set_value mysqlPass "\"${CANARY_DB_PASSWORD:-canary}\""
set_value mysqlDatabase "\"${CANARY_DB_NAME:-canary}\""

set_value ip "\"${CANARY_EXTERNAL_IP:-127.0.0.1}\""
set_value serverName "\"${CANARY_SERVER_NAME:-Canary Multichannel Dev}\""
set_value worldType "\"${CANARY_WORLD_TYPE:-pvp}\""
set_value loginProtocolPort "${CANARY_LOGIN_PORT:-7171}"
set_value gameProtocolPort "${CANARY_GAME_PORT:-7172}"
set_value statusProtocolPort "${CANARY_STATUS_PORT:-7173}"

set_value multiChannelEnabled "${CANARY_MULTICHANNEL_ENABLED:-true}"
set_value loginProtocolEnabled "${CANARY_LOGIN_GATEWAY:-false}"
set_value redisHost "\"${CANARY_REDIS_HOST:-redis}\""
set_value redisPort "${CANARY_REDIS_PORT:-6379}"

echo "[multichannel entrypoint] CANARY_CHANNEL_ID=${CANARY_CHANNEL_ID:-1} worldType=${CANARY_WORLD_TYPE:-pvp} loginGateway=${CANARY_LOGIN_GATEWAY:-false}"

exec /srv/canary/start.sh /bin/canary
