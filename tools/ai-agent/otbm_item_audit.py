from __future__ import annotations

import hashlib
import json
import subprocess
import tempfile
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from otbm_catalog import load_item_catalog

AUDIT_FORMAT = "canary-otbm-item-audit-v1"
SCAN_FORMAT = "canary-otbm-item-scan-v1"

INTERACTIVE_FLAGS = {
    "container",
    "usable",
    "forceUse",
    "multiUse",
    "write",
    "writeOnce",
    "liquidPool",
    "liquidContainer",
    "hangable",
    "rotatable",
    "wrappable",
    "unwrappable",
    "corpse",
    "playerCorpse",
    "ammunition",
    "imbueable",
    "defaultAction",
    "clothes",
    "changedToExpire",
    "upgradeClassification",
    "skillWheelGem",
    "proficiency",
}

MECHANIC_KEYS = ("actionId", "uniqueId", "teleportDestination", "houseDoorId")


class ItemAuditError(RuntimeError):
    pass


def sha256_path(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(4 * 1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ItemAuditError(f"Cannot read JSON {path}: {exc}") from exc
    if not isinstance(payload, dict):
        raise ItemAuditError(f"JSON root must be an object: {path}")
    return payload


def run_native_item_scan(scanner: Path, map_path: Path, output: Path) -> dict[str, Any]:
    command = [str(scanner.resolve()), str(map_path.resolve()), str(output.resolve())]
    completed = subprocess.run(command, capture_output=True, text=True, check=False)
    if completed.returncode != 0:
        detail = completed.stderr.strip() or completed.stdout.strip() or f"exit code {completed.returncode}"
        raise ItemAuditError(f"Native item scanner failed: {detail}")
    payload = load_json(output)
    if payload.get("format") != SCAN_FORMAT:
        raise ItemAuditError(f"Unsupported item scan format: {payload.get('format')!r}")
    return payload


def appearance_map(payload: dict[str, Any]) -> dict[int, dict[str, Any]]:
    appearances = payload.get("appearances")
    if not isinstance(appearances, list):
        raise ItemAuditError("Appearances index has no appearances array")
    result: dict[int, dict[str, Any]] = {}
    for entry in appearances:
        if not isinstance(entry, dict) or entry.get("category") != "object":
            continue
        item_id = entry.get("id")
        if isinstance(item_id, int) and not isinstance(item_id, bool):
            result[item_id] = entry
    return result


def interactive_flags(appearance: dict[str, Any]) -> list[str]:
    flags = appearance.get("flags")
    if not isinstance(flags, dict):
        return []
    return sorted(flag for flag in INTERACTIVE_FLAGS if flag in flags and flags[flag] not in (False, None, {}, []))


def _usage_entry(entry: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": int(entry["id"]),
        "placements": int(entry.get("placements", 0)),
        "inlinePlacements": int(entry.get("inlinePlacements", 0)),
        "itemNodePlacements": int(entry.get("itemNodePlacements", 0)),
        "attributes": dict(entry.get("attributes", {})),
    }


def _sorted_entries(entries: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return sorted(entries, key=lambda entry: (-int(entry.get("placements", 0)), int(entry["id"])))


def build_item_audit(
    *,
    scan: dict[str, Any],
    appearances_index: dict[str, Any],
    items_xml: Path,
    map_path: Path | None = None,
    include_map_hash: bool = True,
) -> dict[str, Any]:
    if scan.get("format") != SCAN_FORMAT:
        raise ItemAuditError(f"Unsupported item scan format: {scan.get('format')!r}")
    items = scan.get("items")
    mechanics = scan.get("mechanicPlacements")
    if not isinstance(items, list) or not isinstance(mechanics, list):
        raise ItemAuditError("Item scan must contain items and mechanicPlacements arrays")

    appearances = appearance_map(appearances_index)
    catalog = load_item_catalog(items_xml)
    mechanic_item_ids = {
        int(entry["itemId"])
        for entry in mechanics
        if isinstance(entry, dict) and isinstance(entry.get("itemId"), int)
    }

    missing_appearance: list[dict[str, Any]] = []
    without_xml: list[dict[str, Any]] = []
    interactive_without_xml: list[dict[str, Any]] = []
    appearance_only_decoration: list[dict[str, Any]] = []
    mechanic_items: list[dict[str, Any]] = []
    explicit_xml: list[dict[str, Any]] = []
    used_placements = 0

    for raw in items:
        if not isinstance(raw, dict) or not isinstance(raw.get("id"), int):
            raise ItemAuditError("Invalid item usage entry")
        usage = _usage_entry(raw)
        item_id = usage["id"]
        used_placements += usage["placements"]
        appearance = appearances.get(item_id)
        xml_info = catalog.lookup(item_id)
        flags = interactive_flags(appearance) if appearance else []
        detail = {
            **usage,
            "appearanceName": appearance.get("name") if appearance else None,
            "interactiveAppearanceFlags": flags,
            "itemsXml": xml_info.to_json() if xml_info else None,
            "hasMapMechanic": item_id in mechanic_item_ids,
        }
        if appearance is None:
            missing_appearance.append(detail)
        if xml_info is None:
            without_xml.append(detail)
            if flags or item_id in mechanic_item_ids:
                interactive_without_xml.append(detail)
            else:
                appearance_only_decoration.append(detail)
        else:
            explicit_xml.append(detail)
        if item_id in mechanic_item_ids:
            mechanic_items.append(detail)

    mechanic_counts = Counter()
    action_values: Counter[int] = Counter()
    unique_values: Counter[int] = Counter()
    destinations: Counter[tuple[int, int, int]] = Counter()
    mechanics_by_item: defaultdict[int, int] = defaultdict(int)
    for entry in mechanics:
        if not isinstance(entry, dict):
            raise ItemAuditError("Invalid mechanic placement entry")
        item_id = int(entry["itemId"])
        mechanics_by_item[item_id] += 1
        for key in MECHANIC_KEYS:
            if key in entry:
                mechanic_counts[key] += 1
        if isinstance(entry.get("actionId"), int):
            action_values[int(entry["actionId"])] += 1
        if isinstance(entry.get("uniqueId"), int):
            unique_values[int(entry["uniqueId"])] += 1
        destination = entry.get("teleportDestination")
        if isinstance(destination, list) and len(destination) == 3 and all(isinstance(value, int) for value in destination):
            destinations[tuple(destination)] += 1

    map_source = dict(scan.get("source") or {})
    if map_path is not None:
        source = map_path.resolve()
        map_source.update(
            {
                "path": str(source),
                "size": source.stat().st_size,
                "sha256": sha256_path(source) if include_map_hash else None,
            }
        )

    missing_appearance = _sorted_entries(missing_appearance)
    without_xml = _sorted_entries(without_xml)
    interactive_without_xml = _sorted_entries(interactive_without_xml)
    appearance_only_decoration = _sorted_entries(appearance_only_decoration)
    mechanic_items = _sorted_entries(mechanic_items)

    summary = {
        "tileCount": int(scan.get("tileCount", 0)),
        "usedItemIds": len(items),
        "totalPlacements": used_placements,
        "inlinePlacements": int(scan.get("inlinePlacements", 0)),
        "itemNodePlacements": int(scan.get("itemNodePlacements", 0)),
        "missingAppearanceIds": len(missing_appearance),
        "missingAppearancePlacements": sum(entry["placements"] for entry in missing_appearance),
        "withoutItemsXmlIds": len(without_xml),
        "withoutItemsXmlPlacements": sum(entry["placements"] for entry in without_xml),
        "interactiveWithoutItemsXmlIds": len(interactive_without_xml),
        "interactiveWithoutItemsXmlPlacements": sum(entry["placements"] for entry in interactive_without_xml),
        "appearanceOnlyDecorationIds": len(appearance_only_decoration),
        "appearanceOnlyDecorationPlacements": sum(entry["placements"] for entry in appearance_only_decoration),
        "mapMechanicItemIds": len(mechanic_items),
        "mapMechanicPlacements": len(mechanics),
        "unknownAttributeTails": int(scan.get("unknownAttributeTails", 0)),
    }
    ok = summary["missingAppearanceIds"] == 0 and summary["unknownAttributeTails"] == 0
    return {
        "format": AUDIT_FORMAT,
        "ok": ok,
        "sources": {
            "map": map_source,
            "appearances": appearances_index.get("source"),
            "itemsXml": catalog.metadata(),
        },
        "summary": summary,
        "mechanicSummary": {
            "attributePlacements": dict(sorted(mechanic_counts.items())),
            "actionIds": [{"value": value, "placements": count} for value, count in sorted(action_values.items())],
            "uniqueIds": [{"value": value, "placements": count} for value, count in sorted(unique_values.items())],
            "teleportDestinations": [
                {"position": list(position), "placements": count}
                for position, count in sorted(destinations.items(), key=lambda item: (-item[1], item[0]))
            ],
        },
        "missingAppearances": missing_appearance,
        "withoutItemsXml": without_xml,
        "interactiveWithoutItemsXml": interactive_without_xml,
        "appearanceOnlyDecorations": appearance_only_decoration,
        "mapMechanicItems": mechanic_items,
        "mechanicPlacements": mechanics,
        "unknownAttributeTypes": scan.get("unknownAttributeTypes", {}),
        "notes": [
            "Canary creates base ItemType records from appearances.dat before applying items.xml overrides.",
            "An item without an explicit items.xml entry is not automatically unsupported.",
            "Interactive appearances and map-level actionId, uniqueId, houseDoorId, or teleport destinations require additional script and gameplay review.",
        ],
    }


def audit_from_files(
    *,
    map_path: Path,
    scanner: Path,
    appearances_index_path: Path,
    items_xml: Path,
    output: Path,
    scan_output: Path | None = None,
    include_map_hash: bool = True,
) -> dict[str, Any]:
    if not scanner.is_file():
        raise FileNotFoundError(scanner)
    if not map_path.is_file():
        raise FileNotFoundError(map_path)
    appearances_index = load_json(appearances_index_path)
    if scan_output is None:
        with tempfile.TemporaryDirectory(prefix="otbm-item-audit-") as temporary:
            scan_path = Path(temporary) / "item-scan.json"
            scan = run_native_item_scan(scanner, map_path, scan_path)
    else:
        scan_output.parent.mkdir(parents=True, exist_ok=True)
        scan = run_native_item_scan(scanner, map_path, scan_output)
    report = build_item_audit(
        scan=scan,
        appearances_index=appearances_index,
        items_xml=items_xml,
        map_path=map_path,
        include_map_hash=include_map_hash,
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return report
