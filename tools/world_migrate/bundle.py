"""Review bundles and offline publication through the shared native file service."""

from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path
from typing import Any

from .inventory import within


def json_bytes(value: Any) -> bytes:
	return (json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False) + "\n").encode("utf-8")


def read_json(path: Path) -> Any:
	def pairs(entries):
		result = {}
		for key, value in entries:
			if key in result:
				raise ValueError(f"{path}: duplicate JSON field {key}")
			result[key] = value
		return result
	return json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=pairs, parse_constant=lambda value: (_ for _ in ()).throw(ValueError(f"Non-finite JSON number: {value}")))


def digest(path: Path) -> str | None:
	if not path.exists():
		return None
	if not path.is_file() or path.is_symlink():
		raise ValueError(f"Expected a regular file: {path}")
	with path.open("rb") as stream:
		return hashlib.file_digest(stream, "sha256").hexdigest()


def sha(content: bytes | None) -> str | None:
	return hashlib.sha256(content).hexdigest() if content is not None else None


def write_new(path: Path, content: bytes) -> None:
	path.parent.mkdir(parents=True, exist_ok=True)
	with path.open("xb") as stream:
		stream.write(content)


def native_path(executable: str | Path | None) -> str:
	requested = str(executable or os.environ.get("WORLD_TOOL_PATH", "world-tool"))
	resolved = shutil.which(requested)
	if not resolved and Path(requested).is_file():
		resolved = str(Path(requested).resolve())
	if not resolved:
		raise ValueError("world-tool was not found; supply --world-tool or WORLD_TOOL_PATH with the distributed native helper")
	return resolved


def native(executable: str | Path | None, *arguments: str | Path) -> dict:
	result = subprocess.run([native_path(executable), *map(str, arguments)], capture_output=True, text=True, encoding="utf-8", timeout=300)
	if result.returncode:
		raise ValueError(f"world-tool rejected the operation:\n{result.stdout}{result.stderr}".rstrip())
	try:
		return json.loads(result.stdout)
	except json.JSONDecodeError as error:
		raise ValueError("world-tool did not return a JSON result; use a compatible 2.x artifact") from error


def require_keys(value: Any, required: set[str], optional: set[str] = frozenset()) -> None:
	if not isinstance(value, dict) or not required <= value.keys() or value.keys() - required - optional:
		raise ValueError(f"Invalid metadata fields; expected {sorted(required)}, optional {sorted(optional)}")


def load_bundle(directory: Path) -> dict:
	data = read_json(directory / "bundle.json")
	require_keys(data, {"schemaVersion", "id", "datapack", "catalog", "map", "items", "files", "sources", "pending", "consumers", "receipt"})
	if data["schemaVersion"] != 1:
		raise ValueError("Unsupported migration bundle version")
	if not isinstance(data["id"], str) or not re.fullmatch(r"[a-z0-9][a-z0-9_.-]{0,127}", data["id"]):
		raise ValueError("Invalid migration identity")
	world = within(directory, data["datapack"]) / "world"
	if not within(directory, data["catalog"]).is_relative_to(world) or not within(directory, data["receipt"]).is_relative_to(world):
		raise ValueError("Catalog and receipt must belong to the datapack's world directory")
	paths = set()
	for entry in data["files"]:
		require_keys(entry, {"file", "before", "after", "beforeSha256", "afterSha256"})
		within(directory, entry["file"])
		if Path(entry["file"]).suffix.lower() not in {".json", ".lua"}:
			raise ValueError("Migration changes are limited to JSON configuration and Lua sources; OTBM is read-only")
		if entry["file"] in paths:
			raise ValueError("Duplicate target in migration bundle")
		paths.add(entry["file"])
		for side in ("before", "after"):
			name, expected = entry[side], entry[side + "Sha256"]
			if (name is None) != (expected is None) or (name is not None and digest(within(directory, name)) != expected):
				raise ValueError(f"Bundle snapshot was changed or is missing: {entry['file']} ({side})")
	for entry in data["sources"]:
		require_keys(entry, {"file", "snapshot", "sha256"})
		if digest(within(directory, entry["snapshot"])) != entry["sha256"]:
			raise ValueError(f"Source snapshot was changed: {entry['file']}")
	return data


def _map_arguments(root: Path, data: dict, override: Path | None) -> tuple[Path, Path]:
	map_file = override.resolve() if override else within(root, data["map"]["file"])
	items = within(root, data["items"]["file"])
	if digest(map_file) != data["map"]["sha256"]:
		raise ValueError("The OTBM changed since inspection; analyze/generate again with that map")
	for entry in data["items"]["sources"]:
		if digest(within(root, entry["file"])) != entry["sha256"]:
			raise ValueError(f"The item catalog changed since inspection: {entry['file']}")
	return map_file, items


def _ready(data: dict) -> None:
	if data["pending"]:
		raise ValueError(f"Bundle has {len(data['pending'])} unresolved declarations; inspect bundle.json before applying")
	unresolved = [entry for entry in data["consumers"] if entry.get("status") not in {"adapted", "preserved"}]
	if unresolved:
		raise ValueError("Migrated configuration still has unresolved Lua consumers: " + ", ".join(sorted({entry["file"] for entry in unresolved})))


def validate_bundle(root: Path, directory: Path, executable: str | Path | None, map_override: Path | None = None) -> dict:
	directory = directory.resolve()
	data = load_bundle(directory)
	_ready(data)
	map_file, items = _map_arguments(root, data, map_override)
	result = native(executable, "validate", within(directory / "after", data["catalog"]), "--map", map_file, "--items", items)
	# Native inspection is read-only; never acknowledge a map/catalog revision
	# that changed while the validator was reading it.
	_map_arguments(root, data, map_override)
	if load_bundle(directory) != data:
		raise ValueError("Bundle changed while validating; review its new revision")
	return {"valid": True, "id": data["id"], "objects": result["objects"]}


def _state(root: Path, data: dict) -> str:
	before, after = True, True
	for entry in data["files"]:
		current = digest(within(root, entry["file"]))
		before &= current == entry["beforeSha256"]
		after &= current == entry["afterSha256"]
	if after:
		return "after"
	if before:
		return "before"
	return "conflict"


def _source_guards(root: Path, data: dict, side: str) -> None:
	targets = {entry["file"]: entry[side + "Sha256"] for entry in data["files"]}
	for entry in data["sources"]:
		if digest(within(root, entry["file"])) != targets.get(entry["file"], entry["sha256"]):
			raise ValueError(f"Source changed since analysis: {entry['file']}")


def apply_bundle(root: Path, directory: Path, executable: str | Path | None, *, offline: bool, map_override: Path | None = None) -> dict:
	if not offline:
		raise ValueError("apply requires --confirm-offline; stop the server and editing sessions first")
	root, directory = root.resolve(), directory.resolve()
	data = load_bundle(directory)
	_ready(data)
	state = _state(root, data)
	if state == "conflict":
		raise ValueError("Migration conflicts with current files; no configuration was written")
	receipt_path = within(root, data["receipt"])
	if state == "after" and receipt_path.is_file():
		receipt = read_json(receipt_path)
		if receipt.get("id") != data["id"] or receipt.get("bundleSha256") != digest(directory / "bundle.json") or receipt.get("state") != "applied":
			raise ValueError("Existing receipt does not describe this applied bundle")
		_source_guards(root, data, "after")
		return {"applied": True, "alreadyApplied": True, "receipt": data["receipt"]}
	if state != "before":
		raise ValueError("Configuration is present without a matching receipt; recover the interrupted publication")
	_source_guards(root, data, "before")
	validate_bundle(root, directory, executable, map_override)
	if load_bundle(directory) != data:
		raise ValueError("Bundle changed before publication; review its new revision")
	recovery = str(Path(data["receipt"]).parent / ".recovery" / data["id"]).replace("\\", "/")
	receipt = {"schemaVersion": 1, "id": data["id"], "state": "applied", "bundleSha256": digest(directory / "bundle.json"), "bundle": data, "recovery": recovery}
	manifest = {"schemaVersion": 1, "catalog": data["catalog"], "changes": [], "guards": []}
	# Stage recovery content before active files. The native journal and lock
	# span backups, patches, layers, receipt and the final catalog publication.
	with tempfile.TemporaryDirectory(prefix="world-publication-", dir=directory) as temporary:
		staging = Path(temporary)
		snapshots = {"bundle.json"} | {entry[side] for entry in data["files"] for side in ("before", "after") if entry[side] is not None} | {entry["snapshot"] for entry in data["sources"]}
		for name in sorted(snapshots):
			content = within(directory, name).read_bytes()
			write_new(within(staging, name), content)
			target = f"{recovery}/{name}"
			current = digest(within(root, target))
			if current is not None and current != sha(content):
				raise ValueError(f"Recovery snapshot conflict: {target}")
			if current is None:
				manifest["changes"].append({"file": target, "before": None, "after": name})
			else:
				manifest["guards"].append({"file": target, "expected": name})
		for entry in data["sources"]:
			manifest["guards"].append({"file": entry["file"], "expected": entry["snapshot"]})
		previous_receipt = receipt_path.read_bytes() if receipt_path.is_file() else None
		if previous_receipt is not None:
			old = read_json(receipt_path)
			if old.get("id") != data["id"] or old.get("state") != "reverted" or old.get("bundleSha256") != receipt["bundleSha256"]:
				raise ValueError("An unrelated receipt already exists; it will not be overwritten")
			write_new(staging / "previous-receipt.json", previous_receipt)
		write_new(staging / "receipt.json", json_bytes(receipt))
		manifest["changes"].extend({key: entry[key] for key in ("file", "before", "after")} for entry in data["files"] if entry["file"] != data["catalog"])
		manifest["changes"].append({"file": data["receipt"], "before": "previous-receipt.json" if previous_receipt is not None else None, "after": "receipt.json"})
		manifest["changes"].extend({key: entry[key] for key in ("file", "before", "after")} for entry in data["files"] if entry["file"] == data["catalog"])
		write_new(staging / "publication.json", json_bytes(manifest))
		native(executable, "publish", staging / "publication.json", "--root", root, "--confirm-offline")
	return {"applied": True, "alreadyApplied": False, "receipt": data["receipt"]}


def revert_bundle(root: Path, receipt_file: Path, executable: str | Path | None, *, offline: bool, map_override: Path | None = None) -> dict:
	if not offline:
		raise ValueError("revert requires --confirm-offline; stop the server and editing sessions first")
	root, receipt_file = root.resolve(), receipt_file.resolve()
	if not receipt_file.is_relative_to(root):
		raise ValueError("Receipt must belong to this repository")
	if not receipt_file.exists():
		# A newly created ownership record is removed by revert; its durable
		# receipt remains available for repeating the original CLI command.
		receipt_file = receipt_file.with_suffix(".receipt.json")
	receipt = read_json(receipt_file)
	if receipt.get("schemaVersion") == 2 and isinstance(receipt.get("receipt"), str):
		receipt_file = (receipt_file.parent / receipt["receipt"]).resolve()
		if not receipt_file.is_relative_to(root):
			raise ValueError("Receipt leaves the repository")
		receipt = read_json(receipt_file)
	require_keys(receipt, {"schemaVersion", "id", "state", "bundleSha256", "bundle", "recovery"})
	if receipt["schemaVersion"] != 1 or receipt["state"] not in {"applied", "reverted"}:
		raise ValueError("Unsupported migration receipt")
	recovery = within(root, receipt["recovery"])
	data = load_bundle(recovery)
	if digest(recovery / "bundle.json") != receipt["bundleSha256"] or data != receipt["bundle"]:
		raise ValueError("Recovery metadata does not match the receipt")
	state = _state(root, data)
	if state == "before" and receipt["state"] == "reverted":
		_source_guards(root, data, "before")
		return {"reverted": True, "alreadyReverted": True}
	if state != "after" or receipt["state"] != "applied":
		raise ValueError("Revert conflicts with work performed after migration; no configuration was written")
	_source_guards(root, data, "after")
	map_file, items = _map_arguments(root, data, map_override)
	with tempfile.TemporaryDirectory(prefix="world-revert-", dir=recovery) as temporary:
		staging = Path(temporary)
		manifest = {"schemaVersion": 1, "catalog": data["catalog"], "changes": [], "guards": []}
		# Reconstruct the complete old project, including unchanged dependencies,
		# for native validation without mutating the current active documents.
		before_files = {entry["file"]: entry["snapshot"] for entry in data["sources"]}
		before_files.update({entry["file"]: entry["before"] for entry in data["files"]})
		for name, source in before_files.items():
			if source is not None:
				write_new(within(staging / "before", name), within(recovery, source).read_bytes())
		if before_files.get(data["catalog"]) is not None:
			native(executable, "validate", within(staging / "before", data["catalog"]), "--map", map_file, "--items", items)
		for entry in data["files"]:
			for side in ("before", "after"):
				if entry[side] is not None:
					write_new(within(staging / "snapshots", entry[side]), within(recovery, entry[side]).read_bytes())
			manifest["changes"].append({"file": entry["file"], "before": f"snapshots/{entry['after']}" if entry["after"] is not None else None, "after": f"snapshots/{entry['before']}" if entry["before"] is not None else None})
		targets = {entry["file"] for entry in data["files"]}
		for entry in data["sources"]:
			if entry["file"] not in targets:
				name = f"guards/{entry['snapshot']}"
				write_new(within(staging, name), within(recovery, entry["snapshot"]).read_bytes())
				manifest["guards"].append({"file": entry["file"], "expected": name})
		write_new(staging / "applied-receipt.json", receipt_file.read_bytes())
		receipt["state"] = "reverted"
		write_new(staging / "reverted-receipt.json", json_bytes(receipt))
		manifest["changes"].append({"file": receipt_file.relative_to(root).as_posix(), "before": "applied-receipt.json", "after": "reverted-receipt.json"})
		manifest["changes"].sort(key=lambda entry: entry["file"] == data["catalog"])
		_map_arguments(root, data, map_override)
		write_new(staging / "publication.json", json_bytes(manifest))
		native(executable, "publish", staging / "publication.json", "--root", root, "--confirm-offline")
	return {"reverted": True, "alreadyReverted": False}


def create_bundle(root: Path, directory: Path, metadata: dict, outputs: dict[str, bytes | None], sources: dict[str, str], report: dict, *, absent_outputs: set[str] = frozenset()) -> dict:
	"""Materialize immutable before/after snapshots without publishing anything."""
	root, directory = root.resolve(), directory.resolve()
	directory.mkdir(parents=True, exist_ok=False)
	data = dict(metadata, schemaVersion=1, files=[], sources=[])
	for name, expected in sorted(sources.items()):
		path = within(root, name)
		if digest(path) != expected:
			raise ValueError(f"Source changed since analysis: {name}")
		content = path.read_bytes()
		if sha(content) != expected:
			raise ValueError(f"Source changed while creating the bundle: {name}")
		snapshot_name = f"sources/{name}"
		write_new(within(directory, snapshot_name), content)
		data["sources"].append({"file": name, "snapshot": snapshot_name, "sha256": expected})
		if name not in outputs:
			write_new(within(directory / "after", name), content)
	for name, after in sorted(outputs.items()):
		path = within(root, name)
		before = path.read_bytes() if path.is_file() else None
		if name in absent_outputs and before is not None:
			raise ValueError(f"A new catalog appeared during generation; review it before extending it: {name}")
		if name in sources and sha(before) != sources[name]:
			raise ValueError(f"Source changed while snapshotting: {name}")
		for side, content in (("before", before), ("after", after)):
			if content is not None:
				write_new(within(directory / side, name), content)
		if before != after:
			data["files"].append({"file": name, "before": f"before/{name}" if before is not None else None, "after": f"after/{name}" if after is not None else None, "beforeSha256": sha(before), "afterSha256": sha(after)})
	write_new(directory / "analysis.json", json_bytes(report))
	write_new(directory / "bundle.json", json_bytes(data))
	load_bundle(directory)
	return {"generated": True, "id": data["id"], "files": len(data["files"]), "pending": len(data["pending"]), "bundle": str(directory)}
