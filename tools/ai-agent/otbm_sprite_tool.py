#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from otbm_sprites import SpriteSheetError, decode_sprite_sheet, encode_png, extract_sprite, sheet_report


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Inspect modern Tibia CIP/LZMA sprite sheets and extract PNG sprites")
    subparsers = parser.add_subparsers(dest="command", required=True)

    inspect_parser = subparsers.add_parser("inspect", help="Decode and validate one 384x384 sprite sheet")
    inspect_parser.add_argument("sheet", type=Path)
    inspect_parser.add_argument("--output", type=Path)

    extract_parser = subparsers.add_parser("extract", help="Extract one sprite by ID")
    extract_parser.add_argument("sheet", type=Path)
    extract_parser.add_argument("--first-id", type=int, required=True)
    extract_parser.add_argument("--last-id", type=int, required=True)
    extract_parser.add_argument("--layout", type=int, required=True)
    extract_parser.add_argument("--sprite-id", type=int, required=True)
    extract_parser.add_argument("--output", type=Path, required=True)
    extract_parser.add_argument("--report", type=Path)
    return parser


def write_json(path: Path | None, payload: dict[str, object]) -> None:
    text = json.dumps(payload, indent=2, ensure_ascii=False) + "\n"
    if path:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)


def main() -> int:
    args = build_parser().parse_args()
    try:
        sheet = decode_sprite_sheet(args.sheet)
        report = sheet_report(sheet)
        if args.command == "inspect":
            write_json(args.output, report)
            return 0

        sprite = extract_sprite(
            sheet,
            sprite_id=args.sprite_id,
            first_sprite_id=args.first_id,
            last_sprite_id=args.last_id,
            layout=args.layout,
        )
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_bytes(encode_png(sprite.width, sprite.height, sprite.rgba))
        report["sprite"] = {
            "id": sprite.sprite_id,
            "firstId": sprite.first_sprite_id,
            "lastId": sprite.last_sprite_id,
            "layout": sprite.layout,
            "width": sprite.width,
            "height": sprite.height,
            "column": sprite.column,
            "row": sprite.row,
            "output": str(args.output.resolve()),
        }
        write_json(args.report, report)
        return 0
    except (FileNotFoundError, OSError, SpriteSheetError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
