#!/usr/bin/env python3
"""Safe, deterministic OTBM inspection, region export, diff and patch tool."""
from __future__ import annotations

import argparse
import json
import sys
from collections.abc import Sequence
from pathlib import Path

from otbm_binary import DEFAULT_MAX_TILES, OTBMError, _require, sha256_path, validate_complete_file
from otbm_patch import (
    build_diff_patch, load_patch, plan_patch, plan_report, write_patched_map,
)
from otbm_scan import (
    build_export, normalize_bounds, position_from_text, render_svg, scan_map,
    scan_summary, write_json,
)

def command_inspect(args: argparse.Namespace) -> int:
    path = Path(args.map)
    scan = scan_map(path, count_tiles=not args.fast)
    payload = scan_summary(scan)
    payload["path"] = str(path.resolve())
    write_json(Path(args.output) if args.output else None, payload)
    return 0


def command_verify(args: argparse.Namespace) -> int:
    path = Path(args.map)
    scan = scan_map(path, count_tiles=args.count_tiles)
    validate_complete_file(path)
    payload = scan_summary(scan)
    payload["path"] = str(path.resolve())
    payload["ok"] = not scan.duplicates
    write_json(Path(args.output) if args.output else None, payload)
    return 0 if payload["ok"] else 2


def command_export(args: argparse.Namespace) -> int:
    bounds = normalize_bounds(args.from_position, args.to_position)
    payload, scan = build_export(Path(args.map), bounds, max_tiles=args.max_tiles)
    write_json(Path(args.output), payload)
    if args.preview:
        render_svg(Path(args.preview), bounds, scan.records)
    return 0


def command_diff(args: argparse.Namespace) -> int:
    bounds = normalize_bounds(args.from_position, args.to_position)
    patch = build_diff_patch(Path(args.base_map), Path(args.modified_map), bounds, max_tiles=args.max_tiles)
    write_json(Path(args.output), patch)
    return 0


def command_apply(args: argparse.Namespace) -> int:
    source = Path(args.map)
    patch = load_patch(Path(args.patch))
    output = Path(args.output) if args.output else None
    if args.write:
        _require(output is not None, "--output is required with --write")
    plan = plan_patch(
        source,
        patch,
        output=output,
        max_tiles=args.max_tiles,
        strict_base=args.strict_base,
        unsafe_no_precondition=args.unsafe_no_precondition,
    )
    written = False
    backup: Path | None = None
    output_sha: str | None = None
    if args.write and plan.ok:
        output_path, backup = write_patched_map(plan, overwrite=args.overwrite)
        output_sha = sha256_path(output_path)
        written = True
    report = plan_report(plan, written=written, output_sha256=output_sha, backup=backup)
    write_json(Path(args.report) if args.report else None, report)
    return 0 if plan.ok else 2


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    inspect_parser = subparsers.add_parser("inspect", help="Read OTBM metadata and optionally count all tiles")
    inspect_parser.add_argument("map")
    inspect_parser.add_argument("--fast", action="store_true", help="Skip full tile counting")
    inspect_parser.add_argument("--output")
    inspect_parser.set_defaults(func=command_inspect)

    verify_parser = subparsers.add_parser("verify", help="Validate the full OTBM tree and count nodes")
    verify_parser.add_argument("map")
    verify_parser.add_argument("--count-tiles", action="store_true", help="Also enumerate every tile (slower on large maps)")
    verify_parser.add_argument("--output")
    verify_parser.set_defaults(func=command_verify)

    export_parser = subparsers.add_parser("export", help="Export a bounded region to readable JSON")
    export_parser.add_argument("map")
    export_parser.add_argument("--from", dest="from_position", type=position_from_text, required=True)
    export_parser.add_argument("--to", dest="to_position", type=position_from_text, required=True)
    export_parser.add_argument("--output", required=True)
    export_parser.add_argument("--preview", help="Optional single-floor SVG occupancy preview")
    export_parser.add_argument("--max-tiles", type=int, default=DEFAULT_MAX_TILES)
    export_parser.set_defaults(func=command_export)

    diff_parser = subparsers.add_parser("diff", help="Create a reusable tile patch from two map versions")
    diff_parser.add_argument("base_map")
    diff_parser.add_argument("modified_map")
    diff_parser.add_argument("--from", dest="from_position", type=position_from_text, required=True)
    diff_parser.add_argument("--to", dest="to_position", type=position_from_text, required=True)
    diff_parser.add_argument("--output", required=True)
    diff_parser.add_argument("--max-tiles", type=int, default=DEFAULT_MAX_TILES)
    diff_parser.set_defaults(func=command_diff)

    apply_parser = subparsers.add_parser("apply", help="Validate or apply a reusable patch; dry-run is the default")
    apply_parser.add_argument("map")
    apply_parser.add_argument("patch")
    apply_parser.add_argument("--output")
    apply_parser.add_argument("--report")
    apply_parser.add_argument("--write", action="store_true", help="Actually create the output OTBM")
    apply_parser.add_argument("--overwrite", action="store_true", help="Back up and replace an existing output file")
    apply_parser.add_argument("--strict-base", action="store_true", help="Reject a patch when the whole-map SHA differs")
    apply_parser.add_argument("--unsafe-no-precondition", action="store_true", help="Allow semantic operations without expectedTileHash")
    apply_parser.add_argument("--max-tiles", type=int, default=DEFAULT_MAX_TILES)
    apply_parser.set_defaults(func=command_apply)

    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return int(args.func(args))
    except (OTBMError, OSError, json.JSONDecodeError, ValueError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
