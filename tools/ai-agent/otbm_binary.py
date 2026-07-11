from __future__ import annotations

import base64
import dataclasses
import hashlib
import mmap
import struct
from collections.abc import Iterable, Iterator, Mapping, Sequence
from pathlib import Path
from typing import Any, BinaryIO

NODE_ESCAPE = 0xFD
NODE_START = 0xFE
NODE_END = 0xFF

OTBM_MAP_DATA = 2
OTBM_TILE_AREA = 4
OTBM_TILE = 5
OTBM_ITEM = 6
OTBM_TOWNS = 12
OTBM_HOUSETILE = 14
OTBM_WAYPOINTS = 15
OTBM_TILE_ZONE = 19

ATTR_DESCRIPTION = 1
ATTR_TILE_FLAGS = 3
ATTR_ACTION_ID = 4
ATTR_UNIQUE_ID = 5
ATTR_TEXT = 6
ATTR_DESC = 7
ATTR_TELE_DEST = 8
ATTR_ITEM = 9
ATTR_DEPOT_ID = 10
ATTR_EXT_SPAWN_MONSTER_FILE = 11
ATTR_RUNE_CHARGES = 12
ATTR_EXT_HOUSE_FILE = 13
ATTR_HOUSEDOOR_ID = 14
ATTR_COUNT = 15
ATTR_DURATION = 16
ATTR_DECAYING_STATE = 17
ATTR_WRITTEN_DATE = 18
ATTR_WRITTEN_BY = 19
ATTR_SLEEPER_GUID = 20
ATTR_SLEEP_START = 21
ATTR_CHARGES = 22
ATTR_EXT_SPAWN_NPC_FILE = 23
ATTR_EXT_ZONE_FILE = 24

ATTRIBUTE_NAMES = {
    ATTR_DESCRIPTION: "description",
    ATTR_TILE_FLAGS: "tileFlags",
    ATTR_ACTION_ID: "actionId",
    ATTR_UNIQUE_ID: "uniqueId",
    ATTR_TEXT: "text",
    ATTR_DESC: "specialDescription",
    ATTR_TELE_DEST: "teleportDestination",
    ATTR_ITEM: "item",
    ATTR_DEPOT_ID: "depotId",
    ATTR_EXT_SPAWN_MONSTER_FILE: "monsterFile",
    ATTR_RUNE_CHARGES: "runeCharges",
    ATTR_EXT_HOUSE_FILE: "houseFile",
    ATTR_HOUSEDOOR_ID: "houseDoorId",
    ATTR_COUNT: "count",
    ATTR_DURATION: "duration",
    ATTR_DECAYING_STATE: "decayingState",
    ATTR_WRITTEN_DATE: "writtenDate",
    ATTR_WRITTEN_BY: "writtenBy",
    ATTR_SLEEPER_GUID: "sleeperGuid",
    ATTR_SLEEP_START: "sleepStart",
    ATTR_CHARGES: "charges",
    ATTR_EXT_SPAWN_NPC_FILE: "npcFile",
    ATTR_EXT_ZONE_FILE: "zoneFile",
}
NAME_TO_ATTRIBUTE = {name: attr for attr, name in ATTRIBUTE_NAMES.items()}

ATTRIBUTE_PAYLOAD_TYPES: dict[int, str] = {
    ATTR_ACTION_ID: "u16",
    ATTR_UNIQUE_ID: "u16",
    ATTR_TEXT: "string",
    ATTR_DESC: "string",
    ATTR_TELE_DEST: "position",
    ATTR_DEPOT_ID: "u16",
    ATTR_RUNE_CHARGES: "u8",
    ATTR_HOUSEDOOR_ID: "u8",
    ATTR_COUNT: "u8",
    ATTR_DURATION: "u32",
    ATTR_DECAYING_STATE: "u8",
    ATTR_WRITTEN_DATE: "u32",
    ATTR_WRITTEN_BY: "string",
    ATTR_SLEEPER_GUID: "u32",
    ATTR_SLEEP_START: "u32",
    ATTR_CHARGES: "u16",
}

PATCH_FORMAT = "canary-otbm-patch-v1"
EXPORT_FORMAT = "canary-otbm-region-v1"
REPORT_FORMAT = "canary-otbm-report-v1"
MAX_COORD = 0xFFFF
DEFAULT_MAX_TILES = 4096
MAX_TILE_NODE_BYTES = 1024 * 1024


class OTBMError(RuntimeError):
    """Base exception for malformed or unsupported OTBM data."""


class PatchConflict(OTBMError):
    """Raised internally for a single operation conflict."""


@dataclasses.dataclass(frozen=True)
class MapHeader:
    identifier: bytes
    root_type: int
    version: int
    width: int
    height: int
    items_major: int
    items_minor: int
    root_start: int
    map_data_start: int


@dataclasses.dataclass(frozen=True)
class TileRecord:
    position: tuple[int, int, int]
    area_start: int
    area_base: tuple[int, int, int]
    start: int
    end: int
    node_type: int
    raw: bytes

    @property
    def normalized_hash(self) -> str:
        return tile_hash(self.raw)


@dataclasses.dataclass
class ScanResult:
    header: MapHeader
    map_sha256: str
    file_size: int
    map_attributes: list[dict[str, Any]]
    area_count: int
    tile_count: int
    records: dict[tuple[int, int, int], TileRecord]
    duplicates: dict[tuple[int, int, int], list[TileRecord]]


class MappedFile:
    def __init__(self, path: Path):
        self.path = path
        self.file: BinaryIO | None = None
        self.mm: mmap.mmap | None = None

    def __enter__(self) -> mmap.mmap:
        self.file = self.path.open("rb")
        self.mm = mmap.mmap(self.file.fileno(), 0, access=mmap.ACCESS_READ)
        return self.mm

    def __exit__(self, exc_type: Any, exc: Any, tb: Any) -> None:
        if self.mm is not None:
            self.mm.close()
        if self.file is not None:
            self.file.close()


def sha256_path(path: Path, chunk_size: int = 4 * 1024 * 1024) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(chunk_size):
            digest.update(chunk)
    return digest.hexdigest()


def validate_complete_file(path: Path) -> None:
    with MappedFile(path) as mm:
        header = parse_header(mm)
        root_end = find_node_end(mm, header.root_start)
        _require(root_end == len(mm), f"Trailing bytes after OTBM root node: {len(mm) - root_end}")


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise OTBMError(message)


def node_properties_end(data: bytes | mmap.mmap | memoryview, start: int) -> int:
    _require(start + 2 <= len(data) and data[start] == NODE_START, f"Invalid node start at offset {start}")
    pos = start + 2
    while pos < len(data):
        byte = data[pos]
        if byte == NODE_ESCAPE:
            _require(pos + 1 < len(data), f"Dangling OTBM escape byte at offset {pos}")
            pos += 2
        elif byte in (NODE_START, NODE_END):
            return pos
        else:
            pos += 1
    raise OTBMError(f"Unterminated node properties at offset {start}")


def find_node_end(data: bytes | mmap.mmap | memoryview, start: int) -> int:
    _require(start + 2 <= len(data) and data[start] == NODE_START, f"Invalid node start at offset {start}")
    depth = 1
    pos = start + 2
    while pos < len(data):
        byte = data[pos]
        if byte == NODE_ESCAPE:
            _require(pos + 1 < len(data), f"Dangling OTBM escape byte at offset {pos}")
            pos += 2
        elif byte == NODE_START:
            _require(pos + 1 < len(data), f"Missing node type at offset {pos}")
            depth += 1
            pos += 2
        elif byte == NODE_END:
            depth -= 1
            pos += 1
            if depth == 0:
                return pos
        else:
            pos += 1
    raise OTBMError(f"Unterminated node at offset {start}")


def iter_child_nodes(
    data: bytes | mmap.mmap | memoryview,
    parent_start: int,
) -> Iterator[tuple[int, int, int]]:
    pos = node_properties_end(data, parent_start)
    while pos < len(data) and data[pos] == NODE_START:
        end = find_node_end(data, pos)
        yield pos, end, int(data[pos + 1])
        pos = end
    _require(pos < len(data) and data[pos] == NODE_END, f"Missing node terminator for node at offset {parent_start}")


def unescape_properties(data: bytes | mmap.mmap | memoryview, start: int, end: int) -> bytes:
    output = bytearray()
    pos = start
    while pos < end:
        byte = data[pos]
        if byte == NODE_ESCAPE:
            _require(pos + 1 < end, f"Dangling escape byte at offset {pos}")
            pos += 1
            byte = data[pos]
        output.append(byte)
        pos += 1
    return bytes(output)


def get_node_properties(data: bytes | mmap.mmap | memoryview, start: int) -> bytes:
    props_end = node_properties_end(data, start)
    return unescape_properties(data, start + 2, props_end)


def escape_properties(properties: bytes) -> bytes:
    output = bytearray()
    for byte in properties:
        if byte in (NODE_ESCAPE, NODE_START, NODE_END):
            output.append(NODE_ESCAPE)
        output.append(byte)
    return bytes(output)


def encode_node(node_type: int, properties: bytes, children: Iterable[bytes] = ()) -> bytes:
    _require(0 <= node_type <= 0xFC, f"Unsupported node type {node_type}")
    output = bytearray((NODE_START, node_type))
    output.extend(escape_properties(properties))
    for child in children:
        output.extend(child)
    output.append(NODE_END)
    return bytes(output)


def decode_node_bytes(raw: bytes) -> tuple[int, bytes, list[bytes]]:
    _require(raw and raw[0] == NODE_START, "Raw node does not start with OTBM node marker")
    end = find_node_end(raw, 0)
    _require(end == len(raw), "Raw node contains trailing bytes")
    properties = get_node_properties(raw, 0)
    children = [raw[start:child_end] for start, child_end, _ in iter_child_nodes(raw, 0)]
    return raw[1], properties, children


def parse_header(mm: mmap.mmap) -> MapHeader:
    _require(len(mm) >= 4 + 2 + 16 + 1, "File is too small to be an OTBM map")
    identifier = bytes(mm[:4])
    _require(identifier in (b"\0\0\0\0", b"OTBM"), f"Unsupported OTBM identifier {identifier!r}")
    root_start = 4
    _require(mm[root_start] == NODE_START, "Missing OTBM root node")
    root_type = int(mm[root_start + 1])
    root_props = get_node_properties(mm, root_start)
    _require(len(root_props) >= 16, "OTBM root header is truncated")
    version, width, height, items_major, items_minor = struct.unpack_from("<IHHII", root_props, 0)
    _require(1 <= version <= 5, f"Unsupported OTBM version {version}")
    _require(items_major >= 3, f"Unsupported item major version {items_major}")
    map_data_start = node_properties_end(mm, root_start)
    _require(mm[map_data_start] == NODE_START and mm[map_data_start + 1] == OTBM_MAP_DATA, "Expected map-data node after root properties")
    return MapHeader(
        identifier=identifier,
        root_type=root_type,
        version=version,
        width=width,
        height=height,
        items_major=items_major,
        items_minor=items_minor,
        root_start=root_start,
        map_data_start=map_data_start,
    )


def _read_u16(data: bytes, offset: int) -> tuple[int, int]:
    _require(offset + 2 <= len(data), "Unexpected end of properties while reading uint16")
    return struct.unpack_from("<H", data, offset)[0], offset + 2


def _read_u32(data: bytes, offset: int) -> tuple[int, int]:
    _require(offset + 4 <= len(data), "Unexpected end of properties while reading uint32")
    return struct.unpack_from("<I", data, offset)[0], offset + 4


def _read_string(data: bytes, offset: int) -> tuple[str, int]:
    length, offset = _read_u16(data, offset)
    _require(offset + length <= len(data), "Unexpected end of properties while reading string")
    value = data[offset : offset + length].decode("utf-8", errors="replace")
    return value, offset + length


def parse_map_attributes(properties: bytes) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    offset = 0
    string_attrs = {
        ATTR_DESCRIPTION,
        ATTR_EXT_SPAWN_MONSTER_FILE,
        ATTR_EXT_HOUSE_FILE,
        ATTR_EXT_SPAWN_NPC_FILE,
        ATTR_EXT_ZONE_FILE,
    }
    while offset < len(properties):
        attr = properties[offset]
        offset += 1
        if attr not in string_attrs:
            result.append({"type": attr, "name": ATTRIBUTE_NAMES.get(attr, "unknown"), "rawTailHex": properties[offset:].hex()})
            break
        value, offset = _read_string(properties, offset)
        result.append({"type": attr, "name": ATTRIBUTE_NAMES.get(attr, "unknown"), "value": value})
    return result


def parse_tile_properties(properties: bytes, node_type: int) -> dict[str, Any]:
    minimum = 6 if node_type == OTBM_HOUSETILE else 2
    _require(len(properties) >= minimum, "Tile properties are truncated")
    offset_x = properties[0]
    offset_y = properties[1]
    offset = 2
    house_id: int | None = None
    if node_type == OTBM_HOUSETILE:
        house_id, offset = _read_u32(properties, offset)
    flags = 0
    inline_item: int | None = None
    raw_unknown: str | None = None
    while offset < len(properties):
        attr = properties[offset]
        offset += 1
        if attr == ATTR_TILE_FLAGS:
            flags, offset = _read_u32(properties, offset)
        elif attr == ATTR_ITEM:
            inline_item, offset = _read_u16(properties, offset)
        else:
            raw_unknown = properties[offset - 1 :].hex()
            break
    return {
        "offsetX": offset_x,
        "offsetY": offset_y,
        "houseId": house_id,
        "flags": flags,
        "inlineItemId": inline_item,
        "unknownPropertiesHex": raw_unknown,
    }


def encode_tile_properties(
    *,
    node_type: int,
    offset_x: int,
    offset_y: int,
    house_id: int | None,
    flags: int,
    inline_item_id: int | None,
) -> bytes:
    _require(0 <= offset_x <= 255 and 0 <= offset_y <= 255, "Tile offsets must fit in uint8")
    output = bytearray((offset_x, offset_y))
    if node_type == OTBM_HOUSETILE:
        _require(house_id is not None and 0 <= house_id <= 0xFFFFFFFF, "House tile requires a valid houseId")
        output.extend(struct.pack("<I", house_id))
    if flags:
        output.append(ATTR_TILE_FLAGS)
        output.extend(struct.pack("<I", flags))
    if inline_item_id is not None:
        _require(0 <= inline_item_id <= 0xFFFF, "Item ID must fit in uint16")
        output.append(ATTR_ITEM)
        output.extend(struct.pack("<H", inline_item_id))
    return bytes(output)


def parse_item_attributes(properties: bytes) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    offset = 0
    while offset < len(properties):
        attr_offset = offset
        attr = properties[offset]
        offset += 1
        payload_type = ATTRIBUTE_PAYLOAD_TYPES.get(attr)
        if payload_type is None:
            result.append(
                {
                    "type": attr,
                    "name": ATTRIBUTE_NAMES.get(attr, "unknown"),
                    "rawTailHex": properties[attr_offset:].hex(),
                    "parseComplete": False,
                }
            )
            return result
        if payload_type == "u8":
            _require(offset + 1 <= len(properties), "Truncated uint8 item attribute")
            value: Any = properties[offset]
            offset += 1
        elif payload_type == "u16":
            value, offset = _read_u16(properties, offset)
        elif payload_type == "u32":
            value, offset = _read_u32(properties, offset)
        elif payload_type == "string":
            value, offset = _read_string(properties, offset)
        elif payload_type == "position":
            _require(offset + 5 <= len(properties), "Truncated teleport destination")
            x, y, z = struct.unpack_from("<HHB", properties, offset)
            offset += 5
            value = [x, y, z]
        else:
            raise AssertionError(payload_type)
        result.append({"type": attr, "name": ATTRIBUTE_NAMES.get(attr, "unknown"), "value": value, "parseComplete": True})
    return result


def encode_item_attributes(attributes: Sequence[Mapping[str, Any]]) -> bytes:
    output = bytearray()
    for entry in attributes:
        attr = int(entry["type"])
        payload_type = ATTRIBUTE_PAYLOAD_TYPES.get(attr)
        _require(payload_type is not None, f"Cannot encode unsupported item attribute {attr}")
        output.append(attr)
        value = entry.get("value")
        if payload_type == "u8":
            output.extend(struct.pack("<B", int(value)))
        elif payload_type == "u16":
            output.extend(struct.pack("<H", int(value)))
        elif payload_type == "u32":
            output.extend(struct.pack("<I", int(value)))
        elif payload_type == "string":
            encoded = str(value).encode("utf-8")
            _require(len(encoded) <= 0xFFFF, "String item attribute is too long")
            output.extend(struct.pack("<H", len(encoded)))
            output.extend(encoded)
        elif payload_type == "position":
            _require(isinstance(value, Sequence) and len(value) == 3, "Position attribute requires [x, y, z]")
            output.extend(struct.pack("<HHB", int(value[0]), int(value[1]), int(value[2])))
        else:
            raise AssertionError(payload_type)
    return bytes(output)


def item_view(raw: bytes) -> dict[str, Any]:
    node_type, properties, children = decode_node_bytes(raw)
    result: dict[str, Any] = {
        "nodeType": node_type,
        "rawNodeBase64": base64.b64encode(raw).decode("ascii"),
        "propertiesHex": properties.hex(),
        "childNodeCount": len(children),
    }
    if node_type == OTBM_ITEM:
        _require(len(properties) >= 2, "Item node properties are truncated")
        item_id = struct.unpack_from("<H", properties, 0)[0]
        result["id"] = item_id
        result["attributes"] = parse_item_attributes(properties[2:])
    elif node_type == OTBM_TILE_ZONE:
        count, offset = _read_u16(properties, 0)
        zones: list[int] = []
        for _ in range(count):
            zone, offset = _read_u16(properties, offset)
            zones.append(zone)
        _require(offset == len(properties), "Unexpected trailing zone properties")
        result["zoneIds"] = zones
    return result


def tile_view(record: TileRecord, include_raw: bool = True) -> dict[str, Any]:
    node_type, properties, children = decode_node_bytes(record.raw)
    parsed = parse_tile_properties(properties, node_type)
    result: dict[str, Any] = {
        "position": list(record.position),
        "areaBase": list(record.area_base),
        "nodeType": node_type,
        "kind": "house" if node_type == OTBM_HOUSETILE else "tile",
        "tileHash": record.normalized_hash,
        "houseId": parsed["houseId"],
        "flags": parsed["flags"],
        "inlineItemId": parsed["inlineItemId"],
        "unknownPropertiesHex": parsed["unknownPropertiesHex"],
        "children": [item_view(child) for child in children],
    }
    if include_raw:
        result["rawNodeBase64"] = base64.b64encode(record.raw).decode("ascii")
    return result


def normalize_tile(raw: bytes) -> bytes:
    node_type, properties, children = decode_node_bytes(raw)
    _require(node_type in (OTBM_TILE, OTBM_HOUSETILE), f"Node type {node_type} is not a tile")
    _require(len(properties) >= 2, "Tile properties are truncated")
    normalized = bytes((0, 0)) + properties[2:]
    return encode_node(node_type, normalized, children)


def tile_hash(raw: bytes) -> str:
    return hashlib.sha256(normalize_tile(raw)).hexdigest()


def relocate_tile(raw: bytes, position: tuple[int, int, int], area_base: tuple[int, int, int]) -> bytes:
    node_type, properties, children = decode_node_bytes(raw)
    _require(node_type in (OTBM_TILE, OTBM_HOUSETILE), "Replacement node is not a tile")
    _require(len(properties) >= 2, "Tile properties are truncated")
    x, y, z = position
    base_x, base_y, base_z = area_base
    _require(z == base_z, "Tile and area floors do not match")
    offset_x = x - base_x
    offset_y = y - base_y
    _require(0 <= offset_x <= 255 and 0 <= offset_y <= 255, "Tile does not fit the selected tile area")
    return encode_node(node_type, bytes((offset_x, offset_y)) + properties[2:], children)


def canonical_area_base(position: tuple[int, int, int]) -> tuple[int, int, int]:
    x, y, z = position
    return x & 0xFF00, y & 0xFF00, z
