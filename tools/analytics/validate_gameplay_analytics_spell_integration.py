#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
HELPER = ROOT / "data/scripts/lib/gameplay_analytics_spell.lua"
DOCS = ROOT / "docs/systems/gameplay-analytics-spells.md"
CORE_PATH = "data-otservbr-global/scripts/lib/gameplay_analytics.lua"

# Representative spell/rune scripts wired up in this change: one offensive
# spell, one healing spell, one offensive rune and one healing rune.
INTEGRATED_FILES = [
    ROOT / "data/scripts/spells/attack/ethereal_spear.lua",
    ROOT / "data/scripts/spells/healing/ultimate_healing.lua",
    ROOT / "data/scripts/runes/fireball.lua",
    ROOT / "data/scripts/runes/intense_healing_rune.lua",
]

# Any spell or rune script anywhere in the shared data packs must never call
# these directly: the generic combat hooks in
# data-otservbr-global/scripts/systems/gameplay_analytics.lua already record
# them, so a spell-level call would double-count session totals.
FORBIDDEN_CALLS = (
    "Analytics.recordDamageDealt(",
    "Analytics.recordHealing(",
    "Analytics.recordManaSpent(",
)

SCAN_DIRECTORIES = [
    ROOT / "data/scripts/spells",
    ROOT / "data/scripts/runes",
    ROOT / "data-canary/scripts/spells",
    ROOT / "data-otservbr-global/scripts/spells",
]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_helper(text: str) -> None:
    require("function GameplayAnalyticsSpell.recordCast" in text, "spell helper is missing recordCast")
    require("if not analytics then\n\t\treturn execute()\n\tend" in text, "spell helper must no-op when analytics is unavailable")
    require("analytics.recordSpell(" in text, "spell helper must call Analytics.recordSpell")
    require("analytics.combatTotals(" in text, "spell helper must read combat totals instead of recomputing them")
    for forbidden in FORBIDDEN_CALLS:
        require(forbidden not in text, f"spell helper must never call {forbidden} directly")
    require("return GameplayAnalyticsSpell" in text, "spell helper must return its module table")


def validate_integrated_file(path: Path, text: str) -> None:
    label = path.relative_to(ROOT)
    require(
        'dofile("data/scripts/lib/gameplay_analytics_spell.lua")' in text,
        f"{label} must load the shared spell analytics helper",
    )
    require(
        CORE_PATH not in text,
        f"{label} must not reload the Gameplay Analytics core; re-executing it can overwrite installed context, batching and reliability wrappers",
    )
    require(
        "GameplayAnalytics" in text,
        f"{label} must resolve the live GameplayAnalytics global at cast time so script load order stays safe",
    )
    require("AnalyticsSpell.recordCast(" in text, f"{label} must route its cast through AnalyticsSpell.recordCast")
    for forbidden in FORBIDDEN_CALLS:
        require(forbidden not in text, f"{label} must never call {forbidden} directly")
    require("spell:register()" in text or "rune:register()" in text, f"{label} must still register its spell/rune")


def validate_no_double_counting_regressions() -> None:
    for directory in SCAN_DIRECTORIES:
        if not directory.is_dir():
            continue
        for path in directory.rglob("*.lua"):
            text = path.read_text(encoding="utf-8")
            for forbidden in FORBIDDEN_CALLS:
                require(
                    forbidden not in text,
                    f"{path.relative_to(ROOT)} calls {forbidden} directly, which would double-count generic combat hooks",
                )


def validate_docs(text: str) -> None:
    for phrase in (
        "gameplay_analytics_spell.lua",
        "recordCast",
        "double-count",
        "critical",
        "data/scripts/spells",
        "data/scripts/runes",
        "live `GameplayAnalytics` global",
        "must never `dofile` the Analytics core",
    ):
        require(phrase in text, f"spell integration documentation lacks: {phrase}")


def main() -> int:
    try:
        validate_helper(read(HELPER))
        for path in INTEGRATED_FILES:
            validate_integrated_file(path, read(path))
        validate_no_double_counting_regressions()
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics spell integration validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics spell integration validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
