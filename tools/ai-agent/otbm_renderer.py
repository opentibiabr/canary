from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from otbm_assets import build_asset_index
from otbm_appearances import build_appearances_index
from otbm_binary import DEFAULT_MAX_TILES, OTBMError, _require, tile_view
from otbm_scan import bounds_tile_count, normalize_bounds, scan_map
from otbm_sprites import DecodedSheet, SpriteSheetError, decode_sprite_sheet, encode_png, extract_sprite

TILE_SIZE = 32
DEFAULT_PADDING_TILES = 4
MAX_CANVAS_PIXELS = 64 * 1024 * 1024
RENDER_REPORT_FORMAT = "canary-otbm-render-report-v1"


@dataclass(frozen=True)
class RenderItem:
    item_id: int
    attributes: tuple[dict[str, Any], ...]
    source: str
    stack_index: int


@dataclass
class RenderDiagnostics:
    warnings: list[dict[str, Any]] = field(default_factory=list)
    errors: list[dict[str, Any]] = field(default_factory=list)
    missing_appearances: set[int] = field(default_factory=set)
    missing_sprites: set[int] = field(default_factory=set)
    decoded_sheets: set[str] = field(default_factory=set)
    rendered_items: int = 0
    rendered_sprites: int = 0

    def warning(self, code: str, message: str, **details: Any) -> None:
        self.warnings.append({"code": code, "message": message, **details})

    def error(self, code: str, message: str, **details: Any) -> None:
        self.errors.append({"code": code, "message": message, **details})


class SpriteRepository:
    def __init__(self, asset_index: dict[str, Any], diagnostics: RenderDiagnostics):
        self.entries = sorted(
            asset_index.get("sprites", []),
            key=lambda entry: (entry.get("firstSpriteId", 0), entry.get("lastSpriteId", 0)),
        )
        self.diagnostics = diagnostics
        self.sheet_cache: dict[str, DecodedSheet] = {}
        self.sprite_cache: dict[tuple[int, int, int, int, str], tuple[int, int, bytes]] = {}

    def _entry(self, sprite_id: int) -> dict[str, Any] | None:
        for entry in self.entries:
            first = entry.get("firstSpriteId")
            last = entry.get("lastSpriteId")
            if not isinstance(first, int) or not isinstance(last, int):
                continue
            if sprite_id < first:
                return None
            if first <= sprite_id <= last:
                return entry
        return None

    def get(self, sprite_id: int) -> tuple[int, int, bytes] | None:
        if sprite_id == 0:
            return None
        entry = self._entry(sprite_id)
        if entry is None:
            self.diagnostics.missing_sprites.add(sprite_id)
            return None
        path_value = entry.get("path")
        first = entry.get("firstSpriteId")
        last = entry.get("lastSpriteId")
        layout = entry.get("spriteType")
        if not isinstance(path_value, str) or not isinstance(first, int) or not isinstance(last, int) or not isinstance(layout, int):
            self.diagnostics.error("invalid_sprite_entry", "Asset index contains an incomplete sprite entry", spriteId=sprite_id)
            return None
        key = (sprite_id, first, last, layout, path_value)
        cached = self.sprite_cache.get(key)
        if cached is not None:
            return cached
        try:
            sheet = self.sheet_cache.get(path_value)
            if sheet is None:
                sheet = decode_sprite_sheet(Path(path_value))
                self.sheet_cache[path_value] = sheet
                self.diagnostics.decoded_sheets.add(path_value)
            sprite = extract_sprite(
                sheet,
                sprite_id=sprite_id,
                first_sprite_id=first,
                last_sprite_id=last,
                layout=layout,
            )
        except (FileNotFoundError, OSError, SpriteSheetError) as exc:
            self.diagnostics.error("sprite_decode_error", str(exc), spriteId=sprite_id, path=path_value)
            return None
        result = (sprite.width, sprite.height, sprite.rgba)
        self.sprite_cache[key] = result
        return result


def _attribute_value(item: RenderItem, *names: str, default: int = 0) -> int:
    for attribute in item.attributes:
        if attribute.get("name") in names and attribute.get("parseComplete") and isinstance(attribute.get("value"), int):
            return int(attribute["value"])
    return default


def _render_items(view: dict[str, Any]) -> list[RenderItem]:
    items: list[RenderItem] = []
    inline_id = view.get("inlineItemId")
    if isinstance(inline_id, int):
        items.append(RenderItem(inline_id, (), "inline", 0))
    for index, child in enumerate(view.get("children", [])):
        item_id = child.get("id")
        if not isinstance(item_id, int):
            continue
        attributes = child.get("attributes")
        normalized = tuple(entry for entry in attributes if isinstance(entry, dict)) if isinstance(attributes, list) else ()
        items.append(RenderItem(item_id, normalized, "node", index))
    return items


def _priority(appearance: dict[str, Any]) -> int:
    flags = appearance.get("flags") if isinstance(appearance.get("flags"), dict) else {}
    if isinstance(flags.get("bank"), dict):
        return 0
    if flags.get("clip"):
        return 1
    if flags.get("bottom"):
        return 2
    if flags.get("top"):
        return 4
    return 3


def _ordered_items(items: list[RenderItem], appearances: dict[int, dict[str, Any]]) -> tuple[list[RenderItem], list[RenderItem]]:
    lower: list[RenderItem] = []
    common: list[RenderItem] = []
    top: list[RenderItem] = []
    for item in items:
        appearance = appearances.get(item.item_id, {})
        priority = _priority(appearance)
        if priority <= 2:
            lower.append(item)
        elif priority == 4:
            top.append(item)
        else:
            common.append(item)
    return [*lower, *reversed(common)], top


def _pattern(item: RenderItem, appearance: dict[str, Any], position: tuple[int, int, int], diagnostics: RenderDiagnostics) -> tuple[int, int, int]:
    groups = appearance.get("frameGroups")
    if not isinstance(groups, list) or not groups:
        return 0, 0, 0
    info = groups[0].get("spriteInfo") if isinstance(groups[0], dict) else None
    if not isinstance(info, dict):
        return 0, 0, 0
    pattern_x = max(1, int(info.get("patternWidth", 1)))
    pattern_y = max(1, int(info.get("patternHeight", 1)))
    pattern_z = max(1, int(info.get("patternDepth", 1)))
    flags = appearance.get("flags") if isinstance(appearance.get("flags"), dict) else {}
    count = _attribute_value(item, "count", "runeCharges", "charges", default=1)

    if flags.get("cumulative") and pattern_x == 4 and pattern_y == 2:
        if count <= 0:
            x, y = 0, 0
        elif count < 5:
            x, y = count - 1, 0
        elif count < 10:
            x, y = 0, 1
        elif count < 25:
            x, y = 1, 1
        elif count < 50:
            x, y = 2, 1
        else:
            x, y = 3, 1
        return x, y, position[2] % pattern_z

    if flags.get("liquidPool") or flags.get("liquidContainer"):
        color = max(0, count)
        return (color % 4) % pattern_x, (color // 4) % pattern_y, position[2] % pattern_z

    if flags.get("hangable") and pattern_x > 1:
        diagnostics.warning(
            "hangable_default_pattern",
            "Hangable item orientation requires neighboring wall-hook metadata; pattern 0 was used",
            itemId=item.item_id,
            position=list(position),
        )
        return 0, position[1] % pattern_y, position[2] % pattern_z

    return position[0] % pattern_x, position[1] % pattern_y, position[2] % pattern_z


def _frame_group(appearance: dict[str, Any]) -> dict[str, Any] | None:
    groups = appearance.get("frameGroups")
    if not isinstance(groups, list):
        return None
    for group in groups:
        if isinstance(group, dict) and group.get("fixedFrameGroup") in {0, 2} and isinstance(group.get("spriteInfo"), dict):
            return group
    for group in groups:
        if isinstance(group, dict) and isinstance(group.get("spriteInfo"), dict):
            return group
    return None


def _sprite_ids(appearance: dict[str, Any], pattern: tuple[int, int, int], diagnostics: RenderDiagnostics, item_id: int) -> list[int]:
    group = _frame_group(appearance)
    if group is None:
        diagnostics.error("missing_frame_group", "Appearance has no renderable frame group", itemId=item_id)
        return []
    info = group["spriteInfo"]
    width = max(1, int(info.get("patternWidth", 1)))
    height = max(1, int(info.get("patternHeight", 1)))
    depth = max(1, int(info.get("patternDepth", 1)))
    layers = max(1, int(info.get("layers", 1)))
    ids = info.get("spriteIds")
    if not isinstance(ids, list):
        diagnostics.error("missing_sprite_ids", "Appearance frame group has no sprite ID list", itemId=item_id)
        return []
    x, y, z = pattern
    x %= width
    y %= height
    z %= depth
    start = (((z * height + y) * width + x) * layers)
    end = start + layers
    if end > len(ids):
        diagnostics.error(
            "sprite_index_out_of_range",
            "Appearance sprite list is shorter than its dimensions require",
            itemId=item_id,
            expectedEnd=end,
            spriteCount=len(ids),
        )
        return []
    return [int(value) for value in ids[start:end] if isinstance(value, int)]


def _blend(canvas: bytearray, canvas_width: int, canvas_height: int, image: bytes, width: int, height: int, x: int, y: int) -> None:
    for source_y in range(height):
        target_y = y + source_y
        if target_y < 0 or target_y >= canvas_height:
            continue
        for source_x in range(width):
            target_x = x + source_x
            if target_x < 0 or target_x >= canvas_width:
                continue
            source_offset = (source_y * width + source_x) * 4
            sa = image[source_offset + 3]
            if sa == 0:
                continue
            target_offset = (target_y * canvas_width + target_x) * 4
            if sa == 255:
                canvas[target_offset : target_offset + 4] = image[source_offset : source_offset + 4]
                continue
            da = canvas[target_offset + 3]
            inv = 255 - sa
            out_a = sa + (da * inv + 127) // 255
            if out_a == 0:
                continue
            for channel in range(3):
                source_premultiplied = image[source_offset + channel] * sa
                target_premultiplied = canvas[target_offset + channel] * da
                output_premultiplied = source_premultiplied + (target_premultiplied * inv + 127) // 255
                canvas[target_offset + channel] = min(255, (output_premultiplied + out_a // 2) // out_a)
            canvas[target_offset + 3] = out_a


def _draw_item(
    canvas: bytearray,
    canvas_width: int,
    canvas_height: int,
    repository: SpriteRepository,
    diagnostics: RenderDiagnostics,
    item: RenderItem,
    appearance: dict[str, Any],
    position: tuple[int, int, int],
    tile_dest_x: int,
    tile_dest_y: int,
    elevation: int,
) -> int:
    pattern = _pattern(item, appearance, position, diagnostics)
    sprite_ids = _sprite_ids(appearance, pattern, diagnostics, item.item_id)
    flags = appearance.get("flags") if isinstance(appearance.get("flags"), dict) else {}
    shift = flags.get("shift") if isinstance(flags.get("shift"), dict) else {}
    displacement_x = int(shift.get("x", 0))
    displacement_y = int(shift.get("y", 0))
    for sprite_id in sprite_ids:
        sprite = repository.get(sprite_id)
        if sprite is None:
            if sprite_id:
                diagnostics.missing_sprites.add(sprite_id)
            continue
        width, height, rgba = sprite
        draw_x = tile_dest_x - elevation + TILE_SIZE - width - displacement_x
        draw_y = tile_dest_y - elevation + TILE_SIZE - height - displacement_y
        _blend(canvas, canvas_width, canvas_height, rgba, width, height, draw_x, draw_y)
        diagnostics.rendered_sprites += 1
    diagnostics.rendered_items += 1
    elevation_value = flags.get("height") if isinstance(flags.get("height"), dict) else {}
    added = int(elevation_value.get("elevation", 0))
    return min(24, elevation + max(0, added))


def _resolve_appearance_path(asset_index: dict[str, Any]) -> Path:
    appearances = asset_index.get("appearances")
    _require(isinstance(appearances, list) and len(appearances) == 1, "Asset index must contain exactly one appearances file")
    path = appearances[0].get("path")
    _require(isinstance(path, str), "Asset index appearances path is missing")
    return Path(path)


def render_region(
    map_path: Path,
    assets_root: Path,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]],
    output: Path,
    *,
    padding_tiles: int = DEFAULT_PADDING_TILES,
    max_tiles: int = DEFAULT_MAX_TILES,
) -> dict[str, Any]:
    lower, upper = normalize_bounds(bounds[0], bounds[1])
    _require(lower[2] == upper[2], "Pixel rendering currently supports exactly one floor")
    requested_tiles = bounds_tile_count((lower, upper))
    _require(requested_tiles <= max_tiles, f"Requested region contains {requested_tiles} positions; limit is {max_tiles}")
    _require(0 <= padding_tiles <= 32, "padding_tiles must be between 0 and 32")

    asset_index = build_asset_index(assets_root, hash_files=True)
    _require(asset_index["ok"], f"Client asset package is invalid: {asset_index['issues'][:5]}")
    appearances_index = build_appearances_index(_resolve_appearance_path(asset_index), asset_index=asset_index)
    _require(appearances_index["ok"], f"Appearances data is invalid: {appearances_index['issues'][:5]}")
    appearances = {
        int(entry["id"]): entry
        for entry in appearances_index["appearances"]
        if isinstance(entry.get("id"), int) and entry.get("category") == "object"
    }

    scan = scan_map(map_path, bounds=(lower, upper), count_tiles=False)
    _require(not scan.duplicates, f"Region contains duplicate tile positions: {sorted(scan.duplicates)[:5]}")
    padding = padding_tiles * TILE_SIZE
    region_width = upper[0] - lower[0] + 1
    region_height = upper[1] - lower[1] + 1
    canvas_width = region_width * TILE_SIZE + padding * 2
    canvas_height = region_height * TILE_SIZE + padding * 2
    _require(canvas_width * canvas_height <= MAX_CANVAS_PIXELS, "Requested render canvas is too large")
    canvas = bytearray(canvas_width * canvas_height * 4)
    diagnostics = RenderDiagnostics()
    repository = SpriteRepository(asset_index, diagnostics)

    for position, record in sorted(scan.records.items(), key=lambda pair: (pair[0][1], pair[0][0], pair[0][2])):
        view = tile_view(record, include_raw=False)
        items = _render_items(view)
        ordered, top = _ordered_items(items, appearances)
        tile_x = padding + (position[0] - lower[0]) * TILE_SIZE
        tile_y = padding + (position[1] - lower[1]) * TILE_SIZE
        elevation = 0
        for item in ordered:
            appearance = appearances.get(item.item_id)
            if appearance is None:
                diagnostics.missing_appearances.add(item.item_id)
                continue
            elevation = _draw_item(
                canvas,
                canvas_width,
                canvas_height,
                repository,
                diagnostics,
                item,
                appearance,
                position,
                tile_x,
                tile_y,
                elevation,
            )
        for item in top:
            appearance = appearances.get(item.item_id)
            if appearance is None:
                diagnostics.missing_appearances.add(item.item_id)
                continue
            _draw_item(
                canvas,
                canvas_width,
                canvas_height,
                repository,
                diagnostics,
                item,
                appearance,
                position,
                tile_x,
                tile_y,
                0,
            )

    if diagnostics.missing_appearances:
        diagnostics.error(
            "missing_appearances",
            f"{len(diagnostics.missing_appearances)} placed item IDs have no object appearance",
            itemIds=sorted(diagnostics.missing_appearances),
        )
    if diagnostics.missing_sprites:
        diagnostics.error(
            "missing_sprites",
            f"{len(diagnostics.missing_sprites)} referenced sprite IDs could not be rendered",
            spriteIds=sorted(diagnostics.missing_sprites),
        )

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(encode_png(canvas_width, canvas_height, bytes(canvas)))
    return {
        "format": RENDER_REPORT_FORMAT,
        "ok": not diagnostics.errors,
        "source": {
            "map": str(map_path.resolve()),
            "mapSha256": scan.map_sha256,
            "assetsRoot": str(assets_root.resolve()),
            "assetCatalogSha256": asset_index["catalog"]["sha256"],
            "appearancesSha256": appearances_index["source"]["sha256"],
        },
        "bounds": {"from": list(lower), "to": list(upper)},
        "output": {
            "path": str(output.resolve()),
            "width": canvas_width,
            "height": canvas_height,
            "paddingPixels": padding,
        },
        "summary": {
            "requestedPositions": requested_tiles,
            "mapTiles": len(scan.records),
            "renderedItems": diagnostics.rendered_items,
            "renderedSprites": diagnostics.rendered_sprites,
            "decodedSheetCount": len(diagnostics.decoded_sheets),
            "missingAppearanceCount": len(diagnostics.missing_appearances),
            "missingSpriteCount": len(diagnostics.missing_sprites),
        },
        "decodedSheets": sorted(diagnostics.decoded_sheets),
        "warnings": diagnostics.warnings,
        "errors": diagnostics.errors,
    }


def load_render_request(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("Render request must be a JSON object")
    return payload
