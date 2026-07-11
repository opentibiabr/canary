#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from otbm_assets import build_asset_index


def write_json(path: Path | None, payload: dict[str, object]) -> None:
    text = json.dumps(payload, indent=2, ensure_ascii=False) + "\n"
    if path is None:
        sys.stdout.write(text)
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Validate and index OTClient/RME client asset packages")
    parser.add_argument("root", type=Path, help="Client root, assets directory, or catalog-content.json")
    parser.add_argument("--output", type=Path, help="Write the JSON index to this path")
    parser.add_argument("--skip-hashes", action="store_true", help="Skip SHA-256 calculation for large asset files")
    parser.add_argument("--allow-errors", action="store_true", help="Return success while retaining errors in the report")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        payload = build_asset_index(args.root, hash_files=not args.skip_hashes)
    except (FileNotFoundError, OSError, ValueError, json.JSONDecodeError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2
    write_json(args.output, payload)
    return 0 if payload["ok"] or args.allow_errors else 2


if __name__ == "__main__":
    raise SystemExit(main())
