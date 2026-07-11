from __future__ import annotations

import json
import lzma
import struct
import sys
import tempfile
import unittest
import zlib
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import OTBMError, OTBM_ITEM, OTBM_MAP_DATA, OTBM_TILE, OTBM_TILE_AREA, encode_node, encode_tile_properties
from otbm_renderer import RenderDiagnostics, RenderItem, _blend, _pattern, render_region
from otbm_sprites import CIP_SIGNATURE, SHEET_SIZE


def varint(value: int) -> bytes:
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
    return varint(number << 3) + varint(value)


def field_bytes(number: int, value: bytes) -> bytes:
    return varint((number << 3) | 2) + varint(len(value)) + value


def object_appearance(item_id: int, sprite_id: int, *, ground: bool = False, top: bool = False, cumulative: bool = False, patterns: tuple[int, int, int] = (1, 1, 1)) -> bytes:
    info = (
        field_varint(1, patterns[0])
        + field_varint(2, patterns[1])
        + field_varint(3, patterns[2])
        + field_varint(4, 1)
        + field_varint(5, sprite_id)
    )
    frame = field_varint(1, 2) + field_varint(2, 0) + field_bytes(3, info)
    flags = b""
    if ground:
        flags += field_bytes(1, field_varint(1, 100))
    if top:
        flags += field_varint(4, 1)
    if cumulative:
        flags += field_varint(6, 1)
    return field_varint(1, item_id) + field_bytes(2, frame) + field_bytes(3, flags) + field_bytes(4, f"item-{item_id}".encode())


def appearances_file(path: Path, objects: list[bytes]) -> None:
    path.write_bytes(b"".join(field_bytes(1, item) for item in objects))


def encode_7bit(value: int) -> bytes:
    return varint(value)


def make_sheet(path: Path) -> None:
    width = height = SHEET_SIZE
    pixel_offset = 54
    row_stride = width * 4
    top_down = bytearray(row_stride * height)
    for y in range(height):
        for x in range(width):
            offset = (y * width + x) * 4
            if x < 32 and y < 32:
                rgba = (255, 0, 0, 255)
            elif 32 <= x < 64 and y < 32 and x == 32 and y == 0:
                rgba = (0, 255, 0, 255)
            else:
                rgba = (255, 0, 255, 255)
            red, green, blue, alpha = rgba
            top_down[offset : offset + 4] = bytes((blue, green, red, alpha))
    bottom_up = bytearray(len(top_down))
    for y in range(height):
        source = (height - 1 - y) * row_stride
        target = y * row_stride
        bottom_up[target : target + row_stride] = top_down[source : source + row_stride]
    file_size = pixel_offset + len(bottom_up)
    bmp = (
        b"BM"
        + struct.pack("<IHHI", file_size, 0, 0, pixel_offset)
        + struct.pack("<IiiHHIIiiII", 40, width, height, 1, 32, 0, len(bottom_up), 2835, 2835, 0, 0)
        + bottom_up
    )
    properties = (2 * 5 + 0) * 9 + 3
    dictionary_size = 1 << 20
    filters = [{"id": lzma.FILTER_LZMA1, "dict_size": dictionary_size, "lc": 3, "lp": 0, "pb": 2}]
    compressed = lzma.compress(bmp, format=lzma.FORMAT_RAW, filters=filters)
    lzma_file = bytes((properties,)) + struct.pack("<I", dictionary_size) + struct.pack("<Q", len(compressed)) + compressed
    encoded_size = encode_7bit(len(lzma_file))
    padding = 32 - len(CIP_SIGNATURE) - len(encoded_size)
    path.write_bytes(b"\0" * padding + CIP_SIGNATURE + encoded_size + lzma_file)


def make_assets(root: Path, objects: list[bytes]) -> None:
    assets = root / "assets"
    assets.mkdir(parents=True)
    appearances_file(assets / "appearances.dat", objects)
    make_sheet(assets / "sprites.lzma")
    (assets / "catalog-content.json").write_text(
        json.dumps(
            [
                {"type": "appearances", "file": "appearances.dat"},
                {"type": "sprite", "file": "sprites.lzma", "firstspriteid": 100, "lastspriteid": 243, "spritetype": 0},
            ]
        ),
        encoding="utf-8",
    )
    (root / "package.json").write_text(json.dumps({"name": "fixture", "version": "1"}), encoding="utf-8")


def make_map(path: Path, inline_id: int, child_id: int | None = None) -> None:
    properties = encode_tile_properties(
        node_type=OTBM_TILE,
        offset_x=44,
        offset_y=88,
        house_id=None,
        flags=0,
        inline_item_id=inline_id,
    )
    children = [encode_node(OTBM_ITEM, struct.pack("<H", child_id))] if child_id is not None else []
    tile = encode_node(OTBM_TILE, properties, children)
    area = encode_node(OTBM_TILE_AREA, struct.pack("<HHB", 256, 512, 7), [tile])
    map_data = encode_node(OTBM_MAP_DATA, b"", [area])
    path.write_bytes(b"\0\0\0\0" + encode_node(0, struct.pack("<IHHII", 4, 1024, 1024, 4, 4), [map_data]))


def decode_png_rgba(path: Path) -> tuple[int, int, bytes]:
    data = path.read_bytes()
    width, height = struct.unpack_from(">II", data, 16)
    offset = 8
    compressed = bytearray()
    while offset < len(data):
        length = struct.unpack_from(">I", data, offset)[0]
        chunk_type = data[offset + 4 : offset + 8]
        payload = data[offset + 8 : offset + 8 + length]
        if chunk_type == b"IDAT":
            compressed.extend(payload)
        offset += 12 + length
        if chunk_type == b"IEND":
            break
    raw = zlib.decompress(bytes(compressed))
    rows = bytearray()
    stride = width * 4
    cursor = 0
    for _ in range(height):
        if raw[cursor] != 0:
            raise AssertionError("fixture decoder supports filter 0 only")
        cursor += 1
        rows.extend(raw[cursor : cursor + stride])
        cursor += stride
    return width, height, bytes(rows)


class RendererTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.assets = self.root / "client"
        self.map_path = self.root / "map.otbm"
        self.output = self.root / "region.png"

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_renders_map_ground_and_top_item_from_real_cip_assets(self) -> None:
        make_assets(
            self.assets,
            [
                object_appearance(100, 100, ground=True),
                object_appearance(101, 101, top=True),
                # A reduced render package may omit sheets used only by unrelated appearances.
                object_appearance(9999, 500),
            ],
        )
        make_map(self.map_path, 100, 101)
        report = render_region(
            self.map_path,
            self.assets,
            ((300, 600, 7), (300, 600, 7)),
            self.output,
            padding_tiles=0,
        )
        self.assertTrue(report["ok"], report)
        self.assertEqual(report["summary"]["renderedItems"], 2)
        self.assertEqual(report["summary"]["renderedSprites"], 2)
        self.assertEqual(report["summary"]["decodedSheetCount"], 1)
        width, height, rgba = decode_png_rgba(self.output)
        self.assertEqual((width, height), (32, 32))
        self.assertEqual(rgba[:4], b"\x00\xff\x00\xff")
        center = ((16 * width) + 16) * 4
        self.assertEqual(rgba[center : center + 4], b"\xff\x00\x00\xff")

    def test_reports_missing_appearance_but_still_writes_png(self) -> None:
        make_assets(self.assets, [object_appearance(100, 100, ground=True)])
        make_map(self.map_path, 999)
        report = render_region(
            self.map_path,
            self.assets,
            ((300, 600, 7), (300, 600, 7)),
            self.output,
            padding_tiles=0,
        )
        self.assertFalse(report["ok"])
        self.assertTrue(self.output.is_file())
        self.assertEqual(report["summary"]["missingAppearanceCount"], 1)
        self.assertEqual(report["errors"][0]["itemIds"], [999])

    def test_stackable_count_pattern_matches_otclient_rules(self) -> None:
        appearance = {
            "flags": {"cumulative": True},
            "frameGroups": [{"spriteInfo": {"patternWidth": 4, "patternHeight": 2, "patternDepth": 1}}],
        }
        cases = {1: (0, 0, 0), 4: (3, 0, 0), 5: (0, 1, 0), 10: (1, 1, 0), 25: (2, 1, 0), 50: (3, 1, 0)}
        for count, expected in cases.items():
            item = RenderItem(100, ({"name": "count", "value": count, "parseComplete": True},), "node", 0)
            self.assertEqual(_pattern(item, appearance, (300, 600, 7), RenderDiagnostics()), expected)

    def test_alpha_blend_uses_source_over(self) -> None:
        canvas = bytearray(b"\xff\x00\x00\xff")
        _blend(canvas, 1, 1, b"\x00\xff\x00\x80", 1, 1, 0, 0)
        self.assertEqual(canvas[3], 255)
        self.assertLess(abs(canvas[0] - 127), 2)
        self.assertLess(abs(canvas[1] - 128), 2)
        self.assertEqual(canvas[2], 0)

    def test_rejects_multiple_floors(self) -> None:
        make_assets(self.assets, [object_appearance(100, 100, ground=True)])
        make_map(self.map_path, 100)
        with self.assertRaisesRegex(OTBMError, "one floor"):
            render_region(
                self.map_path,
                self.assets,
                ((300, 600, 7), (300, 600, 8)),
                self.output,
            )


if __name__ == "__main__":
    unittest.main()
