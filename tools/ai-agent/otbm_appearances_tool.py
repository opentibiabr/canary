#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from otbm_appearances import ProtobufDecodeError, build_appearances_index


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Index modern Tibia appearances.dat protobuf files")
    parser.add_argument("appearances", type=Path)
    parser.add_argument("--asset-index", type=Path, help="Optional CLIENT_ASSETS_INDEX.json used to verify sprite coverage")
    parser.add_argument("--include-non-objects", action="store_true", help="Include outfit, effect, and missile entries")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--allow-errors", action="store_true")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        asset_index = json.loads(args.asset_index.read_text(encoding="utf-8")) if args.asset_index else None
        report = build_appearances_index(
            args.appearances,
            asset_index=asset_index,
            include_non_objects=args.include_non_objects,
        )
    except (FileNotFoundError, OSError, ValueError, json.JSONDecodeError, ProtobufDecodeError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2

    text = json.dumps(report, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0 if report["ok"] or args.allow_errors else 2


if __name__ == "__main__":
    raise SystemExit(main())
