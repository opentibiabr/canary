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
    "excludedPlayerNames",
    "excludedAccountTypes",
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
    require(
        re.search(r"^\s*enabled\s*=\s*false\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "analytics must be disabled by default",
    )
    require(
        re.search(r"^\s*trackPvP\s*=\s*false\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "PvP analytics must be disabled by default",
    )


def validate_schema(text: str) -> None:
    tables = set(re.findall(r"CREATE TABLE IF NOT EXISTS\s+`([^`]+)`", text, flags=re.IGNORECASE))
    missing = sorted(REQUIRED_TABLES - tables)
    require(not missing, f"missing schema tables: {', '.join(missing)}")
    require(
        "FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)" in text,
        "sessions must retain player referential integrity",
    )
    require("UNIQUE KEY `analytics_sessions_uuid`" in text, "session UUID must be unique for retry safety")


def function_body(text: str, signature: str, following: str) -> str:
    start = text.find(signature)
    end = text.find(following, start + len(signature))
    require(start >= 0 and end > start, f"cannot isolate runtime function: {signature}")
    return text[start:end]


def validate_library(text: str) -> None:
    functions = set(re.findall(r"function\s+Analytics\.([A-Za-z0-9_]+)\s*\(", text))
    missing = sorted(REQUIRED_API - functions)
    require(not missing, f"missing analytics API: {', '.join(missing)}")
    require("db.query(sessionInsert(session))" in text, "session writes must be aggregated")
    require("Queue limit reached" in text, "queue overflow must be logged")
    require("minimumSessionSeconds" in text, "minimum session threshold is not enforced")
    require("combatTimeoutSeconds" in text, "combat timeout is not enforced")
    require("local function sessionHasData(session)" in text, "empty sessions must be filtered")
    require("runtimeId = player:getId()" in text, "online lookup must retain the runtime player id")
    require(
        "combatEnd = math.min(combatEnd, session.lastCombatAt)" in text,
        "combat duration must end at the last combat event, not at timeout processing",
    )
    require(
        re.search(r"function\s+Analytics\.recordExperience\([^)]*source[^)]*\)", text) is not None,
        "experience recording must retain the source monster",
    )
    require("monster.experienceRaw = monster.experienceRaw + rawAmount" in text, "per-monster raw experience is not populated")
    require(
        "if Analytics.config.databaseEnabled ~= true then\n\t\treturn true\n\tend" in text,
        "database-disabled mode must not retain completed sessions in memory",
    )
    require(
        "Analytics.recordManaSpent(player, mana)" not in text,
        "spell reporting must not double-count mana already captured by mana-change events",
    )
    require(
        re.search(r"\blocal\s+result\s*=\s*db\.storeQuery", text) is None,
        "database query handles must not shadow Canary's global result API",
    )
    require(
        text.count("ON DUPLICATE KEY UPDATE") >= len(REQUIRED_TABLES),
        "session and detail writes must be idempotent for safe retries",
    )
    flush_body = function_body(text, "function Analytics.flush()", "function Analytics.expireInactive()")
    require(
        "persisted = insertDetails(session)" in flush_body,
        "detail persistence failures must affect the session result",
    )
    require(
        "Analytics.enqueue(session)" in flush_body,
        "failed session or detail writes must be requeued",
    )


def strip_lua_comment(line: str) -> str:
    return line.split("--", 1)[0]


def lua_block_delta(line: str) -> int:
    code = strip_lua_comment(line)
    opens = len(re.findall(r"\b(function|if|for|while|do)\b", code))
    closes = len(re.findall(r"\bend\b", code))
    return opens - closes


def has_global_drain_health_registration(text: str) -> bool:
    callback_names = {
        match.group(1)
        for match in re.finditer(
            r"^\s*(?:local\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*EventCallback(?:\([^)]*\))?\s*$",
            text,
            flags=re.MULTILINE,
        )
    }
    if not callback_names:
        return False

    lines = text.splitlines()
    for index, line in enumerate(lines):
        function_match = re.match(
            r"^\s*function\s+([A-Za-z_][A-Za-z0-9_]*)\.creatureOnDrainHealth\s*\(([^)]*)\)",
            line,
        )
        if not function_match:
            continue

        callback_name = function_match.group(1)
        if callback_name not in callback_names:
            continue

        arguments = {argument.strip() for argument in function_match.group(2).split(",")}
        if not {"creature", "attacker"}.issubset(arguments):
            continue

        depth = lua_block_delta(line)
        body = []
        for body_line in lines[index + 1 :]:
            body.append(body_line)
            depth += lua_block_delta(body_line)
            if depth <= 0:
                break

        body_text = "\n".join(body)
        if "Analytics.recordDamageDealt" not in body_text:
            continue
        if re.search(rf"^\s*{re.escape(callback_name)}:register\(\)\s*$", text, flags=re.MULTILINE):
            return True

    return False


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
    require(has_global_drain_health_registration(text), "global drain-health analytics callback must record outgoing damage")

    login_body = function_body(text, "function login.onLogin(player)", "login:register()")
    require("Analytics.start(player)" not in login_body, "login must not create an empty analytics session")
    require("registerPlayerEvents(player)" in login_body, "login must register analytics creature events")

    experience_body = function_body(
        text,
        "function experienceCallback.playerOnGainExperience",
        "experienceCallback:register()",
    )
    require(
        "Analytics.recordExperience(player, experienceValue, rawExperience, source)" in experience_body,
        "experience source must be passed to per-monster analytics",
    )

    require("Game.getPlayers()" in text, "runtime enable must register events for players already online")
    require(
        "Analytics.config.trackPvP or not sourcePlayer" in text,
        "incoming damage from players and their summons must obey the PvP switch",
    )
    require(
        "Analytics.config.trackPvP or not targetPlayer" in text,
        "damage to player-owned summons must obey the PvP switch",
    )
    require(
        "Analytics.recordDamageDealt(sourcePlayer, creature, secondaryDamage, secondaryType)" in text,
        "secondary damage must retain its own combat type",
    )


def main() -> int:
    try:
        validate_config(read(CONFIG))
        validate_schema(read(SCHEMA))
        validate_library(read(LIBRARY))
        validate_runtime(read(RUNTIME))
        docs = read(DOCS)
        require("## Installation" in docs, "documentation lacks installation section")
        require("## Example balance queries" in docs, "documentation lacks balance queries")
        require("engine-wide drain-health callback" in docs, "documentation describes an obsolete monster spawn hook")
    except AssertionError as error:
        print(f"gameplay analytics validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
