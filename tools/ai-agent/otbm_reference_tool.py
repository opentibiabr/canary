#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from otbm_reference import DEFAULT_ORIGIN, ReferenceError, compare_tibiamaps


def floor_range(value: str) -> list[int]:
    result: set[int] = set()
    for part in value.split(","):
        part = part.strip()
        if "-" in part:
            start, end = (int(item) for item in part.split("-", 1))
            result.update(range(min(start, end), max(start, end) + 1))
        else:
            result.add(int(part))
    if not result or min(result) < 0 or max(result) > 15:
        raise argparse.ArgumentTypeError("Floors must be within 0..15")
    return sorted(result)


def origin(value: str) -> tuple[int, int]:
    try:
        x, y = (int(item.strip()) for item in value.split(",", 1))
    except ValueError as exc:
        raise argparse.ArgumentTypeError("Origin must use x,y") from exc
    return x, y


def main() -> int:
    parser = argparse.ArgumentParser(description="Compare an OTBM map with TibiaMaps map/path PNG floors")
    parser.add_argument("map", type=Path)
    parser.add_argument("tibiamaps", type=Path)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--scanner", type=Path, help="Compiled otbm_reference_scan executable")
    parser.add_argument("--origin", type=origin, default=DEFAULT_ORIGIN)
    parser.add_argument("--floors", type=floor_range, default=list(range(16)))
    parser.add_argument("--minimum-component-area", type=int, default=8)
    parser.add_argument("--skip-map-hash", action="store_true")
    args = parser.parse_args()
    try:
        report = compare_tibiamaps(
            map_path=args.map,
            tibiamaps_directory=args.tibiamaps,
            output_directory=args.output_dir,
            scanner_path=args.scanner,
            origin=args.origin,
            floors=args.floors,
            minimum_component_area=args.minimum_component_area,
            include_hash=not args.skip_map_hash,
        )
    except (FileNotFoundError, OSError, ValueError, ReferenceError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2
    sys.stdout.write(
        json.dumps(
            {
                "ok": True,
                "coverageOfLatest": report["coverageOfLatest"],
                "totals": report["totals"],
                "report": str((args.output_dir / "comparison.json").resolve()),
            },
            indent=2,
        )
        + "\n"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
