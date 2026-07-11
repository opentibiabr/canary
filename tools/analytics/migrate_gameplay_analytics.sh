#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-canary}"
MIGRATIONS_DIR="${MIGRATIONS_DIR:-schema/gameplay_analytics_migrations}"

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

sql() {
	"${MARIADB[@]}" "${DB_NAME}" -e "$1"
}

sql "
CREATE TABLE IF NOT EXISTS \`analytics_schema_migrations\` (
    \`version\` INT UNSIGNED NOT NULL,
    \`name\` VARCHAR(255) NOT NULL,
    \`checksum\` CHAR(64) NOT NULL DEFAULT '',
    \`applied_at\` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (\`version\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"

# Existing installations predate the migration table. Treat the current schema as baseline v1.
sql "
INSERT INTO \`analytics_schema_migrations\` (\`version\`, \`name\`, \`checksum\`)
SELECT 1, 'baseline', ''
WHERE EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = '${DB_NAME}' AND table_name = 'analytics_sessions'
)
AND NOT EXISTS (SELECT 1 FROM \`analytics_schema_migrations\`)"

if [[ ! -d "${MIGRATIONS_DIR}" ]]; then
	echo "Gameplay Analytics migration directory not found: ${MIGRATIONS_DIR}" >&2
	exit 1
fi

mapfile -t migration_files < <(find "${MIGRATIONS_DIR}" -maxdepth 1 -type f -name '[0-9][0-9][0-9]_*.sql' | sort)

for migration_file in "${migration_files[@]}"; do
	filename="$(basename "${migration_file}")"
	raw_version="${filename%%_*}"
	version="$((10#${raw_version}))"
	checksum="$(sha256sum "${migration_file}" | awk '{print $1}')"
	existing_checksum="$(sql "SELECT \`checksum\` FROM \`analytics_schema_migrations\` WHERE \`version\` = ${version} LIMIT 1")"

	if [[ -n "${existing_checksum}" ]]; then
		if [[ "${existing_checksum}" != "${checksum}" ]]; then
			echo "Migration ${filename} checksum mismatch: database=${existing_checksum} file=${checksum}" >&2
			exit 1
		fi
		echo "Migration ${filename} already applied"
		continue
	fi

	# A baseline row may deliberately have an empty checksum. Only version 1 uses that form.
	applied_count="$(sql "SELECT COUNT(*) FROM \`analytics_schema_migrations\` WHERE \`version\` = ${version}")"
	if [[ "${applied_count}" != "0" ]]; then
		echo "Migration ${filename} already represented by a baseline row"
		continue
	fi

	echo "Applying Gameplay Analytics migration ${filename}"
	"${MARIADB[@]}" "${DB_NAME}" < "${migration_file}"
	escaped_name="${filename//\'/\'\'}"
	sql "INSERT INTO \`analytics_schema_migrations\` (\`version\`, \`name\`, \`checksum\`) VALUES (${version}, '${escaped_name}', '${checksum}')"
done

current_version="$(sql "SELECT COALESCE(MAX(\`version\`), 0) FROM \`analytics_schema_migrations\`")"
echo "Gameplay Analytics schema version: ${current_version}"
