#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"
LIBRARY = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/systems/gameplay_analytics.lua"
SCHEMA = ROOT / "schema/gameplay_analytics.sql"
DOCS = ROOT / "docs/systems/gameplay-analytics.md"

REQUIRED_CONFIG = {
    "enabled",
    "databaseEnabled",
    "flushIntervalSeconds",
    "minimumSessionSeconds",
    "combatTimeoutSeconds",
    "includeStaff",
    "trackPvP",
    "trackSpells",
    "trackMonsters",
    "trackDamageTypes",
    "trackSupplies",
    "trackLoot",
    "anonymizePlayers",
    "queueLimit",
    "detailLevel",
    "levelBrackets",
}

REQUIRED_TABLES = {
    "analytics_sessions",
    "analytics_session_monsters",
    "analytics_session_spells",
    "analytics_session_damage_types",
    "analytics_session_supplies",
    "analytics_session_loot",
}

REQUIRED_API = {
    "start",
    "finish",
    "flush",
    "recordExperience",
    "recordDamageDealt",
    "recordDamageReceived",
    "recordHealing",
    "recordManaSpent",
    "recordKill",
    "recordDeath",
    "recordSpell",
    "recordSupply",
    "recordLoot",
    "status",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_config(text: str) -> None:
    keys = set(re.findall(r"^\s*([A-Za-z][A-Za-z0-9_]*)\s*=", text, flags=re.MULTILINE))
    missing = sorted(REQUIRED_CONFIG - keys)
    require(not missing, f"missing config keys: {', '.join(missing)}")
    require(re.search(r"^\s*enabled\s*=\s*false\s*,?\s*$", text, flags=re.MULTILINE) is not None,
            "analytics must be disabled by default")
    require(re.search(r"^\s*trackPvP\s*=\s*false\s*,?\s*$", text, flags=re.MULTILINE) is not None,
            "PvP analytics must be disabled by default")


def validate_schema(text: str) -> None:
    tables = set(re.findall(r"CREATE TABLE IF NOT EXISTS\s+`([^`]+)`", text, flags=re.IGNORECASE))
    missing = sorted(REQUIRED_TABLES - tables)
    require(not missing, f"missing schema tables: {', '.join(missing)}")
    require("FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)" in text,
            "sessions must retain player referential integrity")
    require("UNIQUE KEY `analytics_sessions_uuid`" in text,
            "session UUID must be unique for retry safety")


def validate_library(text: str) -> None:
    functions = set(re.findall(r"function\s+Analytics\.([A-Za-z0-9_]+)\s*\(", text))
    missing = sorted(REQUIRED_API - functions)
    require(not missing, f"missing analytics API: {', '.join(missing)}")
    require("db.query(sessionInsert(session))" in text, "session writes must be aggregated")
    require("Queue limit reached" in text, "queue overflow must be logged")
    require("minimumSessionSeconds" in text, "minimum session threshold is not enforced")
    require("combatTimeoutSeconds" in text, "combat timeout is not enforced")


def validate_runtime(text: str) -> None:
    for event in (
        "GameplayAnalyticsStartup",
        "GameplayAnalyticsShutdown",
        "GameplayAnalyticsLogin",
        "GameplayAnalyticsLogout",
        "GameplayAnalyticsHealth",
        "GameplayAnalyticsMana",
        "GameplayAnalyticsDeath",
        "GameplayAnalyticsKill",
        "GameplayAnalyticsExperience",
    ):
        require(event in text, f"missing runtime event: {event}")
    require('TalkAction("/analytics")' in text, "missing administrative command")
    require("creature:registerEvent(\"GameplayAnalyticsHealth\")" in text,
            "spawned monsters must receive the health event")


def main() -> int:
    try:
        validate_config(read(CONFIG))
        validate_schema(read(SCHEMA))
        validate_library(read(LIBRARY))
        validate_runtime(read(RUNTIME))
        docs = read(DOCS)
        require("## Installation" in docs, "documentation lacks installation section")
        require("## Example balance queries" in docs, "documentation lacks balance queries")
    except AssertionError as error:
        print(f"gameplay analytics validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
