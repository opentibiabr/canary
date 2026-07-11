from __future__ import annotations

import hashlib
import html
import xml.etree.ElementTree as ET
from collections import Counter
from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from otbm_binary import TileRecord, _require, tile_view

CATALOG_FORMAT = "canary-item-catalog-v1"


@dataclass(frozen=True)
class ItemInfo:
    item_id: int
    name: str | None
    article: str | None
    plural: str | None
    item_type: str | None
    category: str
    attributes: dict[str, Any]

    def to_json(self) -> dict[str, Any]:
        return {
            "id": self.item_id,
            "name": self.name,
            "article": self.article,
            "plural": self.plural,
            "type": self.item_type,
            "category": self.category,
            "attributes": self.attributes,
        }


@dataclass(frozen=True)
class ItemCatalog:
    source: Path
    sha256: str
    items: dict[int, ItemInfo]
    diagnostics: tuple[dict[str, Any], ...]

    def lookup(self, item_id: int) -> ItemInfo | None:
        return self.items.get(item_id)

    def metadata(self) -> dict[str, Any]:
        categories = Counter(item.category for item in self.items.values())
        named = sum(1 for item in self.items.values() if item.name)
        return {
            "format": CATALOG_FORMAT,
            "source": str(self.source),
            "sha256": self.sha256,
            "itemCount": len(self.items),
            "namedItemCount": named,
            "categories": dict(sorted(categories.items())),
            "diagnosticCount": len(self.diagnostics),
            "diagnostics": list(self.diagnostics),
        }


def _local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def _coerce_value(value: str) -> Any:
    stripped = value.strip()
    lowered = stripped.lower()
    if lowered in {"true", "false"}:
        return lowered == "true"
    try:
        return int(stripped, 0)
    except ValueError:
        return stripped


def _merge_attribute(attributes: dict[str, Any], key: str, value: Any) -> None:
    if key not in attributes:
        attributes[key] = value
        return
    existing = attributes[key]
    if isinstance(existing, list):
        existing.append(value)
    else:
        attributes[key] = [existing, value]


def _diagnostic(code: str, message: str, **details: Any) -> dict[str, Any]:
    return {"code": code, "message": message, **details}


def _item_ids(element: ET.Element, diagnostics: list[dict[str, Any]]) -> range:
    try:
        if "id" in element.attrib:
            item_id = int(element.attrib["id"])
            if not 0 <= item_id <= 0xFFFF:
                diagnostics.append(_diagnostic("invalid_item_id", f"Skipping item ID outside uint16: {item_id}", itemId=item_id))
                return range(0)
            return range(item_id, item_id + 1)
        if "fromid" not in element.attrib:
            diagnostics.append(_diagnostic("missing_item_id", "Skipping item entry without id or fromid"))
            return range(0)
        if "toid" not in element.attrib:
            diagnostics.append(
                _diagnostic(
                    "missing_toid",
                    f"Skipping fromid={element.attrib['fromid']} without toid",
                    fromId=element.attrib["fromid"],
                )
            )
            return range(0)
        first = int(element.attrib["fromid"])
        last = int(element.attrib["toid"])
    except ValueError as exc:
        diagnostics.append(_diagnostic("invalid_item_id", f"Skipping non-numeric item identifier: {exc}"))
        return range(0)

    if not 0 <= first <= 0xFFFF or not 0 <= last <= 0xFFFF:
        diagnostics.append(
            _diagnostic(
                "invalid_item_range",
                f"Skipping item range outside uint16: {first}..{last}",
                fromId=first,
                toId=last,
            )
        )
        return range(0)
    if first > last:
        diagnostics.append(
            _diagnostic(
                "reversed_item_range",
                f"Skipping reversed item range {first}..{last}, matching Canary's zero-iteration loader behavior",
                fromId=first,
                toId=last,
            )
        )
        return range(0)
    return range(first, last + 1)


def _category(item_type: str | None, attributes: Mapping[str, Any]) -> str:
    normalized_type = (item_type or "").strip().lower().replace(" ", "_")
    aliases = {
        "container": "container",
        "depot": "container",
        "mailbox": "mailbox",
        "trashholder": "trash",
        "teleport": "teleport",
        "door": "door",
        "magicfield": "field",
        "bed": "bed",
        "key": "key",
        "rune": "rune",
    }
    if normalized_type in aliases:
        return aliases[normalized_type]
    keys = {key.lower() for key in attributes}
    if "floorchange" in keys:
        return "floor_change"
    if "field" in keys or "conditiondamage" in keys:
        return "field"
    if "doorid" in keys or "leveldoor" in keys:
        return "door"
    if "writeable" in keys or "maxtextlen" in keys:
        return "writable"
    if "speed" in keys and not bool(attributes.get("pickupable", False)):
        return "ground"
    if bool(attributes.get("pickupable", False)):
        return "pickupable"
    return normalized_type or "item"


def load_item_catalog(path: Path) -> ItemCatalog:
    source = path.resolve()
    _require(source.is_file(), f"items.xml does not exist: {source}")
    digest = hashlib.sha256()
    with source.open("rb") as stream:
        while chunk := stream.read(4 * 1024 * 1024):
            digest.update(chunk)

    items: dict[int, ItemInfo] = {}
    diagnostics: list[dict[str, Any]] = []
    for _, element in ET.iterparse(source, events=("end",)):
        if _local_name(element.tag) != "item":
            continue
        attributes: dict[str, Any] = {}
        for key, value in element.attrib.items():
            if key not in {"id", "fromid", "toid", "name", "article", "plural", "type"}:
                attributes[key] = _coerce_value(value)
        for child in element:
            if _local_name(child.tag) != "attribute":
                continue
            key = child.attrib.get("key")
            if not key:
                continue
            value = _coerce_value(child.attrib.get("value", ""))
            _merge_attribute(attributes, key, value)

        name = element.attrib.get("name") or None
        article = element.attrib.get("article") or None
        plural = element.attrib.get("plural") or None
        item_type = element.attrib.get("type") or str(attributes.get("type") or "") or None
        category = _category(item_type, attributes)
        for item_id in _item_ids(element, diagnostics):
            if item_id in items:
                diagnostics.append(
                    _diagnostic(
                        "duplicate_item_definition",
                        f"Item ID {item_id} is defined more than once; the later XML entry wins",
                        itemId=item_id,
                    )
                )
            items[item_id] = ItemInfo(
                item_id=item_id,
                name=name,
                article=article,
                plural=plural,
                item_type=item_type,
                category=category,
                attributes=dict(attributes),
            )
        element.clear()
    _require(items, f"No item definitions found in {source}")
    return ItemCatalog(source=source, sha256=digest.hexdigest(), items=items, diagnostics=tuple(diagnostics))


def resolve_items_xml(explicit: Path | None, map_path: Path | None = None) -> Path | None:
    if explicit is not None:
        return explicit.resolve()
    candidates = [Path.cwd() / "data/items/items.xml"]
    if map_path is not None:
        current = map_path.resolve().parent
        for parent in (current, *current.parents):
            candidates.append(parent / "data/items/items.xml")
    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    return None


def _catalog_entry(catalog: ItemCatalog, item_id: int) -> dict[str, Any] | None:
    info = catalog.lookup(item_id)
    return info.to_json() if info else None


def enrich_region_export(payload: dict[str, Any], catalog: ItemCatalog) -> dict[str, Any]:
    references = 0
    missing: Counter[int] = Counter()
    categories: Counter[str] = Counter()
    for tile in payload.get("tiles", []):
        inline_id = tile.get("inlineItemId")
        if isinstance(inline_id, int):
            references += 1
            entry = _catalog_entry(catalog, inline_id)
            tile["inlineItem"] = entry
            if entry is None:
                missing[inline_id] += 1
            else:
                categories[entry["category"]] += 1
        for child in tile.get("children", []):
            item_id = child.get("id")
            if not isinstance(item_id, int):
                continue
            references += 1
            entry = _catalog_entry(catalog, item_id)
            child["item"] = entry
            if entry is None:
                missing[item_id] += 1
            else:
                categories[entry["category"]] += 1
    payload["itemCatalog"] = catalog.metadata()
    payload["itemCatalog"]["referenceCount"] = references
    payload["itemCatalog"]["missingItemIds"] = [
        {"id": item_id, "references": count} for item_id, count in sorted(missing.items())
    ]
    payload["itemCatalog"]["referencedCategories"] = dict(sorted(categories.items()))
    return payload


def catalog_document(catalog: ItemCatalog) -> dict[str, Any]:
    return {
        **catalog.metadata(),
        "items": [item.to_json() for _, item in sorted(catalog.items.items())],
    }


CATEGORY_COLORS = {
    "ground": "#667c59",
    "door": "#9c6b30",
    "teleport": "#7e57c2",
    "field": "#c94c4c",
    "container": "#c89b3c",
    "floor_change": "#4d86b8",
    "writable": "#b99b72",
    "pickupable": "#8d8d8d",
    "item": "#6f6f6f",
}


def render_semantic_svg(
    path: Path,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]],
    records: Mapping[tuple[int, int, int], TileRecord],
    catalog: ItemCatalog,
) -> None:
    lower, upper = bounds
    _require(lower[2] == upper[2], "Semantic SVG supports one floor at a time")
    width = upper[0] - lower[0] + 1
    height = upper[1] - lower[1] + 1
    cell = max(8, min(32, 1280 // max(width, height)))
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width * cell}" height="{height * cell}" viewBox="0 0 {width * cell} {height * cell}">',
        '<rect width="100%" height="100%" fill="#151515"/>',
    ]
    for position, record in sorted(records.items()):
        x, y, _ = position
        view = tile_view(record, include_raw=False)
        ids: list[int] = []
        if isinstance(view.get("inlineItemId"), int):
            ids.append(view["inlineItemId"])
        ids.extend(child["id"] for child in view.get("children", []) if isinstance(child.get("id"), int))
        infos = [catalog.lookup(item_id) for item_id in ids]
        known = [info for info in infos if info is not None]
        primary = known[-1] if known else None
        category = primary.category if primary else "item"
        fill = CATEGORY_COLORS.get(category, "#6f6f6f")
        if view["kind"] == "house":
            fill = "#8c4f4f"
        px = (x - lower[0]) * cell
        py = (y - lower[1]) * cell
        labels = [f"{item.item_id}: {item.name or '(unnamed)'} [{item.category}]" for item in known]
        missing_ids = [str(item_id) for item_id, info in zip(ids, infos, strict=True) if info is None]
        if missing_ids:
            labels.append("unknown IDs: " + ", ".join(missing_ids))
        title = html.escape(f"{x},{y},{position[2]} | " + " | ".join(labels))
        parts.append(f'<g><title>{title}</title><rect x="{px}" y="{py}" width="{cell}" height="{cell}" fill="{fill}" stroke="#2d2d2d" stroke-width="0.5"/></g>')
        if cell >= 16 and ids:
            parts.append(f'<text x="{px + 1}" y="{py + cell - 2}" font-size="{max(7, cell // 4)}" fill="#fff">{ids[-1]}</text>')
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts) + "\n", encoding="utf-8")
