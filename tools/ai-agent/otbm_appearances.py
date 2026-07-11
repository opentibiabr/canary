from __future__ import annotations

import hashlib
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterator

APPEARANCES_INDEX_FORMAT = "canary-appearances-index-v1"
MAX_MESSAGE_SIZE = 512 * 1024 * 1024
MAX_NESTING_DEPTH = 32
MAX_VARINT_BYTES = 10


class ProtobufDecodeError(ValueError):
    pass


@dataclass
class Issues:
    entries: list[dict[str, Any]] = field(default_factory=list)

    def add(self, severity: str, code: str, message: str, **details: Any) -> None:
        self.entries.append({"severity": severity, "code": code, "message": message, **details})

    def summary(self) -> dict[str, int]:
        counts = Counter(entry["severity"] for entry in self.entries)
        return {severity: counts.get(severity, 0) for severity in ("error", "warning", "info")}


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(4 * 1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _read_varint(data: bytes | memoryview, offset: int) -> tuple[int, int]:
    result = 0
    shift = 0
    for _ in range(MAX_VARINT_BYTES):
        if offset >= len(data):
            raise ProtobufDecodeError("Unexpected end of message while reading varint")
        byte = data[offset]
        offset += 1
        result |= (byte & 0x7F) << shift
        if not byte & 0x80:
            return result, offset
        shift += 7
    raise ProtobufDecodeError("Varint exceeds 10 bytes")


def _iter_fields(data: bytes | memoryview, *, depth: int = 0) -> Iterator[tuple[int, int, int | memoryview]]:
    if depth > MAX_NESTING_DEPTH:
        raise ProtobufDecodeError(f"Message nesting exceeds {MAX_NESTING_DEPTH}")
    offset = 0
    view = memoryview(data)
    while offset < len(view):
        key, offset = _read_varint(view, offset)
        field_number = key >> 3
        wire_type = key & 0x07
        if field_number == 0:
            raise ProtobufDecodeError("Field number 0 is invalid")
        if wire_type == 0:
            value, offset = _read_varint(view, offset)
            yield field_number, wire_type, value
        elif wire_type == 1:
            if offset + 8 > len(view):
                raise ProtobufDecodeError("Truncated fixed64 field")
            yield field_number, wire_type, view[offset : offset + 8]
            offset += 8
        elif wire_type == 2:
            length, offset = _read_varint(view, offset)
            if length > MAX_MESSAGE_SIZE or offset + length > len(view):
                raise ProtobufDecodeError(f"Invalid length-delimited field length: {length}")
            yield field_number, wire_type, view[offset : offset + length]
            offset += length
        elif wire_type == 5:
            if offset + 4 > len(view):
                raise ProtobufDecodeError("Truncated fixed32 field")
            yield field_number, wire_type, view[offset : offset + 4]
            offset += 4
        else:
            raise ProtobufDecodeError(f"Unsupported protobuf wire type {wire_type}")


def _decode_text(value: memoryview, issues: Issues, location: str) -> str:
    try:
        return bytes(value).decode("utf-8")
    except UnicodeDecodeError:
        issues.add("warning", "invalid_utf8", "String field is not valid UTF-8", location=location)
        return bytes(value).decode("utf-8", errors="replace")


def _parse_simple_uint_message(data: memoryview, fields: dict[int, str], *, depth: int) -> dict[str, int]:
    result: dict[str, int] = {}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if field_number in fields and wire_type == 0:
            result[fields[field_number]] = int(value)
    return result


BOOL_FLAGS = {
    2: "clip",
    3: "bottom",
    4: "top",
    5: "container",
    6: "cumulative",
    7: "usable",
    8: "forceUse",
    9: "multiUse",
    12: "liquidPool",
    13: "unpassable",
    14: "unmovable",
    15: "blocksSight",
    16: "avoid",
    17: "noMovementAnimation",
    18: "takeable",
    19: "liquidContainer",
    20: "hangable",
    22: "rotatable",
    24: "dontHide",
    25: "translucent",
    28: "lyingObject",
    29: "animateAlways",
    32: "fullBank",
    33: "ignoreLook",
    37: "wrappable",
    38: "unwrappable",
    39: "topEffect",
    42: "corpse",
    43: "playerCorpse",
    45: "ammunition",
    46: "showOffSocket",
    47: "reportable",
    53: "wearOut",
    54: "clockExpire",
    55: "expire",
    56: "expireStop",
    57: "decoKit",
    59: "dualWielding",
    70: "hookSouth",
    71: "hookEast",
}


def _parse_flags(data: memoryview, *, depth: int) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if field_number in BOOL_FLAGS and wire_type == 0:
            result[BOOL_FLAGS[field_number]] = bool(value)
        elif field_number == 1 and wire_type == 2:
            result["bank"] = _parse_simple_uint_message(value, {1: "waypoints"}, depth=depth + 1)
        elif field_number == 10 and wire_type == 2:
            result["write"] = _parse_simple_uint_message(value, {1: "maxTextLength"}, depth=depth + 1)
        elif field_number == 11 and wire_type == 2:
            result["writeOnce"] = _parse_simple_uint_message(value, {1: "maxTextLength"}, depth=depth + 1)
        elif field_number == 23 and wire_type == 2:
            result["light"] = _parse_simple_uint_message(value, {1: "brightness", 2: "color"}, depth=depth + 1)
        elif field_number == 26 and wire_type == 2:
            result["shift"] = _parse_simple_uint_message(value, {1: "x", 2: "y"}, depth=depth + 1)
        elif field_number == 27 and wire_type == 2:
            result["height"] = _parse_simple_uint_message(value, {1: "elevation"}, depth=depth + 1)
        elif field_number == 30 and wire_type == 2:
            result["automap"] = _parse_simple_uint_message(value, {1: "color"}, depth=depth + 1)
        elif field_number == 31 and wire_type == 2:
            result["lensHelp"] = _parse_simple_uint_message(value, {1: "id"}, depth=depth + 1)
        elif field_number == 34 and wire_type == 2:
            result["clothes"] = _parse_simple_uint_message(value, {1: "slot"}, depth=depth + 1)
        elif field_number == 35 and wire_type == 2:
            result["defaultAction"] = _parse_simple_uint_message(value, {1: "action"}, depth=depth + 1)
        elif field_number == 41 and wire_type == 2:
            result["changedToExpire"] = _parse_simple_uint_message(value, {1: "formerObjectTypeId"}, depth=depth + 1)
        elif field_number == 44 and wire_type == 2:
            result["cyclopedia"] = _parse_simple_uint_message(value, {1: "type"}, depth=depth + 1)
        elif field_number == 48 and wire_type == 2:
            result["upgradeClassification"] = _parse_simple_uint_message(value, {1: "classification"}, depth=depth + 1)
        elif field_number == 58 and wire_type == 2:
            result["skillWheelGem"] = _parse_simple_uint_message(value, {1: "qualityId", 2: "vocationId"}, depth=depth + 1)
        elif field_number == 60 and wire_type == 2:
            result["imbueable"] = _parse_simple_uint_message(value, {1: "slotCount"}, depth=depth + 1)
        elif field_number == 61 and wire_type == 2:
            result["proficiency"] = _parse_simple_uint_message(value, {1: "id"}, depth=depth + 1)
        elif field_number == 63 and wire_type == 0:
            result["minimumLevel"] = int(value)
        elif field_number == 64 and wire_type == 0:
            result["weaponType"] = int(value)
        elif field_number == 72 and wire_type == 2:
            result["transparencyLevel"] = _parse_simple_uint_message(value, {1: "level"}, depth=depth + 1)
    return result


def _parse_packed_varints(data: memoryview) -> list[int]:
    values: list[int] = []
    offset = 0
    while offset < len(data):
        value, offset = _read_varint(data, offset)
        values.append(value)
    return values


def _parse_animation(data: memoryview, *, depth: int) -> dict[str, Any]:
    result: dict[str, Any] = {"phases": []}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if wire_type == 0 and field_number == 1:
            result["defaultStartPhase"] = int(value)
        elif wire_type == 0 and field_number == 2:
            result["synchronized"] = bool(value)
        elif wire_type == 0 and field_number == 3:
            result["randomStartPhase"] = bool(value)
        elif wire_type == 0 and field_number == 4:
            signed = int(value)
            if signed >= 1 << 63:
                signed -= 1 << 64
            result["loopType"] = signed
        elif wire_type == 0 and field_number == 5:
            result["loopCount"] = int(value)
        elif wire_type == 2 and field_number == 6:
            result["phases"].append(_parse_simple_uint_message(value, {1: "durationMin", 2: "durationMax"}, depth=depth + 1))
    return result


def _parse_sprite_info(data: memoryview, *, depth: int) -> dict[str, Any]:
    result: dict[str, Any] = {"spriteIds": []}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if wire_type == 0 and field_number == 1:
            result["patternWidth"] = int(value)
        elif wire_type == 0 and field_number == 2:
            result["patternHeight"] = int(value)
        elif wire_type == 0 and field_number == 3:
            result["patternDepth"] = int(value)
        elif wire_type == 0 and field_number == 4:
            result["layers"] = int(value)
        elif field_number == 5:
            if wire_type == 0:
                result["spriteIds"].append(int(value))
            elif wire_type == 2:
                result["spriteIds"].extend(_parse_packed_varints(value))
        elif wire_type == 2 and field_number == 6:
            result["animation"] = _parse_animation(value, depth=depth + 1)
        elif wire_type == 0 and field_number == 7:
            result["boundingSquare"] = int(value)
        elif wire_type == 0 and field_number == 8:
            result["opaque"] = bool(value)
    result.setdefault("patternWidth", 1)
    result.setdefault("patternHeight", 1)
    result.setdefault("patternDepth", 1)
    result.setdefault("layers", 1)
    return result


def _parse_frame_group(data: memoryview, *, depth: int) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if wire_type == 0 and field_number == 1:
            result["fixedFrameGroup"] = int(value)
        elif wire_type == 0 and field_number == 2:
            result["id"] = int(value)
        elif wire_type == 2 and field_number == 3:
            result["spriteInfo"] = _parse_sprite_info(value, depth=depth + 1)
    return result


def _parse_appearance(data: memoryview, issues: Issues, *, category: str, index: int, depth: int) -> dict[str, Any]:
    result: dict[str, Any] = {"category": category, "frameGroups": []}
    for field_number, wire_type, value in _iter_fields(data, depth=depth):
        if wire_type == 0 and field_number == 1:
            result["id"] = int(value)
        elif wire_type == 2 and field_number == 2:
            result["frameGroups"].append(_parse_frame_group(value, depth=depth + 1))
        elif wire_type == 2 and field_number == 3:
            result["flags"] = _parse_flags(value, depth=depth + 1)
        elif wire_type == 2 and field_number == 4:
            result["name"] = _decode_text(value, issues, f"{category}[{index}].name")
        elif wire_type == 2 and field_number == 5:
            result["description"] = _decode_text(value, issues, f"{category}[{index}].description")
    return result


def _sprite_coverage(asset_index: dict[str, Any] | None) -> list[tuple[int, int]]:
    if not asset_index:
        return []
    ranges: list[tuple[int, int]] = []
    for entry in asset_index.get("sprites", []):
        first = entry.get("firstSpriteId")
        last = entry.get("lastSpriteId")
        if isinstance(first, int) and isinstance(last, int) and first <= last:
            ranges.append((first, last))
    ranges.sort()
    return ranges


def _is_sprite_covered(sprite_id: int, ranges: list[tuple[int, int]]) -> bool:
    for first, last in ranges:
        if sprite_id < first:
            return False
        if first <= sprite_id <= last:
            return True
    return False


def build_appearances_index(path: Path, *, asset_index: dict[str, Any] | None = None, include_non_objects: bool = False) -> dict[str, Any]:
    source = path.resolve()
    if not source.is_file():
        raise FileNotFoundError(f"appearances file does not exist: {source}")
    size = source.stat().st_size
    if size > MAX_MESSAGE_SIZE:
        raise ValueError(f"appearances file exceeds {MAX_MESSAGE_SIZE} bytes")
    data = source.read_bytes()
    issues = Issues()
    categories = {1: "object", 2: "outfit", 3: "effect", 4: "missile"}
    counts: Counter[str] = Counter()
    appearances: list[dict[str, Any]] = []
    seen_ids: dict[str, set[int]] = {name: set() for name in categories.values()}

    for field_number, wire_type, value in _iter_fields(data):
        category = categories.get(field_number)
        if category is None or wire_type != 2:
            continue
        index = counts[category]
        counts[category] += 1
        appearance = _parse_appearance(value, issues, category=category, index=index, depth=1)
        appearance_id = appearance.get("id")
        if not isinstance(appearance_id, int):
            issues.add("error", "missing_appearance_id", f"{category} appearance has no ID", category=category, index=index)
        elif appearance_id in seen_ids[category]:
            issues.add("error", "duplicate_appearance_id", f"Duplicate {category} appearance ID {appearance_id}", category=category, appearanceId=appearance_id)
        else:
            seen_ids[category].add(appearance_id)
        if category == "object" or include_non_objects:
            appearances.append(appearance)

    object_entries = [entry for entry in appearances if entry["category"] == "object"]
    sprite_ids = [
        sprite_id
        for entry in appearances
        for group in entry.get("frameGroups", [])
        for sprite_id in group.get("spriteInfo", {}).get("spriteIds", [])
    ]
    zero_sprite_references = sum(1 for sprite_id in sprite_ids if sprite_id == 0)
    ranges = _sprite_coverage(asset_index)
    uncovered = sorted({sprite_id for sprite_id in sprite_ids if sprite_id != 0 and ranges and not _is_sprite_covered(sprite_id, ranges)})
    if zero_sprite_references:
        issues.add("warning", "zero_sprite_reference", f"Found {zero_sprite_references} references to sprite ID 0", count=zero_sprite_references)
    if uncovered:
        issues.add("error", "uncovered_sprite_ids", f"{len(uncovered)} sprite IDs are outside the indexed asset ranges", count=len(uncovered), sample=uncovered[:100])

    missing_flags = sum(1 for entry in object_entries if "flags" not in entry)
    missing_frame_groups = sum(1 for entry in object_entries if not entry.get("frameGroups"))
    if missing_flags:
        issues.add("warning", "objects_without_flags", f"{missing_flags} objects have no flags message", count=missing_flags)
    if missing_frame_groups:
        issues.add("warning", "objects_without_frame_groups", f"{missing_frame_groups} objects have no frame groups", count=missing_frame_groups)

    issue_summary = issues.summary()
    return {
        "format": APPEARANCES_INDEX_FORMAT,
        "ok": issue_summary["error"] == 0,
        "source": {"path": str(source), "size": size, "sha256": _sha256(source)},
        "categories": {name: counts.get(name, 0) for name in categories.values()},
        "includeNonObjects": include_non_objects,
        "appearances": appearances,
        "summary": {
            "indexedAppearances": len(appearances),
            "objectCount": counts.get("object", 0),
            "uniqueObjectIds": len(seen_ids["object"]),
            "frameGroupCount": sum(len(entry.get("frameGroups", [])) for entry in appearances),
            "spriteReferenceCount": len(sprite_ids),
            "uniqueSpriteIds": len(set(sprite_ids)),
            "minimumSpriteId": min(sprite_ids) if sprite_ids else None,
            "maximumSpriteId": max(sprite_ids) if sprite_ids else None,
            "uncoveredSpriteIdCount": len(uncovered),
            "missingFlags": missing_flags,
            "missingFrameGroups": missing_frame_groups,
        },
        "issueSummary": issue_summary,
        "issues": issues.entries,
    }
