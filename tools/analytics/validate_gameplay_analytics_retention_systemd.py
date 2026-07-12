#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
SYSTEMD_DIR = ROOT / "tools/analytics/systemd"
SERVICE = SYSTEMD_DIR / "gameplay-analytics-maintenance.service"
TIMER = SYSTEMD_DIR / "gameplay-analytics-maintenance.timer"
ENV_EXAMPLE = SYSTEMD_DIR / "gameplay-analytics-maintenance.env.example"
DOCS = ROOT / "docs/systems/gameplay-analytics-retention.md"

REQUIRED_ENV_KEYS = {
    "DB_HOST",
    "DB_PORT",
    "DB_USER",
    "DB_PASSWORD",
    "DB_NAME",
    "AGGREGATION_LAG_DAYS",
    "MAX_DAYS_PER_RUN",
    "REAGGREGATE_DAYS",
    "RAW_RETENTION_DAYS",
    "DELETE_RAW_SESSIONS",
    "DELETE_BATCH_SIZE",
    "DELETE_MAX_BATCHES",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_env_example(text: str) -> None:
    keys = set(re.findall(r"^([A-Z][A-Z0-9_]*)=", text, flags=re.MULTILINE))
    missing = sorted(REQUIRED_ENV_KEYS - keys)
    require(not missing, f"retention systemd env example is missing keys: {', '.join(missing)}")
    require(
        re.search(r"^DB_PASSWORD=CHANGE_ME$", text, flags=re.MULTILINE) is not None,
        "retention systemd env example must ship a placeholder database password",
    )
    require(
        re.search(r"^REAGGREGATE_DAYS=7$", text, flags=re.MULTILINE) is not None,
        "retention systemd env example must ship a bounded seven-day rolling rebuild window",
    )
    require(
        re.search(r"^DELETE_RAW_SESSIONS=false$", text, flags=re.MULTILINE) is not None,
        "retention systemd env example must default raw deletion to false",
    )
    require(
        "RAW_RETENTION_DAYS must be greater than" in text,
        "retention systemd env example must document the rebuild/retention safety margin",
    )
    require("Never commit a" in text, "retention systemd env example must warn against committing real credentials")


def validate_service(text: str) -> None:
    for token in (
        "[Unit]",
        "[Service]",
        "Type=oneshot",
        "EnvironmentFile=/etc/canary/gameplay-analytics-maintenance.env",
        "maintain_gameplay_analytics.sh",
        "After=network-online.target mariadb.service",
    ):
        require(token in text, f"maintenance service unit lacks: {token}")
    require(
        "[Install]" not in text,
        "the oneshot maintenance service must be activated only by its timer, not enabled directly",
    )


def validate_timer(text: str) -> None:
    for token in (
        "[Unit]",
        "[Timer]",
        "OnCalendar=",
        "Persistent=true",
        "[Install]",
        "WantedBy=timers.target",
    ):
        require(token in text, f"maintenance timer unit lacks: {token}")


def validate_docs(text: str) -> None:
    for phrase in (
        "tools/analytics/systemd/",
        "gameplay-analytics-maintenance.service",
        "gameplay-analytics-maintenance.timer",
        "gameplay-analytics-maintenance.env.example",
        "systemctl enable --now gameplay-analytics-maintenance.timer",
        "systemctl disable --now gameplay-analytics-maintenance.timer",
        "REAGGREGATE_DAYS",
        "### Install",
        "### Uninstall",
    ):
        require(phrase in text, f"retention documentation lacks: {phrase}")


def main() -> int:
    try:
        validate_env_example(read(ENV_EXAMPLE))
        validate_service(read(SERVICE))
        validate_timer(read(TIMER))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics retention systemd validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics retention systemd validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
