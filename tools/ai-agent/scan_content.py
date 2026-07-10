#!/usr/bin/env python3
"""Index Canary gameplay content and simple cross-file references."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

SKIP_DIRS = {".git", "build", "vcpkg_installed", "node_modules", ".cache", ".idea", ".vscode"}
TEXT_EXTENSIONS = {".lua", ".xml", ".json", ".yml", ".yaml"}

CATEGORY_DIRS = {
    "monster": {"monster", "monsters"},
    "npc": {"npc", "npcs"},
    "quest": {"quest", "quests"},
    "spell": {"spell", "spells"},
    "raid": {"raid", "raids"},
    "action": {"action", "actions"},
    "movement": {"movement", "movements"},
    "creaturescript": {"creaturescript", "creaturescripts"},
    "globalevent": {"globalevent", "globalevents"},
}

NAME_PATTERNS = [
    re.compile(r"\bname\s*=\s*[\"']([^\"']+)[\"']", re.I),
    re.compile(r"<\w+\b[^>]*\bname=[\"']([^\"']+)[\"']", re.I),
]

REFERENCE_PATTERNS = {
    "monster": [
        re.compile(r"Game\.createMonster\s*\(\s*[\"']([^\"']+)[\"']", re.I),
        re.compile(r"<monster\b[^>]*\bname=[\"']([^\"']+)[\"']", re.I),
    ],
    "npc": [
        re.compile(r"Game\.createNpc\s*\(\s*[\"']([^\"']+)[\"']", re.I),
        re.compile(r"<npc\b[^>]*\bname=[\"']([^\"']+)[\"']", re.I),
    ],
    "item": [
        re.compile(r"\b(?:itemid|itemId|item_id)\s*[=:]\s*[\"']?(\d+)", re.I),
        re.compile(r"\b(?:Game\.createItem|player:addItem|Item)\s*\(\s*(\d+)", re.I),
    ],
    "storage": [
        re.compile(r"\b(?:getStorageValue|setStorageValue)\s*\(\s*(\d{3,})", re.I),
        re.compile(r"\bstorage\w*\s*[=:]\s*(\d{3,})", re.I),
    ],
}


def iter_files(root: Path) -> Iterable[Path]:
    for path in root.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in TEXT_EXTENSIONS:
            continue
        if any(part in SKIP_DIRS for part in path.relative_to(root).parts):
            continue
        yield path


def git_head(root: Path) -> str:
    try:
        return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True, stderr=subprocess.DEVNULL).strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "unknown"


def classify(path: Path) -> str | None:
    parts = {part.lower() for part in path.parts}
    for category, names in CATEGORY_DIRS.items():
        if parts & names:
            return category
    return None


def extract_name(text: str, fallback: str) -> str:
    for pattern in NAME_PATTERNS:
        match = pattern.search(text)
        if match:
            return match.group(1).strip()
    return fallback


def extract_references(text: str) -> dict[str, list[str | int]]:
    refs: dict[str, set[str | int]] = {key: set() for key in REFERENCE_PATTERNS}
    for kind, patterns in REFERENCE_PATTERNS.items():
        for pattern in patterns:
            for match in pattern.finditer(text):
                raw = match.group(1)
                refs[kind].add(int(raw) if raw.isdigit() else raw)
    return {key: sorted(values, key=str) for key, values in refs.items() if values}


def build_index(root: Path) -> dict[str, Any]:
    entries: list[dict[str, Any]] = []
    by_type: dict[str, list[str]] = defaultdict(list)
    definitions: dict[str, dict[str, list[str]]] = defaultdict(lambda: defaultdict(list))

    for path in iter_files(root):
        rel = path.relative_to(root).as_posix()
        category = classify(Path(rel))
        if not category:
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue

        name = extract_name(text, path.stem.replace("_", " ").title())
        entry = {
            "type": category,
            "name": name,
            "path": rel,
            "references": extract_references(text),
        }
        entries.append(entry)
        by_type[category].append(rel)
        definitions[category][name.lower()].append(rel)

    duplicates = []
    for category, names in definitions.items():
        for normalized_name, paths in names.items():
            if len(paths) > 1:
                duplicates.append({
                    "type": category,
                    "name": normalized_name,
                    "paths": sorted(paths),
                })

    return {
        "schemaVersion": 1,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "baseCommit": git_head(root),
        "summary": {
            "entryCount": len(entries),
            "countsByType": {key: len(value) for key, value in sorted(by_type.items())},
            "duplicateDefinitions": len(duplicates),
        },
        "entries": sorted(entries, key=lambda item: (item["type"], item["name"].lower(), item["path"])),
        "duplicates": sorted(duplicates, key=lambda item: (item["type"], item["name"])),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--output", type=Path, default=Path("docs/ai-agent/CONTENT_INDEX.json"))
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
