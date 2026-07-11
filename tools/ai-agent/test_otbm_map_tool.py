from __future__ import annotations

import base64
import struct
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

import otbm_binary
import otbm_patch
import otbm_scan

otbm = SimpleNamespace()
for module in (otbm_binary, otbm_scan, otbm_patch):
    for name in dir(module):
        if not name.startswith("__"):
            setattr(otbm, name, getattr(module, name))


def make_item(item_id: int, *, action_id: int | None = None, text: str | None = None) -> bytes:
    attrs: list[dict[str, object]] = []
    if action_id is not None:
        attrs.append({"type": otbm.ATTR_ACTION_ID, "value": action_id})
    if text is not None:
        attrs.append({"type": otbm.ATTR_TEXT, "value": text})
    props = struct.pack("<H", item_id) + otbm.encode_item_attributes(attrs)
    return otbm.encode_node(otbm.OTBM_ITEM, props)


def make_tile(
    x: int,
    y: int,
    z: int,
    *,
    base_x: int,
    base_y: int,
    inline_item: int | None = None,
    child_items: list[bytes] | None = None,
    flags: int = 0,
    house_id: int | None = None,
) -> bytes:
    node_type = otbm.OTBM_HOUSETILE if house_id is not None else otbm.OTBM_TILE
    props = otbm.encode_tile_properties(
        node_type=node_type,
        offset_x=x - base_x,
        offset_y=y - base_y,
        house_id=house_id,
        flags=flags,
        inline_item_id=inline_item,
    )
    return otbm.encode_node(node_type, props, child_items or [])


def make_map(path: Path, tiles: list[tuple[tuple[int, int, int], bytes]], *, width: int = 1000, height: int = 1000) -> None:
    areas: list[bytes] = []
    for position, raw_tile in tiles:
        base = otbm.canonical_area_base(position)
        relocated = otbm.relocate_tile(raw_tile, position, base)
        areas.append(otbm.encode_node(otbm.OTBM_TILE_AREA, struct.pack("<HHB", *base), [relocated]))
    attrs = bytearray()
    for attr, text in ((otbm.ATTR_DESCRIPTION, "synthetic map"), (otbm.ATTR_EXT_HOUSE_FILE, "test-house.xml")):
        encoded = text.encode()
        attrs.append(attr)
        attrs.extend(struct.pack("<H", len(encoded)))
        attrs.extend(encoded)
    map_data = otbm.encode_node(
        otbm.OTBM_MAP_DATA,
        bytes(attrs),
        [*areas, otbm.encode_node(otbm.OTBM_TOWNS, b""), otbm.encode_node(otbm.OTBM_WAYPOINTS, b"")],
    )
    root_props = struct.pack("<IHHII", 4, width, height, 4, 4)
    path.write_bytes(b"\0\0\0\0" + otbm.encode_node(0, root_props, [map_data]))


class NodeCodecTests(unittest.TestCase):
    def test_round_trip_escapes_reserved_bytes(self) -> None:
        raw = otbm.encode_node(6, bytes([1, otbm.NODE_ESCAPE, otbm.NODE_START, otbm.NODE_END, 2]))
        node_type, props, children = otbm.decode_node_bytes(raw)
        self.assertEqual(node_type, 6)
        self.assertEqual(props, bytes([1, otbm.NODE_ESCAPE, otbm.NODE_START, otbm.NODE_END, 2]))
        self.assertEqual(children, [])
        self.assertEqual(otbm.encode_node(node_type, props, children), raw)

    def test_item_attribute_round_trip(self) -> None:
        attrs = [
            {"type": otbm.ATTR_ACTION_ID, "value": 5001},
            {"type": otbm.ATTR_TEXT, "value": "hello"},
            {"type": otbm.ATTR_TELE_DEST, "value": [100, 200, 7]},
        ]
        encoded = otbm.encode_item_attributes(attrs)
        decoded = otbm.parse_item_attributes(encoded)
        self.assertEqual([entry["value"] for entry in decoded], [5001, "hello", [100, 200, 7]])


class MapWorkflowTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.base = self.root / "base.otbm"
        base_x, base_y = 256, 512
        tile_one = make_tile(300, 600, 7, base_x=base_x, base_y=base_y, inline_item=100, child_items=[make_item(200, action_id=500)])
        tile_two = make_tile(301, 600, 7, base_x=base_x, base_y=base_y, inline_item=300)
        make_map(self.base, [((300, 600, 7), tile_one), ((301, 600, 7), tile_two)])

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_scan_and_export_are_readable(self) -> None:
        bounds = ((300, 600, 7), (301, 600, 7))
        payload, scan = otbm.build_export(self.base, bounds, max_tiles=4)
        self.assertEqual(payload["format"], otbm.EXPORT_FORMAT)
        self.assertEqual(len(payload["tiles"]), 2)
        first = payload["tiles"][0]
        self.assertEqual(first["inlineItemId"], 100)
        self.assertEqual(first["children"][0]["id"], 200)
        self.assertEqual(first["children"][0]["attributes"][0]["value"], 500)
        self.assertFalse(scan.duplicates)

    def test_semantic_patch_is_dry_run_then_writes_and_validates(self) -> None:
        scan = otbm.scan_map(self.base, positions={(300, 600, 7)}, count_tiles=False)
        record = scan.records[(300, 600, 7)]
        patch = {
            "format": otbm.PATCH_FORMAT,
            "base": {"sha256": scan.map_sha256},
            "bounds": {"from": [300, 600, 7], "to": [300, 600, 7]},
            "operations": [
                {
                    "op": "replace_item_id",
                    "position": [300, 600, 7],
                    "expectedTileHash": record.normalized_hash,
                    "expectedItemId": 100,
                    "itemId": 101,
                    "scope": "inline",
                }
            ],
        }
        output = self.root / "edited.otbm"
        plan = otbm.plan_patch(self.base, patch, output=output, max_tiles=4, strict_base=False, unsafe_no_precondition=False)
        self.assertTrue(plan.ok)
        self.assertFalse(output.exists())
        otbm.write_patched_map(plan, overwrite=False)
        self.assertTrue(output.exists())
        edited = otbm.scan_map(output, positions={(300, 600, 7)}, count_tiles=False)
        self.assertEqual(otbm.tile_view(edited.records[(300, 600, 7)])["inlineItemId"], 101)
        unchanged = otbm.scan_map(output, positions={(301, 600, 7)}, count_tiles=False)
        self.assertEqual(otbm.tile_view(unchanged.records[(301, 600, 7)])["inlineItemId"], 300)

    def test_diff_rebases_over_unrelated_new_map_change(self) -> None:
        modified = self.root / "modified.otbm"
        target_tile = make_tile(300, 600, 7, base_x=256, base_y=512, inline_item=111, child_items=[make_item(200, action_id=500)])
        unchanged_tile = make_tile(301, 600, 7, base_x=256, base_y=512, inline_item=300)
        make_map(modified, [((300, 600, 7), target_tile), ((301, 600, 7), unchanged_tile)])
        patch = otbm.build_diff_patch(self.base, modified, ((300, 600, 7), (301, 600, 7)), max_tiles=4)
        self.assertEqual(len(patch["operations"]), 1)

        newer = self.root / "newer.otbm"
        original_target = make_tile(300, 600, 7, base_x=256, base_y=512, inline_item=100, child_items=[make_item(200, action_id=500)])
        unrelated_changed = make_tile(301, 600, 7, base_x=256, base_y=512, inline_item=999)
        make_map(newer, [((300, 600, 7), original_target), ((301, 600, 7), unrelated_changed)])
        output = self.root / "rebased.otbm"
        plan = otbm.plan_patch(newer, patch, output=output, max_tiles=4, strict_base=False, unsafe_no_precondition=False)
        self.assertTrue(plan.ok)
        self.assertTrue(plan.warnings)
        otbm.write_patched_map(plan, overwrite=False)
        result = otbm.scan_map(output, bounds=((300, 600, 7), (301, 600, 7)), count_tiles=False)
        self.assertEqual(otbm.tile_view(result.records[(300, 600, 7)])["inlineItemId"], 111)
        self.assertEqual(otbm.tile_view(result.records[(301, 600, 7)])["inlineItemId"], 999)

    def test_diff_detects_conflict_when_same_tile_changed(self) -> None:
        modified = self.root / "modified.otbm"
        desired = make_tile(300, 600, 7, base_x=256, base_y=512, inline_item=111)
        second = make_tile(301, 600, 7, base_x=256, base_y=512, inline_item=300)
        make_map(modified, [((300, 600, 7), desired), ((301, 600, 7), second)])
        patch = otbm.build_diff_patch(self.base, modified, ((300, 600, 7), (301, 600, 7)), max_tiles=4)

        conflicting = self.root / "conflicting.otbm"
        conflict_tile = make_tile(300, 600, 7, base_x=256, base_y=512, inline_item=222)
        make_map(conflicting, [((300, 600, 7), conflict_tile), ((301, 600, 7), second)])
        plan = otbm.plan_patch(conflicting, patch, output=self.root / "never.otbm", max_tiles=4, strict_base=False, unsafe_no_precondition=False)
        self.assertFalse(plan.ok)
        self.assertEqual(plan.operation_results[0]["status"], "conflict")

    def test_create_tile_and_existing_output_backup(self) -> None:
        patch = {
            "format": otbm.PATCH_FORMAT,
            "bounds": {"from": [302, 600, 7], "to": [302, 600, 7]},
            "operations": [
                {
                    "op": "create_tile",
                    "position": [302, 600, 7],
                    "inlineItemId": 444,
                    "items": [{"itemId": 555, "attributes": {"actionId": 6000}}],
                }
            ],
        }
        output = self.root / "created.otbm"
        output.write_bytes(b"old-output")
        plan = otbm.plan_patch(self.base, patch, output=output, max_tiles=4, strict_base=False, unsafe_no_precondition=False)
        self.assertTrue(plan.ok)
        _, backup = otbm.write_patched_map(plan, overwrite=True)
        self.assertIsNotNone(backup)
        assert backup is not None
        self.assertEqual(backup.read_bytes(), b"old-output")
        scan = otbm.scan_map(output, positions={(302, 600, 7)}, count_tiles=False)
        view = otbm.tile_view(scan.records[(302, 600, 7)])
        self.assertEqual(view["inlineItemId"], 444)
        self.assertEqual(view["children"][0]["id"], 555)
        self.assertEqual(view["children"][0]["attributes"][0]["value"], 6000)

    def test_write_refuses_source_changed_after_planning(self) -> None:
        scan = otbm.scan_map(self.base, positions={(300, 600, 7)}, count_tiles=False)
        patch = {
            "format": otbm.PATCH_FORMAT,
            "bounds": {"from": [300, 600, 7], "to": [300, 600, 7]},
            "operations": [
                {
                    "op": "replace_item_id",
                    "position": [300, 600, 7],
                    "expectedTileHash": scan.records[(300, 600, 7)].normalized_hash,
                    "expectedItemId": 100,
                    "itemId": 101,
                }
            ],
        }
        plan = otbm.plan_patch(
            self.base,
            patch,
            output=self.root / "changed-source.otbm",
            max_tiles=4,
            strict_base=False,
            unsafe_no_precondition=False,
        )
        self.base.write_bytes(self.base.read_bytes() + b"changed")
        with self.assertRaises(otbm.OTBMError):
            otbm.write_patched_map(plan, overwrite=False)

    def test_export_enforces_bounded_area(self) -> None:
        with self.assertRaises(otbm.OTBMError):
            otbm.build_export(self.base, ((0, 0, 7), (100, 100, 7)), max_tiles=100)

    def test_raw_replacement_is_relocated_to_target_area(self) -> None:
        foreign = make_tile(1, 2, 7, base_x=0, base_y=0, inline_item=777)
        scan = otbm.scan_map(self.base, positions={(300, 600, 7)}, count_tiles=False)
        patch = {
            "format": otbm.PATCH_FORMAT,
            "bounds": {"from": [300, 600, 7], "to": [300, 600, 7]},
            "operations": [
                {
                    "op": "replace_tile",
                    "position": [300, 600, 7],
                    "expectedTileHash": scan.records[(300, 600, 7)].normalized_hash,
                    "tileBase64": base64.b64encode(foreign).decode(),
                }
            ],
        }
        output = self.root / "relocated.otbm"
        plan = otbm.plan_patch(self.base, patch, output=output, max_tiles=4, strict_base=False, unsafe_no_precondition=False)
        self.assertTrue(plan.ok)
        otbm.write_patched_map(plan, overwrite=False)
        result = otbm.scan_map(output, positions={(300, 600, 7)}, count_tiles=False)
        self.assertIn((300, 600, 7), result.records)
        self.assertEqual(otbm.tile_view(result.records[(300, 600, 7)])["inlineItemId"], 777)


if __name__ == "__main__":
    unittest.main()
