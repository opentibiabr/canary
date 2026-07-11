#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

from otbm_item_audit import ItemAuditError, audit_from_files


def locate_scanner(explicit: Path | None) -> Path:
    candidates: list[Path] = []
    if explicit is not None:
        candidates.append(explicit)
    environment = os.environ.get("OTBM_ITEM_AUDIT_SCANNER")
    if environment:
        candidates.append(Path(environment))
    module = Path(__file__).resolve().parent
    candidates.extend((module / "otbm_item_audit_scan", module / "otbm_item_audit_scan.exe"))
    for candidate in candidates:
        resolved = candidate.expanduser().resolve()
        if resolved.is_file():
            return resolved
    raise ItemAuditError("Native item audit scanner was not found; compile otbm_item_audit_scan.cpp or pass --scanner")


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit OTBM item usage against appearances and Canary items.xml")
    parser.add_argument("map", type=Path)
    parser.add_argument("--scanner", type=Path)
    parser.add_argument("--appearances-index", type=Path, required=True)
    parser.add_argument("--items-xml", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--scan-output", type=Path)
    parser.add_argument("--skip-map-hash", action="store_true")
    parser.add_argument("--allow-errors", action="store_true")
    args = parser.parse_args()
    try:
        report = audit_from_files(
            map_path=args.map,
            scanner=locate_scanner(args.scanner),
            appearances_index_path=args.appearances_index,
            items_xml=args.items_xml,
            output=args.output,
            scan_output=args.scan_output,
            include_map_hash=not args.skip_map_hash,
        )
    except (FileNotFoundError, OSError, ValueError, ItemAuditError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2
    sys.stdout.write(json.dumps({"ok": report["ok"], "summary": report["summary"], "output": str(args.output.resolve())}, indent=2) + "\n")
    return 0 if report["ok"] or args.allow_errors else 2


if __name__ == "__main__":
    raise SystemExit(main())
