"""Command line entry point; analysis is read-only unless --report is supplied."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from .inventory import analyze


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
	args = parser.parse_args(argv)
	try:
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
