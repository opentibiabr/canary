#!/usr/bin/env python3
"""Assembles an operator-supplied candidate file into a huntAreas Lua
snippet ready to paste into
data-otservbr-global/scripts/config/gameplay_analytics.lua.

This tool never invents coordinates. It only formats and validates
candidates the operator has already confirmed in-game (see
docs/systems/gameplay-analytics-hunt-areas.md for how). It always validates
the candidates together with the areas already shipped in the config, so a
new candidate that would duplicate a name or overlap an existing area is
rejected before you paste anything.

Usage:
    python tools/analytics/generate_gameplay_analytics_hunt_areas.py my_candidates.json
"""
from __future__ import annotations

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gameplay_analytics_hunt_areas_lib import HuntAreaError, format_lua_table, parse_candidate_file, parse_lua_config, validate_areas  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(f"usage: {argv[0]} <candidate-file.json>", file=sys.stderr)
        return 2

    candidate_path = Path(argv[1])

    try:
        existing = parse_lua_config(CONFIG.read_text(encoding="utf-8"), str(CONFIG.relative_to(ROOT)))
        candidates = parse_candidate_file(candidate_path)
        combined = existing + candidates
        problems = validate_areas(combined)
    except HuntAreaError as error:
        print(f"cannot generate: {error}", file=sys.stderr)
        return 1

    if problems:
        print("cannot generate: the combined catalogue would be invalid:", file=sys.stderr)
        for problem in problems:
            print(f"  - {problem}", file=sys.stderr)
        return 1

    print("-- Paste this in place of the existing huntAreas table in")
    print(f"-- {CONFIG.relative_to(ROOT)}")
    print(format_lua_table(combined))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
