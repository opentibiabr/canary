#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
PRICES = ROOT / "data/scripts/lib/gameplay_analytics_prices.lua"
LOOT_HELPER = ROOT / "data/scripts/lib/gameplay_analytics_loot.lua"
LOOT_CALLBACK = ROOT / "data/scripts/eventcallbacks/monster/postdroploot_gameplay_analytics.lua"
POTIONS = ROOT / "data/scripts/actions/items/potions.lua"
FIREBALL_RUNE = ROOT / "data/scripts/runes/fireball.lua"
HEALING_RUNE = ROOT / "data/scripts/runes/intense_healing_rune.lua"
DOCS = ROOT / "docs/systems/gameplay-analytics-supply-loot.md"
CORE_PATH = "data-otservbr-global/scripts/lib/gameplay_analytics.lua"

SUPPLY_FILES = [POTIONS, FIREBALL_RUNE, HEALING_RUNE]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_prices(text: str) -> None:
    require("function GameplayAnalyticsPrices.buyPrice" in text, "price table is missing buyPrice")
    require("function GameplayAnalyticsPrices.sellPrice" in text, "price table is missing sellPrice")
    require(
        "return (entry and entry.buy) or 0" in text,
        "an unmapped item or side must report zero, never a guess",
    )
    require(
        "return (entry and entry.sell) or 0" in text,
        "an unmapped item or side must report zero, never a guess",
    )
    # Every price entry must be traceable to a specific NPC shop script by a
    # trailing comment; a bare number with no source is not verifiable.
    for lineno, line in enumerate(text.splitlines(), start=1):
        stripped = line.strip()
        if re.match(r"^\[\d+\]\s*=\s*\{", stripped):
            require("--" in stripped, f"price table entry at line {lineno} lacks a source comment: {stripped}")


def validate_loot_helper(text: str) -> None:
    require("function GameplayAnalyticsLoot.recordCorpseLoot" in text, "loot helper is missing recordCorpseLoot")
    require(
        "if not analytics or not player or not items then\n\t\treturn\n\tend" in text,
        "loot helper must no-op when analytics, player or items is unavailable",
    )
    require("analytics.recordLoot(" in text, "loot helper must call Analytics.recordLoot")
    require(", 0)" in text, "loot helper must report a zero market value; no trustworthy market source exists")


def validate_loot_callback(text: str) -> None:
    require(
        'dofile("data/scripts/lib/gameplay_analytics_loot.lua")' in text,
        "loot callback must use the shared loot helper",
    )
    require(
        CORE_PATH not in text,
        "loot callback must not reload the Gameplay Analytics core; doing so can overwrite installed runtime wrappers",
    )
    require("GameplayAnalytics" in text, "loot callback must resolve the live GameplayAnalytics global at event time")
    require("monsterPostDropLoot" in text, "loot callback must register on monsterPostDropLoot")
    require(
        "corpse:getCorpseOwner()" in text,
        "loot must be attributed to the corpse owner, not every party member",
    )
    require(
        "corpse:getItems(true)" in text,
        "loot callback must walk nested corpse containers recursively so their contents are not omitted",
    )
    for forbidden in ("participants", "getMembers()"):
        require(forbidden not in text, f"loot callback must not iterate party members ({forbidden}), which would double-count the same corpse")


def validate_supply_integration(path: Path, text: str) -> None:
    label = path.relative_to(ROOT)
    require(
        'dofile("data/scripts/lib/gameplay_analytics_prices.lua")' in text,
        f"{label} must load the shared price table",
    )
    require(
        CORE_PATH not in text,
        f"{label} must not reload the Gameplay Analytics core; doing so can overwrite installed runtime wrappers",
    )
    require("GameplayAnalytics" in text, f"{label} must resolve the live GameplayAnalytics global at use time")
    require(
        "recordSupply(" in text,
        f"{label} must call Gameplay Analytics recordSupply",
    )
    require("AnalyticsPrices.buyPrice(" in text, f"{label} must price supply consumption from the verified table")


def validate_docs(text: str) -> None:
    for phrase in (
        "Value-source precedence",
        "never guessed",
        "marketValue",
        "gameplay_analytics_prices.lua",
        "corpse owner",
        "nested containers",
    ):
        require(phrase in text, f"supply/loot documentation lacks: {phrase}")
    require("live" in text and "`GameplayAnalytics` global" in text, "supply/loot documentation must describe live GameplayAnalytics global lookup")


def main() -> int:
    try:
        prices_text = read(PRICES)
        validate_prices(prices_text)
        validate_loot_helper(read(LOOT_HELPER))
        validate_loot_callback(read(LOOT_CALLBACK))
        for path in SUPPLY_FILES:
            validate_supply_integration(path, read(path))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics supply/loot validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics supply/loot validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
