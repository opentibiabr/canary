#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
SCHEMA = ROOT / "schema/gameplay_analytics.sql"
MIGRATIONS = ROOT / "schema/gameplay_analytics_migrations"
RUNNER = ROOT / "tools/analytics/migrate_gameplay_analytics.sh"
SCHEMA_GUARD = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/systems/gameplay_analytics.lua"
DOCS = ROOT / "docs/systems/gameplay-analytics-migrations.md"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_schema(text: str) -> None:
    require("CREATE TABLE IF NOT EXISTS `analytics_schema_migrations`" in text, "missing schema migration table")
    for column in ("version", "name", "checksum", "applied_at"):
        require(f"`{column}`" in text, f"migration table lacks {column}")
    require("VALUES (1, 'baseline', '')" in text, "baseline schema version must be recorded")


def validate_migrations() -> None:
    require(MIGRATIONS.is_dir(), "missing migration directory")
    files = sorted(MIGRATIONS.glob("[0-9][0-9][0-9]_*.sql"))
    require(files, "no numbered migrations found")
    versions = [int(path.name.split("_", 1)[0]) for path in files]
    require(versions == sorted(set(versions)), "migration versions must be unique and ordered")
    require(versions == list(range(2, max(versions) + 1)), "post-baseline migration versions must be contiguous from 2")

    migrations = {int(path.name.split("_", 1)[0]): read(path) for path in files}
    migration_two = migrations.get(2, "")
    require("analytics_sessions_server_version_time" in migration_two, "migration 002 must add the server-version index")
    require("IF NOT EXISTS" in migration_two, "migration 002 DDL must be idempotent")

    migration_three = migrations.get(3, "")
    for column in (
        "hunt_area",
        "party_size_min",
        "party_size_max",
        "party_size_avg",
        "shared_experience_seconds",
        "shared_experience_ratio",
        "party_vocations",
    ):
        require(f"`{column}`" in migration_three, f"migration 003 lacks {column}")
    require("analytics_sessions_hunt_area_time" in migration_three, "migration 003 must add the hunt-area index")
    require(migration_three.count("IF NOT EXISTS") >= 8, "migration 003 DDL must be repeatable")


def validate_runner(text: str) -> None:
    for token in (
        "set -euo pipefail",
        "analytics_schema_migrations",
        "sha256sum",
        "checksum mismatch",
        "MIGRATIONS_DIR",
        "10#${raw_version}",
    ):
        require(token in text, f"migration runner lacks {token}")
    require("< \"${migration_file}\"" in text, "migration runner must execute each SQL file")
    require("INSERT INTO \\`analytics_schema_migrations\\`" in text, "successful migrations must be recorded")


def validate_guard(text: str) -> None:
    require("Analytics.REQUIRED_SCHEMA_VERSION = 3" in text, "runtime required schema version is not current")
    require("function Analytics.checkSchema()" in text, "missing runtime schema check")
    require("MAX(`version`)" in text, "schema check must read latest migration version")
    require("not Analytics.checkSchema()" in text, "runtime start must be blocked by incompatible schema")
    require("databaseEnabled ~= true" in text, "database-disabled mode must bypass schema requirement")
    require("Analytics.config.enabled = false" in text, "schema rejection must disable collection")
    for field in ("schemaReady", "schemaVersion", "requiredSchemaVersion", "schemaError"):
        require(field in text, f"schema status lacks {field}")


def validate_runtime(text: str) -> None:
    layers = (
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_context.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")',
    )
    indexes = [text.find(item) for item in layers]
    require(all(index >= 0 for index in indexes), "runtime is missing an analytics layer")
    require(indexes == sorted(indexes), "load order must be core, context, schema, batching, reliability")
    require('command == "schema"' in text, "missing /analytics schema command")
    require("if not Analytics.startRuntime() then" in text, "manual enable must respect schema failure")


def validate_docs(text: str) -> None:
    for phrase in (
        "migrate_gameplay_analytics.sh",
        "checksum mismatch",
        "/analytics schema",
        "Deployment order",
    ):
        require(phrase in text, f"migration documentation lacks {phrase}")


def main() -> int:
    try:
        validate_schema(read(SCHEMA))
        validate_migrations()
        validate_runner(read(RUNNER))
        validate_guard(read(SCHEMA_GUARD))
        validate_runtime(read(RUNTIME))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics migration validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics migration validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
