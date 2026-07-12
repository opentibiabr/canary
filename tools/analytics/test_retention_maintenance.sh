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
TRUNCATE TABLE analytics_daily_party_balance;
TRUNCATE TABLE analytics_maintenance_state;
SET FOREIGN_KEY_CHECKS = 1" >/dev/null

query_scalar "
SET @day_start = UNIX_TIMESTAMP(DATE_SUB(UTC_DATE(), INTERVAL 3 DAY));
SET @old_day_start = UNIX_TIMESTAMP(DATE_SUB(UTC_DATE(), INTERVAL 20 DAY));
INSERT INTO analytics_sessions
    (session_uuid,player_id,player_name,vocation_id,level_start,level_end,started_at,ended_at,duration_seconds,combat_seconds,experience_raw,experience_final,damage_dealt,damage_received,healing_self,healing_others,overhealing,mana_spent,monsters_killed,deaths,loot_value_npc,loot_value_market,supplies_value,party_size,party_size_min,party_size_max,party_size_avg,shared_experience,shared_experience_seconds,shared_experience_ratio,party_vocations,server_version,hunt_area,detail_level,analytics_version)
VALUES
    ('00000000-0000-0000-0000-000000000101',1,'Retention Player',1,550,551,@day_start + 3600,@day_start + 3700,100,100,1000,1500,2000,500,300,100,20,250,10,0,10000,12000,2000,1,1,1,1.00,0,0,0.0000,'1:1','retention-build','retention-area',1,1),
    ('00000000-0000-0000-0000-000000000102',1,'Retention Player',1,580,581,@day_start + 7200,@day_start + 7400,200,200,2000,3000,4000,1000,600,200,40,500,20,1,20000,24000,4000,4,3,4,4.00,1,300,1.0000,'1:1,2:2,4:1','retention-build','retention-area',1,1),
    ('00000000-0000-0000-0000-000000000103',1,'Retention Player',2,650,651,@day_start + 10800,@day_start + 10950,150,150,3000,4500,6000,1500,900,300,60,750,30,0,30000,36000,6000,1,1,1,1.00,0,0,0.0000,'2:1','retention-build','other-area',1,1),
    ('00000000-0000-0000-0000-000000000199',1,'Retention Player',3,250,251,@old_day_start + 3600,@old_day_start + 3700,100,100,700,900,800,200,50,0,0,100,2,0,300,0,50,1,1,1,1.00,0,0,0.0000,'3:1','old-build','old-area',1,1);
SET @detail_session = (SELECT id FROM analytics_sessions WHERE session_uuid = '00000000-0000-0000-0000-000000000199');
INSERT INTO analytics_session_monsters (session_id,monster_name,kills,damage_dealt,damage_received,experience_raw)
VALUES (@detail_session,'retention monster',2,800,200,700)" >/dev/null

run_maintenance() {
	DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" \
	AGGREGATION_LAG_DAYS=1 MAX_DAYS_PER_RUN=30 REAGGREGATE_DAYS=7 RAW_RETENTION_DAYS=10 DELETE_BATCH_SIZE=2 DELETE_MAX_BATCHES=10 \
	DELETE_RAW_SESSIONS="$1" bash tools/analytics/maintain_gameplay_analytics.sh
}

run_maintenance false

assert_scalar "daily aggregate groups" "SELECT COUNT(*) FROM analytics_daily_balance" "3"
assert_scalar "party aggregate groups" "SELECT COUNT(*) FROM analytics_daily_party_balance" "4"
assert_scalar "primary aggregate sessions" "SELECT source_sessions FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "2"
assert_scalar "primary aggregate experience" "SELECT experience_raw FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "3000"
assert_scalar "primary aggregate damage" "SELECT damage_dealt FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "6000"
assert_scalar "primary aggregate party weight" "SELECT party_size_weighted FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "900.0000"
assert_scalar "primary aggregate party seconds" "SELECT party_weight_seconds FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "300"
assert_scalar "primary aggregate average party" "SELECT ROUND(party_size_weighted / NULLIF(party_weight_seconds, 0), 4) FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "3.0000"
assert_scalar "shared seconds are clamped per session" "SELECT shared_experience_seconds FROM analytics_daily_balance WHERE server_version='retention-build' AND hunt_area='retention-area' AND vocation_id=1 AND level_bracket=500" "200"
assert_scalar "solo aggregate sessions" "SELECT source_sessions FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='solo'" "1"
assert_scalar "party aggregate sessions" "SELECT source_sessions FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='party'" "1"
assert_scalar "solo aggregate experience" "SELECT experience_raw FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='solo'" "1000"
assert_scalar "party aggregate experience" "SELECT experience_raw FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='party'" "2000"
assert_scalar "party shared seconds are clamped" "SELECT shared_experience_seconds FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='party'" "200"
assert_scalar "aggregate checkpoint exists" "SELECT COUNT(*) FROM analytics_maintenance_state WHERE state_key='daily_aggregate_through'" "1"
assert_scalar "raw sessions preserved by default" "SELECT COUNT(*) FROM analytics_sessions" "4"

# A session arriving after the sequential checkpoint advanced must still be
# picked up by the rolling rebuild.
query_scalar "
SET @day_start = UNIX_TIMESTAMP(DATE_SUB(UTC_DATE(), INTERVAL 3 DAY));
INSERT INTO analytics_sessions
    (session_uuid,player_id,player_name,vocation_id,level_start,level_end,started_at,ended_at,duration_seconds,combat_seconds,experience_raw,experience_final,damage_dealt,damage_received,healing_self,healing_others,overhealing,mana_spent,monsters_killed,deaths,loot_value_npc,loot_value_market,supplies_value,party_size,party_size_min,party_size_max,party_size_avg,shared_experience,shared_experience_seconds,shared_experience_ratio,party_vocations,server_version,hunt_area,detail_level,analytics_version)
VALUES
    ('00000000-0000-0000-0000-000000000104',1,'Late Retention Player',1,590,591,@day_start + 14400,@day_start + 14450,50,50,500,600,700,100,50,0,0,80,1,0,500,0,100,1,1,1,1.00,0,0,0.0000,'1:1','retention-build','retention-area',1,1)" >/dev/null
run_maintenance false
assert_scalar "late session rebuilt into daily aggregate" "SELECT source_sessions FROM analytics_daily_balance WHERE hunt_area='retention-area' AND vocation_id=1" "3"
assert_scalar "late solo session rebuilt into party aggregate" "SELECT source_sessions FROM analytics_daily_party_balance WHERE hunt_area='retention-area' AND vocation_id=1 AND party_mode='solo'" "2"

# Correcting a raw dimension must remove the stale group, not merely upsert a
# second group and leave the first one behind.
query_scalar "UPDATE analytics_sessions SET hunt_area='moved-area' WHERE session_uuid='00000000-0000-0000-0000-000000000103'" >/dev/null
run_maintenance false
assert_scalar "stale aggregate group removed" "SELECT COUNT(*) FROM analytics_daily_balance WHERE hunt_area='other-area'" "0"
assert_scalar "corrected aggregate group created" "SELECT COUNT(*) FROM analytics_daily_balance WHERE hunt_area='moved-area'" "1"
assert_scalar "stale party group removed" "SELECT COUNT(*) FROM analytics_daily_party_balance WHERE hunt_area='other-area'" "0"
assert_scalar "corrected party group created" "SELECT COUNT(*) FROM analytics_daily_party_balance WHERE hunt_area='moved-area'" "1"

run_maintenance true
assert_scalar "only expired raw session deleted" "SELECT COUNT(*) FROM analytics_sessions" "4"
assert_scalar "old detail rows deleted by cascade" "SELECT COUNT(*) FROM analytics_session_monsters" "0"
assert_scalar "daily aggregates retained" "SELECT COUNT(*) FROM analytics_daily_balance" "3"
assert_scalar "party aggregates retained" "SELECT COUNT(*) FROM analytics_daily_party_balance" "4"
assert_scalar "retention state recorded" "SELECT COUNT(*) FROM analytics_maintenance_state WHERE state_key='raw_deleted_through' AND value_bigint=1" "1"

echo "Gameplay Analytics retention maintenance test passed"
