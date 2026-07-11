from __future__ import annotations

import base64
import dataclasses
import json
import mmap
import os
import shutil
import struct
import tempfile
from collections.abc import Mapping, Sequence
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, BinaryIO

from otbm_binary import (
    DEFAULT_MAX_TILES, MAX_COORD, MAX_TILE_NODE_BYTES, NODE_END, NODE_START, OTBM_MAP_DATA,
    OTBM_TILE_AREA, PATCH_FORMAT, REPORT_FORMAT, MappedFile, OTBMError, PatchConflict,
    TileRecord, _require, canonical_area_base, decode_node_bytes, encode_node,
    escape_properties, get_node_properties, iter_child_nodes, node_properties_end,
    parse_header, relocate_tile, sha256_path, tile_hash, validate_complete_file,
)
from otbm_edit import (
    _decode_tile_from_operation, _operation_position, apply_semantic_operation,
    create_tile_from_operation,
)
from otbm_scan import (
    bounds_tile_count, normalize_bounds, position_in_bounds, scan_map,
)

@dataclasses.dataclass
class ApplyPlan:
    source: Path
    output: Path | None
    patch: dict[str, Any]
    source_sha256: str
    warnings: list[str]
    conflicts: list[dict[str, Any]]
    operation_results: list[dict[str, Any]]
    replacements: dict[int, bytes | None]
    area_replacements: dict[int, dict[int, bytes | None]]
    new_tiles: list[tuple[tuple[int, int, int], bytes]]
    changed_positions: set[tuple[int, int, int]]
    output_width: int
    output_height: int

    @property
    def ok(self) -> bool:
        return not self.conflicts

def load_patch(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    _require(isinstance(payload, dict), "Patch root must be an object")
    _require(payload.get("format") == PATCH_FORMAT, f"Unsupported patch format {payload.get('format')!r}")
    _require(isinstance(payload.get("operations"), list), "Patch requires an operations array")
    bounds_data = payload.get("bounds")
    _require(isinstance(bounds_data, dict), "Patch requires bounds")
    bounds = normalize_bounds(bounds_data.get("from", []), bounds_data.get("to", []))
    for operation in payload["operations"]:
        _require(isinstance(operation, dict), "Patch operations must be objects")
        position = _operation_position(operation)
        _require(position_in_bounds(position, bounds), f"Operation at {position} is outside patch bounds")
    return payload

def patch_bounds(patch: Mapping[str, Any]) -> tuple[tuple[int, int, int], tuple[int, int, int]]:
    bounds = patch["bounds"]
    return normalize_bounds(bounds["from"], bounds["to"])

def plan_patch(
    source: Path,
    patch: dict[str, Any],
    *,
    output: Path | None,
    max_tiles: int,
    strict_base: bool,
    unsafe_no_precondition: bool,
) -> ApplyPlan:
    bounds = patch_bounds(patch)
    bounded_positions = bounds_tile_count(bounds)
    _require(bounded_positions <= max_tiles, f"Patch bounds contain {bounded_positions} positions; limit is {max_tiles}")
    operations: list[dict[str, Any]] = patch["operations"]
    _require(len(operations) <= max_tiles * 16, f"Patch contains too many operations: {len(operations)}")
    positions = {_operation_position(operation) for operation in operations}
    scan = scan_map(source, positions=positions, count_tiles=False)
    warnings: list[str] = []
    conflicts: list[dict[str, Any]] = []
    results: list[dict[str, Any]] = []
    replacements: dict[int, bytes | None] = {}
    area_replacements: dict[int, dict[int, bytes | None]] = {}
    new_tiles: list[tuple[tuple[int, int, int], bytes]] = []
    changed_positions: set[tuple[int, int, int]] = set()

    base = patch.get("base", {})
    expected_base = base.get("sha256") if isinstance(base, dict) else None
    if expected_base and expected_base != scan.map_sha256:
        message = f"Patch base SHA-256 differs: expected {expected_base}, source is {scan.map_sha256}"
        if strict_base:
            conflicts.append({"type": "baseHashMismatch", "message": message})
        else:
            warnings.append(message)

    for position, duplicate_records in scan.duplicates.items():
        conflicts.append(
            {
                "type": "duplicateTile",
                "position": list(position),
                "count": len(duplicate_records),
                "message": "Multiple OTBM tile nodes resolve to the same position",
            }
        )

    working: dict[tuple[int, int, int], bytes | None] = {pos: record.raw for pos, record in scan.records.items()}
    source_records = scan.records

    for index, operation in enumerate(operations):
        position = _operation_position(operation)
        op = str(operation.get("op", ""))
        result = {"index": index, "op": op, "position": list(position), "status": "planned"}
        try:
            expected_hash = operation.get("expectedTileHash")
            current = working.get(position)
            initial_record = source_records.get(position)
            if expected_hash is None and not unsafe_no_precondition and op not in ("add_tile", "create_tile"):
                raise PatchConflict("Operation is missing expectedTileHash")
            if expected_hash is not None:
                current_hash = tile_hash(current) if current is not None else None
                if current_hash != expected_hash:
                    raise PatchConflict(f"Expected tile hash {expected_hash}, found {current_hash}")
            if op in ("add_tile", "create_tile"):
                if current is not None:
                    raise PatchConflict("Tile already exists")
                new_raw = create_tile_from_operation(operation, position)
                working[position] = new_raw
                new_tiles.append((position, new_raw))
            else:
                if current is None:
                    raise PatchConflict("Tile does not exist")
                new_raw = apply_semantic_operation(current, operation)
                working[position] = new_raw
                if initial_record is None:
                    for new_index in range(len(new_tiles) - 1, -1, -1):
                        if new_tiles[new_index][0] == position:
                            if new_raw is None:
                                del new_tiles[new_index]
                            else:
                                new_tiles[new_index] = (position, new_raw)
                            break
                else:
                    if new_raw is not None:
                        new_raw = relocate_tile(new_raw, position, initial_record.area_base)
                        working[position] = new_raw
                    replacements[initial_record.start] = new_raw
                    area_replacements.setdefault(initial_record.area_start, {})[initial_record.start] = new_raw
            changed_positions.add(position)
            result["resultTileHash"] = tile_hash(new_raw) if new_raw is not None else None
        except (OTBMError, PatchConflict, KeyError, TypeError, ValueError, struct.error) as exc:
            result["status"] = "conflict"
            result["message"] = str(exc)
            conflicts.append({"type": "operationConflict", **result})
        results.append(result)

    max_x = max((position[0] for position, raw in working.items() if raw is not None), default=scan.header.width)
    max_y = max((position[1] for position, raw in working.items() if raw is not None), default=scan.header.height)
    output_width = max(scan.header.width, max_x + 1 if max_x < MAX_COORD else MAX_COORD)
    output_height = max(scan.header.height, max_y + 1 if max_y < MAX_COORD else MAX_COORD)

    return ApplyPlan(
        source=source,
        output=output,
        patch=patch,
        source_sha256=scan.map_sha256,
        warnings=warnings,
        conflicts=conflicts,
        operation_results=results,
        replacements=replacements,
        area_replacements=area_replacements,
        new_tiles=new_tiles,
        changed_positions=changed_positions,
        output_width=output_width,
        output_height=output_height,
    )

def _copy_range(stream: BinaryIO, data: bytes | mmap.mmap, start: int, end: int, chunk_size: int = 4 * 1024 * 1024) -> None:
    pos = start
    while pos < end:
        next_pos = min(end, pos + chunk_size)
        stream.write(data[pos:next_pos])
        pos = next_pos

def _rewrite_area(
    mm: mmap.mmap,
    stream: BinaryIO,
    area_start: int,
    replacements: Mapping[int, bytes | None],
) -> int:
    props_end = node_properties_end(mm, area_start)
    _copy_range(stream, mm, area_start, props_end)
    cursor = props_end
    last_child_end = props_end
    for tile_start, tile_end, _ in iter_child_nodes(mm, area_start):
        if tile_start in replacements:
            _copy_range(stream, mm, cursor, tile_start)
            replacement = replacements[tile_start]
            if replacement is not None:
                stream.write(replacement)
            cursor = tile_end
        last_child_end = tile_end
    _copy_range(stream, mm, cursor, last_child_end)
    _require(last_child_end < len(mm) and mm[last_child_end] == NODE_END, "Missing tile-area terminator")
    stream.write(bytes((NODE_END,)))
    return last_child_end + 1

def _new_area_node(position: tuple[int, int, int], tile_raw: bytes) -> bytes:
    area_base = canonical_area_base(position)
    relocated = relocate_tile(tile_raw, position, area_base)
    return encode_node(OTBM_TILE_AREA, struct.pack("<HHB", *area_base), (relocated,))

def _rewrite_map_data(
    mm: mmap.mmap,
    stream: BinaryIO,
    map_data_start: int,
    area_replacements: Mapping[int, Mapping[int, bytes | None]],
    new_tiles: Sequence[tuple[tuple[int, int, int], bytes]],
) -> int:
    props_end = node_properties_end(mm, map_data_start)
    _copy_range(stream, mm, map_data_start, props_end)
    pending_new = [_new_area_node(position, raw) for position, raw in new_tiles]
    inserted_new = False
    cursor = props_end
    last_child_end = props_end
    for child_start, child_end, node_type in iter_child_nodes(mm, map_data_start):
        if node_type != OTBM_TILE_AREA and not inserted_new:
            _copy_range(stream, mm, cursor, child_start)
            for raw in pending_new:
                stream.write(raw)
            cursor = child_start
            inserted_new = True
        replacements = area_replacements.get(child_start)
        if replacements is not None:
            _copy_range(stream, mm, cursor, child_start)
            _rewrite_area(mm, stream, child_start, replacements)
            cursor = child_end
        last_child_end = child_end
    _copy_range(stream, mm, cursor, last_child_end)
    if not inserted_new:
        for raw in pending_new:
            stream.write(raw)
    _require(last_child_end < len(mm) and mm[last_child_end] == NODE_END, "Missing map-data terminator")
    stream.write(bytes((NODE_END,)))
    return last_child_end + 1

def write_patched_map(plan: ApplyPlan, *, overwrite: bool) -> tuple[Path, Path | None]:
    _require(plan.ok, "Cannot write a patch plan with conflicts")
    _require(plan.output is not None, "Output path is required for map writes")
    source = plan.source.resolve()
    output = plan.output.resolve()
    _require(sha256_path(source) == plan.source_sha256, "Source map changed after planning; run apply again")
    _require(source != output, "Output must differ from the source map; in-place writes are forbidden")
    _require(output.suffix.lower() == ".otbm", "Output file must use the .otbm extension")
    output.parent.mkdir(parents=True, exist_ok=True)
    backup: Path | None = None
    if output.exists():
        _require(overwrite, f"Output already exists: {output}; use --overwrite")
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        backup = output.with_name(f"{output.name}.bak.{timestamp}")
        shutil.copy2(output, backup)

    temp_fd, temp_name = tempfile.mkstemp(prefix=f".{output.name}.", suffix=".tmp", dir=output.parent)
    os.close(temp_fd)
    temp_path = Path(temp_name)
    try:
        with MappedFile(source) as mm, temp_path.open("wb") as stream:
            header = parse_header(mm)
            root_props_end = node_properties_end(mm, header.root_start)
            root_props = get_node_properties(mm, header.root_start)
            updated_root_props = bytearray(root_props)
            struct.pack_into("<H", updated_root_props, 4, plan.output_width)
            struct.pack_into("<H", updated_root_props, 6, plan.output_height)
            stream.write(header.identifier)
            stream.write(bytes((NODE_START, header.root_type)))
            stream.write(escape_properties(bytes(updated_root_props)))
            map_data_end = _rewrite_map_data(mm, stream, header.map_data_start, plan.area_replacements, plan.new_tiles)
            _require(map_data_end < len(mm) and mm[map_data_end] == NODE_END, "OTBM root contains unsupported trailing children")
            _require(map_data_end + 1 == len(mm), "OTBM root contains trailing bytes")
            stream.write(bytes((NODE_END,)))
            stream.flush()
            os.fsync(stream.fileno())
        verify = scan_map(temp_path, positions=plan.changed_positions, count_tiles=False)
        validate_complete_file(temp_path)
        _require(not verify.duplicates, "Patched output contains duplicate changed tile positions")
        expected_by_position: dict[tuple[int, int, int], str | None] = {}
        for result in plan.operation_results:
            if result["status"] == "planned":
                expected_by_position[tuple(result["position"])] = result.get("resultTileHash")
        for position, expected_hash in expected_by_position.items():
            record = verify.records.get(position)
            actual_hash = record.normalized_hash if record else None
            _require(actual_hash == expected_hash, f"Round-trip validation failed at {position}: expected {expected_hash}, found {actual_hash}")
        os.replace(temp_path, output)
    except Exception:
        temp_path.unlink(missing_ok=True)
        raise
    return output, backup

def plan_report(plan: ApplyPlan, *, written: bool = False, output_sha256: str | None = None, backup: Path | None = None) -> dict[str, Any]:
    return {
        "format": REPORT_FORMAT,
        "mode": "write" if written else "dry-run",
        "ok": plan.ok,
        "source": str(plan.source),
        "sourceSha256": plan.source_sha256,
        "output": str(plan.output) if plan.output else None,
        "outputSha256": output_sha256,
        "backup": str(backup) if backup else None,
        "warnings": plan.warnings,
        "conflicts": plan.conflicts,
        "operations": plan.operation_results,
        "changedPositions": [list(position) for position in sorted(plan.changed_positions)],
        "replacementCount": len(plan.replacements),
        "newTileCount": len(plan.new_tiles),
        "outputDimensions": [plan.output_width, plan.output_height],
    }

def build_diff_patch(
    base_path: Path,
    modified_path: Path,
    bounds: tuple[tuple[int, int, int], tuple[int, int, int]],
    *,
    max_tiles: int,
) -> dict[str, Any]:
    requested = bounds_tile_count(bounds)
    _require(requested <= max_tiles, f"Diff bounds contain {requested} positions; limit is {max_tiles}")
    base_scan = scan_map(base_path, bounds=bounds, count_tiles=False)
    modified_scan = scan_map(modified_path, bounds=bounds, count_tiles=False)
    _require(not base_scan.duplicates, "Base region contains duplicate tile positions")
    _require(not modified_scan.duplicates, "Modified region contains duplicate tile positions")
    operations: list[dict[str, Any]] = []
    all_positions = sorted(set(base_scan.records) | set(modified_scan.records))
    for position in all_positions:
        before = base_scan.records.get(position)
        after = modified_scan.records.get(position)
        before_hash = before.normalized_hash if before else None
        after_hash = after.normalized_hash if after else None
        if before_hash == after_hash:
            continue
        if before is None and after is not None:
            operations.append(
                {
                    "op": "add_tile",
                    "position": list(position),
                    "tileBase64": base64.b64encode(after.raw).decode("ascii"),
                    "resultTileHash": after_hash,
                }
            )
        elif before is not None and after is None:
            operations.append(
                {
                    "op": "delete_tile",
                    "position": list(position),
                    "expectedTileHash": before_hash,
                    "resultTileHash": None,
                }
            )
        else:
            assert before is not None and after is not None
            operations.append(
                {
                    "op": "replace_tile",
                    "position": list(position),
                    "expectedTileHash": before_hash,
                    "tileBase64": base64.b64encode(after.raw).decode("ascii"),
                    "resultTileHash": after_hash,
                }
            )
    return {
        "format": PATCH_FORMAT,
        "name": f"diff-{base_path.stem}-to-{modified_path.stem}",
        "base": {"sha256": base_scan.map_sha256, "file": base_path.name},
        "bounds": {"from": list(bounds[0]), "to": list(bounds[1])},
        "operations": operations,
    }
