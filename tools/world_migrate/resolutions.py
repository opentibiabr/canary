"""Explicit, revision-bound decisions for characterized repository data."""

from __future__ import annotations

import copy
from pathlib import Path

from .bundle import digest, read_json, require_keys, sha
from .inventory import classify


def identity(entry: dict) -> tuple:
	return tuple(entry[name] for name in ("file", "table", "key", "occurrence", "fingerprint"))


class Resolutions:
	def __init__(self, root: Path, report: dict, map_revision: str, sources: dict, path: Path | None = None):
		self.decisions, self.conflicts, self.used = {}, [], []
		if path is None:
			return
		path = path.resolve()
		if not path.is_relative_to(root):
			raise ValueError("Resolution evidence must be stored in this repository")
		data = read_json(path)
		require_keys(data, {"schemaVersion", "datapack", "mapSha256", "decisions", "conflicts"})
		if data.get("schemaVersion") != 1 or data.get("datapack") != report["datapack"]:
			raise ValueError("Unsupported repository resolution contract")
		# Map-specific decisions never apply to a different customer's OTBM.
		if data["mapSha256"] != map_revision:
			raise ValueError("Resolution evidence belongs to a different OTBM revision")
		if not isinstance(data["decisions"], list) or not isinstance(data["conflicts"], list):
			raise ValueError("Resolution decisions and conflicts must be lists")
		recognized = {identity(entry) for entry in report["declarations"]}
		for decision in data["decisions"]:
			require_keys(decision, {"file", "table", "key", "occurrence", "fingerprint", "action", "reason"}, {"behavior", "dependencies"})
			key = identity(decision)
			if key not in recognized or not isinstance(decision["reason"], str) or not decision["reason"].strip():
				raise ValueError("Resolution must identify a current declaration and explain its decision")
			if key in self.decisions or decision["action"] not in {"inactive", "convert", "attributes-only", "world-identity"}:
				raise ValueError("Invalid or repeated repository resolution")
			if "behavior" in decision:
				require_keys(decision["behavior"], {"id", "contractVersion", "events", "parameters", "positions"})
				if decision["action"] != "world-identity":
					raise ValueError("An explicit replacement behavior requires a World identity decision")
			self.decisions[key] = decision
		self.conflicts = data["conflicts"]
		for conflict in self.conflicts:
			require_keys(conflict, {"attribute", "sources", "winner", "reason"})
			if len(conflict["sources"]) != 2 or conflict["winner"] not in {value["fingerprint"] for value in conflict["sources"]}:
				raise ValueError("Conflict resolution must name one of its two recognized writers")
			for value in conflict["sources"]:
				require_keys(value, {"file", "table", "key", "occurrence", "fingerprint"})
				if identity(value) not in recognized:
					raise ValueError("Conflict evidence refers to a changed or missing declaration")
		for decision in self.decisions.values():
			for dependency in decision.get("dependencies", []):
				require_keys(dependency, {"file", "sha256"})
				file = (root / dependency["file"]).resolve()
				if not file.is_relative_to(root) or not file.is_file():
					raise ValueError("Missing resolution dependency")
				if sha(file.read_text(encoding="utf-8").encode("utf-8")) != dependency["sha256"]:
					raise ValueError(f"The characterized consumer changed: {dependency['file']}")
				sources[file.relative_to(root).as_posix()] = digest(file)
		if path.is_relative_to(root):
			sources[path.relative_to(root).as_posix()] = digest(path)

	def entry(self, entry: dict) -> dict:
		decision = self.decisions.get(identity(entry))
		if decision is None:
			return entry
		result = copy.deepcopy(entry)
		self.used.append(decision)
		if decision["action"] == "inactive":
			result.update(classification="inactive", destination=decision["reason"])
		else:
			if decision["action"] == "attributes-only":
				result["value"] = {name: result["value"][name] for name in ("itemId", "itemPos")}
			classification, destination, responsibilities = classify(entry["table"], result["value"])
			result.update(classification=classification, destination=destination, responsibilities=responsibilities, issues=[])
		return result

	def replace(self, previous: dict, incoming: dict, attribute: str) -> bool:
		keys = {identity(previous), identity(incoming)}
		for conflict in self.conflicts:
			if conflict["attribute"] == attribute and {identity(value) for value in conflict["sources"]} == keys:
				if conflict not in self.used:
					self.used.append(conflict)
				return incoming["fingerprint"] == conflict["winner"]
		raise ValueError(f"Conflicting {attribute} on one base item: {previous['table']}[{previous['key']}] and {incoming['table']}[{incoming['key']}] require explicit characterization")

	def world_identity(self, entry: dict) -> dict | None:
		decision = self.decisions.get(identity(entry))
		return decision if decision and decision["action"] == "world-identity" else None
