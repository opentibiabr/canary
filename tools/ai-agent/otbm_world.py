from __future__ import annotations

import struct
import xml.etree.ElementTree as ET
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from otbm_binary import (
    OTBM_HOUSETILE,
    OTBM_TILE,
    OTBM_TILE_AREA,
    OTBM_TILE_ZONE,
    OTBM_TOWNS,
    OTBM_WAYPOINTS,
    MappedFile,
    _read_string,
    _read_u16,
    _read_u32,
    _require,
    get_node_properties,
    iter_child_nodes,
    parse_header,
    parse_map_attributes,
    sha256_path,
)

OTBM_TOWN = 13
OTBM_WAYPOINT = 16
WORLD_INDEX_FORMAT = "canary-otbm-world-index-v1"

COMPANION_SPECS = {
    "monster": ("monsterFile", "monster", "monsters"),
    "npc": ("npcFile", "npc", "npcs"),
    "house": ("houseFile", "house", "houses"),
    "zones": ("zoneFile", "zones", "zones"),
}


@dataclass
class IssueCollector:
    issues: list[dict[str, Any]] = field(default_factory=list)

    def add(self, severity: str, code: str, message: str, **details: Any) -> None:
        self.issues.append({"severity": severity, "code": code, "message": message, **details})

    def summary(self) -> dict[str, int]:
        counts = Counter(issue["severity"] for issue in self.issues)
        return {name: counts.get(name, 0) for name in ("error", "warning", "info")}


@dataclass(frozen=True)
class MapWorldData:
    towns: list[dict[str, Any]]
    waypoints: list[dict[str, Any]]
    house_ids: set[int]
    zone_ids: set[int]
    tile_areas: int
    tiles: int
    house_tiles: int
    zone_references: int


def _read_position(properties: bytes, offset: int) -> tuple[list[int], int]:
    x, offset = _read_u16(properties, offset)
    y, offset = _read_u16(properties, offset)
    _require(offset < len(properties), "Unexpected end of properties while reading Z coordinate")
    return [x, y, properties[offset]], offset + 1


def _read_towns(data: Any, node_start: int, issues: IssueCollector) -> list[dict[str, Any]]:
    entries: list[dict[str, Any]] = []
    ids: set[int] = set()
    names: set[str] = set()
    for child_start, _, child_type in iter_child_nodes(data, node_start):
        if child_type != OTBM_TOWN:
            issues.add("error", "unexpected_town_node", f"Unexpected node type {child_type} in towns node", offset=child_start)
            continue
        try:
            props = get_node_properties(data, child_start)
            town_id, offset = _read_u32(props, 0)
            name, offset = _read_string(props, offset)
            temple, offset = _read_position(props, offset)
            _require(offset == len(props), "Town node contains trailing properties")
        except Exception as exc:
            issues.add("error", "invalid_town", str(exc), offset=child_start)
            continue
        if town_id in ids:
            issues.add("error", "duplicate_town_id", f"Town ID {town_id} is defined more than once", townId=town_id)
        if name in names:
            issues.add("warning", "duplicate_town_name", f"Town name {name!r} is defined more than once", townName=name)
        ids.add(town_id)
        names.add(name)
        entries.append({"id": town_id, "name": name, "templePosition": temple})
    return entries


def _read_waypoints(data: Any, node_start: int, issues: IssueCollector) -> list[dict[str, Any]]:
    entries: list[dict[str, Any]] = []
    names: set[str] = set()
    for child_start, _, child_type in iter_child_nodes(data, node_start):
        if child_type != OTBM_WAYPOINT:
            issues.add("error", "unexpected_waypoint_node", f"Unexpected node type {child_type} in waypoints node", offset=child_start)
            continue
        try:
            props = get_node_properties(data, child_start)
            name, offset = _read_string(props, 0)
            position, offset = _read_position(props, offset)
            _require(offset == len(props), "Waypoint node contains trailing properties")
        except Exception as exc:
            issues.add("error", "invalid_waypoint", str(exc), offset=child_start)
            continue
        if name in names:
            issues.add("warning", "duplicate_waypoint_name", f"Waypoint {name!r} is defined more than once", waypoint=name)
        names.add(name)
        entries.append({"name": name, "position": position})
    return entries


def _read_zone_ids(properties: bytes, issues: IssueCollector, position: list[int]) -> tuple[set[int], int]:
    try:
        count, offset = _read_u16(properties, 0)
        ids: set[int] = set()
        for _ in range(count):
            zone_id, offset = _read_u16(properties, offset)
            if zone_id == 0:
                issues.add("error", "zero_zone_id", "Map tile references zone ID 0", position=position)
            else:
                ids.add(zone_id)
        _require(offset == len(properties), "Zone node contains trailing properties")
        return ids, count
    except Exception as exc:
        issues.add("error", "invalid_tile_zone", str(exc), position=position)
        return set(), 0


def read_map_world(path: Path, issues: IssueCollector) -> tuple[dict[str, Any], MapWorldData]:
    towns: list[dict[str, Any]] = []
    waypoints: list[dict[str, Any]] = []
    house_ids: set[int] = set()
    zone_ids: set[int] = set()
    tile_areas = tiles = house_tiles = zone_references = 0

    with MappedFile(path) as mm:
        header = parse_header(mm)
        attributes = parse_map_attributes(get_node_properties(mm, header.map_data_start))
        for child_start, _, child_type in iter_child_nodes(mm, header.map_data_start):
            if child_type == OTBM_TOWNS:
                towns.extend(_read_towns(mm, child_start, issues))
                continue
            if child_type == OTBM_WAYPOINTS:
                waypoints.extend(_read_waypoints(mm, child_start, issues))
                continue
            if child_type != OTBM_TILE_AREA:
                continue
            tile_areas += 1
            area_props = get_node_properties(mm, child_start)
            if len(area_props) != 5:
                issues.add("error", "invalid_tile_area", f"Tile area has {len(area_props)} property bytes", offset=child_start)
                continue
            base_x, base_y, base_z = struct.unpack("<HHB", area_props)
            for tile_start, _, tile_type in iter_child_nodes(mm, child_start):
                if tile_type not in (OTBM_TILE, OTBM_HOUSETILE):
                    issues.add("error", "unexpected_tile_node", f"Unexpected node type {tile_type} in tile area", offset=tile_start)
                    continue
                tiles += 1
                props = get_node_properties(mm, tile_start)
                if len(props) < 2:
                    issues.add("error", "truncated_tile", "Tile has fewer than two coordinate bytes", offset=tile_start)
                    continue
                position = [base_x + props[0], base_y + props[1], base_z]
                if tile_type == OTBM_HOUSETILE:
                    house_tiles += 1
                    if len(props) < 6:
                        issues.add("error", "truncated_house_tile", "House tile is missing house ID", position=position)
                    else:
                        house_id = struct.unpack_from("<I", props, 2)[0]
                        if house_id:
                            house_ids.add(house_id)
                        else:
                            issues.add("error", "zero_house_id", "House tile references house ID 0", position=position)
                for item_start, _, item_type in iter_child_nodes(mm, tile_start):
                    if item_type == OTBM_TILE_ZONE:
                        found, count = _read_zone_ids(get_node_properties(mm, item_start), issues, position)
                        zone_ids.update(found)
                        zone_references += count

    metadata = {
        "identifierHex": header.identifier.hex(),
        "version": header.version,
        "width": header.width,
        "height": header.height,
        "itemsMajor": header.items_major,
        "itemsMinor": header.items_minor,
        "attributes": attributes,
    }
    world = MapWorldData(towns, waypoints, house_ids, zone_ids, tile_areas, tiles, house_tiles, zone_references)
    return metadata, world


def _int_attr(element: ET.Element, name: str, default: int | None, issues: IssueCollector, location: str) -> int | None:
    raw = element.attrib.get(name)
    if raw in (None, ""):
        if default is None:
            issues.add("error", "missing_xml_attribute", f"Missing required attribute {name!r}", location=location)
        return default
    try:
        return int(raw)
    except ValueError:
        issues.add("error", "invalid_xml_integer", f"Attribute {name!r} is not an integer: {raw!r}", location=location)
        return default


def _xml_root(path: Path, expected: str, issues: IssueCollector) -> ET.Element | None:
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as exc:
        issues.add("error", "xml_parse_error", str(exc), path=str(path))
        return None
    if root.tag.rsplit("}", 1)[-1].lower() != expected:
        issues.add("error", "unexpected_xml_root", f"Expected root <{expected}>, found <{root.tag}>", path=str(path))
        return None
    return root


def _parse_houses(path: Path, town_ids: set[int], issues: IssueCollector) -> dict[str, Any]:
    root = _xml_root(path, "houses", issues)
    if root is None:
        return {"entries": [], "houseIds": []}
    entries: list[dict[str, Any]] = []
    ids: set[int] = set()
    client_ids: set[int] = set()
    for index, element in enumerate(root):
        location = f"{path.name}:house[{index}]"
        house_id = _int_attr(element, "houseid", None, issues, location)
        if house_id is None:
            continue
        if house_id in ids:
            issues.add("error", "duplicate_house_id", f"House ID {house_id} appears more than once", houseId=house_id)
        ids.add(house_id)
        town_id = _int_attr(element, "townid", 0, issues, location) or 0
        client_id = _int_attr(element, "clientid", 0, issues, location) or 0
        if town_ids and town_id not in town_ids:
            issues.add("error", "unknown_house_town", f"House {house_id} references unknown town {town_id}", houseId=house_id, townId=town_id)
        if client_id and client_id in client_ids:
            issues.add("warning", "duplicate_house_client_id", f"House client ID {client_id} appears more than once", clientId=client_id)
        client_ids.add(client_id)
        entries.append({
            "houseId": house_id,
            "name": element.attrib.get("name", ""),
            "entryPosition": [
                _int_attr(element, "entryx", 0, issues, location) or 0,
                _int_attr(element, "entryy", 0, issues, location) or 0,
                _int_attr(element, "entryz", 0, issues, location) or 0,
            ],
            "rent": _int_attr(element, "rent", 0, issues, location),
            "size": _int_attr(element, "size", 0, issues, location),
            "townId": town_id,
            "clientId": client_id,
            "guildhall": element.attrib.get("guildhall", "false").lower() in {"1", "true", "yes"},
            "beds": _int_attr(element, "beds", -1, issues, location),
        })
    return {"entries": entries, "houseIds": sorted(ids)}


def _parse_spawns(path: Path, kind: str, issues: IssueCollector) -> dict[str, Any]:
    root = _xml_root(path, "monsters" if kind == "monster" else "npcs", issues)
    if root is None:
        return {"groups": [], "entities": [], "names": []}
    groups: list[dict[str, Any]] = []
    entities: list[dict[str, Any]] = []
    names: Counter[str] = Counter()
    for group_index, spawn in enumerate(root):
        location = f"{path.name}:spawn[{group_index}]"
        center = [
            _int_attr(spawn, "centerx", 0, issues, location) or 0,
            _int_attr(spawn, "centery", 0, issues, location) or 0,
            _int_attr(spawn, "centerz", 0, issues, location) or 0,
        ]
        count = 0
        for child_index, child in enumerate(spawn):
            if child.tag.rsplit("}", 1)[-1].lower() != kind:
                continue
            child_location = f"{location}:{kind}[{child_index}]"
            name = child.attrib.get("name", "").strip()
            if not name:
                issues.add("error", "missing_spawn_name", f"{kind.title()} spawn has no name", location=child_location)
                continue
            x = _int_attr(child, "x", 0, issues, child_location) or 0
            y = _int_attr(child, "y", 0, issues, child_location) or 0
            position = [center[0] + x, center[1] + y, center[2]]
            if not (0 <= position[0] <= 65535 and 0 <= position[1] <= 65535 and 0 <= position[2] <= 15):
                issues.add("error", "spawn_position_out_of_range", f"{kind.title()} {name!r} resolves outside OTBM coordinates", position=position)
            spawntime = _int_attr(child, "spawntime", 0, issues, child_location) or 0
            if kind == "npc" and not 1 <= spawntime <= 86400:
                issues.add("warning", "npc_spawntime_out_of_range", f"NPC {name!r} spawntime is outside Canary's 1..86400 second range", spawntime=spawntime)
            names[name.lower()] += 1
            entities.append({
                "name": name,
                "position": position,
                "centerPosition": center,
                "offset": [x, y],
                "direction": _int_attr(child, "direction", 0, issues, child_location),
                "spawntime": spawntime,
                "weight": _int_attr(child, "weight", 1, issues, child_location) if kind == "monster" else None,
            })
            count += 1
        if count == 0:
            issues.add("warning", "empty_spawn_group", f"Spawn group at {center} has no valid {kind} entries", path=str(path))
        groups.append({"centerPosition": center, "radius": _int_attr(spawn, "radius", -1, issues, location), "entityCount": count})
    return {"groups": groups, "entities": entities, "names": [{"name": name, "count": count} for name, count in sorted(names.items())]}


def _parse_zones(path: Path, issues: IssueCollector) -> dict[str, Any]:
    root = _xml_root(path, "zones", issues)
    if root is None:
        return {"entries": [], "zoneIds": []}
    entries: list[dict[str, Any]] = []
    ids: set[int] = set()
    names: set[str] = set()
    for index, element in enumerate(root):
        location = f"{path.name}:zone[{index}]"
        name = element.attrib.get("name", "").strip()
        zone_id = _int_attr(element, "zoneid", 0, issues, location) or 0
        if not name:
            issues.add("error", "missing_zone_name", "Zone has no name", location=location)
        if name == "default":
            issues.add("error", "reserved_zone_name", "Zone name 'default' is reserved", location=location)
        if name in names:
            issues.add("error", "duplicate_zone_name", f"Zone name {name!r} appears more than once", zoneName=name)
        if zone_id and zone_id in ids:
            issues.add("error", "duplicate_zone_id", f"Zone ID {zone_id} appears more than once", zoneId=zone_id)
        names.add(name)
        if zone_id:
            ids.add(zone_id)
        entries.append({"name": name, "zoneId": zone_id})
    return {"entries": entries, "zoneIds": sorted(ids)}


def _companion_paths(map_path: Path, attributes: list[dict[str, Any]], issues: IssueCollector) -> dict[str, dict[str, Any]]:
    values = {entry.get("name"): entry.get("value") for entry in attributes}
    result: dict[str, dict[str, Any]] = {}
    for kind, (attribute_name, suffix, _) in COMPANION_SPECS.items():
        filename = values.get(attribute_name)
        source = "mapAttribute"
        if not isinstance(filename, str) or not filename:
            filename = f"{map_path.stem}-{suffix}.xml"
            source = "convention"
            issues.add("info", "guessed_companion_file", f"No {attribute_name} attribute; using {filename}", kind=kind)
        path = (map_path.resolve().parent / filename).resolve()
        result[kind] = {"path": str(path), "filename": filename, "source": source, "exists": path.is_file()}
    return result


def build_world_index(map_path: Path, *, include_entries: bool = True) -> dict[str, Any]:
    source = map_path.resolve()
    _require(source.is_file(), f"Map file does not exist: {source}")
    issues = IssueCollector()
    map_metadata, world = read_map_world(source, issues)
    town_ids = {entry["id"] for entry in world.towns}
    companions: dict[str, Any] = {}

    for kind, path_data in _companion_paths(source, map_metadata["attributes"], issues).items():
        path = Path(path_data["path"])
        payload = dict(path_data)
        if not path.is_file():
            issues.add("error", "missing_companion_file", f"Referenced {kind} file does not exist", path=str(path), kind=kind)
            payload.update({"sha256": None, "summary": {}, "entries": []})
            companions[kind] = payload
            continue
        payload["sha256"] = sha256_path(path)
        if kind == "house":
            parsed = _parse_houses(path, town_ids, issues)
            entries = parsed["entries"]
            xml_ids = set(parsed["houseIds"])
            for house_id in sorted(world.house_ids - xml_ids):
                issues.add("error", "house_missing_from_xml", f"Map house ID {house_id} is missing from house XML", houseId=house_id)
            for house_id in sorted(xml_ids - world.house_ids):
                issues.add("warning", "house_missing_from_map", f"House XML ID {house_id} has no house tile in the map", houseId=house_id)
            summary = {"houseCount": len(entries), "mapHouseIdCount": len(world.house_ids)}
        elif kind in {"monster", "npc"}:
            parsed = _parse_spawns(path, kind, issues)
            entries = parsed["entities"]
            payload["groups"] = parsed["groups"] if include_entries else []
            payload["names"] = parsed["names"]
            summary = {"groupCount": len(parsed["groups"]), "entityCount": len(entries), "uniqueNameCount": len(parsed["names"])}
        else:
            parsed = _parse_zones(path, issues)
            entries = parsed["entries"]
            xml_ids = set(parsed["zoneIds"])
            for zone_id in sorted(world.zone_ids - xml_ids):
                issues.add("error", "zone_missing_from_xml", f"Map zone ID {zone_id} is missing from zones XML", zoneId=zone_id)
            for zone_id in sorted(xml_ids - world.zone_ids):
                issues.add("info", "zone_missing_from_map", f"Zones XML ID {zone_id} is not referenced by a map tile", zoneId=zone_id)
            summary = {"zoneCount": len(entries), "mapZoneIdCount": len(world.zone_ids)}
        payload["summary"] = summary
        payload["entries"] = entries if include_entries else []
        companions[kind] = payload

    issue_summary = issues.summary()
    return {
        "format": WORLD_INDEX_FORMAT,
        "ok": issue_summary["error"] == 0,
        "source": {"path": str(source), "sha256": sha256_path(source), "fileSize": source.stat().st_size},
        "map": {**map_metadata, "towns": world.towns, "waypoints": world.waypoints, "houseIds": sorted(world.house_ids), "zoneIds": sorted(world.zone_ids)},
        "companions": companions,
        "summary": {
            "townCount": len(world.towns),
            "waypointCount": len(world.waypoints),
            "tileAreaCount": world.tile_areas,
            "tileCount": world.tiles,
            "houseTileCount": world.house_tiles,
            "mapHouseIdCount": len(world.house_ids),
            "mapZoneIdCount": len(world.zone_ids),
            "zoneReferenceCount": world.zone_references,
            "companionFilesPresent": sum(1 for data in companions.values() if data["exists"]),
            "companionFilesExpected": len(companions),
        },
        "issueSummary": issue_summary,
        "issues": issues.issues,
    }
