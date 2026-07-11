#!/usr/bin/env bash
set -euo pipefail

# Repeatable production installer for the Gameplay Analytics database schema.
#
# This script only prepares the database. It never edits the Lua configuration
# and never sets `enabled = true`. Analytics stays disabled until an operator
# verifies "/analytics schema" and "/analytics status" and enables it by hand.
#
# Usage:
#   set -a
#   source /etc/canary/gameplay-analytics.env
#   set +a
#   bash tools/analytics/install_gameplay_analytics.sh

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-canary}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_NAME="${DB_NAME:-canary}"
REQUIRED_SCHEMA_VERSION=3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASELINE_SCHEMA="${BASELINE_SCHEMA:-${SCRIPT_DIR}/../../schema/gameplay_analytics.sql}"
MIGRATE_SCRIPT="${SCRIPT_DIR}/migrate_gameplay_analytics.sh"

if [[ "${DB_PASSWORD}" == "CHANGE_ME" ]]; then
	echo "DB_PASSWORD still has the placeholder value from gameplay-analytics.env.example; set the real database password before installing" >&2
	exit 1
fi

if [[ ! -f "${BASELINE_SCHEMA}" ]]; then
	echo "Baseline schema not found: ${BASELINE_SCHEMA}" >&2
	exit 1
fi

if [[ ! -f "${MIGRATE_SCRIPT}" ]]; then
	echo "Migration runner not found: ${MIGRATE_SCRIPT}" >&2
	exit 1
fi

export MYSQL_PWD="${DB_PASSWORD}"
MARIADB=(mariadb --protocol=TCP --host="${DB_HOST}" --port="${DB_PORT}" --user="${DB_USER}" --batch --skip-column-names)

echo "Step 1/3: applying baseline Gameplay Analytics schema (schema/gameplay_analytics.sql)"
"${MARIADB[@]}" "${DB_NAME}" <"${BASELINE_SCHEMA}"

echo "Step 2/3: applying Gameplay Analytics migrations"
DB_HOST="${DB_HOST}" DB_PORT="${DB_PORT}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" \
	bash "${MIGRATE_SCRIPT}"

echo "Step 3/3: verifying installed schema version"
current_version="$("${MARIADB[@]}" "${DB_NAME}" -e "SELECT COALESCE(MAX(version), 0) FROM analytics_schema_migrations")"
if [[ "${current_version}" -lt "${REQUIRED_SCHEMA_VERSION}" ]]; then
	echo "Gameplay Analytics schema version ${current_version} is still lower than required version ${REQUIRED_SCHEMA_VERSION}" >&2
	exit 1
fi

cat <<VERIFY

Gameplay Analytics database installation complete (schema version ${current_version}/${REQUIRED_SCHEMA_VERSION}).
Analytics remains disabled until you complete verification:

  1. Start (or restart) Canary with this schema in place and with
     CANARY_SERVER_VERSION exported to the Canary process environment.
  2. As a gamemaster, run "/analytics schema" and confirm
     ready=true, current=${REQUIRED_SCHEMA_VERSION}, required=${REQUIRED_SCHEMA_VERSION}, error=none.
  3. As a gamemaster, run "/analytics status" and confirm schemaReady=true
     with no schemaError.
  4. Only after both checks pass, set enabled = true (and databaseEnabled = true
     if desired) in data-otservbr-global/scripts/config/gameplay_analytics.lua
     and restart Canary.

This script never modifies the Lua configuration and never enables Analytics
automatically. It is safe to run again: the baseline schema uses
CREATE TABLE IF NOT EXISTS and the migration runner is idempotent by checksum.
VERIFY
