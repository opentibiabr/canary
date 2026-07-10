#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"
RELIABILITY = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/systems/gameplay_analytics.lua"
SCHEMA = ROOT / "schema/gameplay_analytics.sql"
DOCS = ROOT / "docs/systems/gameplay-analytics.md"

REQUIRED_CONFIG = {
    "maxRetryAttempts",
    "retryBaseDelaySeconds",
    "retryMaxDelaySeconds",
    "deadLetterQueueLimit",
}

REQUIRED_HEALTH_FIELDS = {
    "successfulFlushes",
    "failedFlushes",
    "persistedSessions",
    "retriedSessions",
    "deadLetteredSessions",
    "persistedDeadLetters",
    "droppedSessions",
    "droppedDeadLetters",
    "lastFlushDurationMs",
    "lastFlushProcessed",
    "lastFlushFailed",
    "lastDeadLetterPersistedAt",
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
    require(not missing, f"missing reliability config keys: {', '.join(missing)}")
    require(
        re.search(r"^\s*maxRetryAttempts\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "maxRetryAttempts must default to a positive bounded value",
    )
    require(
        re.search(r"^\s*deadLetterQueueLimit\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "deadLetterQueueLimit must default to a positive value",
    )


def validate_schema(text: str) -> None:
    require(
        "CREATE TABLE IF NOT EXISTS `analytics_dead_letters`" in text,
        "missing analytics dead-letter table",
    )
    require(
        "UNIQUE KEY `analytics_dead_letters_uuid` (`session_uuid`)" in text,
        "dead-letter writes must be idempotent by session UUID",
    )
    for column in ("retry_count", "last_error", "failed_at"):
        require(f"`{column}`" in text, f"dead-letter table lacks {column}")


def validate_reliability(text: str) -> None:
    require("Analytics.reliabilityInstalled" in text, "reliability wrapper must be idempotent")
    require("local originalEnqueue = Analytics.enqueue" in text, "enqueue wrapper must retain the core implementation")
    require("local originalFlush = Analytics.flush" in text, "flush wrapper must retain the core implementation")
    require("function Analytics.persistDeadLetters()" in text, "missing dead-letter persistence API")
    require("function Analytics.enqueue(session)" in text, "missing bounded enqueue wrapper")
    require("function Analytics.flush(force)" in text, "missing retry-aware flush wrapper")
    require("function Analytics.status()" in text, "missing reliability status extension")
    require("function Analytics.stopRuntime()" in text, "shutdown must force a final retry pass")
    require("session.retryCount = session.retryCount + 1" in text, "failed sessions must increment retry count")
    require("session.retryCount > maxRetryAttempts()" in text, "retry attempts must be bounded")
    require("session.nextRetryAt = now() + retryDelay(session.retryCount)" in text, "retry backoff timestamp is missing")
    require("2 ^ exponent" in text, "retry delay must use exponential backoff")
    require("analytics_dead_letters" in text, "dead letters must be persisted to MariaDB")
    require("Analytics._reliabilityCurrentFlushFailures" in text, "flush failures must be counted once per session")
    require("Analytics.flush(true)" in text, "shutdown must force delayed retries")
    require(
        "if Analytics.config.databaseEnabled ~= true then\n\t\tAnalytics.deadLetterQueue = {}\n\t\treturn 0" in text,
        "database-disabled mode must drain pending dead letters",
    )
    require(
        "if Analytics.config.databaseEnabled ~= true then\n\t\tlocal queued = #Analytics.queue\n\t\tAnalytics.deadLetterQueue = {}" in text,
        "database-disabled flush must drain delayed retries",
    )

    health_fields = set(re.findall(r"^\s*([A-Za-z][A-Za-z0-9_]*)\s*=\s*0,", text, flags=re.MULTILINE))
    missing_health = sorted(REQUIRED_HEALTH_FIELDS - health_fields)
    require(not missing_health, f"missing reliability health fields: {', '.join(missing_health)}")


def validate_runtime(text: str) -> None:
    require(
        'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")' in text,
        "runtime must explicitly load the reliability layer",
    )
    require('command == "deadletters"' in text, "admin command must expose dead-letter persistence")
    require("Analytics.flush(true)" in text, "manual flush must force delayed retries")
    for field in ("retryingSessions", "deadLetterQueueSize", "retriedSessions", "failedFlushes"):
        require(field in text, f"admin status does not expose {field}")


def validate_docs(text: str) -> None:
    require("exponential backoff" in text.lower(), "documentation must explain retry backoff")
    require("analytics_dead_letters" in text, "documentation must mention the dead-letter table")
    require("/analytics deadletters" in text, "documentation must describe dead-letter administration")
    require("lastFlushDurationMs" in text, "documentation must list health counters")


def main() -> int:
    try:
        validate_config(read(CONFIG))
        validate_schema(read(SCHEMA))
        validate_reliability(read(RELIABILITY))
        validate_runtime(read(RUNTIME))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics reliability validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics reliability validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
