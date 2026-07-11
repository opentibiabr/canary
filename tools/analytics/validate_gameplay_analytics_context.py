#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"
CONTEXT = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_context.lua"
BATCHING = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua"
SCHEMA_GUARD = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/systems/gameplay_analytics.lua"
MIGRATION = ROOT / "schema/gameplay_analytics_migrations/003_hunt_context.sql"
DOCS = ROOT / "docs/systems/gameplay-analytics-context.md"

REQUIRED_CONFIG = {
    "serverVersion",
    "contextSampleIntervalSeconds",
    "contextMaxGapSeconds",
    "huntAreaGridSize",
    "trackFallbackGridAreas",
    "huntAreas",
}

CONTEXT_COLUMNS = {
    "hunt_area",
    "party_size_min",
    "party_size_max",
    "party_size_avg",
    "shared_experience_seconds",
    "shared_experience_ratio",
    "party_vocations",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def config_keys(text: str) -> set[str]:
    return set(re.findall(r"^\s*([A-Za-z][A-Za-z0-9_]*)\s*=", text, flags=re.MULTILINE))


def validate_config(text: str) -> None:
    missing = sorted(REQUIRED_CONFIG - config_keys(text))
    require(not missing, f"missing context config keys: {', '.join(missing)}")
    require(
        re.search(r"^\s*contextSampleIntervalSeconds\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "context sampling interval must have a positive default",
    )
    require(
        re.search(r"^\s*contextMaxGapSeconds\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "context gap cap must have a positive default",
    )
    require(
        re.search(r"^\s*huntAreaGridSize\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "hunt-area grid size must have a positive default",
    )


def validate_context(text: str) -> None:
    for token in (
        "Analytics.contextInstalled",
        "function Analytics.sampleContext(player, session, force)",
        "function Analytics.finalizeContext(session)",
        "contextSampleIntervalSeconds",
        "contextMaxGapSeconds",
        "huntAreaGridSize",
        "trackFallbackGridAreas",
        "contextPartySizeWeighted",
        "contextSharedSeconds",
        "dominantScore",
        "partyVocations",
        "serverVersion",
        "Analytics.finalizeContext(session)",
    ):
        require(token in text, f"context layer lacks {token}")
    require("timestamp - session.contextLastAt < sampleInterval" in text, "context sampling must be throttled")
    require("math.min(delta, clampInteger(Analytics.config.contextMaxGapSeconds" in text, "context gaps must be capped")
    require("session.partySize = session.partySizeMax" in text, "legacy party_size must remain representative")
    require("session.sharedExperienceSeconds > 0" in text, "legacy shared_experience must remain representative")
    require("string.format(\"grid:%d:%d:%d\"" in text, "fallback areas must be stable coarse grid identifiers")
    require("uniquePlayers[guid]" in text, "party members must be deduplicated")
    require("pcall" in text and "getLeader" in text, "party leader lookup must be safe across binding versions")
    for metric in ("samples", "throttledSamples", "namedAreaSamples", "fallbackAreaSamples", "finalizedSessions"):
        require(metric in text, f"missing context health metric: {metric}")


def validate_migration(text: str) -> None:
    for column in CONTEXT_COLUMNS:
        require(f"`{column}`" in text, f"context migration lacks {column}")
    require("analytics_sessions_hunt_area_time" in text, "context migration lacks hunt-area index")
    require(text.count("IF NOT EXISTS") >= 8, "context migration must be repeatable")


def validate_batching(text: str) -> None:
    for column in CONTEXT_COLUMNS | {"server_version"}:
        require(f"`{column}`" in text, f"session upsert lacks {column}")
        require(
            f"`{column}`=VALUES(`{column}`)" in text,
            f"session upsert does not update {column}",
        )
    for value in ("session.huntArea", "session.partyVocations", "session.serverVersion"):
        require(value in text, f"session upsert does not use {value}")
    require("nullableSql" in text, "optional context strings must use NULL-safe SQL")
    require("sharedExperienceRatio" in text and "partySizeAvg" in text, "context ratios must be persisted")


def validate_schema_guard(text: str) -> None:
    require("Analytics.REQUIRED_SCHEMA_VERSION = 3" in text, "context runtime must require schema version 3")


def validate_runtime(text: str) -> None:
    layers = (
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_context.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")',
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")',
    )
    indexes = [text.find(item) for item in layers]
    require(all(index >= 0 for index in indexes), "runtime is missing a context-related analytics layer")
    require(indexes == sorted(indexes), "load order must be core, context, schema, batching, reliability")
    for metric in ("contextSamples", "contextFinalizedSessions"):
        require(metric in text, f"admin status does not expose {metric}")


def validate_docs(text: str) -> None:
    for phrase in (
        "huntAreas",
        "trackFallbackGridAreas",
        "party_size_avg",
        "shared_experience_ratio",
        "CANARY_SERVER_VERSION",
        "No character names",
    ):
        require(phrase in text, f"context documentation lacks {phrase}")


def main() -> int:
    try:
        validate_config(read(CONFIG))
        validate_context(read(CONTEXT))
        validate_migration(read(MIGRATION))
        validate_batching(read(BATCHING))
        validate_schema_guard(read(SCHEMA_GUARD))
        validate_runtime(read(RUNTIME))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics context validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics context validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
