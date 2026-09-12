"""Command line entry point; analysis is read-only unless --report is supplied."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from .inventory import analyze
from .bundle import apply_bundle, revert_bundle, validate_bundle


def main(argv: list[str] | None = None) -> int:
	parser = argparse.ArgumentParser(prog="python -m tools.world_migrate")
	commands = parser.add_subparsers(dest="command", required=True)
	analysis = commands.add_parser("analyze", help="inspect every loader file without executing Lua or changing sources")
	analysis.add_argument("--datapack", required=True)
	analysis.add_argument("--all", action="store_true", help="select all declarations")
	analysis.add_argument("--file", help="datapack-relative source path")
	analysis.add_argument("--table")
	analysis.add_argument("--entry", action="append", default=[])
	analysis.add_argument("--report", type=Path, help="explicitly write a full JSON report")
	for name in ("generate", "validate", "apply", "revert"):
		command = commands.add_parser(name)
		command.add_argument("--world-tool", type=Path, help="distributed native validator/publisher; defaults to WORLD_TOOL_PATH or PATH")
		command.add_argument("--map", type=Path, help="read the same OTBM from a different local path")
		if name == "generate":
			command.add_argument("--report", type=Path, required=True)
			command.add_argument("--output", type=Path, required=True)
			command.add_argument("--project", type=Path, help="catalog to extend or create; otherwise discover the sole catalog or OTBM")
			command.add_argument("--resolutions", type=Path, help="explicit reviewed decisions for matching source and OTBM revisions")
		elif name == "revert":
			command.add_argument("--receipt", type=Path, required=True)
		else:
			command.add_argument("--bundle", type=Path, required=True)
		if name in {"apply", "revert"}:
			command.add_argument("--confirm-offline", action="store_true")
	args = parser.parse_args(argv)
	try:
		if args.command != "analyze":
			if args.command == "generate":
				from .convert import generate
				result = generate(Path.cwd(), args.report, args.output, args.world_tool, args.project, args.map, args.resolutions)
			elif args.command == "validate":
				result = validate_bundle(Path.cwd(), args.bundle, args.world_tool, args.map)
			elif args.command == "apply":
				result = apply_bundle(Path.cwd(), args.bundle, args.world_tool, offline=args.confirm_offline, map_override=args.map)
			else:
				result = revert_bundle(Path.cwd(), args.receipt, args.world_tool, offline=args.confirm_offline, map_override=args.map)
			print(json.dumps(result, ensure_ascii=False, indent=2))
			return 1 if result.get("pending") else 0
		if args.all and (args.file or args.table or args.entry):
			parser.error("--all cannot be combined with selectors")
		report = analyze(Path.cwd(), args.datapack, selected_file=args.file, selected_table=args.table, entries=args.entry)
		if args.report:
			args.report.parent.mkdir(parents=True, exist_ok=True)
			# A report is an explicit output, not an activation or source edit.
			args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2, allow_nan=False) + "\n", encoding="utf-8", newline="\n")
		print(json.dumps(report["summary"], ensure_ascii=False, indent=2))
		for issue in report["issues"]:
			print(f"{issue['file']}:{issue.get('line', 1)}: {issue['message']}", file=sys.stderr)
		return 1 if report["issues"] else 0
	except (ValueError, OSError) as error:
		print(f"world-migrate: {error}", file=sys.stderr)
		return 2
