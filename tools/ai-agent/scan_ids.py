#!/usr/bin/env python3
"""Scan a Canary repository and optional OTBM maps for identifier usage."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from collections import defaultdict
from collections.abc import Iterable
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

MODULE_DIR = Path(__file__).parent
if str(MODULE_DIR) not in sys.path:
    sys.path.insert(0, str(MODULE_DIR))

from otbm_ids import scan_otbm_identifiers

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


def _source_identity(source: dict[str, Any]) -> tuple[Any, ...]:
    return source.get("path"), source.get("line"), source.get("symbol"), source.get("role")


def _append_conflict(
    conflicts: list[dict[str, Any]],
    namespace: str,
    value: int,
    sources: list[dict[str, Any]],
) -> None:
    definition_sources = [source for source in sources if source["role"] == "definition"]
    locations = {_source_identity(source) for source in definition_sources}
    paths = {source["path"] for source in definition_sources}

    if namespace == "uniqueId" and len(locations) > 1:
        conflicts.append(
            {
                "namespace": namespace,
                "value": value,
                "sources": definition_sources,
                "severity": "error",
                "reason": "Unique ID is defined at multiple locations and must be globally unique.",
            }
        )
    elif namespace == "actionId" and len(locations) > 1:
        conflicts.append(
            {
                "namespace": namespace,
                "value": value,
                "sources": definition_sources,
                "severity": "warning",
                "reason": "Action ID is assigned at multiple locations; reuse may be intentional but must be reviewed.",
            }
        )
    elif len(paths) > 1:
        conflicts.append(
            {
                "namespace": namespace,
                "value": value,
                "sources": definition_sources,
                "severity": "warning",
                "reason": "Identifier is defined in multiple files; review whether duplication is intentional.",
            }
        )


def build_registry(root: Path, maps: Iterable[Path] = ()) -> dict[str, Any]:
    root = root.resolve()
    found: dict[str, dict[int, list[dict[str, Any]]]] = {
        key: defaultdict(list) for key in PATTERNS
    }
    for path in iter_files(root):
        scan_file(path, root, found)

    binary_sources: list[dict[str, Any]] = []
    seen_maps: set[Path] = set()
    for map_path in maps:
        resolved = map_path if map_path.is_absolute() else root / map_path
        resolved = resolved.resolve()
        if resolved in seen_maps:
            continue
        seen_maps.add(resolved)
        scan = scan_otbm_identifiers(resolved, root)
        binary_sources.append(
            {
                key: scan[key]
                for key in ("path", "sha256", "fileSize", "version", "itemsMajor", "itemsMinor", "tileCount", "topLevelItemCount", "counts")
            }
        )
        for namespace, entries in scan["identifiers"].items():
            for value, sources in entries.items():
                found[namespace][int(value)].extend(sources)

    namespaces: dict[str, Any] = {}
    conflicts: list[dict[str, Any]] = []

    for namespace, entries_by_value in found.items():
        entries = []
        for value in sorted(entries_by_value):
            sources = entries_by_value[value]
            entries.append({"value": value, "sources": sources})
            _append_conflict(conflicts, namespace, value, sources)

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
        "binarySources": binary_sources,
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
    parser.add_argument(
        "--map",
        dest="maps",
        action="append",
        type=Path,
        default=[],
        help="Optional OTBM map to scan; may be supplied more than once",
    )
    args = parser.parse_args()

    root = args.root.resolve()
    output = args.output if args.output.is_absolute() else root / args.output
    registry = build_registry(root, args.maps)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(registry, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    counts = {name: len(data["entries"]) for name, data in registry["namespaces"].items()}
    print(
        json.dumps(
            {
                "output": str(output),
                "counts": counts,
                "conflicts": len(registry["conflicts"]),
                "binarySources": len(registry["binarySources"]),
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
