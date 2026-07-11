from __future__ import annotations

import base64
import struct
from collections.abc import Mapping, Sequence
from typing import Any

from otbm_binary import (
    ATTRIBUTE_PAYLOAD_TYPES, MAX_COORD, MAX_TILE_NODE_BYTES, NAME_TO_ATTRIBUTE,
    OTBM_HOUSETILE, OTBM_ITEM, OTBM_TILE, OTBMError, PatchConflict, _require,
    canonical_area_base, decode_node_bytes, encode_item_attributes, encode_node,
    encode_tile_properties, parse_item_attributes, parse_tile_properties,
)


def _operation_position(operation: Mapping[str, Any]) -> tuple[int, int, int]:
    value = operation.get("position")
    _require(isinstance(value, Sequence) and not isinstance(value, (str, bytes)) and len(value) == 3, "Patch operation requires position [x, y, z]")
    position = (int(value[0]), int(value[1]), int(value[2]))
    _require(0 <= position[0] <= MAX_COORD and 0 <= position[1] <= MAX_COORD and 0 <= position[2] <= 15, f"Invalid operation position {position}")
    return position


def _decode_tile_from_operation(operation: Mapping[str, Any]) -> bytes:
    encoded = operation.get("tileBase64")
    _require(isinstance(encoded, str) and encoded, "Tile operation requires tileBase64")
    try:
        raw = base64.b64decode(encoded, validate=True)
    except Exception as exc:
        raise OTBMError("Invalid tileBase64") from exc
    _require(len(raw) <= MAX_TILE_NODE_BYTES, f"Tile node exceeds {MAX_TILE_NODE_BYTES} bytes")
    node_type, _, _ = decode_node_bytes(raw)
    _require(node_type in (OTBM_TILE, OTBM_HOUSETILE), "tileBase64 is not an OTBM tile node")
    return raw


def _item_children(tile_raw: bytes) -> tuple[int, bytes, list[bytes]]:
    node_type, properties, children = decode_node_bytes(tile_raw)
    _require(node_type in (OTBM_TILE, OTBM_HOUSETILE), "Target node is not a tile")
    return node_type, properties, children


def _child_item_id(child: bytes) -> int | None:
    node_type, properties, _ = decode_node_bytes(child)
    if node_type != OTBM_ITEM:
        return None
    _require(len(properties) >= 2, "Item node is truncated")
    return struct.unpack_from("<H", properties, 0)[0]


def _select_item_location(
    tile_raw: bytes,
    *,
    item_id: int,
    occurrence: int,
    scope: str,
) -> tuple[str, int | None]:
    node_type, properties, children = _item_children(tile_raw)
    parsed = parse_tile_properties(properties, node_type)
    matches: list[tuple[str, int | None]] = []
    if scope in ("any", "inline") and parsed["inlineItemId"] == item_id:
        matches.append(("inline", None))
    if scope in ("any", "child"):
        for index, child in enumerate(children):
            if _child_item_id(child) == item_id:
                matches.append(("child", index))
    _require(occurrence >= 0, "occurrence must be non-negative")
    if occurrence >= len(matches):
        raise PatchConflict(f"Item {item_id} occurrence {occurrence} was not found")
    return matches[occurrence]


def _rebuild_tile(
    node_type: int,
    properties: bytes,
    children: Sequence[bytes],
) -> bytes:
    return encode_node(node_type, properties, children)


def apply_semantic_operation(tile_raw: bytes, operation: Mapping[str, Any]) -> bytes | None:
    op = operation["op"]
    if op == "delete_tile":
        return None
    if op == "replace_tile":
        return _decode_tile_from_operation(operation)

    node_type, properties, children = _item_children(tile_raw)
    tile_props = parse_tile_properties(properties, node_type)
    _require(tile_props["unknownPropertiesHex"] is None, "Tile contains unsupported properties; semantic edit refused")

    if op == "replace_item_id":
        expected = int(operation["expectedItemId"])
        value = int(operation["itemId"])
        occurrence = int(operation.get("occurrence", 0))
        scope = str(operation.get("scope", "any"))
        _require(scope in ("any", "inline", "child"), "scope must be any, inline, or child")
        location, child_index = _select_item_location(tile_raw, item_id=expected, occurrence=occurrence, scope=scope)
        if location == "inline":
            tile_props["inlineItemId"] = value
            properties = encode_tile_properties(
                node_type=node_type,
                offset_x=tile_props["offsetX"],
                offset_y=tile_props["offsetY"],
                house_id=tile_props["houseId"],
                flags=tile_props["flags"],
                inline_item_id=tile_props["inlineItemId"],
            )
        else:
            assert child_index is not None
            child_type, child_props, child_children = decode_node_bytes(children[child_index])
            children[child_index] = encode_node(child_type, struct.pack("<H", value) + child_props[2:], child_children)
        return _rebuild_tile(node_type, properties, children)

    if op == "remove_item":
        item_id = int(operation["itemId"])
        occurrence = int(operation.get("occurrence", 0))
        scope = str(operation.get("scope", "any"))
        location, child_index = _select_item_location(tile_raw, item_id=item_id, occurrence=occurrence, scope=scope)
        if location == "inline":
            tile_props["inlineItemId"] = None
            properties = encode_tile_properties(
                node_type=node_type,
                offset_x=tile_props["offsetX"],
                offset_y=tile_props["offsetY"],
                house_id=tile_props["houseId"],
                flags=tile_props["flags"],
                inline_item_id=None,
            )
        else:
            assert child_index is not None
            del children[child_index]
        return _rebuild_tile(node_type, properties, children)

    if op == "add_simple_item":
        item_id = int(operation["itemId"])
        _require(0 <= item_id <= 0xFFFF, "Item ID must fit uint16")
        attributes_data = operation.get("attributes", {})
        _require(isinstance(attributes_data, dict), "attributes must be an object")
        attributes: list[dict[str, Any]] = []
        for name, value in attributes_data.items():
            _require(name in NAME_TO_ATTRIBUTE, f"Unknown attribute name {name}")
            attr = NAME_TO_ATTRIBUTE[name]
            _require(attr in ATTRIBUTE_PAYLOAD_TYPES, f"Attribute {name} is not supported for semantic item creation")
            attributes.append({"type": attr, "value": value})
        item_props = struct.pack("<H", item_id) + encode_item_attributes(attributes)
        children.append(encode_node(OTBM_ITEM, item_props))
        return _rebuild_tile(node_type, properties, children)

    if op == "set_item_attribute":
        item_id = int(operation["itemId"])
        occurrence = int(operation.get("occurrence", 0))
        attr_name = str(operation["attribute"])
        _require(attr_name in NAME_TO_ATTRIBUTE, f"Unknown attribute name {attr_name}")
        attr_type = NAME_TO_ATTRIBUTE[attr_name]
        _require(attr_type in ATTRIBUTE_PAYLOAD_TYPES, f"Attribute {attr_name} is not supported")
        location, child_index = _select_item_location(tile_raw, item_id=item_id, occurrence=occurrence, scope="child")
        _require(location == "child" and child_index is not None, "Item attributes require a child item node")
        child_type, child_props, child_children = decode_node_bytes(children[child_index])
        attrs = parse_item_attributes(child_props[2:])
        _require(all(entry.get("parseComplete") for entry in attrs), "Item contains unsupported attributes; edit refused")
        expected = operation.get("expected")
        existing = next((entry for entry in attrs if entry["type"] == attr_type), None)
        current_value = existing.get("value") if existing else None
        if "expected" in operation and current_value != expected:
            raise PatchConflict(f"Expected {attr_name}={expected!r}, found {current_value!r}")
        if operation.get("value") is None:
            attrs = [entry for entry in attrs if entry["type"] != attr_type]
        elif existing:
            existing["value"] = operation["value"]
        else:
            attrs.append({"type": attr_type, "value": operation["value"], "parseComplete": True})
        children[child_index] = encode_node(child_type, child_props[:2] + encode_item_attributes(attrs), child_children)
        return _rebuild_tile(node_type, properties, children)

    if op == "set_tile_flags":
        expected = operation.get("expected")
        if expected is not None and tile_props["flags"] != int(expected):
            raise PatchConflict(f"Expected tile flags {expected}, found {tile_props['flags']}")
        tile_props["flags"] = int(operation["value"])
        properties = encode_tile_properties(
            node_type=node_type,
            offset_x=tile_props["offsetX"],
            offset_y=tile_props["offsetY"],
            house_id=tile_props["houseId"],
            flags=tile_props["flags"],
            inline_item_id=tile_props["inlineItemId"],
        )
        return _rebuild_tile(node_type, properties, children)

    if op == "set_house_id":
        _require(node_type == OTBM_HOUSETILE, "set_house_id requires a house tile")
        expected = operation.get("expected")
        if expected is not None and tile_props["houseId"] != int(expected):
            raise PatchConflict(f"Expected houseId {expected}, found {tile_props['houseId']}")
        tile_props["houseId"] = int(operation["value"])
        properties = encode_tile_properties(
            node_type=node_type,
            offset_x=tile_props["offsetX"],
            offset_y=tile_props["offsetY"],
            house_id=tile_props["houseId"],
            flags=tile_props["flags"],
            inline_item_id=tile_props["inlineItemId"],
        )
        return _rebuild_tile(node_type, properties, children)

    raise OTBMError(f"Unsupported semantic operation {op!r}")


def create_tile_from_operation(operation: Mapping[str, Any], position: tuple[int, int, int]) -> bytes:
    op = operation["op"]
    if op in ("add_tile", "replace_tile"):
        return _decode_tile_from_operation(operation)
    if op != "create_tile":
        raise PatchConflict(f"Operation {op!r} requires an existing tile")
    kind = str(operation.get("kind", "tile"))
    _require(kind in ("tile", "house"), "create_tile kind must be tile or house")
    node_type = OTBM_HOUSETILE if kind == "house" else OTBM_TILE
    base = canonical_area_base(position)
    props = encode_tile_properties(
        node_type=node_type,
        offset_x=position[0] - base[0],
        offset_y=position[1] - base[1],
        house_id=int(operation["houseId"]) if kind == "house" else None,
        flags=int(operation.get("flags", 0)),
        inline_item_id=int(operation["inlineItemId"]) if operation.get("inlineItemId") is not None else None,
    )
    children: list[bytes] = []
    for item in operation.get("items", []):
        _require(isinstance(item, dict), "create_tile items must be objects")
        item_op = dict(item)
        item_op["op"] = "add_simple_item"
        temporary = encode_node(node_type, props, children)
        temporary = apply_semantic_operation(temporary, item_op)
        assert temporary is not None
        _, props, children = decode_node_bytes(temporary)
    return encode_node(node_type, props, children)
