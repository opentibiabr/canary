#!/usr/bin/env python3
"""Build a machine-readable structural index of a Canary repository."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

SKIP_DIRS = {".git", "build", "vcpkg_installed", "node_modules", ".cache", ".idea", ".vscode"}
TEXT_EXTENSIONS = {".lua", ".xml", ".cpp", ".cc", ".cxx", ".h", ".hpp", ".sql", ".json", ".yml", ".yaml", ".toml", ".md", ".txt"}

CATEGORY_HINTS = {
    "maps": {".otbm", ".otgz"},
    "items": {"items.xml", "items.otb"},
    "monsters": {"monster", "monsters"},
    "npcs": {"npc", "npcs"},
    "quests": {"quest", "quests"},
    "spells": {"spell", "spells"},
    "actions": {"action", "actions"},
    "movements": {"movement", "movements"},
    "creaturescripts": {"creaturescript", "creaturescripts"},
    "globalevents": {"globalevent", "globalevents"},
    "raids": {"raid", "raids"},
    "database": {"schema.sql", "migrations", "database"},
    "tests": {"test", "tests"},
    "engine": {"src", "source", "cmake"},
    "docker": {"docker"},
    "documentation": {"docs", "documentation"},
}


def iter_files(root: Path) -> Iterable[Path]:
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(part in SKIP_DIRS for part in path.relative_to(root).parts):
            continue
        yield path


def git_head(root: Path) -> str:
    try:
        return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True, stderr=subprocess.DEVNULL).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "unknown"


def classify(path: Path) -> list[str]:
    rel_parts = [part.lower() for part in path.parts]
    name = path.name.lower()
    suffix = path.suffix.lower()
    categories: set[str] = set()

    for category, hints in CATEGORY_HINTS.items():
        for hint in hints:
            if hint.startswith(".") and suffix == hint:
                categories.add(category)
            elif hint == name or hint in rel_parts:
                categories.add(category)

    if suffix in {".cpp", ".cc", ".cxx", ".h", ".hpp"}:
        categories.add("engine")
    if suffix == ".lua":
        categories.add("lua")
    if suffix == ".xml":
        categories.add("xml")
    if suffix == ".sql":
        categories.add("database")
    if suffix in {".otbm", ".otgz"}:
        categories.add("maps")

    return sorted(categories)


def file_record(path: Path, root: Path) -> dict[str, Any]:
    rel = path.relative_to(root).as_posix()
    size = path.stat().st_size
    record: dict[str, Any] = {
        "path": rel,
        "extension": path.suffix.lower(),
        "sizeBytes": size,
        "categories": classify(Path(rel)),
    }
    if path.suffix.lower() in TEXT_EXTENSIONS and size <= 2_000_000:
        try:
            data = path.read_bytes()
            record["sha256"] = hashlib.sha256(data).hexdigest()
            record["lineCount"] = data.count(b"\n") + (1 if data else 0)
        except OSError:
            pass
    return record


def build_index(root: Path) -> dict[str, Any]:
    files = [file_record(path, root) for path in iter_files(root)]
    category_counts: Counter[str] = Counter()
    extension_counts: Counter[str] = Counter()
    category_files: dict[str, list[str]] = defaultdict(list)

    for record in files:
        extension_counts[record["extension"] or "<none>"] += 1
        for category in record["categories"]:
            category_counts[category] += 1
            category_files[category].append(record["path"])

    return {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "baseCommit": git_head(root),
        "summary": {
            "fileCount": len(files),
            "totalBytes": sum(record["sizeBytes"] for record in files),
            "categoryCounts": dict(sorted(category_counts.items())),
            "extensionCounts": dict(sorted(extension_counts.items())),
        },
        "categories": {key: sorted(value) for key, value in sorted(category_files.items())},
        "files": sorted(files, key=lambda item: item["path"]),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--output", type=Path, default=Path("docs/ai-agent/PROJECT_STRUCTURE.json"))
    args = parser.parse_args()

    root = args.root.resolve()
    output = args.output if args.output.is_absolute() else root / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    index = build_index(root)
    output.write_text(json.dumps(index, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(index["summary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
