from __future__ import annotations

import copy
import json
import struct
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import (
    ATTR_EXT_HOUSE_FILE,
    ATTR_EXT_SPAWN_MONSTER_FILE,
    ATTR_EXT_SPAWN_NPC_FILE,
    ATTR_EXT_ZONE_FILE,
    OTBM_HOUSETILE,
    OTBM_MAP_DATA,
    OTBM_TILE_AREA,
    OTBM_TILE_ZONE,
    OTBM_TOWNS,
    encode_node,
    encode_tile_properties,
    sha256_path,
)
from otbm_world_patch import (
    WORLD_PATCH_FORMAT,
    build_world_patch_template,
    execute_world_patch,
    plan_world_patch,
    validate_world_patch,
)

OTBM_TOWN = 13


def encoded_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    return struct.pack("<H", len(raw)) + raw


def make_world_map(path: Path) -> None:
    base = (256, 512, 7)
    properties = encode_tile_properties(
        node_type=OTBM_HOUSETILE,
        offset_x=44,
        offset_y=88,
        house_id=7,
        flags=0,
        inline_item_id=100,
    )
    zone_node = encode_node(OTBM_TILE_ZONE, struct.pack("<HH", 1, 9))
    area = encode_node(
        OTBM_TILE_AREA,
        struct.pack("<HHB", *base),
        [encode_node(OTBM_HOUSETILE, properties, [zone_node])],
    )
    town = encode_node(
        OTBM_TOWN,
        struct.pack("<I", 1) + encoded_string("Test Town") + struct.pack("<HHB", 300, 600, 7),
    )
    towns = encode_node(OTBM_TOWNS, b"", [town])
    attributes = bytearray()
    for attr, filename in (
        (ATTR_EXT_SPAWN_MONSTER_FILE, "test-monster.xml"),
        (ATTR_EXT_SPAWN_NPC_FILE, "test-npc.xml"),
        (ATTR_EXT_HOUSE_FILE, "test-house.xml"),
        (ATTR_EXT_ZONE_FILE, "test-zones.xml"),
    ):
        attributes.append(attr)
        attributes.extend(encoded_string(filename))
    map_data = encode_node(OTBM_MAP_DATA, bytes(attributes), [area, towns])
    path.write_bytes(b"\0\0\0\0" + encode_node(0, struct.pack("<IHHII", 4, 1024, 1024, 4, 4), [map_data]))


def write_companions(root: Path) -> None:
    (root / "test-monster.xml").write_text(
        '<monsters><spawn centerx="300" centery="600" centerz="7" radius="5"><monster name="Rat" x="1" y="0" spawntime="30" direction="1" weight="2"/></spawn></monsters>',
        encoding="utf-8",
    )
    (root / "test-npc.xml").write_text(
        '<npcs><spawn centerx="300" centery="600" centerz="7" radius="3"><npc name="Guide" x="0" y="1" spawntime="60" direction="2"/></spawn></npcs>',
        encoding="utf-8",
    )
    (root / "test-house.xml").write_text(
        '<houses><house houseid="7" name="Old House" entryx="300" entryy="601" entryz="7" rent="1000" size="20" townid="1" clientid="70" beds="2"/></houses>',
        encoding="utf-8",
    )
    (root / "test-zones.xml").write_text(
        '<zones><zone name="old-zone" zoneid="9"/></zones>',
        encoding="utf-8",
    )


class WorldPatchTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.map_path = self.root / "test.otbm"
        make_world_map(self.map_path)
        write_companions(self.root)
        self.source_hashes = {
            path.name: sha256_path(path)
            for path in self.root.glob("*.xml")
        }

    def tearDown(self) -> None:
        self.temp.cleanup()

    def populated_patch(self) -> dict[str, object]:
        patch = build_world_patch_template(self.map_path)
        house_hash = patch["inventory"]["house"][0]["entryHash"]
        zone_hash = patch["inventory"]["zones"][0]["entryHash"]
        monster_hash = patch["inventory"]["monster"][0]["entryHash"]
        patch["operations"] = [
            {
                "op": "upsert_house",
                "expectedEntryHash": house_hash,
                "house": {
                    "houseId": 7,
                    "name": "New House",
                    "entryPosition": [300, 601, 7],
                    "rent": 2500,
                    "size": 20,
                    "townId": 1,
                    "clientId": 70,
                    "guildhall": False,
                    "beds": 3,
                },
            },
            {
                "op": "upsert_zone",
                "expectedEntryHash": zone_hash,
                "zone": {"zoneId": 9, "name": "new-zone"},
            },
            {
                "op": "replace_spawn_group",
                "kind": "monster",
                "groupIndex": 0,
                "expectedEntryHash": monster_hash,
                "group": {
                    "centerPosition": [300, 600, 7],
                    "radius": 5,
                    "entities": [
                        {"name": "Cave Rat", "offset": [1, 0], "spawntime": 45, "direction": 1, "weight": 3}
                    ],
                },
            },
            {
                "op": "add_spawn_group",
                "kind": "npc",
                "group": {
                    "centerPosition": [305, 605, 7],
                    "radius": 2,
                    "entities": [
                        {"name": "Merchant", "offset": [0, 0], "spawntime": 60, "direction": 2}
                    ],
                },
            },
        ]
        return patch

    def test_template_contains_hashes_and_entry_inventory(self) -> None:
        patch = build_world_patch_template(self.map_path)
        self.assertEqual(patch["format"], WORLD_PATCH_FORMAT)
        self.assertEqual(len(patch["base"]["map"]["sha256"]), 64)
        self.assertEqual(set(patch["base"]["files"]), {"monster", "npc", "house", "zones"})
        self.assertEqual(patch["inventory"]["house"][0]["houseId"], 7)
        self.assertEqual(patch["inventory"]["zones"][0]["zoneId"], 9)
        self.assertEqual(patch["inventory"]["monster"][0]["groupIndex"], 0)
        self.assertTrue(validate_world_patch(patch)["ok"])

    def test_dry_run_validates_without_changing_sources(self) -> None:
        patch = self.populated_patch()
        plan = plan_world_patch(self.map_path, patch)
        self.assertTrue(plan.ok, plan.conflicts)

        report = execute_world_patch(plan, output_dir=None, write=False, overwrite=False)

        self.assertTrue(report["ok"], report)
        self.assertEqual(report["mode"], "dry-run")
        self.assertEqual(report["validation"]["issueSummary"]["error"], 0)
        self.assertEqual(report["validation"]["companions"]["npcGroupCount"], 2)
        for path in self.root.glob("*.xml"):
            self.assertEqual(sha256_path(path), self.source_hashes[path.name])

    def test_write_publishes_complete_separate_package(self) -> None:
        patch = self.populated_patch()
        plan = plan_world_patch(self.map_path, patch)
        output = self.root / "generated-world"

        report = execute_world_patch(plan, output_dir=output, write=True, overwrite=False)

        self.assertTrue(report["ok"], report)
        self.assertEqual(report["mode"], "write")
        self.assertTrue((output / "test-house.xml").is_file())
        self.assertTrue((output / "test-zones.xml").is_file())
        self.assertTrue((output / "test-monster.xml").is_file())
        self.assertTrue((output / "test-npc.xml").is_file())
        house = ET.parse(output / "test-house.xml").getroot().find("house")
        self.assertIsNotNone(house)
        assert house is not None
        self.assertEqual(house.attrib["name"], "New House")
        self.assertEqual(house.attrib["rent"], "2500")
        zone = ET.parse(output / "test-zones.xml").getroot().find("zone")
        self.assertIsNotNone(zone)
        assert zone is not None
        self.assertEqual(zone.attrib["name"], "new-zone")
        monster = ET.parse(output / "test-monster.xml").getroot().find("spawn/monster")
        self.assertIsNotNone(monster)
        assert monster is not None
        self.assertEqual(monster.attrib["name"], "Cave Rat")
        for path in self.root.glob("test-*.xml"):
            self.assertEqual(sha256_path(path), self.source_hashes[path.name])

    def test_stale_file_hash_is_a_conflict(self) -> None:
        patch = build_world_patch_template(self.map_path)
        (self.root / "test-house.xml").write_text("<houses/>", encoding="utf-8")

        plan = plan_world_patch(self.map_path, patch)

        self.assertFalse(plan.ok)
        self.assertIn("fileHashMismatch", {conflict["type"] for conflict in plan.conflicts})

    def test_stale_entry_hash_prevents_operation(self) -> None:
        patch = self.populated_patch()
        patch["operations"][0]["expectedEntryHash"] = "0" * 64

        plan = plan_world_patch(self.map_path, patch)

        self.assertFalse(plan.ok)
        operation = next(result for result in plan.operations if result["index"] == 0)
        self.assertEqual(operation["status"], "conflict")

    def test_overwrite_backs_up_entire_previous_output_directory(self) -> None:
        output = self.root / "generated-world"
        output.mkdir()
        (output / "marker.txt").write_text("old package", encoding="utf-8")
        plan = plan_world_patch(self.map_path, self.populated_patch())

        report = execute_world_patch(plan, output_dir=output, write=True, overwrite=True)

        self.assertTrue(report["ok"])
        backup = Path(report["backupDirectory"])
        self.assertEqual((backup / "marker.txt").read_text(encoding="utf-8"), "old package")
        self.assertFalse((output / "marker.txt").exists())
        self.assertTrue((output / "test-house.xml").is_file())

    def test_invalid_patch_is_rejected_before_map_access(self) -> None:
        patch = copy.deepcopy(build_world_patch_template(self.map_path))
        patch["operations"] = [{"op": "remove_house", "houseId": 7}]
        report = validate_world_patch(patch)
        self.assertFalse(report["ok"])
        self.assertIn("precondition", {issue["code"] for issue in report["issues"]})

    def test_schema_file_is_valid_json(self) -> None:
        schema = json.loads((MODULE_DIR.parent.parent / "docs/ai-agent/OTBM_WORLD_PATCH.schema.json").read_text(encoding="utf-8"))
        self.assertEqual(schema["properties"]["format"]["const"], WORLD_PATCH_FORMAT)


if __name__ == "__main__":
    unittest.main()
