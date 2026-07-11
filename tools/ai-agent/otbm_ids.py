from __future__ import annotations

import mmap
import struct
from collections import defaultdict
from pathlib import Path
from typing import Any

from otbm_binary import (
    ATTR_ACTION_ID,
    ATTR_UNIQUE_ID,
    OTBM_HOUSETILE,
    OTBM_ITEM,
    OTBM_TILE,
    OTBM_TILE_AREA,
    MappedFile,
    _require,
    get_node_properties,
    iter_child_nodes,
    parse_header,
    parse_item_attributes,
    sha256_path,
)

IdentifierResults = dict[str, dict[int, list[dict[str, Any]]]]


def _source_path(path: Path, root: Path) -> str:
    try:
        return path.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return str(path.resolve())


def _add_identifier(
    results: IdentifierResults,
    namespace: str,
    value: int,
    *,
    source_path: str,
    position: tuple[int, int, int],
    item_id: int,
    item_path: tuple[int, ...],
) -> None:
    path_text = "/".join(str(index) for index in item_path)
    attribute_name = "actionId" if namespace == "actionId" else "uniqueId"
    results[namespace][value].append(
        {
            "path": source_path,
            "symbol": f"tile({position[0]},{position[1]},{position[2]})/item[{path_text}]",
            "context": f"OTBM item {item_id} at {position[0]},{position[1]},{position[2]} has {attribute_name}={value}",
            "role": "definition",
        }
    )


def _scan_item_node(
    data: bytes | mmap.mmap | memoryview,
    node_start: int,
    *,
    position: tuple[int, int, int],
    item_path: tuple[int, ...],
    source_path: str,
    results: IdentifierResults,
) -> None:
    properties = get_node_properties(data, node_start)
    _require(len(properties) >= 2, f"Item node at {position} is truncated")
    item_id = struct.unpack_from("<H", properties, 0)[0]
    for attribute in parse_item_attributes(properties[2:]):
        if not attribute.get("parseComplete"):
            break
        attribute_type = attribute["type"]
        if attribute_type == ATTR_ACTION_ID:
            _add_identifier(
                results,
                "actionId",
                int(attribute["value"]),
                source_path=source_path,
                position=position,
                item_id=item_id,
                item_path=item_path,
            )
        elif attribute_type == ATTR_UNIQUE_ID:
            _add_identifier(
                results,
                "uniqueId",
                int(attribute["value"]),
                source_path=source_path,
                position=position,
                item_id=item_id,
                item_path=item_path,
            )

    child_index = 0
    for child_start, _, child_type in iter_child_nodes(data, node_start):
        if child_type != OTBM_ITEM:
            continue
        _scan_item_node(
            data,
            child_start,
            position=position,
            item_path=(*item_path, child_index),
            source_path=source_path,
            results=results,
        )
        child_index += 1


def scan_otbm_identifiers(path: Path, root: Path) -> dict[str, Any]:
    source = path.resolve()
    _require(source.is_file(), f"OTBM map does not exist: {source}")
    results: IdentifierResults = {
        "actionId": defaultdict(list),
        "uniqueId": defaultdict(list),
    }
    source_path = _source_path(source, root)
    tile_count = 0
    item_count = 0

    with MappedFile(source) as mm:
        header = parse_header(mm)
        for area_start, _, area_type in iter_child_nodes(mm, header.map_data_start):
            if area_type != OTBM_TILE_AREA:
                continue
            area_properties = get_node_properties(mm, area_start)
            _require(len(area_properties) == 5, f"Tile area at offset {area_start} has invalid properties")
            base_x, base_y, base_z = struct.unpack("<HHB", area_properties)
            for tile_start, _, tile_type in iter_child_nodes(mm, area_start):
                if tile_type not in (OTBM_TILE, OTBM_HOUSETILE):
                    continue
                tile_count += 1
                tile_properties = get_node_properties(mm, tile_start)
                _require(len(tile_properties) >= 2, f"Tile at offset {tile_start} is truncated")
                position = (base_x + tile_properties[0], base_y + tile_properties[1], base_z)
                top_level_index = 0
                for item_start, _, item_type in iter_child_nodes(mm, tile_start):
                    if item_type != OTBM_ITEM:
                        continue
                    _scan_item_node(
                        mm,
                        item_start,
                        position=position,
                        item_path=(top_level_index,),
                        source_path=source_path,
                        results=results,
                    )
                    top_level_index += 1
                    item_count += 1

    return {
        "path": source_path,
        "sha256": sha256_path(source),
        "fileSize": source.stat().st_size,
        "version": header.version,
        "itemsMajor": header.items_major,
        "itemsMinor": header.items_minor,
        "tileCount": tile_count,
        "topLevelItemCount": item_count,
        "identifiers": {
            namespace: {value: sources for value, sources in entries.items()}
            for namespace, entries in results.items()
        },
        "counts": {
            namespace: sum(len(sources) for sources in entries.values())
            for namespace, entries in results.items()
        },
    }
