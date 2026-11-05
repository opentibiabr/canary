"""Conservative static model of Canary Action and MoveEvent registration/dispatch.

The runtime intentionally uses ``recursive_directory_iterator`` without a
portable ordering guarantee. This module therefore proves order only inside a
single Lua file and reports cross-file collisions as ambiguous instead of
inventing a winner.
"""

from __future__ import annotations

from collections import defaultdict
import json
from pathlib import Path
from typing import Any, Iterable

from tools.canary_audit.lua_lexer import LuaLexError, Token, tokenize


ACTION_ORDER = ("itemId", "uid", "aid", "position")
ACTION_DISPATCH = ("world", "position", "uid", "aid", "itemId", "rune", "native")
MOVE_REGISTRATION_ORDER = ACTION_ORDER
MOVE_ITEM_DISPATCH = ("uid", "aid", "itemId")
EQUIP_DISPATCH = ("aid", "itemId")
CALLBACKS = {
	"Action": {"onUse"},
	"MoveEvent": {"onStepIn", "onStepOut", "onAddItem", "onRemoveItem", "onEquip", "onDeEquip"},
}
METHOD_SELECTOR = {"id": "itemId", "uid": "uid", "aid": "aid", "position": "position"}
MOVE_TYPES = {
	"stepin": "onStepIn", "stepout": "onStepOut", "additem": "onAddItem", "removeitem": "onRemoveItem",
	"equip": "onEquip", "deequip": "onDeEquip",
}


def _registry_key(entry: dict[str, Any], category: str, value: Any) -> tuple[Any, ...]:
	serialized = json.dumps(value, sort_keys=True, separators=(",", ":"))
	if entry["kind"] == "Action":
		return (entry["kind"], entry["event"], category, serialized)
	return (entry["kind"], entry["event"], category, serialized, tuple(entry["options"].get("slot", [])))


def _pairs(tokens: tuple[Token, ...]) -> dict[int, int]:
	stack: list[tuple[str, int]] = []
	result: dict[int, int] = {}
	for index, token in enumerate(tokens):
		if token.value in {"(", "{", "["}:
			stack.append((str(token.value), index))
		elif token.value in {")", "}", "]"} and stack:
			opener, start = stack.pop()
			if (opener, token.value) in {("(", ")"), ("{", "}"), ("[", "]")}:
				result[start] = index
	return result


def _literal(token: Token) -> int | str | bool | None:
	if token.kind == "number":
		return int(token.value)
	if token.kind == "string":
		return str(token.value)
	if token.value == "true":
		return True
	if token.value == "false":
		return False
	return None


def _arguments(tokens: tuple[Token, ...], start: int, end: int) -> tuple[list[Any], bool]:
	values: list[Any] = []
	cursor = start
	static = True
	while cursor < end:
		if tokens[cursor].value == ",":
			cursor += 1
			continue
		literal = _literal(tokens[cursor])
		if literal is not None:
			values.append(literal)
			cursor += 1
			continue
		if tokens[cursor].value in {"Position", "position"} and cursor + 1 < end and tokens[cursor + 1].value == "(":
			closing = _pairs(tokens).get(cursor + 1)
			if closing is not None and closing <= end:
				parts, resolved = _arguments(tokens, cursor + 2, closing)
				if resolved and len(parts) == 3 and all(type(value) is int for value in parts):
					values.append({"x": parts[0], "y": parts[1], "z": parts[2]})
					cursor = closing + 1
					continue
		static = False
		cursor += 1
	return values, static


def _callback_dependencies(tokens: tuple[Token, ...], variable: str, callbacks: set[str]) -> dict[str, Any]:
	locals_before: dict[str, int] = {}
	uses: dict[str, set[str]] = defaultdict(set)
	mutated: set[str] = set()
	constructors: list[int] = []
	for index in range(len(tokens) - 3):
		if tokens[index].value == "local" and tokens[index + 1].kind == "identifier":
			locals_before[str(tokens[index + 1].value)] = index
		if tokens[index].kind == "identifier" and tokens[index].value == variable and tokens[index + 1].value in {".", ":"} and tokens[index + 2].value in callbacks:
			constructors.append(index)
	for start in constructors:
		event = str(tokens[start + 2].value)
		# A bounded lexical slice is deliberately conservative. If a callback body
		# cannot be isolated, every visible local reference remains a dependency.
		end = min(len(tokens), start + 2000)
		for index in range(start + 3, end):
			if index > start + 3 and tokens[index].value == "function" and tokens[index + 1].kind == "identifier":
				break
			if tokens[index].kind != "identifier":
				continue
			name = str(tokens[index].value)
			if name in locals_before and locals_before[name] < start:
				uses[name].add(event)
				if index + 1 < end and tokens[index + 1].value == "=":
					mutated.add(name)
	shared = sorted(name for name, events in uses.items() if len(events) > 1)
	return {
		"capturedLocals": sorted(uses),
		"sharedLocals": shared,
		"mutableCapturedLocals": sorted(mutated),
		"automaticExtraction": not shared and not mutated,
	}


def scan_file(file: Path, root: Path) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
	relative = file.relative_to(root).as_posix()
	try:
		tokens = tokenize(file.read_text(encoding="utf-8"), max_tokens=1_000_000)
	except (LuaLexError, UnicodeError) as error:
		return [], [{"file": relative, "message": f"dispatch scan failed: {error}"}]
	pairs = _pairs(tokens)
	objects: dict[str, dict[str, Any]] = {}
	result: list[dict[str, Any]] = []
	issues: list[dict[str, Any]] = []
	for index in range(len(tokens) - 4):
		local_offset = 1 if tokens[index].value == "local" else 0
		if tokens[index + local_offset].kind != "identifier" or tokens[index + local_offset + 1].value != "=":
			continue
		kind = tokens[index + local_offset + 2].value
		if kind not in CALLBACKS or tokens[index + local_offset + 3].value != "(":
			continue
		name = str(tokens[index + local_offset].value)
		objects[name] = {
			"kind": str(kind), "variable": name, "file": relative, "line": tokens[index].line,
			"selectors": {key: [] for key in ACTION_ORDER}, "selectorConfidence": "proven",
			"event": "onUse" if kind == "Action" else None, "options": {}, "registered": False,
		}
	for index in range(len(tokens) - 3):
		name = str(tokens[index].value)
		if name not in objects or tokens[index + 1].value not in {":", "."} or tokens[index + 2].kind != "identifier" or tokens[index + 3].value != "(":
			continue
		closing = pairs.get(index + 3)
		if closing is None:
			continue
		method = str(tokens[index + 2].value)
		values, static = _arguments(tokens, index + 4, closing)
		entry = objects[name]
		if method in METHOD_SELECTOR:
			selector = METHOD_SELECTOR[method]
			accepted = [value for value in values if (selector == "position" and isinstance(value, dict)) or (selector != "position" and type(value) is int)]
			entry["selectors"][selector].extend(accepted)
			if not static or len(accepted) != len(values):
				entry["selectorConfidence"] = "unknown"
		elif entry["kind"] == "MoveEvent" and method == "type":
			entry["event"] = MOVE_TYPES.get(str(values[0]).lower()) if static and len(values) == 1 else None
		elif method in CALLBACKS[entry["kind"]]:
			entry["event"] = method
		elif method in {"allowFarUse", "blockWalls", "checkFloor", "slot", "level", "magicLevel", "premium", "vocation"}:
			entry["options"].setdefault(method, []).extend(values)
			if not static:
				entry["selectorConfidence"] = "unknown"
		elif method == "register":
			entry["registered"] = True
			entry["registerLine"] = tokens[index].line
			result.append(entry)
	installed_keys: dict[tuple[Any, ...], dict[str, Any]] = {}
	for entry in result:
		entry["dependencies"] = _callback_dependencies(tokens, entry["variable"], CALLBACKS[entry["kind"]])
		categories = ACTION_ORDER if entry["kind"] == "Action" else MOVE_REGISTRATION_ORDER
		entry["registrationCategory"] = None
		entry["installedSelectors"] = {category: [] for category in categories}
		entry["rejectedSelectors"] = {category: [] for category in categories}
		entry["shadowedBy"] = []
		entry["installed"] = False
		if entry["selectorConfidence"] == "proven" and entry["event"] is not None:
			for category in categories:
				installed = []
				for value in entry["selectors"][category]:
					key = _registry_key(entry, category, value)
					if key in installed_keys:
						entry["rejectedSelectors"][category].append(value)
						entry["shadowedBy"].append({"file": installed_keys[key]["file"], "line": installed_keys[key].get("registerLine", installed_keys[key]["line"]), "category": category, "value": value})
					else:
						installed_keys[key] = entry
						installed.append(value)
				if installed:
					entry["installedSelectors"][category] = installed
					entry["registrationCategory"] = category
					entry["installed"] = True
					break
		entry["equivalence"] = "proven" if entry["installed"] and entry["dependencies"]["automaticExtraction"] else "pending"
		if not entry["installed"]:
			issues.append({"file": entry["file"], "line": entry.get("registerLine", entry["line"]), "message": f"{entry['kind']} registration cannot be proven statically"})
	return result, issues


def analyze_dispatch(repository: Path, datapack: Path) -> dict[str, Any]:
	files: set[Path] = set()
	for directory in (repository / "data/scripts", datapack / "scripts"):
		if directory.is_dir():
			files.update(path for path in directory.rglob("*.lua") if not path.name.startswith("#"))
	registrations: list[dict[str, Any]] = []
	issues: list[dict[str, Any]] = []
	for file in sorted(files):
		found, errors = scan_file(file, repository)
		registrations.extend(found)
		issues.extend(errors)

	# Registration order across files is unspecified by the server. A collision
	# can therefore identify candidates, but cannot prove which one was installed.
	owners: dict[tuple, list[dict[str, Any]]] = defaultdict(list)
	for entry in registrations:
		category = entry["registrationCategory"]
		if not entry["installed"] or category is None:
			continue
		for value in entry["installedSelectors"][category]:
			key = _registry_key(entry, category, value)
			owners[key].append(entry)
	for key, candidates in owners.items():
		files = {candidate["file"] for candidate in candidates}
		if len(candidates) > 1 and len(files) > 1:
			for candidate in candidates:
				candidate["installed"] = None
				candidate["equivalence"] = "pending"
			issues.append({"message": "cross-file duplicate has unspecified installation order", "registry": list(key), "candidates": [candidate["file"] for candidate in candidates]})
	return {
		"loadOrder": {"confidence": "unknown", "reason": "Scripts::loadScripts uses recursive_directory_iterator without a portable sort"},
		"actionRegistrationOrder": list(ACTION_ORDER),
		"actionDispatchOrder": list(ACTION_DISPATCH),
		"moveRegistrationOrder": list(MOVE_REGISTRATION_ORDER),
		"moveItemDispatchOrder": list(MOVE_ITEM_DISPATCH),
		"equipDispatchOrder": list(EQUIP_DISPATCH),
		"registrations": registrations,
		"issues": issues,
	}


def resolve_action_dispatch(registrations: Iterable[dict[str, Any]], item: dict[str, Any], *, world: str | None = None) -> dict[str, Any]:
	if world:
		return {"applicable": [world], "executed": [world], "confidence": "proven", "source": "world"}
	selectors = {
		"position": item.get("position"), "uid": item.get("uid", 0), "aid": item.get("aid", 0), "itemId": item.get("itemId", 0),
	}
	applicable: list[dict[str, Any]] = []
	for category in ACTION_DISPATCH[1:5]:
		matches = [entry for entry in registrations if entry.get("kind") == "Action" and entry.get("event") == "onUse" and selectors[category] in entry.get("installedSelectors", entry.get("selectors", {})).get(category, []) and entry.get("installed") is not False]
		applicable.extend(matches)
		if matches:
			confidence = "proven" if len(matches) == 1 and matches[0].get("installed") is True else "unknown"
			return {"applicable": applicable, "executed": matches[:1] if confidence == "proven" else [], "confidence": confidence, "source": category}
	return {"applicable": [], "executed": [], "confidence": "proven", "source": "native"}


def resolve_move_sequence(registrations: Iterable[dict[str, Any]], tile: dict[str, Any], event: str) -> dict[str, Any]:
	registrations = list(registrations)
	sequence: list[dict[str, Any]] = []
	confidence = "proven"
	position = tile.get("position")
	position_events = [entry for entry in registrations if entry.get("kind") == "MoveEvent" and entry.get("event") == event and position in entry.get("installedSelectors", entry.get("selectors", {})).get("position", []) and entry.get("installed") is not False]
	if len(position_events) == 1 and position_events[0].get("installed") is True:
		sequence.append(position_events[0])
	elif position_events:
		confidence = "unknown"
	for item in tile.get("items", []):
		for category in MOVE_ITEM_DISPATCH:
			value = item.get(category, 0)
			matches = [entry for entry in registrations if entry.get("kind") == "MoveEvent" and entry.get("event") == event and value in entry.get("installedSelectors", entry.get("selectors", {})).get(category, []) and entry.get("installed") is not False]
			if matches:
				if len(matches) == 1 and matches[0].get("installed") is True:
					sequence.append(matches[0])
				else:
					confidence = "unknown"
				break
	return {"applicable": sequence, "executedInOrder": sequence if confidence == "proven" else [], "confidence": confidence, "stopsOnZero": True}
