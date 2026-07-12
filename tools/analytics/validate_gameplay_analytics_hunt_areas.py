#!/usr/bin/env python3
"""Validates the huntAreas table shipped in
data-otservbr-global/scripts/config/gameplay_analytics.lua, and optionally
a candidate JSON file (see docs/systems/gameplay-analytics-hunt-areas.md),
for malformed coordinates, duplicate names and overlapping rectangles.
"""
from __future__ import annotations

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gameplay_analytics_hunt_areas_lib import HuntAreaError, parse_candidate_file, parse_lua_config, validate_areas  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"


def main(argv: list[str]) -> int:
    candidate_path = Path(argv[1]) if len(argv) > 1 else None

    try:
        config_text = CONFIG.read_text(encoding="utf-8")
        areas = parse_lua_config(config_text, str(CONFIG.relative_to(ROOT)))

        if candidate_path is not None:
            areas = areas + parse_candidate_file(candidate_path)

        problems = validate_areas(areas)
    except HuntAreaError as error:
        print(f"hunt area validation failed: {error}", file=sys.stderr)
        return 1

    if problems:
        print("hunt area validation failed:", file=sys.stderr)
        for problem in problems:
            print(f"  - {problem}", file=sys.stderr)
        return 1

    print(f"hunt area validation passed ({len(areas)} area(s) checked)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
