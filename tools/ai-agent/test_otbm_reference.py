from __future__ import annotations

import binascii
import json
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
import zlib
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_binary import OTBM_MAP_DATA, OTBM_TILE, OTBM_TILE_AREA, encode_node, encode_tile_properties
from otbm_reference import (
    PngImage,
    bit_at,
    compare_floor,
    connected_components,
    read_png_rgb,
    scan_otbm_occupancy,
    write_occupancy,
    compare_tibiamaps,
)
from otbm_sprites import encode_png


def png_chunk(chunk_type: bytes, payload: bytes) -> bytes:
    crc = binascii.crc32(chunk_type)
    crc = binascii.crc32(payload, crc) & 0xFFFFFFFF
    return struct.pack('>I', len(payload)) + chunk_type + payload + struct.pack('>I', crc)


def indexed_png_4(width: int, height: int, indexes: list[int], palette: list[tuple[int, int, int]]) -> bytes:
    stride = (width + 1) // 2
    rows = bytearray()
    for y in range(height):
        rows.append(0)
        row = indexes[y * width : (y + 1) * width]
        for x in range(0, width, 2):
            high = row[x] << 4
            low = row[x + 1] if x + 1 < width else 0
            rows.append(high | low)
    ihdr = struct.pack('>IIBBBBB', width, height, 4, 3, 0, 0, 0)
    plte = b''.join(bytes(color) for color in palette)
    return b'\x89PNG\r\n\x1a\n' + png_chunk(b'IHDR', ihdr) + png_chunk(b'PLTE', plte) + png_chunk(b'IDAT', zlib.compress(bytes(rows))) + png_chunk(b'IEND', b'')


def make_map(path: Path) -> None:
    base_x, base_y, floor = 256, 512, 7
    tiles = []
    for x, y, item_id in ((300, 600, 100), (301, 600, 101), (510, 767, 102)):
        properties = encode_tile_properties(
            node_type=OTBM_TILE,
            offset_x=x - base_x,
            offset_y=y - base_y,
            house_id=None,
            flags=0,
            inline_item_id=item_id,
        )
        tiles.append(encode_node(OTBM_TILE, properties))
    area = encode_node(OTBM_TILE_AREA, struct.pack('<HHB', base_x, base_y, floor), tiles)
    map_data = encode_node(OTBM_MAP_DATA, b'', [area])
    root = encode_node(0, struct.pack('<IHHII', 4, 1024, 1024, 4, 4), [map_data])
    path.write_bytes(b'\0\0\0\0' + root)


class ReferenceTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self) -> None:
        self.temp.cleanup()

    def test_reads_rgba_and_indexed_four_bit_png(self) -> None:
        rgba_path = self.root / 'rgba.png'
        rgba_path.write_bytes(encode_png(2, 1, b'\xff\x00\x00\xff\x00\xff\x00\xff'))
        rgba = read_png_rgb(rgba_path)
        self.assertEqual((rgba.width, rgba.height), (2, 1))
        self.assertEqual(rgba.rgb, b'\xff\x00\x00\x00\xff\x00')

        indexed_path = self.root / 'indexed.png'
        indexed_path.write_bytes(indexed_png_4(3, 2, [0, 1, 2, 2, 1, 0], [(0, 0, 0), (51, 102, 153), (255, 51, 0)]))
        indexed = read_png_rgb(indexed_path)
        self.assertEqual((indexed.width, indexed.height), (3, 2))
        self.assertEqual(indexed.rgb[:9], b'\x00\x00\x00\x33\x66\x99\xff\x33\x00')
        self.assertEqual(indexed.rgb[9:], b'\xff\x33\x00\x33\x66\x99\x00\x00\x00')

    def test_scans_otbm_occupancy_including_escaped_offsets(self) -> None:
        map_path = self.root / 'fixture.otbm'
        make_map(map_path)
        report = scan_otbm_occupancy(
            map_path,
            origin=(256, 512),
            width=256,
            height=256,
            floors=[7],
            include_hash=False,
        )
        self.assertEqual(report['totalTiles'], 3)
        self.assertEqual(report['inReferenceBoundsTiles'], 3)
        bits = report['floors'][7]['occupancy']
        self.assertTrue(bit_at(bits, (600 - 512) * 256 + (300 - 256)))
        self.assertTrue(bit_at(bits, (600 - 512) * 256 + (301 - 256)))
        self.assertTrue(bit_at(bits, (767 - 512) * 256 + (510 - 256)))
        output = self.root / 'occupancy'
        write_occupancy(output, report)
        metadata = json.loads((output / 'occupancy.json').read_text())
        self.assertEqual(metadata['totalTiles'], 3)
        self.assertEqual((output / 'floor-07.bits').read_bytes(), bits)

    def test_connected_components_use_four_neighbor_and_walkability(self) -> None:
        width, height = 5, 4
        mask = bytearray([
            1, 1, 0, 0, 1,
            0, 1, 0, 1, 1,
            0, 0, 1, 0, 0,
            1, 1, 0, 0, 0,
        ])
        walkable = bytearray([1 if value and index % 2 == 0 else 0 for index, value in enumerate(mask)])
        components = connected_components(mask, walkable, width=width, height=height, origin=(100, 200), floor=8, minimum_area=1)
        self.assertEqual([entry['area'] for entry in components], [3, 3, 2, 1])
        self.assertEqual(components[0]['bounds'], {'from': [100, 200, 8], 'to': [101, 201, 8]})
        self.assertEqual(components[1]['bounds'], {'from': [103, 200, 8], 'to': [104, 201, 8]})
        self.assertEqual(components[2]['bounds'], {'from': [100, 203, 8], 'to': [101, 203, 8]})

    def test_compare_floor_reports_latest_only_and_diff(self) -> None:
        width, height = 4, 3
        blue = (51, 102, 153)
        red = (255, 51, 0)
        pixels = [blue] * (width * height)
        for index in (1, 2, 5, 10):
            pixels[index] = red
        map_image = PngImage(width, height, b''.join(bytes(pixel) for pixel in pixels))
        path_pixels = [(255, 255, 0)] * (width * height)
        path_pixels[2] = (100, 100, 100)
        path_pixels[10] = (150, 150, 150)
        path_image = PngImage(width, height, b''.join(bytes(pixel) for pixel in path_pixels))
        occupancy = bytearray((width * height + 7) // 8)
        occupancy[0] |= 1 << 1
        occupancy[0] |= 1 << 5
        occupancy[1] |= 1 << (11 - 8)
        diff = self.root / 'diff.png'
        report = compare_floor(
            floor=7,
            map_image=map_image,
            path_image=path_image,
            occupancy=bytes(occupancy),
            origin=(300, 400),
            minimum_component_area=1,
            write_diff_to=diff,
        )
        self.assertEqual(report['latestTerrainTiles'], 4)
        self.assertEqual(report['overlapTiles'], 2)
        self.assertEqual(report['latestOnlyTiles'], 2)
        self.assertEqual(report['latestOnlyWalkableTiles'], 2)
        self.assertEqual(report['otbmOnlyTiles'], 1)
        self.assertEqual(report['componentCount'], 2)
        self.assertTrue(diff.is_file())
        decoded = read_png_rgb(diff)
        self.assertEqual((decoded.width, decoded.height), (width, height))

    def test_native_scanner_and_end_to_end_compare(self) -> None:
        compiler = shutil.which("c++") or shutil.which("g++")
        if compiler is None:
            self.skipTest("A C++ compiler is required for the native scanner integration test")
        scanner_source = MODULE_DIR / "otbm_reference_scan.cpp"
        scanner = self.root / "otbm_reference_scan"
        completed = subprocess.run(
            [compiler, "-O2", "-std=c++20", str(scanner_source), "-o", str(scanner)],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(completed.returncode, 0, completed.stderr)

        map_path = self.root / "fixture.otbm"
        make_map(map_path)
        reference = self.root / "reference"
        reference.mkdir()
        width, height = 4, 3
        blue = b"\x33\x66\x99\xff"
        red = b"\xff\x33\x00\xff"
        map_pixels = [blue] * (width * height)
        for index in (0, 1, 5, 10):
            map_pixels[index] = red
        path_pixels = [b"\xff\xff\x00\xff"] * (width * height)
        path_pixels[5] = b"\x64\x64\x64\xff"
        path_pixels[10] = b"\x96\x96\x96\xff"
        (reference / "floor-07-map.png").write_bytes(encode_png(width, height, b"".join(map_pixels)))
        (reference / "floor-07-path.png").write_bytes(encode_png(width, height, b"".join(path_pixels)))

        output = self.root / "comparison"
        report = compare_tibiamaps(
            map_path=map_path,
            tibiamaps_directory=reference,
            output_directory=output,
            scanner_path=scanner,
            origin=(300, 600),
            floors=[7],
            minimum_component_area=1,
            include_hash=False,
        )
        self.assertEqual(report["totals"]["latestTerrainTiles"], 4)
        self.assertEqual(report["totals"]["overlapTiles"], 2)
        self.assertEqual(report["totals"]["latestOnlyTiles"], 2)
        self.assertEqual(report["totals"]["latestOnlyWalkableTiles"], 2)
        self.assertEqual(report["otbm"]["totalTiles"], 3)
        self.assertEqual(report["otbm"]["inReferenceBoundsTiles"], 2)
        self.assertTrue((output / "floor-07-diff.png").is_file())
        self.assertTrue((output / "occupancy" / "floor-07.bits").is_file())



if __name__ == '__main__':
    unittest.main()
