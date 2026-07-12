#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-canary}"
AGGREGATION_LAG_DAYS="${AGGREGATION_LAG_DAYS:-1}"
MAX_DAYS_PER_RUN="${MAX_DAYS_PER_RUN:-31}"
REAGGREGATE_DAYS="${REAGGREGATE_DAYS:-7}"
RAW_RETENTION_DAYS="${RAW_RETENTION_DAYS:-180}"
DELETE_RAW_SESSIONS="${DELETE_RAW_SESSIONS:-false}"
DELETE_BATCH_SIZE="${DELETE_BATCH_SIZE:-5000}"
DELETE_MAX_BATCHES="${DELETE_MAX_BATCHES:-20}"
REQUIRED_SCHEMA_VERSION=3

for numeric_name in DB_PORT AGGREGATION_LAG_DAYS MAX_DAYS_PER_RUN REAGGREGATE_DAYS RAW_RETENTION_DAYS DELETE_BATCH_SIZE DELETE_MAX_BATCHES; do
	value="${!numeric_name}"
	if [[ ! "${value}" =~ ^[0-9]+$ ]]; then
		echo "${numeric_name} must be a non-negative integer" >&2
		exit 1
	fi
done

if [[ "${MAX_DAYS_PER_RUN}" -lt 1 || "${REAGGREGATE_DAYS}" -lt 1 || "${DELETE_BATCH_SIZE}" -lt 1 || "${DELETE_MAX_BATCHES}" -lt 1 ]]; then
	echo "MAX_DAYS_PER_RUN, REAGGREGATE_DAYS, DELETE_BATCH_SIZE and DELETE_MAX_BATCHES must be positive" >&2
	exit 1
fi

if [[ "${DELETE_RAW_SESSIONS}" != "true" && "${DELETE_RAW_SESSIONS}" != "false" ]]; then
	echo "DELETE_RAW_SESSIONS must be true or false" >&2
	exit 1
fi

# The rolling rebuild must never reach dates whose raw sessions may already
# have been deleted, otherwise a rebuild could erase the only retained
# aggregate for that day.
if [[ "${DELETE_RAW_SESSIONS}" == "true" && "${RAW_RETENTION_DAYS}" -le $((REAGGREGATE_DAYS + AGGREGATION_LAG_DAYS)) ]]; then
	echo "RAW_RETENTION_DAYS must be greater than REAGGREGATE_DAYS + AGGREGATION_LAG_DAYS when raw deletion is enabled" >&2
	exit 1
fi

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

query_scalar() {
	"${MARIADB[@]}" "${DB_NAME}" -e "SET time_zone = '+00:00'; $1"
}

schema_version="$(query_scalar "SELECT COALESCE(MAX(version), 0) FROM analytics_schema_migrations")"
if [[ "${schema_version}" -lt "${REQUIRED_SCHEMA_VERSION}" ]]; then
	echo "Gameplay Analytics schema version ${schema_version} is older than required version ${REQUIRED_SCHEMA_VERSION}" >&2
	exit 1
fi

retention_tables="$(query_scalar "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_NAME}' AND table_name IN ('analytics_daily_balance','analytics_daily_party_balance','analytics_maintenance_state')")"
if [[ "${retention_tables}" != "3" ]]; then
	echo "Gameplay Analytics retention schema is missing; apply schema/gameplay_analytics_retention.sql" >&2
	exit 1
fi

aggregate_date() {
	local current_date="$1"
	local next_date="$2"
	echo "Aggregating Gameplay Analytics date ${current_date}"

	# Delete and rebuild the complete day in one transaction. This is stronger
	# than an upsert-only pass: late rows, corrected dimensions and removed raw
	# rows cannot leave stale aggregate groups behind.
	query_scalar "
START TRANSACTION;
DELETE FROM analytics_daily_balance WHERE session_date = '${current_date}';
INSERT INTO analytics_daily_balance
    (session_date,server_version,hunt_area,vocation_id,level_bracket,source_sessions,combat_seconds,experience_raw,experience_final,damage_dealt,damage_received,healing_total,overhealing,mana_spent,monsters_killed,deaths,loot_value_npc,loot_value_market,supplies_value,party_size_weighted,party_weight_seconds,shared_experience_seconds)
SELECT
    '${current_date}',
    COALESCE(server_version, ''),
    COALESCE(hunt_area, ''),
    vocation_id,
    FLOOR(level_start / 100) * 100,
    COUNT(*),
    COALESCE(SUM(combat_seconds), 0),
    COALESCE(SUM(experience_raw), 0),
    COALESCE(SUM(experience_final), 0),
    COALESCE(SUM(damage_dealt), 0),
    COALESCE(SUM(damage_received), 0),
    COALESCE(SUM(healing_self + healing_others), 0),
    COALESCE(SUM(overhealing), 0),
    COALESCE(SUM(mana_spent), 0),
    COALESCE(SUM(monsters_killed), 0),
    COALESCE(SUM(deaths), 0),
    COALESCE(SUM(loot_value_npc), 0),
    COALESCE(SUM(loot_value_market), 0),
    COALESCE(SUM(supplies_value), 0),
    COALESCE(SUM(COALESCE(party_size_avg, party_size, 1) * combat_seconds), 0),
    COALESCE(SUM(combat_seconds), 0),
    COALESCE(SUM(LEAST(COALESCE(shared_experience_seconds, 0), combat_seconds)), 0)
FROM analytics_sessions
WHERE started_at >= UNIX_TIMESTAMP('${current_date} 00:00:00')
  AND started_at < UNIX_TIMESTAMP('${next_date} 00:00:00')
GROUP BY COALESCE(server_version, ''), COALESCE(hunt_area, ''), vocation_id, FLOOR(level_start / 100) * 100;

DELETE FROM analytics_daily_party_balance WHERE session_date = '${current_date}';
INSERT INTO analytics_daily_party_balance
    (session_date,server_version,hunt_area,vocation_id,level_bracket,party_mode,source_sessions,combat_seconds,experience_raw,experience_final,damage_dealt,damage_received,healing_total,overhealing,mana_spent,monsters_killed,deaths,loot_value_npc,loot_value_market,supplies_value,party_size_weighted,party_weight_seconds,shared_experience_seconds)
SELECT
    '${current_date}',
    COALESCE(server_version, ''),
    COALESCE(hunt_area, ''),
    vocation_id,
    FLOOR(level_start / 100) * 100,
    CASE WHEN COALESCE(party_size_avg, party_size, 1) <= 1 THEN 'solo' ELSE 'party' END,
    COUNT(*),
    COALESCE(SUM(combat_seconds), 0),
    COALESCE(SUM(experience_raw), 0),
    COALESCE(SUM(experience_final), 0),
    COALESCE(SUM(damage_dealt), 0),
    COALESCE(SUM(damage_received), 0),
    COALESCE(SUM(healing_self + healing_others), 0),
    COALESCE(SUM(overhealing), 0),
    COALESCE(SUM(mana_spent), 0),
    COALESCE(SUM(monsters_killed), 0),
    COALESCE(SUM(deaths), 0),
    COALESCE(SUM(loot_value_npc), 0),
    COALESCE(SUM(loot_value_market), 0),
    COALESCE(SUM(supplies_value), 0),
    COALESCE(SUM(COALESCE(party_size_avg, party_size, 1) * combat_seconds), 0),
    COALESCE(SUM(combat_seconds), 0),
    COALESCE(SUM(LEAST(COALESCE(shared_experience_seconds, 0), combat_seconds)), 0)
FROM analytics_sessions
WHERE started_at >= UNIX_TIMESTAMP('${current_date} 00:00:00')
  AND started_at < UNIX_TIMESTAMP('${next_date} 00:00:00')
GROUP BY
    COALESCE(server_version, ''),
    COALESCE(hunt_area, ''),
    vocation_id,
    FLOOR(level_start / 100) * 100,
    CASE WHEN COALESCE(party_size_avg, party_size, 1) <= 1 THEN 'solo' ELSE 'party' END;
COMMIT;" >/dev/null
}

target_date="$(query_scalar "SELECT DATE_FORMAT(DATE_SUB(UTC_DATE(), INTERVAL ${AGGREGATION_LAG_DAYS} DAY), '%Y-%m-%d')")"
last_aggregated="$(query_scalar "SELECT COALESCE(DATE_FORMAT(value_date, '%Y-%m-%d'), '') FROM analytics_maintenance_state WHERE state_key = 'daily_aggregate_through' LIMIT 1")"

if [[ -n "${last_aggregated}" ]]; then
	current_date="$(query_scalar "SELECT DATE_FORMAT(DATE_ADD('${last_aggregated}', INTERVAL 1 DAY), '%Y-%m-%d')")"
else
	current_date="$(query_scalar "SELECT COALESCE(DATE_FORMAT(DATE(FROM_UNIXTIME(MIN(started_at))), '%Y-%m-%d'), '') FROM analytics_sessions")"
fi

processed_days=0
while [[ -n "${current_date}" && "${processed_days}" -lt "${MAX_DAYS_PER_RUN}" ]]; do
	if [[ "${current_date}" > "${target_date}" ]]; then
		break
	fi

	next_date="$(query_scalar "SELECT DATE_FORMAT(DATE_ADD('${current_date}', INTERVAL 1 DAY), '%Y-%m-%d')")"
	aggregate_date "${current_date}" "${next_date}"

	query_scalar "
INSERT INTO analytics_maintenance_state (state_key, value_date, value_bigint)
VALUES ('daily_aggregate_through', '${current_date}', 0)
ON DUPLICATE KEY UPDATE value_date=VALUES(value_date), updated_at=CURRENT_TIMESTAMP" >/dev/null

	current_date="${next_date}"
	processed_days=$((processed_days + 1))
done

# Rebuild a bounded recent window every run. This picks up delayed session
# flushes and corrected raw rows even after the sequential checkpoint has
# advanced past their day.
reaggregate_offset=$((REAGGREGATE_DAYS - 1))
reaggregate_date="$(query_scalar "SELECT DATE_FORMAT(DATE_SUB('${target_date}', INTERVAL ${reaggregate_offset} DAY), '%Y-%m-%d')")"
reprocessed_days=0
while [[ "${reaggregate_date}" < "${target_date}" || "${reaggregate_date}" == "${target_date}" ]]; do
	next_date="$(query_scalar "SELECT DATE_FORMAT(DATE_ADD('${reaggregate_date}', INTERVAL 1 DAY), '%Y-%m-%d')")"
	aggregate_date "${reaggregate_date}" "${next_date}"
	reaggregate_date="${next_date}"
	reprocessed_days=$((reprocessed_days + 1))
	if [[ "${reprocessed_days}" -ge "${REAGGREGATE_DAYS}" ]]; then
		break
	fi
done

aggregate_through="$(query_scalar "SELECT COALESCE(DATE_FORMAT(value_date, '%Y-%m-%d'), '') FROM analytics_maintenance_state WHERE state_key = 'daily_aggregate_through' LIMIT 1")"
echo "Gameplay Analytics aggregation processed ${processed_days} catch-up day(s), rebuilt ${reprocessed_days} recent day(s); checkpoint=${aggregate_through:-none}; target=${target_date}"

if [[ "${DELETE_RAW_SESSIONS}" != "true" ]]; then
	echo "Raw-session deletion disabled; set DELETE_RAW_SESSIONS=true after validating aggregates"
	exit 0
fi

if [[ -z "${aggregate_through}" ]]; then
	echo "Raw-session deletion skipped because no aggregate checkpoint exists" >&2
	exit 1
fi

retention_cutoff="$(query_scalar "SELECT DATE_FORMAT(DATE_SUB(UTC_DATE(), INTERVAL ${RAW_RETENTION_DAYS} DAY), '%Y-%m-%d')")"
deleted_total=0
for _ in $(seq 1 "${DELETE_MAX_BATCHES}"); do
	deleted="$(query_scalar "
DELETE sessions
FROM analytics_sessions AS sessions
JOIN (
    SELECT id
    FROM (
        SELECT id
        FROM analytics_sessions
        WHERE started_at < UNIX_TIMESTAMP('${retention_cutoff} 00:00:00')
          AND started_at < UNIX_TIMESTAMP(DATE_ADD('${aggregate_through}', INTERVAL 1 DAY))
        ORDER BY started_at, id
        LIMIT ${DELETE_BATCH_SIZE}
    ) AS selected_ids
) AS doomed ON doomed.id = sessions.id;
SELECT ROW_COUNT()")"

	deleted="${deleted##*$'\n'}"
	deleted_total=$((deleted_total + deleted))
	if [[ "${deleted}" -lt "${DELETE_BATCH_SIZE}" ]]; then
		break
	fi
done

query_scalar "
INSERT INTO analytics_maintenance_state (state_key, value_date, value_bigint)
VALUES ('raw_deleted_through', DATE_SUB('${retention_cutoff}', INTERVAL 1 DAY), ${deleted_total})
ON DUPLICATE KEY UPDATE value_date=VALUES(value_date), value_bigint=value_bigint + VALUES(value_bigint), updated_at=CURRENT_TIMESTAMP" >/dev/null

echo "Gameplay Analytics retention deleted ${deleted_total} raw session(s) older than ${retention_cutoff} and already covered through ${aggregate_through}"
