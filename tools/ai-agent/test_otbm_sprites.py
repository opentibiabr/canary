from __future__ import annotations

import lzma
import struct
import sys
import tempfile
import unittest
import zlib
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_sprites import (
    CIP_SIGNATURE,
    SHEET_SIZE,
    SpriteSheetError,
    decode_sprite_sheet,
    encode_png,
    extract_sprite,
    layout_size,
    sheet_report,
)


def encode_7bit(value: int) -> bytes:
    output = bytearray()
    while True:
        byte = value & 0x7F
        value >>= 7
        if value:
            output.append(byte | 0x80)
        else:
            output.append(byte)
            return bytes(output)


def make_bmp(*, width: int = SHEET_SIZE, height: int = SHEET_SIZE) -> bytes:
    rgba = bytearray(width * height * 4)
    for index in range(0, len(rgba), 4):
        rgba[index : index + 4] = b"\x00\x00\x00\xff"

    def set_pixel(x: int, y: int, color: bytes) -> None:
        offset = (y * width + x) * 4
        rgba[offset : offset + 4] = color

    set_pixel(0, 0, b"\xff\x00\x00\xff")
    if width > 32:
        set_pixel(32, 0, b"\x00\xff\x00\xff")
    if height > 1:
        set_pixel(0, 1, b"\xff\x00\xff\xff")

    pixel_offset = 54
    row_stride = width * 4
    pixels = bytearray(row_stride * height)
    for output_y in range(height):
        source_y = height - 1 - output_y
        for x in range(width):
            source = (source_y * width + x) * 4
            target = output_y * row_stride + x * 4
            red, green, blue, alpha = rgba[source : source + 4]
            pixels[target : target + 4] = bytes((blue, green, red, alpha))

    file_size = pixel_offset + len(pixels)
    file_header = b"BM" + struct.pack("<IHHI", file_size, 0, 0, pixel_offset)
    dib_header = struct.pack(
        "<IiiHHIIiiII",
        40,
        width,
        height,
        1,
        32,
        0,
        len(pixels),
        2835,
        2835,
        0,
        0,
    )
    return file_header + dib_header + pixels


def make_cip_sheet(bmp: bytes, *, lc: int = 3, lp: int = 0, pb: int = 2, dictionary_size: int = 1 << 20) -> bytes:
    properties = (pb * 5 + lp) * 9 + lc
    filters = [
        {
            "id": lzma.FILTER_LZMA1,
            "dict_size": dictionary_size,
            "lc": lc,
            "lp": lp,
            "pb": pb,
        }
    ]
    compressed = lzma.compress(bmp, format=lzma.FORMAT_RAW, filters=filters)
    lzma_file = bytes((properties,)) + struct.pack("<I", dictionary_size) + struct.pack("<Q", len(compressed)) + compressed
    encoded_size = encode_7bit(len(lzma_file))
    padding = 32 - len(CIP_SIGNATURE) - len(encoded_size)
    if padding < 0:
        raise AssertionError("fixture header is too large")
    return b"\0" * padding + CIP_SIGNATURE + encoded_size + lzma_file


class SpriteSheetTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.path = self.root / "sheet.lzma"
        self.path.write_bytes(make_cip_sheet(make_bmp()))

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_decodes_cip_lzma_bmp_and_matches_otclient_pixel_rules(self) -> None:
        sheet = decode_sprite_sheet(self.path)
        self.assertEqual((sheet.width, sheet.height), (384, 384))
        self.assertEqual(sheet.rgba[0:4], b"\xff\x00\x00\xff")
        second_row = 384 * 4
        self.assertEqual(sheet.rgba[second_row : second_row + 4], b"\0\0\0\0")
        self.assertEqual(sheet.magenta_pixels, 1)
        self.assertEqual(sheet.header.lc, 3)
        self.assertEqual(sheet.header.lp, 0)
        self.assertEqual(sheet.header.pb, 2)
        self.assertEqual(sheet.header.declared_compressed_size, len(self.path.read_bytes()) - 45)
        report = sheet_report(sheet)
        self.assertTrue(report["ok"])
        self.assertEqual(report["bmp"]["rgbaBytes"], 384 * 384 * 4)

    def test_extracts_sprite_using_otclient_layout_grid(self) -> None:
        sheet = decode_sprite_sheet(self.path)
        sprite = extract_sprite(
            sheet,
            sprite_id=101,
            first_sprite_id=100,
            last_sprite_id=243,
            layout=0,
        )
        self.assertEqual((sprite.width, sprite.height), (32, 32))
        self.assertEqual((sprite.column, sprite.row), (1, 0))
        self.assertEqual(sprite.rgba[:4], b"\x00\xff\x00\xff")

    def test_layout_table_matches_extended_otclient_values(self) -> None:
        self.assertEqual(layout_size(0), (32, 32))
        self.assertEqual(layout_size(3), (64, 64))
        self.assertEqual(layout_size(17), (96, 384))
        self.assertEqual(layout_size(35), (384, 384))
        with self.assertRaises(SpriteSheetError):
            layout_size(36)

    def test_encodes_valid_rgba_png(self) -> None:
        png = encode_png(2, 1, b"\xff\x00\x00\xff\x00\xff\x00\x80")
        self.assertEqual(png[:8], b"\x89PNG\r\n\x1a\n")
        ihdr_length = struct.unpack_from(">I", png, 8)[0]
        self.assertEqual(ihdr_length, 13)
        self.assertEqual(png[12:16], b"IHDR")
        width, height = struct.unpack_from(">II", png, 16)
        self.assertEqual((width, height), (2, 1))
        idat = png.index(b"IDAT")
        length = struct.unpack_from(">I", png, idat - 4)[0]
        raw = zlib.decompress(png[idat + 4 : idat + 4 + length])
        self.assertEqual(raw, b"\0\xff\x00\x00\xff\x00\xff\x00\x80")

    def test_rejects_cip_size_mismatch(self) -> None:
        data = bytearray(self.path.read_bytes())
        signature = data.index(CIP_SIGNATURE)
        size_offset = signature + len(CIP_SIGNATURE)
        data[size_offset] ^= 1
        self.path.write_bytes(data)
        with self.assertRaisesRegex(SpriteSheetError, "size mismatch"):
            decode_sprite_sheet(self.path)

    def test_rejects_inner_compressed_size_mismatch(self) -> None:
        data = bytearray(self.path.read_bytes())
        declared = struct.unpack_from("<Q", data, 37)[0]
        struct.pack_into("<Q", data, 37, declared + 1)
        self.path.write_bytes(data)
        with self.assertRaisesRegex(SpriteSheetError, "compressed size mismatch"):
            decode_sprite_sheet(self.path)

    def test_rejects_missing_signature(self) -> None:
        data = self.path.read_bytes().replace(CIP_SIGNATURE, b"abcde", 1)
        self.path.write_bytes(data)
        with self.assertRaisesRegex(SpriteSheetError, "signature"):
            decode_sprite_sheet(self.path)

    def test_rejects_non_384_bmp(self) -> None:
        self.path.write_bytes(make_cip_sheet(make_bmp(width=32, height=32)))
        with self.assertRaisesRegex(SpriteSheetError, "384x384"):
            decode_sprite_sheet(self.path)

    def test_rejects_sprite_outside_range_or_capacity(self) -> None:
        sheet = decode_sprite_sheet(self.path)
        with self.assertRaisesRegex(SpriteSheetError, "outside"):
            extract_sprite(sheet, sprite_id=99, first_sprite_id=100, last_sprite_id=200, layout=0)
        with self.assertRaisesRegex(SpriteSheetError, "capacity"):
            extract_sprite(sheet, sprite_id=244, first_sprite_id=100, last_sprite_id=300, layout=0)

    def test_rejects_invalid_png_dimensions(self) -> None:
        with self.assertRaises(SpriteSheetError):
            encode_png(2, 2, b"short")


if __name__ == "__main__":
    unittest.main()
