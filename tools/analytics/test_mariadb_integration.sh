#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-root}"
DB_NAME="${DB_NAME:-canary_test}"

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

for attempt in $(seq 1 30); do
	if "${MARIADB[@]}" -e "SELECT 1" >/dev/null 2>&1; then
		break
	fi
	if [[ "${attempt}" -eq 30 ]]; then
		echo "MariaDB did not become ready" >&2
		exit 1
	fi
	sleep 2
done

"${MARIADB[@]}" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"

"${MARIADB[@]}" "${DB_NAME}" <<'SQL'
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `analytics_session_loot`;
DROP TABLE IF EXISTS `analytics_session_supplies`;
DROP TABLE IF EXISTS `analytics_session_damage_types`;
DROP TABLE IF EXISTS `analytics_session_spells`;
DROP TABLE IF EXISTS `analytics_session_monsters`;
DROP TABLE IF EXISTS `analytics_dead_letters`;
DROP TABLE IF EXISTS `analytics_schema_migrations`;
DROP TABLE IF EXISTS `analytics_sessions`;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE IF NOT EXISTS `players` (
    `id` INT NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `players` (`id`) VALUES (1) ON DUPLICATE KEY UPDATE `id` = VALUES(`id`);
SQL

# The schema is intentionally imported twice to prove that deployment is repeatable.
"${MARIADB[@]}" "${DB_NAME}" < schema/gameplay_analytics.sql
"${MARIADB[@]}" "${DB_NAME}" < schema/gameplay_analytics.sql

"${MARIADB[@]}" "${DB_NAME}" <<'SQL'
INSERT INTO `analytics_sessions`
    (`session_uuid`,`player_id`,`player_name`,`vocation_id`,`level_start`,`level_end`,`started_at`,`ended_at`,`duration_seconds`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_self`,`healing_others`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size`,`shared_experience`,`detail_level`,`analytics_version`)
VALUES
    ('00000000-0000-0000-0000-000000000001',1,'Integration Player',1,100,101,1000,1060,60,50,1000,1500,2000,500,300,100,20,250,10,0,10000,12000,2000,1,0,1,1)
ON DUPLICATE KEY UPDATE
    `player_name`=VALUES(`player_name`),`experience_raw`=VALUES(`experience_raw`),`damage_dealt`=VALUES(`damage_dealt`);

INSERT INTO `analytics_sessions`
    (`session_uuid`,`player_id`,`player_name`,`vocation_id`,`level_start`,`level_end`,`started_at`,`ended_at`,`duration_seconds`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_self`,`healing_others`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size`,`shared_experience`,`detail_level`,`analytics_version`)
VALUES
    ('00000000-0000-0000-0000-000000000001',1,'Integration Player Updated',1,100,101,1000,1060,60,50,2000,1500,3000,500,300,100,20,250,10,0,10000,12000,2000,1,0,1,1)
ON DUPLICATE KEY UPDATE
    `player_name`=VALUES(`player_name`),`experience_raw`=VALUES(`experience_raw`),`damage_dealt`=VALUES(`damage_dealt`);

SET @session_id = (SELECT `id` FROM `analytics_sessions` WHERE `session_uuid` = '00000000-0000-0000-0000-000000000001');

INSERT INTO `analytics_session_monsters`
    (`session_id`,`monster_name`,`kills`,`damage_dealt`,`damage_received`,`experience_raw`)
VALUES (@session_id,'integration monster',2,100,20,50)
ON DUPLICATE KEY UPDATE `kills`=VALUES(`kills`),`damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`),`experience_raw`=VALUES(`experience_raw`);
INSERT INTO `analytics_session_monsters`
    (`session_id`,`monster_name`,`kills`,`damage_dealt`,`damage_received`,`experience_raw`)
VALUES (@session_id,'integration monster',3,200,30,75)
ON DUPLICATE KEY UPDATE `kills`=VALUES(`kills`),`damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`),`experience_raw`=VALUES(`experience_raw`);

INSERT INTO `analytics_session_spells`
    (`session_id`,`spell_name`,`casts`,`targets_hit`,`damage`,`healing`,`mana_spent`,`critical_hits`)
VALUES (@session_id,'integration spell',4,5,600,0,100,1)
ON DUPLICATE KEY UPDATE `casts`=VALUES(`casts`),`targets_hit`=VALUES(`targets_hit`),`damage`=VALUES(`damage`),`healing`=VALUES(`healing`),`mana_spent`=VALUES(`mana_spent`),`critical_hits`=VALUES(`critical_hits`);
INSERT INTO `analytics_session_spells`
    (`session_id`,`spell_name`,`casts`,`targets_hit`,`damage`,`healing`,`mana_spent`,`critical_hits`)
VALUES (@session_id,'integration spell',6,7,800,10,150,2)
ON DUPLICATE KEY UPDATE `casts`=VALUES(`casts`),`targets_hit`=VALUES(`targets_hit`),`damage`=VALUES(`damage`),`healing`=VALUES(`healing`),`mana_spent`=VALUES(`mana_spent`),`critical_hits`=VALUES(`critical_hits`);

INSERT INTO `analytics_session_damage_types`
    (`session_id`,`damage_type`,`damage_dealt`,`damage_received`)
VALUES (@session_id,1,900,100)
ON DUPLICATE KEY UPDATE `damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`);
INSERT INTO `analytics_session_damage_types`
    (`session_id`,`damage_type`,`damage_dealt`,`damage_received`)
VALUES (@session_id,1,1200,150)
ON DUPLICATE KEY UPDATE `damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`);

INSERT INTO `analytics_session_supplies`
    (`session_id`,`item_id`,`amount_used`,`unit_value`,`total_value`)
VALUES (@session_id,268,10,50,500)
ON DUPLICATE KEY UPDATE `amount_used`=VALUES(`amount_used`),`unit_value`=VALUES(`unit_value`),`total_value`=VALUES(`total_value`);
INSERT INTO `analytics_session_supplies`
    (`session_id`,`item_id`,`amount_used`,`unit_value`,`total_value`)
VALUES (@session_id,268,12,50,600)
ON DUPLICATE KEY UPDATE `amount_used`=VALUES(`amount_used`),`unit_value`=VALUES(`unit_value`),`total_value`=VALUES(`total_value`);

INSERT INTO `analytics_session_loot`
    (`session_id`,`item_id`,`amount`,`npc_value`,`market_value`)
VALUES (@session_id,3031,20,2000,2200)
ON DUPLICATE KEY UPDATE `amount`=VALUES(`amount`),`npc_value`=VALUES(`npc_value`),`market_value`=VALUES(`market_value`);
INSERT INTO `analytics_session_loot`
    (`session_id`,`item_id`,`amount`,`npc_value`,`market_value`)
VALUES (@session_id,3031,25,2500,2750)
ON DUPLICATE KEY UPDATE `amount`=VALUES(`amount`),`npc_value`=VALUES(`npc_value`),`market_value`=VALUES(`market_value`);

INSERT INTO `analytics_dead_letters`
    (`session_uuid`,`player_id`,`player_name`,`retry_count`,`last_error`,`failed_at`,`started_at`,`ended_at`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`)
VALUES
    ('00000000-0000-0000-0000-000000000002',1,'Integration Player',2,'first failure',1100,1000,1060,100,150,200,50,25,20,2,0,0,0,0)
ON DUPLICATE KEY UPDATE `retry_count`=VALUES(`retry_count`),`last_error`=VALUES(`last_error`),`failed_at`=VALUES(`failed_at`);
INSERT INTO `analytics_dead_letters`
    (`session_uuid`,`player_id`,`player_name`,`retry_count`,`last_error`,`failed_at`,`started_at`,`ended_at`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_total`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`)
VALUES
    ('00000000-0000-0000-0000-000000000002',1,'Integration Player',5,'final failure',1200,1000,1060,100,150,200,50,25,20,2,0,0,0,0)
ON DUPLICATE KEY UPDATE `retry_count`=VALUES(`retry_count`),`last_error`=VALUES(`last_error`),`failed_at`=VALUES(`failed_at`);
SQL

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

assert_scalar "analytics table count" "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_NAME}' AND table_name LIKE 'analytics_%'" "8"
assert_scalar "analytics InnoDB table count" "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_NAME}' AND table_name LIKE 'analytics_%' AND engine='InnoDB'" "8"
assert_scalar "analytics baseline schema version" "SELECT MAX(version) FROM analytics_schema_migrations" "1"
assert_scalar "analytics detail foreign keys" "SELECT COUNT(*) FROM information_schema.referential_constraints WHERE constraint_schema='${DB_NAME}' AND table_name IN ('analytics_session_monsters','analytics_session_spells','analytics_session_damage_types','analytics_session_supplies','analytics_session_loot')" "5"
assert_scalar "idempotent session row" "SELECT COUNT(*) FROM analytics_sessions WHERE session_uuid='00000000-0000-0000-0000-000000000001'" "1"
assert_scalar "session upsert values" "SELECT CONCAT(player_name,'|',experience_raw,'|',damage_dealt) FROM analytics_sessions WHERE session_uuid='00000000-0000-0000-0000-000000000001'" "Integration Player Updated|2000|3000"
assert_scalar "monster upsert" "SELECT CONCAT(COUNT(*),'|',MAX(kills),'|',MAX(damage_dealt)) FROM analytics_session_monsters" "1|3|200"
assert_scalar "spell upsert" "SELECT CONCAT(COUNT(*),'|',MAX(casts),'|',MAX(damage)) FROM analytics_session_spells" "1|6|800"
assert_scalar "damage type upsert" "SELECT CONCAT(COUNT(*),'|',MAX(damage_dealt),'|',MAX(damage_received)) FROM analytics_session_damage_types" "1|1200|150"
assert_scalar "supply upsert" "SELECT CONCAT(COUNT(*),'|',MAX(amount_used),'|',MAX(total_value)) FROM analytics_session_supplies" "1|12|600"
assert_scalar "loot upsert" "SELECT CONCAT(COUNT(*),'|',MAX(amount),'|',MAX(market_value)) FROM analytics_session_loot" "1|25|2750"
assert_scalar "dead-letter upsert" "SELECT CONCAT(COUNT(*),'|',MAX(retry_count),'|',MAX(last_error)) FROM analytics_dead_letters" "1|5|final failure"

# Verify ON DELETE CASCADE for every detail table.
query_scalar "DELETE FROM analytics_sessions WHERE session_uuid='00000000-0000-0000-0000-000000000001'" >/dev/null
assert_scalar "monster cascade" "SELECT COUNT(*) FROM analytics_session_monsters" "0"
assert_scalar "spell cascade" "SELECT COUNT(*) FROM analytics_session_spells" "0"
assert_scalar "damage type cascade" "SELECT COUNT(*) FROM analytics_session_damage_types" "0"
assert_scalar "supply cascade" "SELECT COUNT(*) FROM analytics_session_supplies" "0"
assert_scalar "loot cascade" "SELECT COUNT(*) FROM analytics_session_loot" "0"

echo "Gameplay Analytics MariaDB integration test passed"
