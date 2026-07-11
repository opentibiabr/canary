#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
ENV_EXAMPLE = ROOT / "tools/analytics/gameplay-analytics.env.example"
INSTALL = ROOT / "tools/analytics/install_gameplay_analytics.sh"
DOCS = ROOT / "docs/systems/gameplay-analytics-deployment.md"

REQUIRED_ENV_KEYS = {
    "DB_HOST",
    "DB_PORT",
    "DB_USER",
    "DB_PASSWORD",
    "DB_NAME",
    "CANARY_SERVER_VERSION",
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
    require(not missing, f"env example is missing keys: {', '.join(missing)}")
    require(
        re.search(r"^DB_PASSWORD=CHANGE_ME$", text, flags=re.MULTILINE) is not None,
        "env example must ship a placeholder database password, not a real one",
    )
    require(
        re.search(r"^CANARY_SERVER_VERSION=CHANGE_ME$", text, flags=re.MULTILINE) is not None,
        "env example must ship a placeholder server version",
    )
    require("Never commit a filled-in copy" in text, "env example must warn against committing real credentials")


def validate_install_script(text: str) -> None:
    require(text.startswith("#!/usr/bin/env bash"), "install script must be a bash script")
    require("set -euo pipefail" in text, "install script must fail fast")
    require(
        'if [[ "${DB_PASSWORD}" == "CHANGE_ME" ]]' in text,
        "install script must refuse to run with the placeholder password",
    )
    require("schema/gameplay_analytics.sql" in text, "install script must apply the baseline schema file")
    require("migrate_gameplay_analytics.sh" in text, "install script must run the migration runner")
    require(
        re.search(r"REQUIRED_SCHEMA_VERSION\s*=\s*3", text) is not None,
        "install script must verify the schema version it requires",
    )
    require("sed -i" not in text, "install script must never edit the Lua configuration in place")
    require(
        re.search(r"[>|]\s*\S*gameplay_analytics\.lua", text) is None,
        "install script must never write to the Lua configuration file",
    )
    require('"/analytics schema"' in text, "install script must instruct the operator to verify /analytics schema")
    require('"/analytics status"' in text, "install script must instruct the operator to verify /analytics status")
    require(
        "never modifies the Lua configuration" in text,
        "install script must document that it does not touch the Lua configuration",
    )


def validate_docs(text: str) -> None:
    for phrase in (
        "## Rollback",
        "/analytics schema",
        "/analytics status",
        "CANARY_SERVER_VERSION",
        "chmod 600",
        "Never commit the filled-in",
        "install_gameplay_analytics.sh",
        "gameplay-analytics.env.example",
        "must never prevent Canary from starting",
        "repeatable",
    ):
        require(phrase in text, f"deployment documentation lacks: {phrase}")


def main() -> int:
    try:
        validate_env_example(read(ENV_EXAMPLE))
        validate_install_script(read(INSTALL))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics deployment validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics deployment validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
