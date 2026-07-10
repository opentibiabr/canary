#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ALLOWED_TYPES = {"quest", "npc", "monster", "item"}
SAFE_ID = re.compile(r"^[a-z0-9][a-z0-9_-]{0,63}$")


def _norm_name(value: str) -> str:
    return " ".join(value.casefold().split())


def normalize(raw: dict, content_index: dict) -> dict:
    findings: list[dict] = []
    entities: list[dict] = []
    seen_ids: set[str] = set()

    indexed: dict[tuple[str, str], list[dict]] = {}
    for entry in content_index.get("entries", []):
        key = (entry.get("type", ""), _norm_name(str(entry.get("name", ""))))
        indexed.setdefault(key, []).append(entry)

    for position, entity in enumerate(raw.get("entities", [])):
        entity_id = entity.get("id")
        entity_type = entity.get("type")
        name = entity.get("name")
        if not isinstance(entity_id, str) or not SAFE_ID.fullmatch(entity_id):
            findings.append({"level": "error", "entity": entity_id, "message": f"entity {position} has invalid id"})
            continue
        if entity_id in seen_ids:
            findings.append({"level": "error", "entity": entity_id, "message": "duplicate entity id"})
            continue
        seen_ids.add(entity_id)
        if entity_type not in ALLOWED_TYPES:
            findings.append({"level": "error", "entity": entity_id, "message": "unsupported entity type"})
            continue
        if not isinstance(name, str) or not name.strip():
            findings.append({"level": "error", "entity": entity_id, "message": "entity name is required"})
            continue

        source_refs = entity.get("sourceRefs", [])
        if not source_refs:
            findings.append({"level": "warning", "entity": entity_id, "message": "entity has no source references"})

        matches = indexed.get((entity_type, _norm_name(name)), [])
        normalized = {
            "id": entity_id,
            "type": entity_type,
            "name": name.strip(),
            "canonical": bool(entity.get("canonical", False)),
            "sourceRefs": source_refs,
            "facts": entity.get("facts", {}),
            "canary": {
                "status": "matched" if matches else "missing",
                "matches": [
                    {"path": item.get("path"), "datapack": item.get("datapack"), "name": item.get("name")}
                    for item in matches
                ],
            },
        }
        entities.append(normalized)

    return {
        "schemaVersion": "1.0",
        "sourceDocument": raw.get("documentId"),
        "entities": entities,
        "summary": {
            "entityCount": len(entities),
            "matchedInCanary": sum(1 for item in entities if item["canary"]["status"] == "matched"),
            "missingInCanary": sum(1 for item in entities if item["canary"]["status"] == "missing"),
            "findingCount": len(findings),
        },
        "findings": findings,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--content-index", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    result = normalize(
        json.loads(args.input.read_text(encoding="utf-8")),
        json.loads(args.content_index.read_text(encoding="utf-8")),
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(result["summary"], indent=2))
    return 1 if any(item["level"] == "error" for item in result["findings"]) else 0


if __name__ == "__main__":
    raise SystemExit(main())
