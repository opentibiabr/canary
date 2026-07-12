#!/usr/bin/env bash
set -euo pipefail

# Verifies schema/gameplay_analytics_views.sql against a real MariaDB
# instance: the views apply cleanly, compute correct ratios from sample data,
# keep solo and party in separate aggregates, cap shared experience at 100%,
# handle zero denominators, return zero rows against empty datasets, and use
# indexes for representative bounded dashboard queries.

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

assert_uses_index() {
	local description="$1"
	local sql="$2"
	local plan
	plan="$("${MARIADB[@]}" "${DB_NAME}" -e "EXPLAIN ${sql}")"
	if echo "${plan}" | grep -qi '\bALL\b'; then
		echo "${description}: query plan used a full table scan:" >&2
		echo "${plan}" >&2
		exit 1
	fi
}

echo "Applying reporting views"
"${MARIADB[@]}" "${DB_NAME}" <schema/gameplay_analytics_views.sql
"${MARIADB[@]}" "${DB_NAME}" <schema/gameplay_analytics_views.sql

query_scalar "DELETE FROM analytics_daily_party_balance" >/dev/null
query_scalar "DELETE FROM analytics_daily_balance" >/dev/null
query_scalar "DELETE FROM analytics_sessions" >/dev/null
query_scalar "DELETE FROM analytics_dead_letters" >/dev/null

echo "Checking empty-dataset behaviour"
assert_scalar "empty daily metrics view" "SELECT COUNT(*) FROM analytics_daily_vocation_metrics" "0"
assert_scalar "empty party mode view" "SELECT COUNT(*) FROM analytics_daily_party_mode_metrics" "0"
assert_scalar "empty drilldown view" "SELECT COUNT(*) FROM analytics_session_drilldown" "0"
assert_scalar "empty spell efficiency view" "SELECT COUNT(*) FROM analytics_spell_efficiency_drilldown" "0"
assert_scalar "empty dead-letter health view" "SELECT CONCAT(pending_dead_letters,'|',max_retry_count) FROM analytics_dead_letter_health" "0|0"

echo "Inserting sample rows"
"${MARIADB[@]}" "${DB_NAME}" <<'SQL'
INSERT INTO `analytics_daily_balance`
    (`session_date`,`server_version`,`hunt_area`,`vocation_id`,`level_bracket`,`source_sessions`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size_weighted`,`party_weight_seconds`,`shared_experience_seconds`)
VALUES
    ('2026-07-10','build-1','rotten-blood-east',1,100,25,90000,9000000,9500000,8100000,900000,450000,10000,300000,5000,10,120000,0,45000,180000,90000,100000),
    ('2026-07-10','build-1','zero-combat-area',2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO `analytics_daily_party_balance`
    (`session_date`,`server_version`,`hunt_area`,`vocation_id`,`level_bracket`,`party_mode`,`source_sessions`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size_weighted`,`party_weight_seconds`,`shared_experience_seconds`)
VALUES
    ('2026-07-10','build-1','rotten-blood-east',1,100,'solo',12,36000,3600000,3700000,3000000,300000,100000,0,100000,2000,2,50000,0,15000,36000,36000,0),
    ('2026-07-10','build-1','rotten-blood-east',1,100,'party',13,36000,5400000,5800000,5100000,400000,250000,10000,200000,3000,8,70000,0,30000,144000,36000,36000),
    ('2026-07-10','build-1','zero-combat-area',2,0,'solo',1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO `analytics_sessions`
    (`session_uuid`,`player_id`,`player_name`,`vocation_id`,`level_start`,`level_end`,`started_at`,`ended_at`,`duration_seconds`,`combat_seconds`,`experience_raw`,`damage_dealt`,`damage_received`,`healing_self`,`healing_others`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size`,`hunt_area`,`server_version`)
VALUES
    ('00000000-0000-0000-0000-0000000000a1',1,'Dashboard Test',1,100,105,1000,1900,900,900,50000,45000,5000,2000,0,0,600,0,250,1,'rotten-blood-east','build-1');

SET @session_id = (SELECT id FROM `analytics_sessions` WHERE `session_uuid` = '00000000-0000-0000-0000-0000000000a1');
INSERT INTO `analytics_session_spells` (`session_id`,`spell_name`,`casts`,`targets_hit`,`damage`,`healing`,`mana_spent`,`critical_hits`)
VALUES (@session_id,'ethereal spear',10,10,4500,0,250,0);

INSERT INTO `analytics_dead_letters`
    (`session_uuid`,`player_id`,`player_name`,`retry_count`,`last_error`,`failed_at`,`started_at`,`ended_at`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`)
VALUES
    ('00000000-0000-0000-0000-0000000000b1',1,'Dashboard Test',3,'db timeout',1500,1000,1060,100,150,200,50,25,20,2,0,0,0,0);
SQL

echo "Checking computed metrics"
assert_scalar "daily exp/h and dps" "SELECT CONCAT(exp_per_hour,'|',dps,'|',deaths_per_100_sessions) FROM analytics_daily_vocation_metrics WHERE hunt_area='rotten-blood-east'" "360000|90|40.00"
assert_scalar "daily profit and supply cost per hour" "SELECT CONCAT(npc_profit_per_hour,'|',supply_cost_per_hour) FROM analytics_daily_vocation_metrics WHERE hunt_area='rotten-blood-east'" "3000|1800"
assert_scalar "daily average party size" "SELECT avg_party_size FROM analytics_daily_vocation_metrics WHERE hunt_area='rotten-blood-east'" "2.00"
assert_scalar "shared experience is capped" "SELECT shared_experience_percent FROM analytics_daily_vocation_metrics WHERE hunt_area='rotten-blood-east'" "100.00"
assert_scalar "solo and party remain separate" "SELECT GROUP_CONCAT(CONCAT(mode,':',exp_per_hour) ORDER BY mode SEPARATOR '|') FROM analytics_daily_party_mode_metrics WHERE vocation_id=1" "party:540000|solo:360000"
assert_scalar "party view retains dimensions" "SELECT CONCAT(server_version,'|',hunt_area,'|',level_bracket) FROM analytics_daily_party_mode_metrics WHERE vocation_id=1 AND mode='party'" "build-1|rotten-blood-east|100"
assert_scalar "zero combat_seconds does not error" "SELECT CONCAT(COALESCE(exp_per_hour,'NULL'),'|',COALESCE(dps,'NULL'),'|',COALESCE(avg_party_size,'NULL'),'|',COALESCE(shared_experience_percent,'NULL')) FROM analytics_daily_vocation_metrics WHERE hunt_area='zero-combat-area'" "NULL|NULL|NULL|NULL"
assert_scalar "zero party combat_seconds does not error" "SELECT COALESCE(exp_per_hour,'NULL') FROM analytics_daily_party_mode_metrics WHERE hunt_area='zero-combat-area'" "NULL"
assert_scalar "drilldown row" "SELECT CONCAT(vocation_id,'|',hunt_area,'|',damage_dealt) FROM analytics_session_drilldown WHERE id=(SELECT id FROM analytics_sessions WHERE session_uuid='00000000-0000-0000-0000-0000000000a1')" "1|rotten-blood-east|45000"
assert_scalar "spell efficiency row" "SELECT CONCAT(spell_name,'|',casts,'|',damage) FROM analytics_spell_efficiency_drilldown WHERE spell_name='ethereal spear'" "ethereal spear|10|4500"
assert_scalar "dead-letter health" "SELECT CONCAT(pending_dead_letters,'|',max_retry_count) FROM analytics_dead_letter_health" "1|3"

echo "Checking query plans avoid full table scans"
assert_uses_index "session drilldown time filter" "SELECT * FROM analytics_session_drilldown WHERE started_at BETWEEN 0 AND 999999999"
assert_uses_index "daily metrics vocation and date filter" "SELECT * FROM analytics_daily_vocation_metrics WHERE vocation_id = 1 AND session_date >= '2026-01-01'"
assert_uses_index "party metrics vocation and date filter" "SELECT * FROM analytics_daily_party_mode_metrics WHERE vocation_id = 1 AND session_date >= '2026-01-01'"

echo "Gameplay Analytics dashboard views test passed"
