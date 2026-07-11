from __future__ import annotations

import binascii
import hashlib
import json
import mmap
import os
import re
import struct
import subprocess
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

NODE_ESCAPE = 0xFD
NODE_START = 0xFE
NODE_END = 0xFF
OTBM_MAP_DATA = 2
OTBM_TILE_AREA = 4
OTBM_TILE = 5
OTBM_HOUSETILE = 14
REFERENCE_FORMAT = "canary-otbm-reference-report-v1"
OCCUPANCY_FORMAT = "canary-otbm-occupancy-v1"
DEFAULT_ORIGIN = (31744, 30976)
DEFAULT_WIDTH = 2560
DEFAULT_HEIGHT = 2048
MARKER_PATTERN = re.compile(b"[\xfe\xff]")


class ReferenceError(RuntimeError):
    pass


@dataclass(frozen=True)
class PngImage:
    width: int
    height: int
    rgb: bytes


@dataclass
class ComponentStats:
    area: int
    walkable: int
    min_x: int
    min_y: int
    max_x: int
    max_y: int
    sum_x: int
    sum_y: int

    def merge(self, other: "ComponentStats") -> None:
        self.area += other.area
        self.walkable += other.walkable
        self.min_x = min(self.min_x, other.min_x)
        self.min_y = min(self.min_y, other.min_y)
        self.max_x = max(self.max_x, other.max_x)
        self.max_y = max(self.max_y, other.max_y)
        self.sum_x += other.sum_x
        self.sum_y += other.sum_y


def sha256_path(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(4 * 1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _is_escaped(data: mmap.mmap, position: int) -> bool:
    count = 0
    position -= 1
    while position >= 0 and data[position] == NODE_ESCAPE:
        count += 1
        position -= 1
    return bool(count & 1)


def _read_logical(data: mmap.mmap, position: int, count: int) -> list[int]:
    result: list[int] = []
    while len(result) < count:
        if position >= len(data):
            raise ReferenceError("Truncated OTBM properties")
        value = data[position]
        position += 1
        if value == NODE_ESCAPE:
            if position >= len(data):
                raise ReferenceError("Dangling OTBM escape byte")
            value = data[position]
            position += 1
        elif value in {NODE_START, NODE_END}:
            raise ReferenceError("OTBM node properties are shorter than expected")
        result.append(value)
    return result


def _set_bit(bits: bytearray, index: int) -> bool:
    byte_index = index >> 3
    bit = 1 << (index & 7)
    duplicate = bool(bits[byte_index] & bit)
    bits[byte_index] |= bit
    return duplicate


def bit_at(bits: bytes | bytearray, index: int) -> bool:
    return bool(bits[index >> 3] & (1 << (index & 7)))


def scan_otbm_occupancy(
    path: Path,
    *,
    origin: tuple[int, int] = DEFAULT_ORIGIN,
    width: int = DEFAULT_WIDTH,
    height: int = DEFAULT_HEIGHT,
    floors: Iterable[int] = range(16),
    include_hash: bool = True,
) -> dict[str, Any]:
    source = path.resolve()
    if not source.is_file():
        raise FileNotFoundError(source)
    if width <= 0 or height <= 0:
        raise ReferenceError("Reference dimensions must be positive")
    selected_floors = sorted(set(int(floor) for floor in floors))
    if not selected_floors or selected_floors[0] < 0 or selected_floors[-1] > 15:
        raise ReferenceError("Floors must be within 0..15")

    pixels = width * height
    byte_count = (pixels + 7) // 8
    occupancy = {floor: bytearray(byte_count) for floor in selected_floors}
    floor_counts = [0] * 16
    floor_bounds: list[list[int] | None] = [None] * 16
    total_tiles = 0
    in_reference_bounds = 0
    duplicate_reference_positions = 0
    tile_area_nodes = 0
    stack: list[tuple[int, tuple[int, int, int] | None]] = []
    origin_x, origin_y = origin

    with source.open("rb") as stream, mmap.mmap(stream.fileno(), 0, access=mmap.ACCESS_READ) as data:
        if len(data) < 8:
            raise ReferenceError("OTBM file is too small")
        for marker in MARKER_PATTERN.finditer(data):
            position = marker.start()
            if _is_escaped(data, position):
                continue
            value = data[position]
            if value == NODE_END:
                if not stack:
                    raise ReferenceError(f"Unexpected OTBM node end at offset {position}")
                stack.pop()
                continue

            if position + 1 >= len(data):
                raise ReferenceError("OTBM node has no type")
            node_type = int(data[position + 1])
            parent_type, parent_area = stack[-1] if stack else (-1, None)
            area: tuple[int, int, int] | None = None
            if node_type == OTBM_TILE_AREA and parent_type == OTBM_MAP_DATA:
                props = _read_logical(data, position + 2, 5)
                area = (props[0] | props[1] << 8, props[2] | props[3] << 8, props[4])
                tile_area_nodes += 1
            elif node_type in {OTBM_TILE, OTBM_HOUSETILE} and parent_type == OTBM_TILE_AREA and parent_area is not None:
                props = _read_logical(data, position + 2, 2)
                x = parent_area[0] + props[0]
                y = parent_area[1] + props[1]
                z = parent_area[2]
                total_tiles += 1
                if 0 <= z <= 15:
                    floor_counts[z] += 1
                    current = floor_bounds[z]
                    if current is None:
                        floor_bounds[z] = [x, y, x, y]
                    else:
                        current[0] = min(current[0], x)
                        current[1] = min(current[1], y)
                        current[2] = max(current[2], x)
                        current[3] = max(current[3], y)
                    if z in occupancy and origin_x <= x < origin_x + width and origin_y <= y < origin_y + height:
                        index = (y - origin_y) * width + (x - origin_x)
                        if _set_bit(occupancy[z], index):
                            duplicate_reference_positions += 1
                        else:
                            in_reference_bounds += 1
            stack.append((node_type, area))

    if stack:
        raise ReferenceError("OTBM contains unterminated nodes")

    return {
        "format": OCCUPANCY_FORMAT,
        "source": {
            "path": str(source),
            "size": source.stat().st_size,
            "sha256": sha256_path(source) if include_hash else None,
        },
        "origin": list(origin),
        "width": width,
        "height": height,
        "tileAreaNodes": tile_area_nodes,
        "totalTiles": total_tiles,
        "inReferenceBoundsTiles": in_reference_bounds,
        "duplicateReferencePositions": duplicate_reference_positions,
        "floors": [
            {
                "z": z,
                "tileCount": floor_counts[z],
                "bounds": None
                if floor_bounds[z] is None
                else [floor_bounds[z][:2], floor_bounds[z][2:]],
                "occupancy": bytes(occupancy[z]) if z in occupancy else None,
            }
            for z in range(16)
        ],
    }


def write_occupancy(directory: Path, report: dict[str, Any]) -> None:
    destination = directory.resolve()
    destination.mkdir(parents=True, exist_ok=True)
    serializable = {key: value for key, value in report.items() if key != "floors"}
    serializable["floors"] = []
    for floor in report["floors"]:
        entry = {key: value for key, value in floor.items() if key != "occupancy"}
        serializable["floors"].append(entry)
        occupancy = floor.get("occupancy")
        if occupancy is not None:
            (destination / f"floor-{floor['z']:02d}.bits").write_bytes(occupancy)
    (destination / "occupancy.json").write_text(json.dumps(serializable, indent=2) + "\n", encoding="utf-8")


def locate_native_scanner(explicit: Path | None = None) -> Path:
    candidates: list[Path] = []
    if explicit is not None:
        candidates.append(explicit)
    environment = os.environ.get("OTBM_REFERENCE_SCANNER")
    if environment:
        candidates.append(Path(environment))
    module_directory = Path(__file__).resolve().parent
    candidates.extend((module_directory / "otbm_reference_scan", module_directory / "otbm_reference_scan.exe"))
    for candidate in candidates:
        resolved = candidate.expanduser().resolve()
        if resolved.is_file():
            return resolved
    raise ReferenceError(
        "Native OTBM scanner was not found. Compile tools/ai-agent/otbm_reference_scan.cpp "
        "and pass --scanner, or set OTBM_REFERENCE_SCANNER."
    )


def run_native_scanner(
    scanner: Path,
    map_path: Path,
    output_directory: Path,
    *,
    origin: tuple[int, int],
    width: int,
    height: int,
) -> dict[str, Any]:
    destination = output_directory.resolve()
    destination.mkdir(parents=True, exist_ok=True)
    command = [
        str(scanner.resolve()),
        str(map_path.resolve()),
        str(destination),
        "--origin-x",
        str(origin[0]),
        "--origin-y",
        str(origin[1]),
        "--width",
        str(width),
        "--height",
        str(height),
    ]
    completed = subprocess.run(command, capture_output=True, text=True, check=False)
    if completed.returncode != 0:
        detail = completed.stderr.strip() or completed.stdout.strip() or f"exit code {completed.returncode}"
        raise ReferenceError(f"Native OTBM scanner failed: {detail}")
    manifest_path = destination / "occupancy.json"
    if not manifest_path.is_file():
        raise ReferenceError("Native OTBM scanner did not produce occupancy.json")
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReferenceError(f"Cannot read native occupancy manifest: {exc}") from exc
    if manifest.get("format") != OCCUPANCY_FORMAT:
        raise ReferenceError("Unsupported native occupancy manifest format")
    if manifest.get("origin") != list(origin) or manifest.get("width") != width or manifest.get("height") != height:
        raise ReferenceError("Native occupancy manifest dimensions do not match the reference")
    floors = manifest.get("floors")
    if not isinstance(floors, list) or len(floors) != 16:
        raise ReferenceError("Native occupancy manifest must contain 16 floors")
    expected_bytes = (width * height + 7) // 8
    for floor in floors:
        filename = floor.get("occupancyFile")
        if not isinstance(filename, str):
            raise ReferenceError("Native occupancy floor has no occupancyFile")
        path = destination / filename
        if not path.is_file() or path.stat().st_size != expected_bytes:
            raise ReferenceError(f"Invalid native occupancy bitset: {path}")
    return manifest


def read_native_occupancy(directory: Path, manifest: dict[str, Any], floor: int) -> bytes:
    floors = manifest.get("floors", [])
    entry = next((item for item in floors if item.get("z") == floor), None)
    if entry is None:
        raise ReferenceError(f"Native occupancy manifest has no floor {floor}")
    path = directory / entry["occupancyFile"]
    return path.read_bytes()


def _paeth(left: int, above: int, upper_left: int) -> int:
    estimate = left + above - upper_left
    left_distance = abs(estimate - left)
    above_distance = abs(estimate - above)
    upper_left_distance = abs(estimate - upper_left)
    if left_distance <= above_distance and left_distance <= upper_left_distance:
        return left
    if above_distance <= upper_left_distance:
        return above
    return upper_left


def read_png_rgb(path: Path) -> PngImage:
    source = path.resolve()
    data = source.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ReferenceError(f"Not a PNG file: {source}")
    position = 8
    width = height = 0
    bit_depth = color_type = interlace = -1
    idat = bytearray()
    palette: list[tuple[int, int, int]] = []
    transparency = b""
    while position < len(data):
        if position + 12 > len(data):
            raise ReferenceError(f"Truncated PNG chunk in {source}")
        length = struct.unpack_from(">I", data, position)[0]
        chunk_type = data[position + 4 : position + 8]
        payload_start = position + 8
        payload_end = payload_start + length
        crc_end = payload_end + 4
        if crc_end > len(data):
            raise ReferenceError(f"PNG chunk exceeds file bounds in {source}")
        payload = data[payload_start:payload_end]
        expected_crc = struct.unpack_from(">I", data, payload_end)[0]
        actual_crc = binascii.crc32(chunk_type)
        actual_crc = binascii.crc32(payload, actual_crc) & 0xFFFFFFFF
        if actual_crc != expected_crc:
            raise ReferenceError(f"PNG CRC mismatch for {chunk_type!r} in {source}")
        if chunk_type == b"IHDR":
            if length != 13:
                raise ReferenceError("Invalid PNG IHDR length")
            width, height, bit_depth, color_type, compression, filtering, interlace = struct.unpack(">IIBBBBB", payload)
            if compression != 0 or filtering != 0:
                raise ReferenceError("Unsupported PNG compression or filter method")
        elif chunk_type == b"PLTE":
            if len(payload) % 3:
                raise ReferenceError("Invalid PNG palette length")
            palette = [tuple(payload[index:index + 3]) for index in range(0, len(payload), 3)]
        elif chunk_type == b"tRNS":
            transparency = payload
        elif chunk_type == b"IDAT":
            idat.extend(payload)
        elif chunk_type == b"IEND":
            break
        position = crc_end
    if width <= 0 or height <= 0:
        raise ReferenceError(f"PNG has no valid IHDR: {source}")
    supported = (color_type in {2, 6} and bit_depth == 8) or (color_type == 3 and bit_depth in {1, 2, 4, 8})
    if not supported or interlace != 0:
        raise ReferenceError(
            f"Only non-interlaced RGB/RGBA or indexed PNG is supported; got bitDepth={bit_depth}, colorType={color_type}, interlace={interlace}"
        )
    if color_type == 3 and not palette:
        raise ReferenceError("Indexed PNG has no palette")
    bytes_per_pixel = 3 if color_type == 2 else 4 if color_type == 6 else 1
    stride = width * bytes_per_pixel if color_type != 3 else (width * bit_depth + 7) // 8
    try:
        raw = zlib.decompress(bytes(idat))
    except zlib.error as exc:
        raise ReferenceError(f"PNG decompression failed for {source}: {exc}") from exc
    if len(raw) != height * (stride + 1):
        raise ReferenceError(f"Unexpected PNG scanline size in {source}")

    reconstructed = bytearray(height * stride)
    source_offset = 0
    for y in range(height):
        filter_type = raw[source_offset]
        source_offset += 1
        target_offset = y * stride
        for x in range(stride):
            value = raw[source_offset + x]
            left = reconstructed[target_offset + x - bytes_per_pixel] if x >= bytes_per_pixel else 0
            above = reconstructed[target_offset - stride + x] if y > 0 else 0
            upper_left = reconstructed[target_offset - stride + x - bytes_per_pixel] if y > 0 and x >= bytes_per_pixel else 0
            if filter_type == 0:
                decoded = value
            elif filter_type == 1:
                decoded = value + left
            elif filter_type == 2:
                decoded = value + above
            elif filter_type == 3:
                decoded = value + ((left + above) // 2)
            elif filter_type == 4:
                decoded = value + _paeth(left, above, upper_left)
            else:
                raise ReferenceError(f"Unsupported PNG row filter {filter_type}")
            reconstructed[target_offset + x] = decoded & 0xFF
        source_offset += stride

    if color_type == 2:
        rgb = bytes(reconstructed)
    elif color_type == 6:
        rgb_data = bytearray(width * height * 3)
        source_offset = target_offset = 0
        for _ in range(width * height):
            red, green, blue, alpha = reconstructed[source_offset : source_offset + 4]
            if alpha == 0:
                red = green = blue = 0
            rgb_data[target_offset : target_offset + 3] = bytes((red, green, blue))
            source_offset += 4
            target_offset += 3
        rgb = bytes(rgb_data)
    else:
        rgb_data = bytearray(width * height * 3)
        target_offset = 0
        mask = (1 << bit_depth) - 1
        for y in range(height):
            row = reconstructed[y * stride : (y + 1) * stride]
            for x in range(width):
                bit_offset = x * bit_depth
                byte_value = row[bit_offset >> 3]
                shift = 8 - bit_depth - (bit_offset & 7)
                palette_index = (byte_value >> shift) & mask
                if palette_index >= len(palette):
                    raise ReferenceError("PNG palette index is out of bounds")
                red, green, blue = palette[palette_index]
                alpha = transparency[palette_index] if palette_index < len(transparency) else 255
                if alpha == 0:
                    red = green = blue = 0
                rgb_data[target_offset : target_offset + 3] = bytes((red, green, blue))
                target_offset += 3
        rgb = bytes(rgb_data)
    return PngImage(width=width, height=height, rgb=rgb)


class _UnionFind:
    def __init__(self) -> None:
        self.parent: list[int] = []
        self.stats: list[ComponentStats] = []

    def add(self, stats: ComponentStats) -> int:
        index = len(self.parent)
        self.parent.append(index)
        self.stats.append(stats)
        return index

    def find(self, value: int) -> int:
        root = value
        while self.parent[root] != root:
            root = self.parent[root]
        while self.parent[value] != value:
            parent = self.parent[value]
            self.parent[value] = root
            value = parent
        return root

    def union(self, left: int, right: int) -> int:
        left_root = self.find(left)
        right_root = self.find(right)
        if left_root == right_root:
            return left_root
        if self.stats[left_root].area < self.stats[right_root].area:
            left_root, right_root = right_root, left_root
        self.parent[right_root] = left_root
        self.stats[left_root].merge(self.stats[right_root])
        return left_root


def _runs(row: bytes) -> list[tuple[int, int]]:
    result: list[tuple[int, int]] = []
    position = 0
    while position < len(row):
        start = row.find(b"\x01", position)
        if start < 0:
            break
        end = row.find(b"\x00", start)
        if end < 0:
            end = len(row)
        result.append((start, end))
        position = end
    return result


def connected_components(
    mask: bytes | bytearray,
    walkable: bytes | bytearray,
    *,
    width: int,
    height: int,
    origin: tuple[int, int],
    floor: int,
    minimum_area: int,
) -> list[dict[str, Any]]:
    if len(mask) != width * height or len(walkable) != len(mask):
        raise ReferenceError("Component mask dimensions do not match")
    union_find = _UnionFind()
    previous: list[tuple[int, int, int]] = []
    origin_x, origin_y = origin
    for y in range(height):
        start_offset = y * width
        row = bytes(mask[start_offset : start_offset + width])
        walkable_row = bytes(walkable[start_offset : start_offset + width])
        current: list[tuple[int, int, int]] = []
        for start, end in _runs(row):
            length = end - start
            walkable_count = walkable_row[start:end].count(1)
            world_start_x = origin_x + start
            world_end_x = origin_x + end - 1
            world_y = origin_y + y
            run_id = union_find.add(
                ComponentStats(
                    area=length,
                    walkable=walkable_count,
                    min_x=world_start_x,
                    min_y=world_y,
                    max_x=world_end_x,
                    max_y=world_y,
                    sum_x=(world_start_x + world_end_x) * length // 2,
                    sum_y=world_y * length,
                )
            )
            current.append((start, end, run_id))

        previous_index = 0
        for start, end, run_id in current:
            while previous_index < len(previous) and previous[previous_index][1] <= start:
                previous_index += 1
            candidate = previous_index
            while candidate < len(previous) and previous[candidate][0] < end:
                previous_start, previous_end, previous_id = previous[candidate]
                if previous_start < end and start < previous_end:
                    run_id = union_find.union(run_id, previous_id)
                candidate += 1
        previous = [(start, end, union_find.find(run_id)) for start, end, run_id in current]

    components: list[dict[str, Any]] = []
    for index, stats in enumerate(union_find.stats):
        if union_find.find(index) != index or stats.area < minimum_area:
            continue
        components.append(
            {
                "floor": floor,
                "area": stats.area,
                "walkable": stats.walkable,
                "walkableRatio": round(stats.walkable / stats.area, 6),
                "bounds": {
                    "from": [stats.min_x, stats.min_y, floor],
                    "to": [stats.max_x, stats.max_y, floor],
                },
                "centroid": [round(stats.sum_x / stats.area, 1), round(stats.sum_y / stats.area, 1), floor],
                "width": stats.max_x - stats.min_x + 1,
                "height": stats.max_y - stats.min_y + 1,
            }
        )
    components.sort(key=lambda entry: (entry["area"], entry["walkable"]), reverse=True)
    return components


def _pixel(rgb: bytes, index: int) -> tuple[int, int, int]:
    offset = index * 3
    return rgb[offset], rgb[offset + 1], rgb[offset + 2]


def compare_floor(
    *,
    floor: int,
    map_image: PngImage,
    path_image: PngImage,
    occupancy: bytes,
    origin: tuple[int, int],
    minimum_component_area: int = 8,
    write_diff_to: Path | None = None,
) -> dict[str, Any]:
    if map_image.width != path_image.width or map_image.height != path_image.height:
        raise ReferenceError("Map and pathfinding PNG dimensions differ")
    width, height = map_image.width, map_image.height
    pixels = width * height
    if len(occupancy) < (pixels + 7) // 8:
        raise ReferenceError("OTBM occupancy bitset is too short")

    latest_only = bytearray(pixels)
    walkable_latest_only = bytearray(pixels)
    overlay = bytearray(pixels * 4) if write_diff_to else None
    latest_terrain = otbm_tiles = overlap = latest_only_count = otbm_only = walkable_count = 0
    background = (51, 102, 153) if floor == 7 else (0, 0, 0)

    for index in range(pixels):
        color = _pixel(map_image.rgb, index)
        terrain = color != background
        occupied = bit_at(occupancy, index)
        if terrain:
            latest_terrain += 1
        if occupied:
            otbm_tiles += 1
        if terrain and occupied:
            overlap += 1
            overlay_color = (35, 170, 70, 255)
        elif terrain:
            latest_only[index] = 1
            latest_only_count += 1
            path_color = _pixel(path_image.rgb, index)
            is_walkable = path_color[0] == path_color[1] == path_color[2]
            if is_walkable:
                walkable_latest_only[index] = 1
                walkable_count += 1
            overlay_color = (235, 50, 40, 255)
        elif occupied:
            otbm_only += 1
            overlay_color = (40, 100, 235, 255)
        else:
            overlay_color = (0, 0, 0, 0)
        if overlay is not None:
            offset = index * 4
            overlay[offset : offset + 4] = bytes(overlay_color)

    components = connected_components(
        latest_only,
        walkable_latest_only,
        width=width,
        height=height,
        origin=origin,
        floor=floor,
        minimum_area=minimum_component_area,
    )
    if write_diff_to is not None and overlay is not None:
        from otbm_sprites import encode_png

        write_diff_to.parent.mkdir(parents=True, exist_ok=True)
        write_diff_to.write_bytes(encode_png(width, height, bytes(overlay)))

    return {
        "z": floor,
        "latestTerrainTiles": latest_terrain,
        "otbmTilesInBounds": otbm_tiles,
        "overlapTiles": overlap,
        "latestOnlyTiles": latest_only_count,
        "latestOnlyWalkableTiles": walkable_count,
        "otbmOnlyTiles": otbm_only,
        "coverageOfLatest": round(overlap / max(1, latest_terrain), 6),
        "componentCount": len(components),
        "largestComponents": components,
    }


def compare_tibiamaps(
    *,
    map_path: Path,
    tibiamaps_directory: Path,
    output_directory: Path,
    scanner_path: Path | None = None,
    origin: tuple[int, int] = DEFAULT_ORIGIN,
    floors: Iterable[int] = range(16),
    minimum_component_area: int = 8,
    include_hash: bool = True,
) -> dict[str, Any]:
    selected_floors = sorted(set(int(floor) for floor in floors))
    if not selected_floors or selected_floors[0] < 0 or selected_floors[-1] > 15:
        raise ReferenceError("Floors must be within 0..15")
    reference_directory = tibiamaps_directory.resolve()
    output_directory = output_directory.resolve()
    first_map = read_png_rgb(reference_directory / f"floor-{selected_floors[0]:02d}-map.png")
    scanner = locate_native_scanner(scanner_path)
    occupancy_directory = output_directory / "occupancy"
    occupancy_report = run_native_scanner(
        scanner,
        map_path,
        occupancy_directory,
        origin=origin,
        width=first_map.width,
        height=first_map.height,
    )
    occupancy_report["source"] = {
        "path": str(map_path.resolve()),
        "size": map_path.resolve().stat().st_size,
        "sha256": sha256_path(map_path.resolve()) if include_hash else None,
    }
    (occupancy_directory / "occupancy.json").write_text(
        json.dumps(occupancy_report, indent=2) + "\n", encoding="utf-8"
    )

    output_directory.mkdir(parents=True, exist_ok=True)
    floor_reports: list[dict[str, Any]] = []
    largest_regions: list[dict[str, Any]] = []
    for floor in selected_floors:
        map_image = read_png_rgb(reference_directory / f"floor-{floor:02d}-map.png")
        path_image = read_png_rgb(reference_directory / f"floor-{floor:02d}-path.png")
        if map_image.width != first_map.width or map_image.height != first_map.height:
            raise ReferenceError("TibiaMaps floor dimensions are inconsistent")
        occupancy = read_native_occupancy(occupancy_directory, occupancy_report, floor)
        floor_report = compare_floor(
            floor=floor,
            map_image=map_image,
            path_image=path_image,
            occupancy=occupancy,
            origin=origin,
            minimum_component_area=minimum_component_area,
            write_diff_to=output_directory / f"floor-{floor:02d}-diff.png",
        )
        floor_reports.append(floor_report)
        largest_regions.extend(floor_report["largestComponents"][:50])

    totals = {
        key: sum(int(floor[key]) for floor in floor_reports)
        for key in (
            "latestTerrainTiles",
            "otbmTilesInBounds",
            "overlapTiles",
            "latestOnlyTiles",
            "latestOnlyWalkableTiles",
            "otbmOnlyTiles",
        )
    }
    report = {
        "format": REFERENCE_FORMAT,
        "reference": {
            "directory": str(reference_directory),
            "origin": list(origin),
            "width": first_map.width,
            "height": first_map.height,
            "floors": selected_floors,
        },
        "otbm": occupancy_report,
        "totals": totals,
        "coverageOfLatest": round(totals["overlapTiles"] / max(1, totals["latestTerrainTiles"]), 6),
        "floors": floor_reports,
        "largestMissingRegions": sorted(
            largest_regions,
            key=lambda entry: (entry["area"], entry["walkable"]),
            reverse=True,
        )[:100],
        "largestWalkableMissingRegions": sorted(
            largest_regions,
            key=lambda entry: (entry["walkable"], entry["area"]),
            reverse=True,
        )[:100],
        "legend": {
            "green": "tile exists in both OTBM and reference",
            "red": "tile exists only in reference",
            "blue": "tile exists only in OTBM",
            "transparent": "tile exists in neither source",
        },
    }
    (output_directory / "comparison.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    return report
