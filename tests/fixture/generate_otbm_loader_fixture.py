#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path

REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
TOOLS_DIR = REPOSITORY_ROOT / "tools/ai-agent"
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from otbm_binary import (
    ATTR_EXT_HOUSE_FILE,
    ATTR_EXT_SPAWN_MONSTER_FILE,
    ATTR_EXT_SPAWN_NPC_FILE,
    ATTR_EXT_ZONE_FILE,
    OTBM_HOUSETILE,
    OTBM_MAP_DATA,
    OTBM_TILE,
    OTBM_TILE_AREA,
    OTBM_TILE_ZONE,
    OTBM_TOWNS,
    OTBM_WAYPOINTS,
    PATCH_FORMAT,
    encode_node,
    encode_tile_properties,
    sha256_path,
    tile_view,
    validate_complete_file,
)
from otbm_patch import plan_patch, write_patched_map
from otbm_scan import scan_map

OTBM_TOWN = 13
OTBM_WAYPOINT = 16
SOURCE_ITEM_ID = 2148
PATCHED_ITEM_ID = 2152
PATCH_POSITION = (300, 600, 7)
HOUSE_POSITION = (301, 600, 7)


def encoded_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    return struct.pack("<H", len(raw)) + raw


def map_attributes() -> bytes:
    attributes = bytearray()
    for attribute, filename in (
        (ATTR_EXT_SPAWN_MONSTER_FILE, "smoke-monster.xml"),
        (ATTR_EXT_SPAWN_NPC_FILE, "smoke-npc.xml"),
        (ATTR_EXT_HOUSE_FILE, "smoke-house.xml"),
        (ATTR_EXT_ZONE_FILE, "smoke-zones.xml"),
    ):
        attributes.append(attribute)
        attributes.extend(encoded_string(filename))
    return bytes(attributes)


def build_base_map(path: Path) -> None:
    base_x, base_y, floor = 256, 512, 7
    normal_properties = encode_tile_properties(
        node_type=OTBM_TILE,
        offset_x=PATCH_POSITION[0] - base_x,
        offset_y=PATCH_POSITION[1] - base_y,
        house_id=None,
        flags=0,
        inline_item_id=SOURCE_ITEM_ID,
    )
    zone_node = encode_node(OTBM_TILE_ZONE, struct.pack("<HH", 1, 9))
    normal_tile = encode_node(OTBM_TILE, normal_properties, [zone_node])

    house_properties = encode_tile_properties(
        node_type=OTBM_HOUSETILE,
        offset_x=HOUSE_POSITION[0] - base_x,
        offset_y=HOUSE_POSITION[1] - base_y,
        house_id=7,
        flags=0,
        inline_item_id=None,
    )
    house_tile = encode_node(OTBM_HOUSETILE, house_properties)
    area = encode_node(
        OTBM_TILE_AREA,
        struct.pack("<HHB", base_x, base_y, floor),
        [normal_tile, house_tile],
    )

    town_properties = struct.pack("<I", 1) + encoded_string("Loader Smoke Town") + struct.pack("<HHB", 300, 600, 7)
    towns = encode_node(OTBM_TOWNS, b"", [encode_node(OTBM_TOWN, town_properties)])
    waypoint_properties = encoded_string("patch destination") + struct.pack("<HHB", 300, 600, 7)
    waypoints = encode_node(OTBM_WAYPOINTS, b"", [encode_node(OTBM_WAYPOINT, waypoint_properties)])

    map_data = encode_node(OTBM_MAP_DATA, map_attributes(), [area, towns, waypoints])
    root_properties = struct.pack("<IHHII", 4, 1024, 1024, 4, 4)
    path.write_bytes(b"\0\0\0\0" + encode_node(0, root_properties, [map_data]))


def write_companions(output_dir: Path) -> None:
    (output_dir / "smoke-monster.xml").write_text(
        '<monsters><spawn centerx="300" centery="600" centerz="7" radius="5"><monster name="Rat" x="1" y="0" spawntime="30" direction="1" weight="1"/></spawn></monsters>',
        encoding="utf-8",
    )
    (output_dir / "smoke-npc.xml").write_text(
        '<npcs><spawn centerx="300" centery="600" centerz="7" radius="3"><npc name="Guide" x="0" y="1" spawntime="60" direction="2"/></spawn></npcs>',
        encoding="utf-8",
    )
    (output_dir / "smoke-house.xml").write_text(
        '<houses><house houseid="7" name="Loader Smoke House" entryx="301" entryy="601" entryz="7" rent="1000" size="1" townid="1" clientid="7007" beds="1"/></houses>',
        encoding="utf-8",
    )
    (output_dir / "smoke-zones.xml").write_text(
        '<zones><zone name="loader-smoke-zone" zoneid="9"/></zones>',
        encoding="utf-8",
    )


def generate(output_dir: Path) -> dict[str, object]:
    output_dir.mkdir(parents=True, exist_ok=True)
    base_path = output_dir / "base.otbm"
    edited_path = output_dir / "edited.otbm"
    build_base_map(base_path)
    write_companions(output_dir)

    scan = scan_map(base_path, positions={PATCH_POSITION}, count_tiles=False)
    source_record = scan.records[PATCH_POSITION]
    patch = {
        "format": PATCH_FORMAT,
        "name": "canary-loader-smoke",
        "base": {"sha256": scan.map_sha256, "file": base_path.name},
        "bounds": {"from": list(PATCH_POSITION), "to": list(PATCH_POSITION)},
        "operations": [
            {
                "op": "replace_item_id",
                "position": list(PATCH_POSITION),
                "expectedTileHash": source_record.normalized_hash,
                "expectedItemId": SOURCE_ITEM_ID,
                "itemId": PATCHED_ITEM_ID,
                "scope": "inline",
            }
        ],
    }
    plan = plan_patch(
        base_path,
        patch,
        output=edited_path,
        max_tiles=1,
        strict_base=True,
        unsafe_no_precondition=False,
    )
    if not plan.ok:
        raise RuntimeError(f"Patch planning failed: {plan.conflicts}")
    write_patched_map(plan, overwrite=False)
    validate_complete_file(edited_path)

    result = scan_map(edited_path, positions={PATCH_POSITION}, count_tiles=False)
    view = tile_view(result.records[PATCH_POSITION], include_raw=False)
    if view["inlineItemId"] != PATCHED_ITEM_ID:
        raise RuntimeError(f"Expected inline item {PATCHED_ITEM_ID}, got {view['inlineItemId']}")

    manifest = {
        "format": "canary-otbm-loader-smoke-v1",
        "base": {"path": str(base_path), "sha256": sha256_path(base_path)},
        "edited": {"path": str(edited_path), "sha256": sha256_path(edited_path)},
        "patchPosition": list(PATCH_POSITION),
        "housePosition": list(HOUSE_POSITION),
        "sourceItemId": SOURCE_ITEM_ID,
        "patchedItemId": PATCHED_ITEM_ID,
    }
    (output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    manifest = generate(args.output_dir.resolve())
    print(json.dumps(manifest, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
