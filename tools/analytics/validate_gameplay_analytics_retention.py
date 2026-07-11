#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
SCHEMA = ROOT / "schema/gameplay_analytics_retention.sql"
RUNNER = ROOT / "tools/analytics/maintain_gameplay_analytics.sh"
TEST = ROOT / "tools/analytics/test_retention_maintenance.sh"
DOCS = ROOT / "docs/systems/gameplay-analytics-retention.md"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_schema(text: str) -> None:
    for table in ("analytics_daily_balance", "analytics_maintenance_state"):
        require(f"CREATE TABLE IF NOT EXISTS `{table}`" in text, f"retention schema lacks {table}")
    for column in (
        "session_date",
        "server_version",
        "hunt_area",
        "vocation_id",
        "level_bracket",
        "source_sessions",
        "party_size_weighted",
        "party_weight_seconds",
        "shared_experience_seconds",
    ):
        require(f"`{column}`" in text, f"daily aggregate lacks {column}")
    require("analytics_sessions_started_id" in text, "retention schema lacks raw-session cleanup index")
    require("IF NOT EXISTS" in text, "retention schema must be repeatable")
    require(text.count("ENGINE=InnoDB") == 2, "retention tables must use InnoDB")


def validate_runner(text: str) -> None:
    for token in (
        "set -euo pipefail",
        "REQUIRED_SCHEMA_VERSION=3",
        "analytics_daily_balance",
        "analytics_maintenance_state",
        "daily_aggregate_through",
        "MAX_DAYS_PER_RUN",
        "DELETE_RAW_SESSIONS",
        "DELETE_BATCH_SIZE",
        "DELETE_MAX_BATCHES",
        "ON DUPLICATE KEY UPDATE",
        "GREATEST(combat_seconds, 1)",
        "aggregate_through",
    ):
        require(token in text, f"maintenance runner lacks {token}")

    daily_start = text.find("INSERT INTO analytics_daily_balance")
    state_start = text.find("INSERT INTO analytics_maintenance_state", daily_start)
    require(daily_start >= 0 and state_start > daily_start, "maintenance runner lacks the daily aggregate statement")
    daily_statement = text[daily_start:state_start]
    require(
        "ON DUPLICATE KEY UPDATE" in daily_statement,
        "daily aggregate must use ON DUPLICATE KEY UPDATE",
    )

    require('DELETE_RAW_SESSIONS="${DELETE_RAW_SESSIONS:-false}"' in text, "raw deletion must be disabled by default")
    require('if [[ "${DELETE_RAW_SESSIONS}" != "true" ]]' in text, "raw deletion must require explicit opt-in")
    require("table_name IN ('analytics_daily_balance','analytics_maintenance_state')" in text, "runner must verify optional retention schema")
    require("started_at < UNIX_TIMESTAMP(DATE_ADD('${aggregate_through}', INTERVAL 1 DAY))" in text, "deletion must stay behind the aggregate checkpoint")
    require("LIMIT ${DELETE_BATCH_SIZE}" in text, "raw deletion must be batched")
    require("value_bigint=value_bigint + VALUES(value_bigint)" in text, "deleted-row counter must accumulate")
    require('if [[ "${current_date}" > "${target_date}" ]]' in text, "date loop must use valid Bash ordering")


def validate_test(text: str) -> None:
    for phrase in (
        "idempotent aggregate groups",
        "raw sessions preserved by default",
        "expired raw sessions deleted",
        "detail rows deleted by cascade",
        "daily aggregates retained",
    ):
        require(phrase in text, f"retention integration test lacks {phrase}")


def validate_docs(text: str) -> None:
    for phrase in (
        "DELETE_RAW_SESSIONS=false",
        "daily_aggregate_through",
        "systemd timer",
        "Back up",
        "analytics_daily_balance",
        "gameplay_analytics_retention.sql",
    ):
        require(phrase in text, f"retention documentation lacks {phrase}")


def main() -> int:
    try:
        validate_schema(read(SCHEMA))
        validate_runner(read(RUNNER))
        validate_test(read(TEST))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics retention validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics retention validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
