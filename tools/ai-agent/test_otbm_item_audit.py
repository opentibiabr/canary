from __future__ import annotations

import json
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import (
    ATTR_ACTION_ID,
    ATTR_HOUSEDOOR_ID,
    ATTR_TELE_DEST,
    ATTR_UNIQUE_ID,
    OTBM_ITEM,
    OTBM_MAP_DATA,
    OTBM_TILE,
    OTBM_TILE_AREA,
    encode_item_attributes,
    encode_node,
    encode_tile_properties,
)
from otbm_item_audit import AUDIT_FORMAT, build_item_audit, run_native_item_scan


def item_node(item_id: int, attributes: list[dict[str, object]] | None = None, children: list[bytes] | None = None) -> bytes:
    properties = struct.pack('<H', item_id) + encode_item_attributes(attributes or [])
    return encode_node(OTBM_ITEM, properties, children or [])


def make_map(path: Path) -> None:
    base_x, base_y, floor = 256, 512, 7
    nested = item_node(201, [{"type": ATTR_UNIQUE_ID, "value": 62135}])
    container = item_node(200, [{"type": ATTR_ACTION_ID, "value": 8026}], [nested])
    teleporter = item_node(202, [{"type": ATTR_TELE_DEST, "value": [310, 620, 8]}])
    door = item_node(203, [{"type": ATTR_HOUSEDOOR_ID, "value": 7}])
    decoration = item_node(204)
    tile_properties = encode_tile_properties(
        node_type=OTBM_TILE,
        offset_x=44,
        offset_y=88,
        house_id=None,
        flags=0,
        inline_item_id=100,
    )
    tile = encode_node(OTBM_TILE, tile_properties, [container, teleporter, door, decoration])
    area = encode_node(OTBM_TILE_AREA, struct.pack('<HHB', base_x, base_y, floor), [tile])
    map_data = encode_node(OTBM_MAP_DATA, b'', [area])
    root = encode_node(0, struct.pack('<IHHII', 4, 1024, 1024, 4, 4), [map_data])
    path.write_bytes(b'\0\0\0\0' + root)


def appearances(include_door: bool = True) -> dict[str, object]:
    entries = [
        {"category": "object", "id": 100, "frameGroups": [], "flags": {"bank": {"waypoints": 100}}},
        {"category": "object", "id": 200, "frameGroups": [], "flags": {"container": True}},
        {"category": "object", "id": 201, "frameGroups": [], "flags": {"usable": True}},
        {"category": "object", "id": 202, "frameGroups": [], "flags": {"unmovable": True}},
        {"category": "object", "id": 204, "frameGroups": [], "flags": {"unmovable": True}},
    ]
    if include_door:
        entries.append({"category": "object", "id": 203, "frameGroups": [], "flags": {"unmovable": True}})
    return {
        "format": "canary-appearances-index-v1",
        "ok": True,
        "source": {"path": "appearances.dat", "size": 1, "sha256": "0" * 64},
        "appearances": entries,
    }


def write_items_xml(path: Path) -> None:
    path.write_text(
        '<items>'
        '<item id="100" name="ground"><attribute key="speed" value="100"/></item>'
        '<item id="200" name="container" type="container"/>'
        '<item id="202" name="teleport" type="teleport"/>'
        '</items>',
        encoding='utf-8',
    )


class ItemAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        compiler = shutil.which('c++') or shutil.which('g++')
        if compiler is None:
            raise unittest.SkipTest('A C++ compiler is required')
        cls.build = tempfile.TemporaryDirectory()
        cls.scanner = Path(cls.build.name) / 'otbm_item_audit_scan'
        completed = subprocess.run(
            [compiler, '-O2', '-std=c++20', '-Wall', '-Wextra', '-Wpedantic', str(MODULE_DIR / 'otbm_item_audit_scan.cpp'), '-o', str(cls.scanner)],
            capture_output=True,
            text=True,
            check=False,
        )
        if completed.returncode != 0:
            raise RuntimeError(completed.stderr)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.build.cleanup()

    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.map_path = self.root / 'fixture.otbm'
        self.scan_path = self.root / 'scan.json'
        self.items_xml = self.root / 'items.xml'
        make_map(self.map_path)
        write_items_xml(self.items_xml)

    def tearDown(self) -> None:
        self.temp.cleanup()

    def scan(self) -> dict[str, object]:
        return run_native_item_scan(self.scanner, self.map_path, self.scan_path)

    def test_native_scanner_counts_inline_nested_and_mechanic_attributes(self) -> None:
        scan = self.scan()
        self.assertEqual(scan['tileCount'], 1)
        self.assertEqual(scan['totalPlacements'], 6)
        self.assertEqual(scan['inlinePlacements'], 1)
        self.assertEqual(scan['itemNodePlacements'], 5)
        self.assertEqual(scan['uniqueItemIds'], 6)
        self.assertEqual(scan['unknownAttributeTails'], 0)
        usage = {entry['id']: entry for entry in scan['items']}
        self.assertEqual(usage[100]['inlinePlacements'], 1)
        self.assertEqual(usage[200]['attributes'], {'4': 1})
        self.assertEqual(usage[201]['attributes'], {'5': 1})
        self.assertEqual(usage[202]['attributes'], {'8': 1})
        self.assertEqual(usage[203]['attributes'], {'14': 1})
        mechanics = {entry['itemId']: entry for entry in scan['mechanicPlacements']}
        self.assertEqual(mechanics[200]['actionId'], 8026)
        self.assertEqual(mechanics[201]['uniqueId'], 62135)
        self.assertEqual(mechanics[201]['itemDepth'], 1)
        self.assertEqual(mechanics[202]['teleportDestination'], [310, 620, 8])
        self.assertEqual(mechanics[203]['houseDoorId'], 7)
        self.assertTrue(all(entry['position'] == [300, 600, 7] for entry in mechanics.values()))

    def test_audit_classifies_explicit_interactive_decoration_and_mechanics(self) -> None:
        report = build_item_audit(
            scan=self.scan(),
            appearances_index=appearances(),
            items_xml=self.items_xml,
            map_path=self.map_path,
            include_map_hash=False,
        )
        self.assertEqual(report['format'], AUDIT_FORMAT)
        self.assertTrue(report['ok'])
        summary = report['summary']
        self.assertEqual(summary['usedItemIds'], 6)
        self.assertEqual(summary['withoutItemsXmlIds'], 3)
        self.assertEqual(summary['interactiveWithoutItemsXmlIds'], 2)
        self.assertEqual(summary['appearanceOnlyDecorationIds'], 1)
        self.assertEqual(summary['mapMechanicItemIds'], 4)
        self.assertEqual(summary['mapMechanicPlacements'], 4)
        self.assertEqual([entry['id'] for entry in report['appearanceOnlyDecorations']], [204])
        self.assertEqual({entry['id'] for entry in report['interactiveWithoutItemsXml']}, {201, 203})
        self.assertEqual(report['mechanicSummary']['attributePlacements'], {
            'actionId': 1,
            'houseDoorId': 1,
            'teleportDestination': 1,
            'uniqueId': 1,
        })

    def test_missing_appearance_is_an_error(self) -> None:
        report = build_item_audit(
            scan=self.scan(),
            appearances_index=appearances(include_door=False),
            items_xml=self.items_xml,
            include_map_hash=False,
        )
        self.assertFalse(report['ok'])
        self.assertEqual(report['summary']['missingAppearanceIds'], 1)
        self.assertEqual(report['missingAppearances'][0]['id'], 203)


if __name__ == '__main__':
    unittest.main()
