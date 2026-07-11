#!/usr/bin/env bash
set -euo pipefail

# Confirms that the exact verified NPC prices used by the supply/loot
# game-script integration (data/scripts/lib/gameplay_analytics_prices.lua)
# persist correctly end-to-end. This does not duplicate
# test_mariadb_integration.sh's generic upsert/cascade coverage for
# analytics_session_supplies/analytics_session_loot; it ties this feature's
# specific real numbers through the same schema and proves retrying the
# same values never double-counts them.
#
# Run this after test_mariadb_integration.sh has applied the schema.

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-root}"
DB_NAME="${DB_NAME:-canary_test}"

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

query_scalar() {
	"${MARIADB[@]}" "${DB_NAME}" -e "$1"
}

assert_scalar() {
	local description="$1"
	local sql="$2"
	local expected="$3"
	local actual
	actual="$(query_scalar "${sql}")"
	if [[ "${actual}" != "${expected}" ]]; then
		echo "${description}: expected '${expected}', got '${actual}'" >&2
		exit 1
	fi
}

SESSION_UUID="00000000-0000-0000-0000-000000000010"

upsert_supply_and_loot() {
	"${MARIADB[@]}" "${DB_NAME}" <<SQL
INSERT INTO \`analytics_sessions\`
    (\`session_uuid\`,\`player_id\`,\`player_name\`,\`vocation_id\`,\`level_start\`,\`level_end\`,\`started_at\`,\`ended_at\`,\`duration_seconds\`)
VALUES ('${SESSION_UUID}',1,'Supply Loot Test',1,100,100,1000,1060,60)
ON DUPLICATE KEY UPDATE \`player_name\`=VALUES(\`player_name\`);
SET @session_id = (SELECT id FROM \`analytics_sessions\` WHERE \`session_uuid\` = '${SESSION_UUID}');

-- Health potion (data-otservbr-global/npc/chuckles.lua "buy = 50"): 3 consumed.
INSERT INTO \`analytics_session_supplies\`
    (\`session_id\`,\`item_id\`,\`amount_used\`,\`unit_value\`,\`total_value\`)
VALUES (@session_id,266,3,50,150)
ON DUPLICATE KEY UPDATE \`amount_used\`=VALUES(\`amount_used\`),\`unit_value\`=VALUES(\`unit_value\`),\`total_value\`=VALUES(\`total_value\`);

-- Leather armor (data-otservbr-global/npc/azil.lua "sell = 12"): 2 looted, no verified market source.
INSERT INTO \`analytics_session_loot\`
    (\`session_id\`,\`item_id\`,\`amount\`,\`npc_value\`,\`market_value\`)
VALUES (@session_id,3361,2,24,0)
ON DUPLICATE KEY UPDATE \`amount\`=VALUES(\`amount\`),\`npc_value\`=VALUES(\`npc_value\`),\`market_value\`=VALUES(\`market_value\`);
SQL
}

upsert_supply_and_loot

assert_scalar "verified supply price persists" \
	"SELECT CONCAT(amount_used,'|',unit_value,'|',total_value) FROM analytics_session_supplies WHERE item_id=266 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"3|50|150"
assert_scalar "verified loot price persists with zero market value" \
	"SELECT CONCAT(amount,'|',npc_value,'|',market_value) FROM analytics_session_loot WHERE item_id=3361 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"2|24|0"

# Re-run the identical upsert to prove a retry never double-counts.
upsert_supply_and_loot

assert_scalar "idempotent supply retry" \
	"SELECT COUNT(*) FROM analytics_session_supplies WHERE item_id=266 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"1"
assert_scalar "idempotent supply value after retry" \
	"SELECT total_value FROM analytics_session_supplies WHERE item_id=266 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"150"
assert_scalar "idempotent loot retry" \
	"SELECT COUNT(*) FROM analytics_session_loot WHERE item_id=3361 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"1"
assert_scalar "idempotent loot value after retry" \
	"SELECT npc_value FROM analytics_session_loot WHERE item_id=3361 AND session_id=(SELECT id FROM analytics_sessions WHERE session_uuid='${SESSION_UUID}')" \
	"24"

echo "Gameplay Analytics supply/loot verified-price persistence test passed"
