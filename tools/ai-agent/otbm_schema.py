from __future__ import annotations

import base64
import re
from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from typing import Any

from otbm_binary import MAX_COORD, MAX_TILE_NODE_BYTES, OTBM_HOUSETILE, OTBM_ITEM, OTBM_TILE, PATCH_FORMAT, decode_node_bytes

HASH_PATTERN = re.compile(r"^[0-9a-fA-F]{64}$")
SUPPORTED_OPERATIONS = {
    "replace_item_id",
    "remove_item",
    "add_simple_item",
    "set_item_attribute",
    "set_tile_flags",
    "set_house_id",
    "create_tile",
    "add_tile",
    "replace_tile",
    "delete_tile",
}
EXISTING_TILE_OPERATIONS = SUPPORTED_OPERATIONS - {"create_tile", "add_tile"}


@dataclass(frozen=True)
class ValidationIssue:
    path: str
    message: str
    code: str
    severity: str = "error"

    def to_json(self) -> dict[str, str]:
        return {
            "path": self.path,
            "message": self.message,
            "code": self.code,
            "severity": self.severity,
        }


def _is_int(value: Any) -> bool:
    return isinstance(value, int) and not isinstance(value, bool)


def _check_position(value: Any, path: str, issues: list[ValidationIssue]) -> tuple[int, int, int] | None:
    if not isinstance(value, Sequence) or isinstance(value, (str, bytes)) or len(value) != 3:
        issues.append(ValidationIssue(path, "must be an array [x, y, z]", "position_shape"))
        return None
    if not all(_is_int(part) for part in value):
        issues.append(ValidationIssue(path, "coordinates must be integers", "position_type"))
        return None
    position = int(value[0]), int(value[1]), int(value[2])
    if not (0 <= position[0] <= MAX_COORD and 0 <= position[1] <= MAX_COORD and 0 <= position[2] <= 15):
        issues.append(ValidationIssue(path, "position is outside OTBM coordinate limits", "position_range"))
        return None
    return position


def _check_item_id(value: Any, path: str, issues: list[ValidationIssue]) -> None:
    if not _is_int(value) or not 0 <= int(value) <= 0xFFFF:
        issues.append(ValidationIssue(path, "must be an integer from 0 to 65535", "item_id"))


def _check_hash(value: Any, path: str, issues: list[ValidationIssue]) -> None:
    if not isinstance(value, str) or HASH_PATTERN.fullmatch(value) is None:
        issues.append(ValidationIssue(path, "must be a 64-character SHA-256 hex string", "sha256"))


def _check_tile_base64(value: Any, path: str, issues: list[ValidationIssue]) -> None:
    if not isinstance(value, str) or not value:
        issues.append(ValidationIssue(path, "must be a non-empty Base64 string", "tile_base64"))
        return
    try:
        raw = base64.b64decode(value, validate=True)
    except Exception:
        issues.append(ValidationIssue(path, "is not valid Base64", "tile_base64"))
        return
    if len(raw) > MAX_TILE_NODE_BYTES:
        issues.append(ValidationIssue(path, f"decoded tile exceeds {MAX_TILE_NODE_BYTES} bytes", "tile_size"))
        return
    try:
        node_type, _, _ = decode_node_bytes(raw)
    except Exception as exc:
        issues.append(ValidationIssue(path, f"does not contain one complete OTBM node: {exc}", "tile_node"))
        return
    if node_type not in (OTBM_TILE, OTBM_HOUSETILE):
        issues.append(ValidationIssue(path, f"node type {node_type} is not a tile", "tile_node_type"))


def _required(operation: Mapping[str, Any], field: str, path: str, issues: list[ValidationIssue]) -> bool:
    if field not in operation:
        issues.append(ValidationIssue(f"{path}.{field}", "is required", "required"))
        return False
    return True


def _validate_operation(
    operation: Any,
    index: int,
    lower: tuple[int, int, int] | None,
    upper: tuple[int, int, int] | None,
    require_preconditions: bool,
    issues: list[ValidationIssue],
) -> None:
    path = f"$.operations[{index}]"
    if not isinstance(operation, Mapping):
        issues.append(ValidationIssue(path, "must be an object", "operation_type"))
        return
    op = operation.get("op")
    if not isinstance(op, str) or op not in SUPPORTED_OPERATIONS:
        issues.append(ValidationIssue(f"{path}.op", f"must be one of {sorted(SUPPORTED_OPERATIONS)}", "operation_name"))
        return
    position = _check_position(operation.get("position"), f"{path}.position", issues)
    if position is not None and lower is not None and upper is not None:
        if not all(lower[axis] <= position[axis] <= upper[axis] for axis in range(3)):
            issues.append(ValidationIssue(f"{path}.position", "is outside patch bounds", "operation_bounds"))

    if "expectedTileHash" in operation:
        _check_hash(operation["expectedTileHash"], f"{path}.expectedTileHash", issues)
    elif require_preconditions and op in EXISTING_TILE_OPERATIONS:
        issues.append(ValidationIssue(f"{path}.expectedTileHash", "is required for an existing-tile operation", "precondition"))

    if op in {"add_tile", "replace_tile"}:
        if _required(operation, "tileBase64", path, issues):
            _check_tile_base64(operation["tileBase64"], f"{path}.tileBase64", issues)
    elif op == "replace_item_id":
        for field in ("expectedItemId", "itemId"):
            if _required(operation, field, path, issues):
                _check_item_id(operation[field], f"{path}.{field}", issues)
        scope = operation.get("scope", "any")
        if scope not in {"any", "inline", "child"}:
            issues.append(ValidationIssue(f"{path}.scope", "must be any, inline, or child", "scope"))
    elif op in {"remove_item", "add_simple_item", "set_item_attribute"}:
        if _required(operation, "itemId", path, issues):
            _check_item_id(operation["itemId"], f"{path}.itemId", issues)
        if op == "add_simple_item" and "attributes" in operation and not isinstance(operation["attributes"], Mapping):
            issues.append(ValidationIssue(f"{path}.attributes", "must be an object", "attributes_type"))
        if op == "set_item_attribute":
            if _required(operation, "attribute", path, issues) and not isinstance(operation["attribute"], str):
                issues.append(ValidationIssue(f"{path}.attribute", "must be a string", "attribute_name"))
            if "value" not in operation:
                issues.append(ValidationIssue(f"{path}.value", "must be present; null removes the attribute", "required"))
    elif op == "set_tile_flags":
        if _required(operation, "value", path, issues) and (not _is_int(operation["value"]) or not 0 <= int(operation["value"]) <= 0xFFFFFFFF):
            issues.append(ValidationIssue(f"{path}.value", "must be a uint32", "tile_flags"))
    elif op == "set_house_id":
        if _required(operation, "value", path, issues) and (not _is_int(operation["value"]) or not 0 <= int(operation["value"]) <= 0xFFFFFFFF):
            issues.append(ValidationIssue(f"{path}.value", "must be a uint32", "house_id"))
    elif op == "create_tile":
        kind = operation.get("kind", "tile")
        if kind not in {"tile", "house"}:
            issues.append(ValidationIssue(f"{path}.kind", "must be tile or house", "tile_kind"))
        if kind == "house" and "houseId" not in operation:
            issues.append(ValidationIssue(f"{path}.houseId", "is required for a house tile", "required"))
        if "inlineItemId" in operation and operation["inlineItemId"] is not None:
            _check_item_id(operation["inlineItemId"], f"{path}.inlineItemId", issues)
        items = operation.get("items", [])
        if not isinstance(items, list):
            issues.append(ValidationIssue(f"{path}.items", "must be an array", "items_type"))
        else:
            for item_index, item in enumerate(items):
                item_path = f"{path}.items[{item_index}]"
                if not isinstance(item, Mapping):
                    issues.append(ValidationIssue(item_path, "must be an object", "item_type"))
                    continue
                if "itemId" not in item:
                    issues.append(ValidationIssue(f"{item_path}.itemId", "is required", "required"))
                else:
                    _check_item_id(item["itemId"], f"{item_path}.itemId", issues)

    if "occurrence" in operation and (not _is_int(operation["occurrence"]) or int(operation["occurrence"]) < 0):
        issues.append(ValidationIssue(f"{path}.occurrence", "must be a non-negative integer", "occurrence"))


def validate_patch_document(payload: Any, *, require_preconditions: bool = True) -> dict[str, Any]:
    issues: list[ValidationIssue] = []
    if not isinstance(payload, Mapping):
        return {
            "format": "canary-otbm-patch-validation-v1",
            "ok": False,
            "issues": [ValidationIssue("$", "patch root must be an object", "root_type").to_json()],
        }
    if payload.get("format") != PATCH_FORMAT:
        issues.append(ValidationIssue("$.format", f"must equal {PATCH_FORMAT!r}", "format"))
    if "name" in payload and not isinstance(payload["name"], str):
        issues.append(ValidationIssue("$.name", "must be a string", "name_type"))
    base = payload.get("base")
    if base is not None:
        if not isinstance(base, Mapping):
            issues.append(ValidationIssue("$.base", "must be an object", "base_type"))
        elif "sha256" in base:
            _check_hash(base["sha256"], "$.base.sha256", issues)

    lower: tuple[int, int, int] | None = None
    upper: tuple[int, int, int] | None = None
    bounds = payload.get("bounds")
    if not isinstance(bounds, Mapping):
        issues.append(ValidationIssue("$.bounds", "must be an object", "bounds_type"))
    else:
        lower = _check_position(bounds.get("from"), "$.bounds.from", issues)
        upper = _check_position(bounds.get("to"), "$.bounds.to", issues)
        if lower is not None and upper is not None and any(lower[axis] > upper[axis] for axis in range(3)):
            issues.append(ValidationIssue("$.bounds", "from must not exceed to", "bounds_order"))

    operations = payload.get("operations")
    if not isinstance(operations, list):
        issues.append(ValidationIssue("$.operations", "must be an array", "operations_type"))
        operations = []
    for index, operation in enumerate(operations):
        _validate_operation(operation, index, lower, upper, require_preconditions, issues)

    errors = [issue for issue in issues if issue.severity == "error"]
    return {
        "format": "canary-otbm-patch-validation-v1",
        "ok": not errors,
        "operationCount": len(operations),
        "issues": [issue.to_json() for issue in issues],
    }
