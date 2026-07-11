#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-root}"
DB_NAME="${DB_NAME:-canary_test}"

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

query_scalar() {
	"${MARIADB[@]}" "${DB_NAME}" -e "SET time_zone = '+00:00'; $1"
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

query_scalar "
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE analytics_session_monsters;
TRUNCATE TABLE analytics_session_spells;
TRUNCATE TABLE analytics_session_damage_types;
TRUNCATE TABLE analytics_session_supplies;
TRUNCATE TABLE analytics_session_loot;
TRUNCATE TABLE analytics_sessions;
TRUNCATE TABLE analytics_daily_balance;
TRUNCATE TABLE analytics_maintenance_state;
SET FOREIGN_KEY_CHECKS = 1" >/dev/null

query_scalar "
SET @day_start = UNIX_TIMESTAMP(DATE_SUB(UTC_DATE(), INTERVAL 3 DAY));
INSERT INTO analytics_sessions
    (session_uuid,player_id,player_name,vocation_id,level_start,level_end,started_at,ended_at,duration_seconds,combat_seconds,experience_raw,experience_final,damage_dealt,damage_received,healing_self,healing_others,overhealing,mana_spent,monsters_killed,deaths,loot_value_npc,loot_value_market,supplies_value,party_size,party_size_min,party_size_max,party_size_avg,shared_experience,shared_experience_seconds,shared_experience_ratio,party_vocations,server_version,hunt_area,detail_level,analytics_version)
VALUES
    ('00000000-0000-0000-0000-000000000101',1,'Retention Player',1,550,551,@day_start + 3600,@day_start + 3700,100,100,1000,1500,2000,500,300,100,20,250,10,0,10000,12000,2000,2,2,2,2.00,1,50,0.5000,'1:1,2:1','retention-build','retention-area',1,1),
    ('00000000-0000-0000-0000-000000000102',1,'Retention Player',1,580,581,@day_start + 7200,@day_start + 7400,200,200,2000,3000,4000,1000,600,200,40,500,20,1,20000,24000,4000,4,3,4,4.00,1,100,0.5000,'1:1,2:2,4:1','retention-build','retention-area',1,1),
    ('00000000-0000-0000-0000-000000000103',1,'Retention Player',2,650,651,@day_start + 10800,@day_start + 10950,150,150,3000,4500,6000,1500,900,300,60,750,30,0,30000,36000,6000,1,1,1,1.00,0,0,0.0000,'2:1','retention-build','other-area',1,1);
SET @detail_session = (SELECT id FROM analytics_sessions WHERE session_uuid = '00000000-0000-0000-0000-000000000101');
INSERT INTO analytics_session_monsters (session_id,monster_name,kills,damage_dealt,damage_received,experience_raw)
VALUES (@detail_session,'retention monster',10,2000,500,1000)" >/dev/null

run_maintenance() {
	DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" \
	AGGREGATION_LAG_DAYS=1 MAX_DAYS_PER_RUN=10 RAW_RETENTION_DAYS=2 DELETE_BATCH_SIZE=2 DELETE_MAX_BATCHES=10 \
	DELETE_RAW_SESSIONS="$1" bash tools/analytics/maintain_gameplay_analytics.sh
}

run_maintenance false

assert_scalar "daily aggregate groups" "SELECT COUNT(*) FROM analytics_daily_balance" "2"
assert_scalar "primary aggregate sessions" "SELECT source_sessions FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "2"
assert_scalar "primary aggregate experience" "SELECT experience_raw FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "3000"
assert_scalar "primary aggregate damage" "SELECT damage_dealt FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "6000"
assert_scalar "primary aggregate party weight" "SELECT party_size_weighted FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "1000.0000"
assert_scalar "primary aggregate party seconds" "SELECT party_weight_seconds FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "300"
assert_scalar "primary aggregate average party" "SELECT ROUND(party_size_weighted / NULLIF(party_weight_seconds, 0), 4) FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "3.3333"
assert_scalar "primary aggregate shared seconds" "SELECT shared_experience_seconds FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "150"
assert_scalar "aggregate checkpoint exists" "SELECT COUNT(*) FROM analytics_maintenance_state WHERE state_key='daily_aggregate_through'" "1"
assert_scalar "raw sessions preserved by default" "SELECT COUNT(*) FROM analytics_sessions" "3"

run_maintenance false
assert_scalar "idempotent aggregate groups" "SELECT COUNT(*) FROM analytics_daily_balance" "2"
assert_scalar "idempotent aggregate sessions" "SELECT source_sessions FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "2"

run_maintenance true
assert_scalar "expired raw sessions deleted" "SELECT COUNT(*) FROM analytics_sessions" "0"
assert_scalar "detail rows deleted by cascade" "SELECT COUNT(*) FROM analytics_session_monsters" "0"
assert_scalar "daily aggregates retained" "SELECT COUNT(*) FROM analytics_daily_balance" "2"
assert_scalar "retention state recorded" "SELECT COUNT(*) FROM analytics_maintenance_state WHERE state_key='raw_deleted_through' AND value_bigint=3" "1"

echo "Gameplay Analytics retention maintenance test passed"
