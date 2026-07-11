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

DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" \
	bash tools/analytics/migrate_gameplay_analytics.sh
DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" \
	bash tools/analytics/migrate_gameplay_analytics.sh

assert_scalar "current schema version" "SELECT MAX(version) FROM analytics_schema_migrations" "3"
assert_scalar "applied migration count" "SELECT COUNT(*) FROM analytics_schema_migrations" "3"
assert_scalar "migration 002 checksum length" "SELECT CHAR_LENGTH(checksum) FROM analytics_schema_migrations WHERE version = 2" "64"
assert_scalar "migration 003 checksum length" "SELECT CHAR_LENGTH(checksum) FROM analytics_schema_migrations WHERE version = 3" "64"
assert_scalar "server-version index" "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema='${DB_NAME}' AND table_name='analytics_sessions' AND index_name='analytics_sessions_server_version_time'" "2"
assert_scalar "server-version index order" "SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') FROM information_schema.statistics WHERE table_schema='${DB_NAME}' AND table_name='analytics_sessions' AND index_name='analytics_sessions_server_version_time'" "server_version,started_at"
assert_scalar "hunt-area index" "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema='${DB_NAME}' AND table_name='analytics_sessions' AND index_name='analytics_sessions_hunt_area_time'" "2"
assert_scalar "hunt-area index order" "SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') FROM information_schema.statistics WHERE table_schema='${DB_NAME}' AND table_name='analytics_sessions' AND index_name='analytics_sessions_hunt_area_time'" "hunt_area,started_at"
assert_scalar "hunt-context columns" "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='${DB_NAME}' AND table_name='analytics_sessions' AND column_name IN ('hunt_area','party_size_min','party_size_max','party_size_avg','shared_experience_seconds','shared_experience_ratio','party_vocations')" "7"

# Applied migrations are immutable. Mutating version 003 must be rejected.
temporary_migrations="$(mktemp -d)"
trap 'rm -rf "${temporary_migrations}"' EXIT
cp schema/gameplay_analytics_migrations/*.sql "${temporary_migrations}/"
echo "-- checksum mutation" >> "${temporary_migrations}/003_hunt_context.sql"

if DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" MIGRATIONS_DIR="${temporary_migrations}" \
	bash tools/analytics/migrate_gameplay_analytics.sh > migration-checksum-mismatch.log 2>&1; then
	echo "Migration runner accepted a modified applied migration" >&2
	exit 1
fi

if ! grep -q "checksum mismatch" migration-checksum-mismatch.log; then
	echo "Migration checksum failure was not diagnosed" >&2
	cat migration-checksum-mismatch.log >&2
	exit 1
fi

echo "Gameplay Analytics schema migration test passed"
