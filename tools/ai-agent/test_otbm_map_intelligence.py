from __future__ import annotations

import base64
import json
import struct
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import OTBM_ITEM, OTBM_TILE, PATCH_FORMAT, TileRecord, encode_node, encode_tile_properties
from otbm_catalog import catalog_document, enrich_region_export, load_item_catalog, render_semantic_svg
from otbm_schema import validate_patch_document


class ItemCatalogTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.items_xml = self.root / "items.xml"
        self.items_xml.write_text(
            """<?xml version="1.0"?>
<items>
  <item id="100" article="a" name="stone floor">
    <attribute key="speed" value="150" />
  </item>
  <item fromid="200" toid="201" article="a" name="wooden door" type="door">
    <attribute key="blocksolid" value="true" />
  </item>
  <item id="300" name="quest chest" type="container">
    <attribute key="pickupable" value="false" />
  </item>
</items>
""",
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_loads_ids_ranges_names_types_and_attributes(self) -> None:
        catalog = load_item_catalog(self.items_xml)
        self.assertEqual(len(catalog.items), 4)
        self.assertEqual(catalog.items[100].name, "stone floor")
        self.assertEqual(catalog.items[100].category, "ground")
        self.assertEqual(catalog.items[100].attributes["speed"], 150)
        self.assertEqual(catalog.items[200].category, "door")
        self.assertEqual(catalog.items[201].name, "wooden door")
        self.assertIs(catalog.items[200].attributes["blocksolid"], True)
        self.assertEqual(catalog.items[300].category, "container")
        document = catalog_document(catalog)
        self.assertEqual(document["format"], "canary-item-catalog-v1")
        self.assertEqual(document["itemCount"], 4)
        self.assertEqual(document["diagnosticCount"], 0)
        self.assertEqual(len(document["sha256"]), 64)

    def test_enriches_region_and_reports_unknown_ids(self) -> None:
        catalog = load_item_catalog(self.items_xml)
        payload = {
            "tiles": [
                {
                    "position": [300, 600, 7],
                    "inlineItemId": 100,
                    "children": [{"id": 200}, {"id": 999}],
                }
            ]
        }
        enrich_region_export(payload, catalog)
        tile = payload["tiles"][0]
        self.assertEqual(tile["inlineItem"]["name"], "stone floor")
        self.assertEqual(tile["children"][0]["item"]["category"], "door")
        self.assertIsNone(tile["children"][1]["item"])
        self.assertEqual(payload["itemCatalog"]["missingItemIds"], [{"id": 999, "references": 1}])
        self.assertEqual(payload["itemCatalog"]["referenceCount"], 3)

    def test_renders_semantic_svg_with_tooltips(self) -> None:
        catalog = load_item_catalog(self.items_xml)
        props = encode_tile_properties(
            node_type=OTBM_TILE,
            offset_x=44,
            offset_y=88,
            house_id=None,
            flags=0,
            inline_item_id=100,
        )
        item = encode_node(OTBM_ITEM, struct.pack("<H", 200))
        raw = encode_node(OTBM_TILE, props, [item])
        record = TileRecord(
            position=(300, 600, 7),
            area_start=0,
            area_base=(256, 512, 7),
            start=0,
            end=len(raw),
            node_type=OTBM_TILE,
            raw=raw,
        )
        output = self.root / "preview.svg"
        render_semantic_svg(output, ((300, 600, 7), (300, 600, 7)), {(300, 600, 7): record}, catalog)
        text = output.read_text(encoding="utf-8")
        self.assertIn("stone floor", text)
        self.assertIn("wooden door", text)
        self.assertIn("300,600,7", text)

    def test_duplicate_definition_uses_later_entry_and_reports_it(self) -> None:
        duplicate = self.root / "duplicate.xml"
        duplicate.write_text('<items><item id="1" name="one"/><item id="1" name="two"/></items>', encoding="utf-8")
        catalog = load_item_catalog(duplicate)
        self.assertEqual(catalog.items[1].name, "two")
        self.assertEqual(catalog.diagnostics[0]["code"], "duplicate_item_definition")

    def test_reversed_range_is_skipped_like_canary_loader(self) -> None:
        reversed_range = self.root / "reversed.xml"
        reversed_range.write_text(
            '<items><item id="1" name="one"/><item fromid="10" toid="5" name="ignored"/></items>',
            encoding="utf-8",
        )
        catalog = load_item_catalog(reversed_range)
        self.assertEqual(set(catalog.items), {1})
        self.assertEqual(catalog.diagnostics[0]["code"], "reversed_item_range")


class PatchSchemaTests(unittest.TestCase):
    def valid_patch(self) -> dict[str, object]:
        return {
            "format": PATCH_FORMAT,
            "name": "semantic-change",
            "base": {"sha256": "a" * 64, "file": "base.otbm"},
            "bounds": {"from": [300, 600, 7], "to": [301, 601, 7]},
            "operations": [
                {
                    "op": "replace_item_id",
                    "position": [300, 600, 7],
                    "expectedTileHash": "b" * 64,
                    "expectedItemId": 100,
                    "itemId": 101,
                    "scope": "inline",
                }
            ],
        }

    def test_accepts_well_formed_semantic_patch(self) -> None:
        report = validate_patch_document(self.valid_patch())
        self.assertTrue(report["ok"])
        self.assertEqual(report["issues"], [])

    def test_requires_tile_preconditions_by_default(self) -> None:
        patch = self.valid_patch()
        operation = patch["operations"][0]
        del operation["expectedTileHash"]
        report = validate_patch_document(patch)
        self.assertFalse(report["ok"])
        self.assertIn("precondition", {issue["code"] for issue in report["issues"]})
        relaxed = validate_patch_document(patch, require_preconditions=False)
        self.assertTrue(relaxed["ok"])

    def test_rejects_operation_outside_bounds(self) -> None:
        patch = self.valid_patch()
        patch["operations"][0]["position"] = [400, 600, 7]
        report = validate_patch_document(patch)
        self.assertFalse(report["ok"])
        self.assertIn("operation_bounds", {issue["code"] for issue in report["issues"]})

    def test_validates_raw_tile_base64_and_node_type(self) -> None:
        props = encode_tile_properties(
            node_type=OTBM_TILE,
            offset_x=0,
            offset_y=0,
            house_id=None,
            flags=0,
            inline_item_id=100,
        )
        tile = encode_node(OTBM_TILE, props)
        patch = {
            "format": PATCH_FORMAT,
            "bounds": {"from": [1, 2, 7], "to": [1, 2, 7]},
            "operations": [
                {
                    "op": "add_tile",
                    "position": [1, 2, 7],
                    "tileBase64": base64.b64encode(tile).decode("ascii"),
                }
            ],
        }
        self.assertTrue(validate_patch_document(patch)["ok"])
        patch["operations"][0]["tileBase64"] = "not base64"
        report = validate_patch_document(patch)
        self.assertFalse(report["ok"])
        self.assertIn("tile_base64", {issue["code"] for issue in report["issues"]})

    def test_rejects_unknown_operation_and_invalid_item_id(self) -> None:
        patch = self.valid_patch()
        patch["operations"].append({"op": "invent_item", "position": [301, 600, 7]})
        patch["operations"][0]["itemId"] = 70000
        report = validate_patch_document(patch)
        codes = {issue["code"] for issue in report["issues"]}
        self.assertFalse(report["ok"])
        self.assertIn("operation_name", codes)
        self.assertIn("item_id", codes)

    def test_schema_file_is_valid_json(self) -> None:
        schema = json.loads((MODULE_DIR.parent.parent / "docs/ai-agent/OTBM_PATCH.schema.json").read_text(encoding="utf-8"))
        self.assertEqual(schema["$schema"], "https://json-schema.org/draft/2020-12/schema")
        self.assertEqual(schema["properties"]["format"]["const"], PATCH_FORMAT)


if __name__ == "__main__":
    unittest.main()
