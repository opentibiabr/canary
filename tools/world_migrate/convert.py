"""Convert recognized declarations using selectors supplied by world-tool."""

from __future__ import annotations

import copy
import os
import re
import tempfile
from pathlib import Path

from .bundle import create_bundle, digest, json_bytes, native, read_json, sha, write_new
from .inventory import ACTION_TABLES, UNIQUE_TABLES, canonical, within
from .gameplay import REWARD_FIELDS, adapt_consumers, behavior_files, consumer_constants, reward_parameters


def relative(path: Path, parent: Path) -> str:
	return Path(os.path.relpath(path, parent)).as_posix()


def positions(value):
	if isinstance(value, dict):
		if set(value) == {"x", "y", "z"} and all(type(number) is int for number in value.values()):
			yield value
		else:
			for child in value.values():
				yield from positions(child)
	elif isinstance(value, list):
		for child in value:
			yield from positions(child)


def object_id(entry: dict, occurrence: str) -> str:
	identity = canonical([entry["file"], entry["table"], entry["key"], entry["occurrence"], occurrence])
	key = re.sub(r"[^a-z0-9_-]", "_", entry["key"].lower())[:30]
	return f"legacy.{entry['table'].lower()}.{key}.{sha(identity.encode('utf-8'))[:12]}"


class Converter:
	def __init__(self, root: Path, pack: Path, catalog_file: Path, catalog: dict, layers: dict[str, dict], inspected: dict, migration: dict):
		self.root, self.pack, self.catalog_file = root, pack, catalog_file
		self.catalog, self.layers, self.migration = catalog, layers, migration
		self.tiles = {canonical(tile["position"]): tile for tile in inspected["tiles"]}
		self.pending, self.outcomes = [], []
		self.by_original: dict[int, dict] = {}
		self.behavior_ids: set[str] = set()
		self.consumer_constants = consumer_constants(pack)
		self.existing = {obj["id"]: obj for layer in layers.values() for obj in layer["objects"]}

	def behavior(self, entry: dict, obj: dict) -> list[str]:
		table, value = entry["table"], entry["value"]
		binding = None
		if table == "ChestUnique" and "reward" in value:
			binding = {"id": "quest.reward", "contractVersion": 1, "events": ["onUse"], "parameters": reward_parameters(value, entry["key"], self.consumer_constants)}
		elif table in {"TeleportUnique", "TeleportItemUnique", "TileUnique"}:
			mechanism = table == "TileUnique"
			position = value.get("targetPos" if mechanism else "destination")
			if position is None:
				return []
			name = "target" if mechanism else "destination"
			anchor = {"id": object_id(entry, name), "kind": "anchor", "position": position}
			self.layer(entry)["objects"].append(anchor)
			binding = {"id": "world.tile_mechanism" if mechanism else "world.player_teleport", "contractVersion": 1, "events": ["onStepIn", "onStepOut"] if mechanism else ["onUse" if table == "TeleportItemUnique" else "onStepIn"], "parameters": {"targetItem": value["targetItem"]} if mechanism else {"effect": value["effect"]}, "relations": {name: {"object": anchor["id"]}}}
		if binding is None:
			return []
		self.behavior_ids.add(binding["id"])
		obj.setdefault("behaviors", []).append(binding)
		return binding["events"]

	def item(self, position: dict, item_id: int | None = None, role: str = "item") -> dict:
		tile = self.tiles.get(canonical(position))
		if not tile or not tile["exists"]:
			raise ValueError("The declared tile does not exist in the inspected OTBM")
		legacy = tile["legacy"]
		key = legacy.get("firstByItemId", {}).get(str(item_id)) if role == "item" else legacy.get(role)
		if key is None:
			raise ValueError(f"No legacy target for {role}, itemId={item_id}, at {position}")
		return next(item for item in tile["items"] if item["key"] == key)

	def layer(self, entry: dict) -> dict:
		name = f"systems/{Path(entry['file']).stem}.layer.json"
		path = (self.catalog_file.parent / name).relative_to(self.root).as_posix()
		if path not in self.layers:
			self.layers[path] = {"schemaVersion": 2, "id": f"legacy-{Path(entry['file']).stem}", "name": Path(entry["file"]).stem.replace("_", " ").title(), "objects": []}
			self.catalog["layers"].append({"file": name, "enabled": True})
		return self.layers[path]

	def bind(self, entry: dict, occurrence: str, item: dict, attributes: dict) -> dict:
		if item["key"] in self.by_original:
			obj = self.by_original[item["key"]]
			for name, value in attributes.items():
				if name in obj.get("attributes", {}) and obj["attributes"][name] != value:
					raise ValueError(f"Two declarations assign different {name} values to the same original; characterize their loader order")
			obj.setdefault("attributes", {}).update(attributes)
		else:
			obj = {"id": object_id(entry, occurrence), "kind": "item", "source": {"mode": "map", "selector": copy.deepcopy(item["selector"])}}
			if attributes:
				obj["attributes"] = attributes
			self.by_original[item["key"]] = obj
			self.layer(entry)["objects"].append(obj)
		return obj

	def claim(self, entry: dict, occurrence: str, obj: dict, responsibilities: list[str]) -> None:
		file = self.pack / entry["file"]
		origin = {"file": relative(file, self.catalog_file.parent / "migrations"), "table": entry["table"], "key": entry["key"], "declaration": entry["occurrence"], "fingerprint": entry["fingerprint"]}
		self.migration["claims"].append({"source": origin, "occurrence": occurrence, "object": obj["id"], "responsibilities": responsibilities})

	def created(self, entry: dict, occurrence: str, item_id: int, placement: dict, attributes: dict) -> dict:
		obj = {"id": object_id(entry, occurrence), "kind": "item", "source": {"mode": "create", "itemId": item_id, "count": 1, "placement": placement}, "lifecycle": "refillOnStartup"}
		if attributes:
			obj["attributes"] = attributes
		self.layer(entry)["objects"].append(obj)
		return obj

	def book(self, entry: dict) -> None:
		value = entry["value"]
		if value.keys() - {"itemId", "containerId", "position", "text"}:
			raise ValueError("Unrecognized book fields require an adapter")
		if type(value.get("itemId")) is not int or not isinstance(value.get("text"), str):
			raise ValueError("Expected a known book itemId and literal text")
		position = value["position"]
		tile = self.tiles.get(canonical(position))
		if not tile or not tile["exists"]:
			raise ValueError("The book's tile does not exist in the inspected OTBM")
		attributes = {"text": value["text"]}
		if value.get("containerId") is not None:
			container = self.item(position, value["containerId"])
			if not container["container"]:
				raise ValueError("The selected book destination is not a container")
			parent = self.bind(entry, "container", container, {})
			# Legacy Container:addItem inserts each new book at the front. Source
			# order remains significant and is retained in the generated layer.
			obj = self.created(entry, "item", value["itemId"], {"container": parent["id"], "order": 0}, attributes)
			responsibilities = ["creation", "attributes.text"]
		elif str(value["itemId"]) in tile["legacy"]["firstByItemId"]:
			obj = self.bind(entry, "item", self.item(position, value["itemId"]), attributes)
			responsibilities = ["attributes.text"]
		else:
			obj = self.created(entry, "item", value["itemId"], {"position": position}, attributes)
			responsibilities = ["creation", "attributes.text"]
		self.claim(entry, "item", obj, responsibilities)
		self.outcomes.append({"source": object_id(entry, "declaration"), "status": "converted", "objects": [obj["id"]]})

	def creation(self, entry: dict) -> None:
		value = entry["value"]
		if set(value) != {"itemPos"} or not isinstance(value["itemPos"], list):
			raise ValueError("Expected an item creation position list")
		item_id = int(entry["key"])
		for position in value["itemPos"]:
			if not self.tiles.get(canonical(position), {}).get("exists"):
				raise ValueError("An item creation tile does not exist in the inspected OTBM")
		ids = []
		for i, position in enumerate(value["itemPos"], 1):
			occurrence = f"{i}.item"
			if str(item_id) in self.tiles[canonical(position)]["legacy"]["firstByItemId"]:
				obj = self.bind(entry, occurrence, self.item(position, item_id), {})
			else:
				provided = [obj for layer in self.layers.values() for obj in layer["objects"] if obj.get("source", {}).get("mode") == "create" and obj["source"].get("itemId") == item_id and obj["source"].get("placement", {}).get("position") == position]
				obj = provided[0] if provided else self.created(entry, occurrence, item_id, {"position": position}, {})
			self.claim(entry, occurrence, obj, ["creation"])
			ids.append(obj["id"])
		self.outcomes.append({"source": object_id(entry, "declaration"), "status": "converted", "objects": ids})

	def declaration(self, entry: dict) -> None:
		if entry["classification"] in {"runtime-state", "inactive"}:
			self.outcomes.append({"source": object_id(entry, "declaration"), "status": entry["classification"], "reason": entry["destination"], "objects": []})
			return
		if entry["classification"] == "needs-analysis":
			raise ValueError("; ".join(issue["message"] for issue in entry["issues"]) or entry["destination"])
		table, value = entry["table"], entry["value"]
		if table == "TeleportUnique" and value.get("worldObject") in self.existing:
			# An explicitly associated, already-authored object remains authoritative.
			# Migration claims ownership without replacing edited positions/relations.
			obj = self.existing[value["worldObject"]]
			if obj.get("attributes", {}).get("uid") != int(entry["key"]) or not obj.get("components"):
				raise ValueError("The existing World association no longer supplies the legacy UID/teleport responsibility")
			self.claim(entry, "item", obj, ["attributes.uid", "onStepIn"])
			self.outcomes.append({"source": object_id(entry, "declaration"), "status": "already-world", "objects": [obj["id"]]})
			return
		if table == "BookDocumentTable":
			self.book(entry)
			return
		if table == "CreateItemOnMap":
			self.creation(entry)
			return
		if table not in ACTION_TABLES | UNIQUE_TABLES | {"SignTable"}:
			raise ValueError(f"Conversion adapter is required for {table}")
		allowed = {"itemId", "itemPos", "text"} if table == "SignTable" else {"itemId", "itemPos"}
		if table == "ChestUnique":
			allowed |= REWARD_FIELDS
		elif table in {"TeleportUnique", "TeleportItemUnique"}:
			allowed |= {"destination", "effect"}
		elif table == "TileUnique":
			allowed |= {"targetPos", "targetItem"}
		if value.keys() - allowed:
			raise ValueError("Behavior/configuration fields require an adapter: " + ", ".join(sorted(value.keys() - allowed)))
		item_id = value.get("itemId")
		if type(item_id) is not int and (item_id is not False or table not in ACTION_TABLES):
			raise ValueError("Expected a known itemId or an action-table false selector")
		if table in ACTION_TABLES:
			locations = value.get("itemPos")
			if not isinstance(locations, list):
				raise ValueError("Expected a contiguous action position list")
		else:
			locations = [value.get("itemPos")]
		key = int(entry["key"]) if table != "SignTable" else None
		if key is not None and not 0 <= key <= 65535:
			raise ValueError("AID/UID is outside the supported range")
		attributes = {"text": value["text"]} if table == "SignTable" else {"aid" if table in ACTION_TABLES else "uid": key}
		if table == "SignTable" and not isinstance(value["text"], str):
			raise ValueError("Expected literal sign text")
		targets = []
		for i, position in enumerate(locations, 1):
			if not isinstance(position, dict) or list(positions(position)) != [position]:
				raise ValueError("Invalid or unresolved position")
			roles = [role for role in ("topDown", "topTop", "ground") if role in self.tiles.get(canonical(position), {}).get("legacy", {})] if item_id is False else ["item"]
			if not roles:
				raise ValueError("No base item matches this false selector")
			for role in roles:
				item = self.item(position, item_id, role)
				if table == "SignTable":
					matches = [item for item in self.tiles[canonical(position)]["items"] if item["itemId"] == item_id]
					if len(matches) != 1:
						raise ValueError("The legacy sign loader only applies text when exactly one item exists")
				occurrence = f"{i}.{role}" if table in ACTION_TABLES else "item"
				targets.append((occurrence, item))
		# Validate the full declaration before changing the output model.
		for occurrence, item in targets:
			existing = self.by_original.get(item["key"], {}).get("attributes", {})
			if any(name in existing and existing[name] != value for name, value in attributes.items()):
				raise ValueError("Conflicting attributes on the same base item require explicit characterization")
		ids = []
		for occurrence, item in targets:
			obj = self.bind(entry, occurrence, item, copy.deepcopy(attributes))
			events = self.behavior(entry, obj)
			self.claim(entry, occurrence, obj, [f"attributes.{name}" for name in attributes] + events)
			ids.append(obj["id"])
		self.outcomes.append({"source": object_id(entry, "declaration"), "status": "converted", "objects": ids})


def generate(root: Path, report_file: Path, output: Path, executable: str | Path | None, project_file: Path | None = None, map_override: Path | None = None) -> dict:
	root = root.resolve()
	report = read_json(report_file)
	if report.get("schemaVersion") != 1 or report.get("toolVersion") != "2.0.0":
		raise ValueError("Unsupported analysis report; run analyze with this version")
	pack = within(root, report["datapack"])
	sources = dict(report["sources"])
	for name, expected in sources.items():
		if digest(within(root, name)) != expected:
			raise ValueError(f"Source changed since analysis: {name}")
	if project_file is None:
		catalogs = sorted((pack / "world").glob("*.world.json"))
		if len(catalogs) != 1:
			raise ValueError("Supply --project: expected exactly one World catalog in this datapack")
		project_file = catalogs[0]
	project_file = project_file.resolve()
	if not project_file.is_relative_to(pack / "world"):
		raise ValueError("The catalog must belong to the selected datapack's world directory")
	loaded = native(executable, "normalize", project_file, "--convert-v2")
	if "files" not in loaded:
		raise ValueError("The native helper is too old to supply exact source revisions")
	for entry in loaded["files"]:
		path = within(root, project_file.parent / entry["file"])
		sources[path.relative_to(root).as_posix()] = sha(entry["content"].encode("utf-8"))
	catalog = loaded["project"]
	catalog.pop("$schema", None)
	layers = {}
	for reference, layer in zip(catalog["layers"], loaded["layers"], strict=True):
		path = (project_file.parent / reference["file"]).resolve()
		if not path.is_relative_to(pack / "world"):
			raise ValueError("Move imported layers into world before generating a migration")
		layer.pop("$schema", None)
		layers[path.relative_to(root).as_posix()] = layer
	selected = [entry for entry in report["declarations"] if entry["selected"]]
	migration_id = "migration-" + sha(canonical([(entry["file"], entry["table"], entry["key"], entry["occurrence"], entry["fingerprint"]) for entry in selected]).encode("utf-8"))[:20]
	migration_file = project_file.parent / "migrations" / f"{migration_id}.json"
	if migration_file.exists():
		raise ValueError("This migration already has an ownership record; use its existing bundle/receipt instead of duplicating it")
	logical_map = within(root, project_file.parent / catalog["map"])
	map_file = map_override.resolve() if map_override else logical_map
	map_revision = digest(map_file)
	if map_revision is None:
		raise ValueError("The map is missing; supply --map with the matching OTBM")
	items = within(root, project_file.parent / catalog["items"])
	item_sources = [{"file": path.relative_to(root).as_posix(), "sha256": digest(path)} for path in (items, items.with_name("appearances.dat"))]
	requested = {canonical(position): position for entry in selected for position in positions(entry.get("value"))}
	with tempfile.TemporaryDirectory(prefix="world-inspection-") as temporary:
		positions_file = Path(temporary) / "positions.json"
		write_new(positions_file, json_bytes(list(requested.values())))
		inspected = native(executable, "inspect", "--map", map_file, "--items", items, "--positions", positions_file)
	if digest(map_file) != map_revision:
		raise ValueError("The OTBM changed while inspecting it")
	migration = {"schemaVersion": 2, "id": migration_id, "receipt": f"{migration_id}.receipt.json", "sources": [], "claims": []}
	for name in sorted({entry["file"] for entry in selected}):
		path = pack / name
		# Runtime provenance uses normalized Lua source, while filesystem guards
		# deliberately retain exact bytes (including the original line endings).
		migration["sources"].append({"file": relative(path, migration_file.parent), "sha256": sha(path.read_text(encoding="utf-8").encode("utf-8"))})
	converter = Converter(root, pack, project_file, catalog, layers, inspected, migration)
	# loadMapAttributes applies texts/books before attribute tables, and the
	# creation table last. In particular, creation must not duplicate a book
	# which the preceding loader already supplied at the same tile.
	order = {"SignTable": 0, "BookDocumentTable": 1, "CreateItemOnMap": 3}
	for entry in sorted(selected, key=lambda entry: order.get(entry["table"], 2)):
		try:
			converter.declaration(entry)
		except (ValueError, KeyError, TypeError) as error:
			converter.pending.append({"file": entry["file"], "table": entry["table"], "key": entry["key"], "line": entry["line"], "message": str(error)})
	catalog.setdefault("migrations", []).append(relative(migration_file, project_file.parent))
	selected_tables = {entry["table"] for entry in selected}
	consumers, patches = adapt_consumers(root, pack, report["consumers"], selected_tables)
	outputs = behavior_files(root, pack, catalog, converter.behavior_ids)
	outputs.update(patches)
	outputs.update({name: json_bytes(layer) for name, layer in layers.items()})
	outputs[project_file.relative_to(root).as_posix()] = json_bytes(catalog)
	outputs[migration_file.relative_to(root).as_posix()] = json_bytes(migration)
	metadata = {"id": migration_id, "datapack": report["datapack"], "catalog": project_file.relative_to(root).as_posix(), "map": {"file": logical_map.relative_to(root).as_posix(), "sha256": map_revision}, "items": {"file": items.relative_to(root).as_posix(), "sources": item_sources}, "pending": converter.pending, "consumers": consumers, "receipt": migration_file.with_suffix(".receipt.json").relative_to(root).as_posix()}
	return create_bundle(root, output, metadata, outputs, sources, dict(report, outcomes=converter.outcomes))
