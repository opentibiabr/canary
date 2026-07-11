#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from otbm_binary import OTBMError
from otbm_renderer import render_region
from otbm_scan import position_from_text
from otbm_sprites import SpriteSheetError


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Render a bounded OTBM region using modern OTClient/RME assets")
    parser.add_argument("map", type=Path)
    parser.add_argument("assets", type=Path, help="Client root, assets directory, or OTClient data/things/<version>")
    parser.add_argument("--from", dest="from_position", type=position_from_text, required=True)
    parser.add_argument("--to", dest="to_position", type=position_from_text, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--padding-tiles", type=int, default=4)
    parser.add_argument("--max-tiles", type=int, default=4096)
    parser.add_argument("--allow-errors", action="store_true", help="Keep the PNG and return success while reporting missing assets")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        report = render_region(
            args.map,
            args.assets,
            (args.from_position, args.to_position),
            args.output,
            padding_tiles=args.padding_tiles,
            max_tiles=args.max_tiles,
        )
    except (FileNotFoundError, OSError, ValueError, OTBMError, SpriteSheetError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2
    text = json.dumps(report, indent=2, ensure_ascii=False) + "\n"
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0 if report["ok"] or args.allow_errors else 2


if __name__ == "__main__":
    raise SystemExit(main())
