from __future__ import annotations

import hashlib
import json
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

ASSET_INDEX_FORMAT = "canary-client-assets-index-v1"
CATALOG_FILENAME = "catalog-content.json"


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


def _safe_catalog_path(catalog_dir: Path, value: Any, issues: Issues, location: str) -> Path | None:
    if not isinstance(value, str) or not value.strip():
        issues.add("error", "invalid_asset_filename", "Asset filename must be a non-empty string", location=location)
        return None
    relative = Path(value)
    if relative.is_absolute() or not relative.parts or any(part in {"", ".", ".."} for part in relative.parts):
        issues.add("error", "unsafe_asset_filename", f"Unsafe asset filename: {value}", location=location, filename=value)
        return None
    resolved = (catalog_dir / relative).resolve()
    try:
        resolved.relative_to(catalog_dir.resolve())
    except ValueError:
        issues.add("error", "asset_path_escape", f"Asset path escapes catalog directory: {value}", location=location, filename=value)
        return None
    return resolved


def _candidate_catalogs(root: Path) -> list[Path]:
    candidates = [root / CATALOG_FILENAME, root / "assets" / CATALOG_FILENAME]
    if root.name == "assets":
        candidates.insert(0, root / CATALOG_FILENAME)
    seen: set[Path] = set()
    result: list[Path] = []
    for candidate in candidates:
        resolved = candidate.resolve()
        if resolved in seen:
            continue
        seen.add(resolved)
        result.append(resolved)
    return result


def resolve_catalog(root: Path) -> Path:
    source = root.resolve()
    if source.is_file():
        if source.name != CATALOG_FILENAME:
            raise ValueError(f"Expected {CATALOG_FILENAME}, got {source.name}")
        return source
    for candidate in _candidate_catalogs(source):
        if candidate.is_file():
            return candidate
    raise FileNotFoundError(f"Could not find {CATALOG_FILENAME} under {source} or {source / 'assets'}")


def _load_json(path: Path, issues: Issues, code: str) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        issues.add("error", code, str(exc), path=str(path))
        return None


def _catalog_entries(payload: Any, issues: Issues) -> list[dict[str, Any]]:
    if isinstance(payload, list):
        raw_entries = payload
    elif isinstance(payload, dict) and isinstance(payload.get("content"), list):
        raw_entries = payload["content"]
        issues.add("info", "catalog_content_wrapper", "Catalog entries were read from the 'content' property")
    else:
        issues.add("error", "invalid_catalog_root", "Catalog root must be an array or an object with a content array")
        return []
    entries: list[dict[str, Any]] = []
    for index, entry in enumerate(raw_entries):
        if not isinstance(entry, dict):
            issues.add("error", "invalid_catalog_entry", "Catalog entry must be an object", index=index)
            continue
        entries.append(entry)
    return entries


def _file_record(path: Path | None, catalog_dir: Path, *, hash_files: bool) -> dict[str, Any]:
    if path is None:
        return {"path": None, "relativePath": None, "exists": False, "size": None, "sha256": None}
    exists = path.is_file()
    try:
        relative = path.relative_to(catalog_dir).as_posix()
    except ValueError:
        relative = str(path)
    return {
        "path": str(path),
        "relativePath": relative,
        "exists": exists,
        "size": path.stat().st_size if exists else None,
        "sha256": _sha256(path) if exists and hash_files else None,
    }


def _integer(entry: dict[str, Any], key: str, issues: Issues, index: int, *, minimum: int = 0) -> int | None:
    value = entry.get(key)
    if isinstance(value, bool) or not isinstance(value, int) or value < minimum:
        issues.add("error", "invalid_catalog_integer", f"{key} must be an integer >= {minimum}", index=index, field=key, value=value)
        return None
    return value


def _package_metadata(catalog_path: Path, issues: Issues) -> dict[str, Any] | None:
    candidates = [catalog_path.parent / "package.json", catalog_path.parent.parent / "package.json"]
    for candidate in candidates:
        if not candidate.is_file():
            continue
        payload = _load_json(candidate, issues, "package_json_parse_error")
        if not isinstance(payload, dict):
            issues.add("warning", "invalid_package_json", "package.json root is not an object", path=str(candidate))
            return {"path": str(candidate), "valid": False}
        return {
            "path": str(candidate),
            "valid": True,
            "name": payload.get("name"),
            "version": payload.get("version"),
            "buildVersion": payload.get("buildVersion"),
            "raw": payload,
        }
    issues.add("warning", "missing_package_json", "No package.json was found beside the asset directory")
    return None


def _asset_identifier(catalog_dir: Path, hash_files: bool) -> dict[str, Any] | None:
    path = catalog_dir / "assets.json.sha256"
    if not path.is_file():
        return None
    value = path.read_text(encoding="utf-8-sig", errors="replace").strip()
    record = _file_record(path, catalog_dir, hash_files=hash_files)
    record["value"] = value
    return record


def build_asset_index(root: Path, *, hash_files: bool = True) -> dict[str, Any]:
    requested_root = root.resolve()
    catalog_path = resolve_catalog(requested_root)
    catalog_dir = catalog_path.parent.resolve()
    issues = Issues()
    payload = _load_json(catalog_path, issues, "catalog_parse_error")
    entries = _catalog_entries(payload, issues) if payload is not None else []

    appearances: list[dict[str, Any]] = []
    sprites: list[dict[str, Any]] = []
    other_types: Counter[str] = Counter()
    filenames: Counter[str] = Counter()

    for index, entry in enumerate(entries):
        entry_type = str(entry.get("type", "")).strip().lower()
        location = f"catalog[{index}]"
        path = _safe_catalog_path(catalog_dir, entry.get("file"), issues, location)
        filename = entry.get("file") if isinstance(entry.get("file"), str) else None
        if filename:
            filenames[filename] += 1
        file_data = _file_record(path, catalog_dir, hash_files=hash_files)
        if path is not None and not path.is_file():
            issues.add("error", "missing_asset_file", f"Catalog file does not exist: {filename}", index=index, filename=filename)

        if entry_type == "appearances":
            appearances.append({"catalogIndex": index, "type": entry_type, "file": filename, **file_data})
            continue
        if entry_type == "sprite":
            first = _integer(entry, "firstspriteid", issues, index, minimum=0)
            last = _integer(entry, "lastspriteid", issues, index, minimum=0)
            sprite_type = _integer(entry, "spritetype", issues, index, minimum=0)
            if first is not None and last is not None and first > last:
                issues.add("error", "reversed_sprite_range", f"Sprite range is reversed: {first}..{last}", index=index, firstSpriteId=first, lastSpriteId=last)
            sprites.append(
                {
                    "catalogIndex": index,
                    "type": entry_type,
                    "file": filename,
                    "firstSpriteId": first,
                    "lastSpriteId": last,
                    "spriteType": sprite_type,
                    "compression": "lzma" if isinstance(filename, str) and filename.lower().endswith(".lzma") else "none",
                    **file_data,
                }
            )
            continue
        other_types[entry_type or "<missing>"] += 1
        issues.add("info", "ignored_catalog_type", f"Catalog entry type {entry_type or '<missing>'!r} is not used by the map renderer", index=index)

    if len(appearances) != 1:
        issues.add("error", "appearances_entry_count", f"Expected exactly one appearances entry, found {len(appearances)}", count=len(appearances))

    for filename, count in sorted(filenames.items()):
        if count > 1:
            issues.add("warning", "duplicate_asset_filename", f"Asset filename is referenced {count} times: {filename}", filename=filename, count=count)

    valid_ranges = [
        sprite
        for sprite in sprites
        if isinstance(sprite["firstSpriteId"], int)
        and isinstance(sprite["lastSpriteId"], int)
        and sprite["firstSpriteId"] <= sprite["lastSpriteId"]
    ]
    valid_ranges.sort(key=lambda sprite: (sprite["firstSpriteId"], sprite["lastSpriteId"], sprite["catalogIndex"]))
    gaps: list[dict[str, int]] = []
    overlaps: list[dict[str, int]] = []
    previous_last: int | None = None
    for sprite in valid_ranges:
        first = sprite["firstSpriteId"]
        last = sprite["lastSpriteId"]
        if previous_last is not None:
            if first <= previous_last:
                overlap = {"from": first, "to": min(previous_last, last)}
                overlaps.append(overlap)
                issues.add("error", "overlapping_sprite_ranges", f"Sprite ranges overlap at {overlap['from']}..{overlap['to']}", **overlap)
            elif first > previous_last + 1:
                gap = {"from": previous_last + 1, "to": first - 1}
                gaps.append(gap)
                issues.add("warning", "sprite_range_gap", f"Sprite range gap at {gap['from']}..{gap['to']}", **gap)
        previous_last = last if previous_last is None else max(previous_last, last)

    package = _package_metadata(catalog_path, issues)
    asset_identifier = _asset_identifier(catalog_dir, hash_files)
    issue_summary = issues.summary()
    existing_sprite_files = sum(1 for sprite in sprites if sprite["exists"])
    declared_sprite_count = sum(
        sprite["lastSpriteId"] - sprite["firstSpriteId"] + 1
        for sprite in valid_ranges
    )
    return {
        "format": ASSET_INDEX_FORMAT,
        "ok": issue_summary["error"] == 0,
        "requestedRoot": str(requested_root),
        "catalog": {
            "path": str(catalog_path),
            "directory": str(catalog_dir),
            "sha256": _sha256(catalog_path) if hash_files else None,
            "entryCount": len(entries),
        },
        "package": package,
        "assetIdentifier": asset_identifier,
        "appearances": appearances,
        "sprites": valid_ranges,
        "otherCatalogTypes": dict(sorted(other_types.items())),
        "coverage": {
            "rangeCount": len(valid_ranges),
            "declaredSpriteCount": declared_sprite_count,
            "firstSpriteId": valid_ranges[0]["firstSpriteId"] if valid_ranges else None,
            "lastSpriteId": max((sprite["lastSpriteId"] for sprite in valid_ranges), default=None),
            "gaps": gaps,
            "overlaps": overlaps,
        },
        "summary": {
            "appearancesEntries": len(appearances),
            "spriteEntries": len(sprites),
            "existingSpriteFiles": existing_sprite_files,
            "missingSpriteFiles": len(sprites) - existing_sprite_files,
            "hashesCalculated": hash_files,
        },
        "issueSummary": issue_summary,
        "issues": issues.entries,
    }
