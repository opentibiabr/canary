from __future__ import annotations

import struct
import sys
import tempfile
import unittest
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
    OTBM_WAYPOINTS,
    encode_node,
    encode_tile_properties,
)
from otbm_world import WORLD_INDEX_FORMAT, build_world_index

OTBM_TOWN = 13
OTBM_WAYPOINT = 16


def encoded_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    return struct.pack("<H", len(raw)) + raw


def make_world_map(path: Path, *, house_id: int = 7, zone_id: int = 9) -> None:
    base = (256, 512, 7)
    tile_properties = encode_tile_properties(
        node_type=OTBM_HOUSETILE,
        offset_x=44,
        offset_y=88,
        house_id=house_id,
        flags=0,
        inline_item_id=100,
    )
    zone_node = encode_node(OTBM_TILE_ZONE, struct.pack("<HH", 1, zone_id))
    house_tile = encode_node(OTBM_HOUSETILE, tile_properties, [zone_node])
    area = encode_node(OTBM_TILE_AREA, struct.pack("<HHB", *base), [house_tile])

    town_properties = struct.pack("<I", 1) + encoded_string("Test Town") + struct.pack("<HHB", 300, 600, 7)
    towns = encode_node(OTBM_TOWNS, b"", [encode_node(OTBM_TOWN, town_properties)])
    waypoint_properties = encoded_string("quest entrance") + struct.pack("<HHB", 301, 600, 7)
    waypoints = encode_node(OTBM_WAYPOINTS, b"", [encode_node(OTBM_WAYPOINT, waypoint_properties)])

    attributes = bytearray()
    for attr, filename in (
        (ATTR_EXT_SPAWN_MONSTER_FILE, "test-monster.xml"),
        (ATTR_EXT_SPAWN_NPC_FILE, "test-npc.xml"),
        (ATTR_EXT_HOUSE_FILE, "test-house.xml"),
        (ATTR_EXT_ZONE_FILE, "test-zones.xml"),
    ):
        attributes.append(attr)
        attributes.extend(encoded_string(filename))
    map_data = encode_node(OTBM_MAP_DATA, bytes(attributes), [area, towns, waypoints])
    root_properties = struct.pack("<IHHII", 4, 1024, 1024, 4, 4)
    path.write_bytes(b"\0\0\0\0" + encode_node(0, root_properties, [map_data]))


def write_companions(root: Path, *, house_id: int = 7, zone_id: int = 9, town_id: int = 1) -> None:
    (root / "test-monster.xml").write_text(
        '<monsters><spawn centerx="300" centery="600" centerz="7" radius="5"><monster name="Rat" x="1" y="0" spawntime="30" direction="1" weight="2"/></spawn></monsters>',
        encoding="utf-8",
    )
    (root / "test-npc.xml").write_text(
        '<npcs><spawn centerx="300" centery="600" centerz="7" radius="3"><npc name="Guide" x="0" y="1" spawntime="60" direction="2"/></spawn></npcs>',
        encoding="utf-8",
    )
    (root / "test-house.xml").write_text(
        f'<houses><house houseid="{house_id}" name="Test House" entryx="300" entryy="601" entryz="7" rent="1000" size="20" townid="{town_id}" clientid="70" beds="2"/></houses>',
        encoding="utf-8",
    )
    (root / "test-zones.xml").write_text(
        f'<zones><zone name="test-zone" zoneid="{zone_id}"/></zones>',
        encoding="utf-8",
    )


class WorldIndexTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.map_path = self.root / "test.otbm"
        make_world_map(self.map_path)
        write_companions(self.root)

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_indexes_map_metadata_and_companion_files(self) -> None:
        report = build_world_index(self.map_path)
        self.assertEqual(report["format"], WORLD_INDEX_FORMAT)
        self.assertTrue(report["ok"], report["issues"])
        self.assertEqual(report["map"]["towns"][0]["name"], "Test Town")
        self.assertEqual(report["map"]["waypoints"][0]["name"], "quest entrance")
        self.assertEqual(report["map"]["houseIds"], [7])
        self.assertEqual(report["map"]["zoneIds"], [9])
        self.assertEqual(report["companions"]["house"]["entries"][0]["townId"], 1)
        self.assertEqual(report["companions"]["monster"]["entries"][0]["position"], [301, 600, 7])
        self.assertEqual(report["companions"]["npc"]["entries"][0]["position"], [300, 601, 7])
        self.assertEqual(report["summary"]["companionFilesPresent"], 4)
        self.assertEqual(report["issueSummary"]["error"], 0)

    def test_summary_only_omits_large_entry_arrays(self) -> None:
        report = build_world_index(self.map_path, include_entries=False)
        self.assertTrue(report["ok"])
        self.assertEqual(report["companions"]["monster"]["entries"], [])
        self.assertEqual(report["companions"]["npc"]["groups"], [])
        self.assertEqual(report["companions"]["monster"]["summary"]["entityCount"], 1)

    def test_reports_missing_companion_file(self) -> None:
        (self.root / "test-npc.xml").unlink()
        report = build_world_index(self.map_path)
        self.assertFalse(report["ok"])
        codes = {issue["code"] for issue in report["issues"]}
        self.assertIn("missing_companion_file", codes)
        self.assertFalse(report["companions"]["npc"]["exists"])

    def test_cross_checks_house_zone_and_town_references(self) -> None:
        write_companions(self.root, house_id=8, zone_id=10, town_id=999)
        report = build_world_index(self.map_path)
        self.assertFalse(report["ok"])
        codes = {issue["code"] for issue in report["issues"]}
        self.assertIn("house_missing_from_xml", codes)
        self.assertIn("house_missing_from_map", codes)
        self.assertIn("zone_missing_from_xml", codes)
        self.assertIn("unknown_house_town", codes)

    def test_guesses_conventional_companion_names(self) -> None:
        guessed_map = self.root / "guessed.otbm"
        base = (256, 512, 7)
        props = encode_tile_properties(node_type=OTBM_HOUSETILE, offset_x=44, offset_y=88, house_id=7, flags=0, inline_item_id=100)
        area = encode_node(OTBM_TILE_AREA, struct.pack("<HHB", *base), [encode_node(OTBM_HOUSETILE, props)])
        towns = encode_node(OTBM_TOWNS, b"", [encode_node(OTBM_TOWN, struct.pack("<I", 1) + encoded_string("Test Town") + struct.pack("<HHB", 300, 600, 7))])
        waypoints = encode_node(OTBM_WAYPOINTS, b"")
        map_data = encode_node(OTBM_MAP_DATA, b"", [area, towns, waypoints])
        guessed_map.write_bytes(b"\0\0\0\0" + encode_node(0, struct.pack("<IHHII", 4, 1024, 1024, 4, 4), [map_data]))
        for suffix, content in (
            ("monster", "<monsters/>"),
            ("npc", "<npcs/>"),
            ("house", '<houses><house houseid="7" name="H" entryx="1" entryy="1" entryz="7" townid="1"/></houses>'),
            ("zones", "<zones/>"),
        ):
            (self.root / f"guessed-{suffix}.xml").write_text(content, encoding="utf-8")
        report = build_world_index(guessed_map)
        self.assertTrue(all(data["source"] == "convention" for data in report["companions"].values()))
        self.assertGreaterEqual(report["issueSummary"]["info"], 4)


if __name__ == "__main__":
    unittest.main()
