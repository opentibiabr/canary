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
from .resolutions import Resolutions


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


def has_table_behavior(entry: dict) -> bool:
	"""Match the registered ranges of the fingerprint-verified consumers."""
	if entry["classification"] in {"inactive", "runtime-state", "needs-analysis"} or entry["table"] not in {"ChestUnique", "TeleportUnique", "TeleportItemUnique", "TileUnique"}:
		return False
	table, key, value = entry["table"], int(entry["key"]), entry["value"]
	if table == "ChestUnique":
		return "reward" in value and (5000 <= key <= 9000 or 10000 <= key <= 12000 or key == 14092)
	return (
		table == "TeleportUnique" and 38001 <= key <= 40000 and "destination" in value
		or table == "TeleportItemUnique" and 15001 <= key <= 20000 and "destination" in value
		or table == "TileUnique" and 29001 <= key <= 30000 and "targetPos" in value
	)


class Converter:
	def __init__(self, root: Path, pack: Path, catalog_file: Path, catalog: dict, layers: dict[str, dict], inspected: dict, migration: dict, resolutions: Resolutions):
		self.root, self.pack, self.catalog_file = root, pack, catalog_file
		self.catalog, self.layers, self.migration = catalog, layers, migration
		self.tiles = {canonical(tile["position"]): tile for tile in inspected["tiles"]}
		self.unique_ids = inspected.get("uniqueIds", [])
		self.items, self.parents = {}, {}
		def index(items: list[dict], parent: dict | None = None) -> None:
			for item in items:
				self.items[item["key"]] = item
				if parent is not None:
					self.parents[item["key"]] = parent
				index(item.get("children", []), item)
		for tile in inspected["tiles"]:
			index(tile["items"])
		self.pending, self.outcomes = [], []
		self.by_original: dict[int, dict] = {}
		self.attribute_sources: dict[tuple[int, str], tuple[dict, str]] = {}
		self.resolutions = resolutions
		self.behavior_ids: set[str] = set()
		self.configurations: dict[int, dict] = {}
		self.consumer_constants = consumer_constants(pack)
		self.existing = {obj["id"]: obj for layer in layers.values() for obj in layer["objects"]}

	def behavior(self, entry: dict, obj: dict, special: dict | None = None) -> list[str]:
		table, value = entry["table"], entry["value"]
		binding = None
		if special is not None:
			binding = copy.deepcopy(special)
			for name, position in binding.pop("positions", {}).items():
				anchor = self.anchor(entry, name, position)
				binding.setdefault("relations", {})[name] = {"object": anchor["id"]}
		elif not has_table_behavior(entry):
			return []
		elif table == "ChestUnique":
			binding = {"id": "quest.reward", "contractVersion": 1, "events": ["onUse"], "parameters": reward_parameters(value, entry["key"], self.consumer_constants)}
		elif table in {"TeleportUnique", "TeleportItemUnique", "TileUnique"}:
			mechanism = table == "TileUnique"
			position = value.get("targetPos" if mechanism else "destination")
			if position is None:
				return []
			name = "target" if mechanism else "destination"
			anchor = self.anchor(entry, name, position)
			binding = {"id": "world.tile_mechanism" if mechanism else "world.player_teleport", "contractVersion": 1, "events": ["onStepIn", "onStepOut"] if mechanism else ["onUse" if table == "TeleportItemUnique" else "onStepIn"], "parameters": {"targetItem": value["targetItem"]} if mechanism else {"effect": value["effect"]}, "relations": {name: {"object": anchor["id"]}}}
		if binding is None:
			return []
		self.behavior_ids.add(binding["id"])
		obj.setdefault("behaviors", []).append(binding)
		return binding["events"]

	def anchor(self, entry: dict, name: str, position: dict) -> dict:
		identity = object_id(entry, name)
		objects = self.layer(entry)["objects"]
		for obj in objects:
			if obj["id"] == identity:
				if obj.get("position") != position or obj["kind"] != "anchor":
					raise ValueError("Conflicting positions for one migrated relation")
				return obj
		anchor = {"id": identity, "kind": "anchor", "position": position}
		objects.append(anchor)
		return anchor

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
					previous = self.attribute_sources[(item["key"], name)][0]
					if not self.resolutions.replace(previous, entry, name):
						continue
				obj.setdefault("attributes", {})[name] = value
				self.attribute_sources[(item["key"], name)] = (entry, occurrence)
		else:
			selector = copy.deepcopy(item["selector"])
			if item["key"] in self.parents:
				parent = self.bind(entry, occurrence + ".container", self.parents[item["key"]], {})
				selector["container"] = parent["id"]
			obj = {"id": object_id(entry, occurrence), "kind": "item", "source": {"mode": "map", "selector": selector}}
			if attributes:
				obj["attributes"] = attributes
			self.by_original[item["key"]] = obj
			self.layer(entry)["objects"].append(obj)
			for name in attributes:
				self.attribute_sources[(item["key"], name)] = (entry, occurrence)
		return obj

	def finish(self) -> None:
		# A table also configures pre-existing UID consumers outside itemPos.
		# Resolve the final effective UID before assigning any event: a later
		# loader may have overwritten a reward's UID on its declared tile.
		keys = list(dict.fromkeys([*self.by_original, *(item["key"] for item in self.unique_ids if item["uid"] in self.configurations)]))
		for key in keys:
			item = self.items[key]
			obj = self.by_original.get(key)
			uid = obj.get("attributes", {}).get("uid", item["attributes"]["uid"]) if obj else item["attributes"]["uid"]
			writer = self.attribute_sources.get((key, "uid"))
			decision = self.resolutions.world_identity(writer[0]) if writer else None
			entry = writer[0] if decision else self.configurations.get(uid)
			if entry is None:
				continue
			occurrence = writer[1] if writer and writer[0] == entry else "uid-consumer"
			try:
				obj = obj or self.bind(entry, occurrence, item, {})
				events = self.behavior(entry, obj, decision.get("behavior") if decision else None)
				if decision and not events:
					raise ValueError("Removing a compatibility UID requires a characterized replacement behavior")
				if events:
					self.claim(entry, occurrence, obj, events)
					if occurrence == "uid-consumer":
						self.outcomes.append({"source": object_id(entry, "declaration"), "status": "implicit-consumer", "objects": [obj["id"]]})
			except (ValueError, KeyError, TypeError) as error:
				self.pending.append({"file": entry["file"], "table": entry["table"], "key": entry["key"], "line": entry["line"], "message": str(error)})

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
		if self.resolutions.world_identity(entry):
			if table not in UNIQUE_TABLES:
				raise ValueError("World identity replacement requires a UID declaration")
			attributes["uid"] = 0
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
		# Validate every competing assignment before changing the output model.
		for occurrence, item in targets:
			existing = self.by_original.get(item["key"], {}).get("attributes", {})
			for name, value in attributes.items():
				if name in existing and existing[name] != value:
					self.resolutions.replace(self.attribute_sources[(item["key"], name)][0], entry, name)
		ids = []
		for occurrence, item in targets:
			obj = self.bind(entry, occurrence, item, copy.deepcopy(attributes))
			self.claim(entry, occurrence, obj, [f"attributes.{name}" for name in attributes])
			ids.append(obj["id"])
		self.outcomes.append({"source": object_id(entry, "declaration"), "status": "converted", "objects": ids})


def project_input(root: Path, pack: Path, project_file: Path | None, map_override: Path | None, executable: str | Path | None) -> tuple[Path, dict, set[str]]:
	world = pack / "world"
	if project_file is None:
		catalogs = sorted(world.glob("*.world.json"))
		if len(catalogs) > 1:
			raise ValueError("Supply --project: more than one World catalog belongs to this datapack")
		if catalogs:
			project_file = catalogs[0]
		else:
			maps = [map_override.resolve()] if map_override else sorted(world.glob("*.otbm"))
			if len(maps) != 1:
				raise ValueError("Supply --map or --project: a new catalog requires an unambiguous OTBM")
			project_file = world / (maps[0].stem + ".world.json")
	project_file = project_file.resolve()
	if not project_file.is_relative_to(world) or not project_file.name.endswith(".world.json"):
		raise ValueError("The catalog must be a .world.json file in the selected datapack's world directory")
	if project_file.exists():
		return project_file, native(executable, "normalize", project_file, "--convert-v2"), set()
	if map_override:
		original = map_override.resolve()
		logical_map = original if original.is_relative_to(world) else world / original.name
	else:
		logical_map = project_file.with_name(project_file.name.removesuffix(".world.json") + ".otbm")
		if not logical_map.is_file():
			raise ValueError("The new catalog has no sibling OTBM; supply --map with its intended base map")
	id_part = re.sub(r"[^a-z0-9_-]", "_", logical_map.stem.lower())
	catalog = {"schemaVersion": 2, "id": "world-" + id_part, "map": relative(logical_map, project_file.parent), "items": relative(root / "data/items/items.xml", project_file.parent), "layers": [], "behaviorCatalog": [], "migrations": []}
	return project_file, {"project": catalog, "layers": [], "files": []}, {project_file.relative_to(root).as_posix()}


def generate(root: Path, report_file: Path, output: Path, executable: str | Path | None, project_file: Path | None = None, map_override: Path | None = None, resolutions_file: Path | None = None) -> dict:
	root = root.resolve()
	report = read_json(report_file)
	if report.get("schemaVersion") != 1 or report.get("toolVersion") != "2.0.0":
		raise ValueError("Unsupported analysis report; run analyze with this version")
	pack = within(root, report["datapack"])
	sources = dict(report["sources"])
	for name, expected in sources.items():
		if digest(within(root, name)) != expected:
			raise ValueError(f"Source changed since analysis: {name}")
	project_file, loaded, absent_outputs = project_input(root, pack, project_file, map_override, executable)
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
	resolutions = Resolutions(root, report, map_revision, sources, resolutions_file)
	resolved_entries = [resolutions.entry(entry) for entry in selected]
	items = within(root, project_file.parent / catalog["items"])
	item_sources = [{"file": path.relative_to(root).as_posix(), "sha256": digest(path)} for path in (items, items.with_name("appearances.dat"))]
	requested = {canonical(position): position for entry in selected for position in positions(entry.get("value"))}
	with tempfile.TemporaryDirectory(prefix="world-inspection-") as temporary:
		positions_file = Path(temporary) / "positions.json"
		write_new(positions_file, json_bytes(list(requested.values())))
		inspected = native(executable, "inspect", "--map", map_file, "--items", items, "--positions", positions_file)
		configured_uids = {int(entry["key"]) for entry in resolved_entries if has_table_behavior(entry) and not entry["value"].get("worldObject")}
		implicit_positions = {canonical(item["position"]): item["position"] for item in inspected["uniqueIds"] if item["uid"] in configured_uids and canonical(item["position"]) not in requested}
		if implicit_positions:
			implicit_file = Path(temporary) / "implicit-positions.json"
			write_new(implicit_file, json_bytes(list(implicit_positions.values())))
			implicit = native(executable, "inspect", "--map", map_file, "--items", items, "--positions", implicit_file)
			inspected["tiles"].extend(implicit["tiles"])
	if digest(map_file) != map_revision:
		raise ValueError("The OTBM changed while inspecting it")
	migration = {"schemaVersion": 2, "id": migration_id, "receipt": f"{migration_id}.receipt.json", "sources": [], "claims": []}
	for name in sorted({entry["file"] for entry in selected}):
		path = pack / name
		# Runtime provenance uses normalized Lua source, while filesystem guards
		# deliberately retain exact bytes (including the original line endings).
		migration["sources"].append({"file": relative(path, migration_file.parent), "sha256": sha(path.read_text(encoding="utf-8").encode("utf-8"))})
	converter = Converter(root, pack, project_file, catalog, layers, inspected, migration, resolutions)
	# loadMapAttributes applies texts/books before attribute tables, and the
	# creation table last. In particular, creation must not duplicate a book
	# which the preceding loader already supplied at the same tile.
	order = {name: index for index, name in enumerate(("SignTable", "BookDocumentTable", "ChestAction", "ChestUnique", "CorpseAction", "CorpseUnique", "KeyDoorAction", "LevelDoorAction", "QuestDoorAction", "QuestDoorUnique", "ItemAction", "ItemUnique", "ItemUnmovableAction", "LeverAction", "LeverUnique", "TeleportAction", "TeleportUnique", "TeleportItemAction", "TeleportItemUnique", "TileAction", "TileUnique", "TilePickAction", "CreateItemOnMap"))}
	for entry in sorted(resolved_entries, key=lambda entry: order.get(entry["table"], 100)):
		try:
			converter.declaration(entry)
			if has_table_behavior(entry) and not entry["value"].get("worldObject"):
				converter.configurations[int(entry["key"])] = entry
		except (ValueError, KeyError, TypeError) as error:
			converter.pending.append({"file": entry["file"], "table": entry["table"], "key": entry["key"], "line": entry["line"], "message": str(error)})
	converter.finish()
	catalog.setdefault("migrations", []).append(relative(migration_file, project_file.parent))
	selected_tables = {entry["table"] for entry in selected}
	consumers, patches = adapt_consumers(root, pack, report["consumers"], selected_tables)
	outputs = behavior_files(root, pack, catalog, converter.behavior_ids, project_file)
	outputs.update(patches)
	outputs.update({name: json_bytes(layer) for name, layer in layers.items()})
	outputs[project_file.relative_to(root).as_posix()] = json_bytes(catalog)
	outputs[migration_file.relative_to(root).as_posix()] = json_bytes(migration)
	metadata = {"id": migration_id, "datapack": report["datapack"], "catalog": project_file.relative_to(root).as_posix(), "map": {"file": logical_map.relative_to(root).as_posix(), "sha256": map_revision}, "items": {"file": items.relative_to(root).as_posix(), "sources": item_sources}, "pending": converter.pending, "consumers": consumers, "receipt": migration_file.with_suffix(".receipt.json").relative_to(root).as_posix()}
	return create_bundle(root, output, metadata, outputs, sources, dict(report, outcomes=converter.outcomes, resolutionEvidence=resolutions.used), absent_outputs=absent_outputs)
