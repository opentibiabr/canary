#!/usr/bin/env python3
"""Safe, deterministic OTBM inspection, catalog enrichment, diff and patch tool."""
from __future__ import annotations

import argparse
import json
import sys
import xml.etree.ElementTree as ET
from collections.abc import Sequence
from pathlib import Path

from otbm_binary import DEFAULT_MAX_TILES, OTBMError, _require, sha256_path, validate_complete_file
from otbm_catalog import (
    ItemCatalog,
    catalog_document,
    enrich_region_export,
    load_item_catalog,
    render_semantic_svg,
    resolve_items_xml,
)
from otbm_patch import build_diff_patch, load_patch, plan_patch, plan_report, write_patched_map
from otbm_scan import build_export, normalize_bounds, position_from_text, render_svg, scan_map, scan_summary, write_json
from otbm_schema import validate_patch_document


def _load_catalog_for_map(args: argparse.Namespace, map_path: Path) -> ItemCatalog | None:
    explicit = Path(args.items_xml) if getattr(args, "items_xml", None) else None
    items_xml = resolve_items_xml(explicit, map_path)
    if items_xml is None:
        _require(not getattr(args, "require_catalog", False), "No items.xml was found; pass --items-xml")
        return None
    return load_item_catalog(items_xml)


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


def command_catalog(args: argparse.Namespace) -> int:
    catalog = load_item_catalog(Path(args.items_xml))
    write_json(Path(args.output), catalog_document(catalog))
    return 0


def command_export(args: argparse.Namespace) -> int:
    map_path = Path(args.map)
    bounds = normalize_bounds(args.from_position, args.to_position)
    payload, scan = build_export(map_path, bounds, max_tiles=args.max_tiles)
    catalog = _load_catalog_for_map(args, map_path)
    if catalog is not None:
        enrich_region_export(payload, catalog)
    write_json(Path(args.output), payload)
    if args.preview:
        if catalog is not None:
            render_semantic_svg(Path(args.preview), bounds, scan.records, catalog)
        else:
            render_svg(Path(args.preview), bounds, scan.records)
    return 0


def command_diff(args: argparse.Namespace) -> int:
    bounds = normalize_bounds(args.from_position, args.to_position)
    patch = build_diff_patch(Path(args.base_map), Path(args.modified_map), bounds, max_tiles=args.max_tiles)
    validation = validate_patch_document(patch)
    _require(validation["ok"], f"Generated patch failed validation: {validation['issues']}")
    write_json(Path(args.output), patch)
    return 0


def command_validate_patch(args: argparse.Namespace) -> int:
    payload = json.loads(Path(args.patch).read_text(encoding="utf-8"))
    report = validate_patch_document(payload, require_preconditions=not args.allow_missing_preconditions)
    write_json(Path(args.output) if args.output else None, report)
    return 0 if report["ok"] else 2


def command_apply(args: argparse.Namespace) -> int:
    source = Path(args.map)
    patch_path = Path(args.patch)
    raw_patch = json.loads(patch_path.read_text(encoding="utf-8"))
    validation = validate_patch_document(raw_patch, require_preconditions=not args.unsafe_no_precondition)
    if not validation["ok"]:
        report = {
            "format": "canary-otbm-report-v1",
            "mode": "validation",
            "ok": False,
            "source": str(source),
            "output": args.output,
            "validation": validation,
        }
        write_json(Path(args.report) if args.report else None, report)
        return 2
    patch = load_patch(patch_path)
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
    report["validation"] = validation
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

    catalog_parser = subparsers.add_parser("catalog", help="Build a machine-readable item catalog from Canary items.xml")
    catalog_parser.add_argument("items_xml")
    catalog_parser.add_argument("--output", required=True)
    catalog_parser.set_defaults(func=command_catalog)

    export_parser = subparsers.add_parser("export", help="Export a bounded region to readable JSON")
    export_parser.add_argument("map")
    export_parser.add_argument("--from", dest="from_position", type=position_from_text, required=True)
    export_parser.add_argument("--to", dest="to_position", type=position_from_text, required=True)
    export_parser.add_argument("--output", required=True)
    export_parser.add_argument("--preview", help="Optional single-floor SVG logical preview")
    export_parser.add_argument("--items-xml", help="Canary items.xml used to add names, categories, and properties")
    export_parser.add_argument("--require-catalog", action="store_true", help="Fail instead of exporting raw item IDs when items.xml cannot be found")
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

    validate_parser = subparsers.add_parser("validate-patch", help="Validate patch structure and encoded tile nodes without a map")
    validate_parser.add_argument("patch")
    validate_parser.add_argument("--output")
    validate_parser.add_argument("--allow-missing-preconditions", action="store_true")
    validate_parser.set_defaults(func=command_validate_patch)

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
    except (OTBMError, OSError, json.JSONDecodeError, ValueError, ET.ParseError) as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
