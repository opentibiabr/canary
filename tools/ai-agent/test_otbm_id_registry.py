from __future__ import annotations

import importlib.util
import struct
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
if str(MODULE_DIR) not in sys.path:
    sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import (
    ATTR_ACTION_ID,
    ATTR_UNIQUE_ID,
    OTBM_ITEM,
    OTBM_MAP_DATA,
    OTBM_TILE,
    OTBM_TILE_AREA,
    encode_item_attributes,
    encode_node,
    encode_tile_properties,
)
from otbm_ids import scan_otbm_identifiers

SPEC = importlib.util.spec_from_file_location("scan_ids_otbm_test", MODULE_DIR / "scan_ids.py")
assert SPEC and SPEC.loader
scan_ids = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(scan_ids)


def make_item(
    item_id: int,
    *,
    action_id: int | None = None,
    unique_id: int | None = None,
    children: list[bytes] | None = None,
) -> bytes:
    attributes: list[dict[str, int]] = []
    if action_id is not None:
        attributes.append({"type": ATTR_ACTION_ID, "value": action_id})
    if unique_id is not None:
        attributes.append({"type": ATTR_UNIQUE_ID, "value": unique_id})
    properties = struct.pack("<H", item_id) + encode_item_attributes(attributes)
    return encode_node(OTBM_ITEM, properties, children or [])


def make_map(path: Path, tiles: list[tuple[int, int, list[bytes]]]) -> None:
    base_x, base_y, z = 256, 512, 7
    tile_nodes: list[bytes] = []
    for x, y, items in tiles:
        properties = encode_tile_properties(
            node_type=OTBM_TILE,
            offset_x=x - base_x,
            offset_y=y - base_y,
            house_id=None,
            flags=0,
            inline_item_id=100,
        )
        tile_nodes.append(encode_node(OTBM_TILE, properties, items))
    area = encode_node(OTBM_TILE_AREA, struct.pack("<HHB", base_x, base_y, z), tile_nodes)
    map_data = encode_node(OTBM_MAP_DATA, b"", [area])
    root_properties = struct.pack("<IHHII", 4, 1024, 1024, 4, 4)
    path.write_bytes(b"\0\0\0\0" + encode_node(0, root_properties, [map_data]))


class OTBMIdentifierScannerTests(unittest.TestCase):
    def test_scans_top_level_and_nested_item_attributes(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            map_path = root / "world.otbm"
            nested = make_item(202, action_id=47002, unique_id=48002)
            parent = make_item(201, action_id=47001, unique_id=48001, children=[nested])
            make_map(map_path, [(300, 600, [parent])])

            result = scan_otbm_identifiers(map_path, root)

            self.assertEqual(set(result["identifiers"]["actionId"]), {47001, 47002})
            self.assertEqual(set(result["identifiers"]["uniqueId"]), {48001, 48002})
            nested_source = result["identifiers"]["uniqueId"][48002][0]
            self.assertEqual(nested_source["path"], "world.otbm")
            self.assertIn("tile(300,600,7)/item[0/0]", nested_source["symbol"])
            self.assertIn("OTBM item 202", nested_source["context"])
            self.assertEqual(result["counts"], {"actionId": 2, "uniqueId": 2})
            self.assertEqual(result["tileCount"], 1)
            self.assertEqual(result["topLevelItemCount"], 1)

    def test_registry_merges_text_and_map_sources(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "script.lua").write_text("local actionId = 47001\nlocal uniqueId = 48010", encoding="utf-8")
            map_path = root / "world.otbm"
            make_map(map_path, [(300, 600, [make_item(201, action_id=47001, unique_id=48001)])])

            registry = scan_ids.build_registry(root, [map_path])

            action_entry = next(entry for entry in registry["namespaces"]["actionId"]["entries"] if entry["value"] == 47001)
            self.assertEqual(len(action_entry["sources"]), 2)
            self.assertEqual({source["path"] for source in action_entry["sources"]}, {"script.lua", "world.otbm"})
            self.assertEqual(len(registry["binarySources"]), 1)
            self.assertEqual(registry["binarySources"][0]["counts"]["uniqueId"], 1)
            conflict = next(item for item in registry["conflicts"] if item["namespace"] == "actionId" and item["value"] == 47001)
            self.assertEqual(conflict["severity"], "warning")

    def test_duplicate_unique_id_in_same_map_is_error(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            map_path = root / "world.otbm"
            make_map(
                map_path,
                [
                    (300, 600, [make_item(201, unique_id=48001)]),
                    (301, 600, [make_item(202, unique_id=48001)]),
                ],
            )

            registry = scan_ids.build_registry(root, [map_path])
            conflict = next(item for item in registry["conflicts"] if item["namespace"] == "uniqueId" and item["value"] == 48001)
            self.assertEqual(conflict["severity"], "error")
            self.assertEqual(len(conflict["sources"]), 2)
            self.assertNotEqual(conflict["sources"][0]["symbol"], conflict["sources"][1]["symbol"])

    def test_duplicate_map_argument_is_scanned_once(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            map_path = root / "world.otbm"
            make_map(map_path, [(300, 600, [make_item(201, action_id=47001)])])

            registry = scan_ids.build_registry(root, [map_path, map_path])

            self.assertEqual(len(registry["binarySources"]), 1)
            entry = next(item for item in registry["namespaces"]["actionId"]["entries"] if item["value"] == 47001)
            self.assertEqual(len(entry["sources"]), 1)


if __name__ == "__main__":
    unittest.main()
