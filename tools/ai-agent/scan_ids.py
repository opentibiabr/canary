#!/usr/bin/env python3
"""Scan a Canary repository for storage, action, unique and item identifiers."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

TEXT_EXTENSIONS = {
    ".lua", ".xml", ".cpp", ".cc", ".cxx", ".h", ".hpp", ".sql", ".json", ".yml", ".yaml", ".toml", ".md"
}
SKIP_DIRS = {".git", "build", "vcpkg_installed", "node_modules", ".cache", ".idea", ".vscode"}

PATTERNS: dict[str, list[tuple[str, re.Pattern[str]]]] = {
    "storage": [
        ("definition", re.compile(r"\b(?:storage|storageValue|storageId|storageKey)\s*[=:]\s*(\d{3,})", re.I)),
        ("reference", re.compile(r"\b(?:getStorageValue|setStorageValue)\s*\(\s*(\d{3,})", re.I)),
    ],
    "actionId": [
        ("definition", re.compile(r"\b(?:actionid|actionId|aid)\s*[=:]\s*[\"']?(\d+)", re.I)),
        ("definition", re.compile(r"\b(?:action|Action)\s*\([^\n]*?\b(?:id|aid)\s*[=:]\s*(\d+)", re.I)),
    ],
    "uniqueId": [
        ("definition", re.compile(r"\b(?:uniqueid|uniqueId|uid)\s*[=:]\s*[\"']?(\d+)", re.I)),
    ],
    "itemId": [
        ("reference", re.compile(r"\b(?:itemid|itemId|item_id|clientid|serverid)\s*[=:]\s*[\"']?(\d+)", re.I)),
        ("reference", re.compile(r"\b(?:Item|Game\.createItem|player:addItem)\s*\(\s*(\d+)", re.I)),
        ("definition", re.compile(r"<item\b[^>]*\bid=[\"'](\d+)[\"']", re.I)),
    ],
}


def iter_files(root: Path) -> Iterable[Path]:
    for path in root.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in TEXT_EXTENSIONS:
            continue
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        yield path


def git_head(root: Path) -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=root, text=True, stderr=subprocess.DEVNULL
        ).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "unknown"


def scan_file(path: Path, root: Path, results: dict[str, dict[int, list[dict[str, Any]]]]) -> None:
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return

    rel = path.relative_to(root).as_posix()
    for line_no, line in enumerate(text.splitlines(), start=1):
        for namespace, patterns in PATTERNS.items():
            seen_on_line: set[tuple[int, str]] = set()
            for role, pattern in patterns:
                for match in pattern.finditer(line):
                    value = int(match.group(1))
                    key = (value, role)
                    if key in seen_on_line:
                        continue
                    seen_on_line.add(key)
                    results[namespace][value].append(
                        {
                            "path": rel,
                            "line": line_no,
                            "context": line.strip()[:300],
                            "role": role,
                        }
                    )


def build_registry(root: Path) -> dict[str, Any]:
    found: dict[str, dict[int, list[dict[str, Any]]]] = {
        key: defaultdict(list) for key in PATTERNS
    }
    for path in iter_files(root):
        scan_file(path, root, found)

    namespaces: dict[str, Any] = {}
    conflicts: list[dict[str, Any]] = []

    for namespace, entries_by_value in found.items():
        entries = []
        for value in sorted(entries_by_value):
            sources = entries_by_value[value]
            entries.append({"value": value, "sources": sources})

            definition_sources = [source for source in sources if source["role"] == "definition"]
            unique_definition_paths = {source["path"] for source in definition_sources}
            if len(unique_definition_paths) > 1:
                conflicts.append(
                    {
                        "namespace": namespace,
                        "value": value,
                        "sources": definition_sources,
                        "severity": "warning",
                        "reason": "Identifier is defined in multiple files; review whether duplication is intentional.",
                    }
                )

        values = list(entries_by_value)
        namespaces[namespace] = {
            "entries": entries,
            **({"minimum": min(values), "maximum": max(values)} if values else {}),
        }

    return {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "baseCommit": git_head(root),
        "namespaces": namespaces,
        "conflicts": conflicts,
        "reservations": [],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd(), help="Repository root")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("docs/ai-agent/ID_REGISTRY.json"),
        help="Output path relative to repository root",
    )
    args = parser.parse_args()

    root = args.root.resolve()
    output = args.output if args.output.is_absolute() else root / args.output
    registry = build_registry(root)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(registry, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    counts = {name: len(data["entries"]) for name, data in registry["namespaces"].items()}
    print(json.dumps({"output": str(output), "counts": counts, "conflicts": len(registry["conflicts"])}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
