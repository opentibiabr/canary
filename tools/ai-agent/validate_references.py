#!/usr/bin/env python3
"""Validate gameplay references against generated content and identifier indexes."""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path
from typing import Any


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def validate(content: dict[str, Any], registry: dict[str, Any]) -> dict[str, Any]:
    definitions: dict[str, set[str]] = defaultdict(set)
    for entry in content.get("entries", []):
        definitions[entry["type"]].add(str(entry["name"]).casefold())

    known_ids: dict[str, set[int]] = {}
    for namespace, data in registry.get("namespaces", {}).items():
        known_ids[namespace] = {int(entry["value"]) for entry in data.get("entries", [])}

    findings: list[dict[str, Any]] = []

    for entry in content.get("entries", []):
        source = entry["path"]
        refs = entry.get("references", {})

        for name in refs.get("monster", []):
            if str(name).casefold() not in definitions.get("monster", set()):
                findings.append({
                    "severity": "warning",
                    "type": "missing-monster",
                    "source": source,
                    "value": name,
                })

        for name in refs.get("npc", []):
            if str(name).casefold() not in definitions.get("npc", set()):
                findings.append({
                    "severity": "warning",
                    "type": "missing-npc",
                    "source": source,
                    "value": name,
                })

        for value in refs.get("item", []):
            if int(value) not in known_ids.get("itemId", set()):
                findings.append({
                    "severity": "warning",
                    "type": "missing-item-id",
                    "source": source,
                    "value": int(value),
                })

        for value in refs.get("storage", []):
            if int(value) not in known_ids.get("storage", set()):
                findings.append({
                    "severity": "info",
                    "type": "unregistered-storage",
                    "source": source,
                    "value": int(value),
                })

    counts: dict[str, int] = defaultdict(int)
    for finding in findings:
        counts[finding["type"]] += 1

    return {
        "schemaVersion": 1,
        "summary": {
            "findingCount": len(findings),
            "countsByType": dict(sorted(counts.items())),
        },
        "findings": sorted(
            findings,
            key=lambda item: (item["severity"], item["type"], item["source"], str(item["value"])),
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--content", type=Path, required=True)
    parser.add_argument("--registry", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    report = validate(load_json(args.content), load_json(args.registry))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(report["summary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
