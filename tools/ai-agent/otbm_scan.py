from __future__ import annotations

import argparse
import base64
import json
import mmap
import struct
import sys
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Any

from otbm_binary import (
    ATTR_DESCRIPTION, ATTR_EXT_HOUSE_FILE, ATTR_EXT_SPAWN_MONSTER_FILE,
    ATTR_EXT_SPAWN_NPC_FILE, ATTR_EXT_ZONE_FILE, DEFAULT_MAX_TILES,
    EXPORT_FORMAT, MAX_COORD, NODE_END, NODE_START, OTBM_HOUSETILE,
    OTBM_MAP_DATA, OTBM_TILE, OTBM_TILE_AREA, MapHeader, MappedFile,
    OTBMError, ScanResult, TileRecord, _read_u16, _require,
    decode_node_bytes, encode_node, find_node_end, get_node_properties,
    iter_child_nodes, parse_header, parse_map_attributes, sha256_path,
    tile_view,
)


def position_from_text(value: str) -> tuple[int, int, int]:
    parts = value.split(",")
    if len(parts) != 3:
        raise argparse.ArgumentTypeError("Position must use x,y,z")
    try:
        position = tuple(int(part.strip()) for part in parts)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("Position must contain integers") from exc
    if not (0 <= position[0] <= MAX_COORD and 0 <= position[1] <= MAX_COORD and 0 <= position[2] <= 15):
        raise argparse.ArgumentTypeError("Position is outside the OTBM coordinate range")
    return position  # type: ignore[return-value]


def normalize_bounds(
    start: Sequence[int],
    end: Sequence[int],
) -> tuple[tuple[int, int, int], tuple[int, int, int]]:
    _require(len(start) == 3 and len(end) == 3, "Bounds require three coordinates")
    lower = (min(int(start[0]), int(end[0])), min(int(start[1]), int(end[1])), min(int(start[2]), int(end[2])))
    upper = (max(int(start[0]), int(end[0])), max(int(start[1]), int(end[1])), max(int(start[2]), int(end[2])))
    _require(0 <= lower[0] <= upper[0] <= MAX_COORD, "X bounds are invalid")
    _require(0 <= lower[1] <= upper[1] <= MAX_COORD, "Y bounds are invalid")
    _require(0 <= lower[2] <= upper[2] <= 15, "Z bounds are invalid")
    return lower, upper


def bounds_tile_count(bounds: tuple[tuple[int, int, int], tuple[int, int, int]]) -> int:
    lower, upper = bounds
    return (upper[0] - lower[0] + 1) * (upper[1] - lower[1] + 1) * (upper[2] - lower[2] + 1)


def position_in_bounds(position: tuple[int, int, int], bounds: tuple[tuple[int, int, int], tuple[int, int, int]]) -> bool:
    lower, upper = bounds
    return all(lower[index] <= position[index] <= upper[index] for index in range(3))


def area_intersects_bounds(area_base: tuple[int, int, int], bounds: tuple[tuple[int, int, int], tuple[int, int, int]]) -> bool:
    base_x, base_y, base_z = area_base
    lower, upper = bounds
    return lower[2] <= base_z <= upper[2] and base_x <= upper[0] and base_x + 255 >= lower[0] and base_y <= upper[1] and base_y + 255 >= lower[1]


def decode_area_base(properties: bytes) -> tuple[int, int, int]:
    _require(len(properties) == 5, f"Tile-area properties must be 5 bytes, got {len(properties)}")
    return struct.unpack("<HHB", properties)


def scan_map(
    path: Path,
    *,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]] | None = None,
    positions: set[tuple[int, int, int]] | None = None,
    count_tiles: bool = True,
) -> ScanResult:
    path = path.resolve()
    _require(path.is_file(), f"Map file does not exist: {path}")
    stat_before = path.stat()
    file_size = stat_before.st_size
    map_sha = sha256_path(path)
    records: dict[tuple[int, int, int], TileRecord] = {}
    duplicates: dict[tuple[int, int, int], list[TileRecord]] = {}
    area_count = 0
    tile_count = 0
    with MappedFile(path) as mm:
        header = parse_header(mm)
        map_properties = get_node_properties(mm, header.map_data_start)
        map_attributes = parse_map_attributes(map_properties)
        for area_start, area_end, node_type in iter_child_nodes(mm, header.map_data_start):
            if node_type != OTBM_TILE_AREA:
                continue
            area_count += 1
            area_base = decode_area_base(get_node_properties(mm, area_start))
            should_collect_tiles = False
            if positions is not None:
                should_collect_tiles = any(
                    position[2] == area_base[2]
                    and area_base[0] <= position[0] <= area_base[0] + 255
                    and area_base[1] <= position[1] <= area_base[1] + 255
                    for position in positions
                )
            elif bounds is not None:
                should_collect_tiles = area_intersects_bounds(area_base, bounds)
            if not count_tiles and not should_collect_tiles:
                continue
            for tile_start, tile_end, tile_type in iter_child_nodes(mm, area_start):
                _require(tile_type in (OTBM_TILE, OTBM_HOUSETILE), f"Unexpected node type {tile_type} inside tile area")
                if count_tiles:
                    tile_count += 1
                if not should_collect_tiles:
                    continue
                props = get_node_properties(mm, tile_start)
                _require(len(props) >= 2, f"Truncated tile at offset {tile_start}")
                position = (area_base[0] + props[0], area_base[1] + props[1], area_base[2])
                if positions is not None and position not in positions:
                    continue
                if bounds is not None and not position_in_bounds(position, bounds):
                    continue
                record = TileRecord(
                    position=position,
                    area_start=area_start,
                    area_base=area_base,
                    start=tile_start,
                    end=tile_end,
                    node_type=tile_type,
                    raw=bytes(mm[tile_start:tile_end]),
                )
                existing = records.get(position)
                if existing is None:
                    records[position] = record
                else:
                    duplicates.setdefault(position, [existing]).append(record)
    stat_after = path.stat()
    _require(
        stat_before.st_size == stat_after.st_size and stat_before.st_mtime_ns == stat_after.st_mtime_ns,
        "Map changed while it was being scanned; retry with a stable source file",
    )
    return ScanResult(
        header=header,
        map_sha256=map_sha,
        file_size=file_size,
        map_attributes=map_attributes,
        area_count=area_count,
        tile_count=tile_count,
        records=records,
        duplicates=duplicates,
    )


def scan_summary(scan: ScanResult) -> dict[str, Any]:
    return {
        "path": None,
        "sha256": scan.map_sha256,
        "fileSize": scan.file_size,
        "identifierHex": scan.header.identifier.hex(),
        "rootType": scan.header.root_type,
        "version": scan.header.version,
        "width": scan.header.width,
        "height": scan.header.height,
        "itemsMajor": scan.header.items_major,
        "itemsMinor": scan.header.items_minor,
        "mapAttributes": scan.map_attributes,
        "tileAreaCount": scan.area_count,
        "tileCount": scan.tile_count,
        "selectedTileCount": len(scan.records),
        "duplicateSelectedPositions": {",".join(map(str, key)): len(value) for key, value in scan.duplicates.items()},
    }


def write_json(path: Path | None, payload: Any) -> None:
    text = json.dumps(payload, indent=2, ensure_ascii=False, sort_keys=True) + "\n"
    if path is None:
        sys.stdout.write(text)
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")


def render_svg(
    path: Path,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]],
    records: Mapping[tuple[int, int, int], TileRecord],
) -> None:
    lower, upper = bounds
    _require(lower[2] == upper[2], "SVG preview supports one floor at a time")
    width = upper[0] - lower[0] + 1
    height = upper[1] - lower[1] + 1
    cell = max(4, min(24, 1024 // max(width, height)))
    svg_width = width * cell
    svg_height = height * cell
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{svg_width}" height="{svg_height}" viewBox="0 0 {svg_width} {svg_height}">',
        '<rect width="100%" height="100%" fill="#111"/>',
    ]
    for position, record in sorted(records.items()):
        x, y, _ = position
        view = tile_view(record, include_raw=False)
        item_count = len(view["children"]) + (1 if view["inlineItemId"] is not None else 0)
        shade = min(230, 60 + item_count * 28)
        px = (x - lower[0]) * cell
        py = (y - lower[1]) * cell
        fill = f"rgb({shade},{shade},{shade})"
        if view["kind"] == "house":
            fill = f"rgb({shade},90,90)"
        parts.append(f'<rect x="{px}" y="{py}" width="{cell}" height="{cell}" fill="{fill}" stroke="#333" stroke-width="0.5"/>')
        if cell >= 12 and view["inlineItemId"] is not None:
            parts.append(
                f'<text x="{px + 1}" y="{py + cell - 2}" font-size="{max(6, cell // 3)}" fill="#000">{view["inlineItemId"]}</text>'
            )
    parts.append("</svg>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parts) + "\n", encoding="utf-8")


def build_export(
    path: Path,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]],
    *,
    max_tiles: int,
) -> tuple[dict[str, Any], ScanResult]:
    requested = bounds_tile_count(bounds)
    _require(requested <= max_tiles, f"Requested region contains {requested} positions; limit is {max_tiles}")
    scan = scan_map(path, bounds=bounds, count_tiles=False)
    _require(not scan.duplicates, f"Region contains duplicate tile positions: {sorted(scan.duplicates)[:5]}")
    payload = {
        "format": EXPORT_FORMAT,
        "source": {
            "path": path.name,
            "sha256": scan.map_sha256,
            "version": scan.header.version,
            "width": scan.header.width,
            "height": scan.header.height,
            "itemsMajor": scan.header.items_major,
            "itemsMinor": scan.header.items_minor,
        },
        "bounds": {"from": list(bounds[0]), "to": list(bounds[1])},
        "tiles": [tile_view(record) for _, record in sorted(scan.records.items())],
    }
    return payload, scan
