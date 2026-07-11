from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_appearances import APPEARANCES_INDEX_FORMAT, ProtobufDecodeError, build_appearances_index


def varint(value: int) -> bytes:
    if value < 0:
        value += 1 << 64
    output = bytearray()
    while True:
        byte = value & 0x7F
        value >>= 7
        if value:
            output.append(byte | 0x80)
        else:
            output.append(byte)
            return bytes(output)


def field_varint(number: int, value: int) -> bytes:
    return varint((number << 3) | 0) + varint(value)


def field_bytes(number: int, value: bytes) -> bytes:
    return varint((number << 3) | 2) + varint(len(value)) + value


def simple_message(values: dict[int, int]) -> bytes:
    return b"".join(field_varint(number, value) for number, value in values.items())


def sprite_info(sprite_ids: list[int], *, packed: bool = False, animation: bool = True) -> bytes:
    payload = field_varint(1, 2) + field_varint(2, 1) + field_varint(3, 1) + field_varint(4, 1)
    if packed:
        payload += field_bytes(5, b"".join(varint(sprite_id) for sprite_id in sprite_ids))
    else:
        payload += b"".join(field_varint(5, sprite_id) for sprite_id in sprite_ids)
    if animation:
        phase = simple_message({1: 100, 2: 200})
        animation_message = (
            field_varint(1, 0)
            + field_varint(2, 1)
            + field_varint(3, 0)
            + field_varint(4, -1)
            + field_varint(5, 0)
            + field_bytes(6, phase)
        )
        payload += field_bytes(6, animation_message)
    payload += field_varint(7, 64) + field_varint(8, 1)
    return payload


def flags_message() -> bytes:
    return b"".join(
        [
            field_varint(3, 1),
            field_varint(4, 1),
            field_varint(13, 1),
            field_varint(14, 1),
            field_varint(28, 1),
            field_bytes(23, simple_message({1: 7, 2: 215})),
            field_bytes(26, simple_message({1: 3, 2: 4})),
            field_bytes(27, simple_message({1: 8})),
            field_bytes(30, simple_message({1: 42})),
            field_bytes(72, simple_message({1: 65})),
            field_varint(99, 12345),
        ]
    )


def appearance(appearance_id: int, sprite_ids: list[int], *, name: str = "fixture", packed: bool = False, with_flags: bool = True) -> bytes:
    frame_group = field_varint(1, 2) + field_varint(2, 0) + field_bytes(3, sprite_info(sprite_ids, packed=packed))
    payload = field_varint(1, appearance_id) + field_bytes(2, frame_group)
    if with_flags:
        payload += field_bytes(3, flags_message())
    payload += field_bytes(4, name.encode("utf-8")) + field_bytes(5, b"description")
    return payload


def root_message(objects: list[bytes], *, outfits: list[bytes] | None = None) -> bytes:
    payload = b"".join(field_bytes(1, value) for value in objects)
    payload += b"".join(field_bytes(2, value) for value in outfits or [])
    return payload


def asset_index(first: int, last: int) -> dict[str, object]:
    return {"sprites": [{"firstSpriteId": first, "lastSpriteId": last}]}


class AppearancesIndexTests(unittest.TestCase):
    def write(self, payload: bytes) -> Path:
        path = self.root / "appearances.dat"
        path.write_bytes(payload)
        return path

    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_parses_objects_frames_animation_flags_and_sprite_ids(self) -> None:
        path = self.write(root_message([appearance(2148, [100, 101, 102], packed=True, name="gold coin")]))
        report = build_appearances_index(path, asset_index=asset_index(0, 200))
        self.assertEqual(report["format"], APPEARANCES_INDEX_FORMAT)
        self.assertTrue(report["ok"], report["issues"])
        self.assertEqual(report["categories"]["object"], 1)
        entry = report["appearances"][0]
        self.assertEqual(entry["id"], 2148)
        self.assertEqual(entry["name"], "gold coin")
        self.assertTrue(entry["flags"]["bottom"])
        self.assertTrue(entry["flags"]["top"])
        self.assertEqual(entry["flags"]["shift"], {"x": 3, "y": 4})
        self.assertEqual(entry["flags"]["height"], {"elevation": 8})
        self.assertEqual(entry["flags"]["automap"], {"color": 42})
        info = entry["frameGroups"][0]["spriteInfo"]
        self.assertEqual(info["spriteIds"], [100, 101, 102])
        self.assertEqual(info["patternWidth"], 2)
        self.assertEqual(info["animation"]["loopType"], -1)
        self.assertEqual(info["animation"]["phases"], [{"durationMin": 100, "durationMax": 200}])
        self.assertEqual(report["summary"]["uniqueSpriteIds"], 3)

    def test_reports_duplicate_object_ids(self) -> None:
        path = self.write(root_message([appearance(100, [1]), appearance(100, [2])]))
        report = build_appearances_index(path)
        self.assertFalse(report["ok"])
        self.assertIn("duplicate_appearance_id", {issue["code"] for issue in report["issues"]})

    def test_reports_uncovered_sprite_ids_against_asset_index(self) -> None:
        path = self.write(root_message([appearance(100, [10, 20, 30])]))
        report = build_appearances_index(path, asset_index=asset_index(10, 20))
        self.assertFalse(report["ok"])
        issue = next(issue for issue in report["issues"] if issue["code"] == "uncovered_sprite_ids")
        self.assertEqual(issue["sample"], [30])
        self.assertEqual(report["summary"]["uncoveredSpriteIdCount"], 1)

    def test_indexes_non_objects_only_when_requested(self) -> None:
        payload = root_message([appearance(100, [1])], outfits=[appearance(200, [2], name="outfit")])
        path = self.write(payload)
        default = build_appearances_index(path)
        expanded = build_appearances_index(path, include_non_objects=True)
        self.assertEqual(default["categories"], {"object": 1, "outfit": 1, "effect": 0, "missile": 0})
        self.assertEqual(len(default["appearances"]), 1)
        self.assertEqual(len(expanded["appearances"]), 2)
        self.assertEqual(expanded["appearances"][1]["category"], "outfit")

    def test_missing_flags_and_zero_sprite_are_warnings(self) -> None:
        path = self.write(root_message([appearance(100, [0], with_flags=False)]))
        report = build_appearances_index(path)
        self.assertTrue(report["ok"])
        codes = {issue["code"] for issue in report["issues"]}
        self.assertIn("objects_without_flags", codes)
        self.assertIn("zero_sprite_reference", codes)
        self.assertEqual(report["summary"]["missingFlags"], 1)

    def test_unknown_fields_are_skipped(self) -> None:
        object_payload = appearance(100, [1]) + field_bytes(100, b"future extension")
        path = self.write(field_varint(100, 77) + root_message([object_payload]))
        report = build_appearances_index(path)
        self.assertTrue(report["ok"])
        self.assertEqual(report["appearances"][0]["id"], 100)

    def test_rejects_truncated_or_overlong_varints(self) -> None:
        path = self.write(b"\x08\x80")
        with self.assertRaises(ProtobufDecodeError):
            build_appearances_index(path)
        path.write_bytes(b"\x08" + b"\x80" * 11)
        with self.assertRaises(ProtobufDecodeError):
            build_appearances_index(path)

    def test_invalid_utf8_is_replaced_and_reported(self) -> None:
        payload = field_varint(1, 100) + field_bytes(2, field_bytes(3, sprite_info([1]))) + field_bytes(3, flags_message()) + field_bytes(4, b"\xff")
        path = self.write(root_message([payload]))
        report = build_appearances_index(path)
        self.assertTrue(report["ok"])
        self.assertEqual(report["appearances"][0]["name"], "�")
        self.assertIn("invalid_utf8", {issue["code"] for issue in report["issues"]})


if __name__ == "__main__":
    unittest.main()
