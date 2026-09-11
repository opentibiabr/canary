"""Reproducible declaration and consumer inventory, rooted in the real loader."""

from __future__ import annotations

import hashlib
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from tools.canary_audit.lua_lexer import LuaLexError, tokenize
from .lua_ast import Node, Reader, Unresolved, evaluate, json_value


ACTION_TABLES = {
	"ChestAction", "CorpseAction", "KeyDoorAction", "LevelDoorAction",
	"QuestDoorAction", "ItemAction", "DailyRewardAction", "ItemUnmovableAction",
	"LeverAction", "TeleportAction", "TeleportItemAction", "TileAction", "TilePickAction",
}
UNIQUE_TABLES = {
	"ChestUnique", "CorpseUnique", "QuestDoorUnique", "ItemUnique", "LeverUnique",
	"TeleportUnique", "TeleportItemUnique", "TileUnique",
}
SPECIAL_TABLES = {"CreateItemOnMap", "BookDocumentTable", "SignTable", "QuestKeysUpdate"}
KNOWN_TABLES = ACTION_TABLES | UNIQUE_TABLES | SPECIAL_TABLES
ADAPTERS = {
	"scripts/globalevents/others/map_attributes_loader.lua": "ownership-aware startup",
	"scripts/movements/others/teleport.lua": "world teleport behavior",
	"scripts/actions/system/quest_reward_common.lua": "world quest reward context",
	"scripts/actions/other/teleport_item.lua": "world use-teleport behavior",
	"scripts/movements/others/remove-create_item.lua": "world tile mechanism behavior",
	"scripts/quests/dawnport/actions_the_rare_herb.lua": "world instance context; retain quest state logic",
}


def fingerprint(content: bytes) -> str:
	return hashlib.sha256(content).hexdigest()


def canonical(value: Any) -> str:
	return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"), allow_nan=False)


def within(root: Path, value: str | Path) -> Path:
	path = (root / value).resolve()
	if not path.is_relative_to(root.resolve()):
		raise ValueError(f"path leaves its root: {value}")
	return path


def loader_files(datapack: Path) -> tuple[list[Path], list[dict]]:
	loader = datapack / "startup/tables/load.lua"
	reader = Reader(loader.read_text(encoding="utf-8"))
	tokens = reader.tokens
	files = []
	issues = []
	i = 0
	while i < len(tokens):
		if tokens[i].value == "dofile" and i + 1 < len(tokens) and tokens[i + 1].value == "(":
			end = reader.pairs.get(i + 1)
			if end is not None:
				args = tokens[i + 2:end]
				if len(args) == 4 and [t.value for t in args[:3]] == ["DATA_DIRECTORY", ".", "."] and args[3].kind == "string":
					files.append(within(datapack, str(args[3].value).lstrip("/")))
				else:
					issues.append({"file": "startup/tables/load.lua", "line": tokens[i].line, "message": "dynamic loader path requires analysis"})
				i = end + 1
				continue
		issues.append({"file": "startup/tables/load.lua", "line": tokens[i].line, "message": "unrecognized loader statement"})
		i += 1
	return files, issues


def constants_from_datapack(repository: Path, datapack: Path) -> tuple[dict[str, Any], dict[str, str]]:
	constants: dict[str, Any] = {}
	sources: dict[str, str] = {}
	storage_file = datapack / "lib/core/storages.lua"
	if storage_file.is_file():
		reader = Reader(storage_file.read_text(encoding="utf-8"))
		def leaves(prefix: str, node: Node) -> None:
			if node.kind != "table":
				try:
					constants[prefix] = evaluate(node, constants)
				except Unresolved:
					pass
				return
			counts = Counter(field.key.value for field in node.value if field.key.kind == "scalar")
			for field in node.value:
				if field.key.kind == "scalar" and isinstance(field.key.value, str) and counts[field.key.value] == 1:
					leaves(prefix + "." + field.key.value, field.value)
		assignments = reader.assignments()
		counts = Counter(assignment.name for assignment in assignments)
		for assignment in assignments:
			if assignment.name in {"Storage", "GlobalStorage"} and counts[assignment.name] == 1:
				leaves(assignment.name, assignment.value)
		sources[storage_file.relative_to(repository).as_posix()] = fingerprint(storage_file.read_bytes())
	# Only the declared MagicEffectClasses enum is recognized, and only explicit
	# numeric values (or an unambiguous consecutive value) can become constants.
	enum_file = repository / "src/utils/utils_definitions.hpp"
	if enum_file.is_file():
		text = enum_file.read_text(encoding="utf-8")
		match = re.search(r"enum\s+MagicEffectClasses\s*:\s*uint16_t\s*\{([^}]+)\}", text, re.S)
		if match:
			tokens = tokenize(match[1])
			index, next_value = 0, 0
			while index < len(tokens):
				name = tokens[index]
				index += 1
				if name.kind != "identifier":
					break
				if index < len(tokens) and tokens[index].value == "=":
					index += 1
					if index >= len(tokens) or tokens[index].kind != "number":
						break
					next_value = int(tokens[index].value)
					index += 1
				if index < len(tokens) and tokens[index].value != ",":
					break
				constants[str(name.value)] = next_value
				next_value += 1
				index += 1
			sources[enum_file.relative_to(repository).as_posix()] = fingerprint(enum_file.read_bytes())
	return constants, sources


def symbols(node: Node) -> set[str]:
	if node.kind == "symbol":
		return {node.value}
	if node.kind == "table":
		return set().union(*(symbols(field.key) | symbols(field.value) for field in node.value))
	if node.kind == "position":
		return set().union(*(symbols(arg) for arg in node.value))
	return set()


def classify(table: str, value: Any) -> tuple[str, str, list[str]]:
	if table == "QuestKeysUpdate":
		return "runtime-state", "existing storage migration", []
	if not isinstance(value, dict):
		return "needs-analysis", "invalid declaration value", []
	if table == "BookDocumentTable":
		if not value.get("position"):
			return "inactive", "no position declared; preserve without activation", []
		return "known-adaptation", "container content or selected book", ["attributes.text", "creation"]
	if table == "SignTable":
		return "automatic", "selected item attributes", ["attributes.text"]
	if table == "CreateItemOnMap":
		return "known-adaptation", "reconciled external item", ["creation"]
	responsibilities = ["attributes.aid" if table in ACTION_TABLES else "attributes.uid"]
	if table not in ACTION_TABLES | UNIQUE_TABLES:
		return "needs-analysis", "unknown table loader", []
	if table == "TeleportUnique" and "destination" in value:
		return "known-adaptation", "player teleport behavior and relation", responsibilities + ["onStepIn"]
	if table == "TeleportItemUnique" and "destination" in value:
		return "known-adaptation", "use-teleport behavior and relation", responsibilities + ["onUse"]
	if table == "TileUnique" and "targetPos" in value:
		return "known-adaptation", "tile mechanism behavior and target relation", responsibilities + ["onStepIn", "onStepOut"]
	if table == "ItemUnique" and value.get("itemId") == 21393:
		return "known-adaptation", "rare herb instance context; retain quest state logic", responsibilities
	if table in {"ChestAction", "ChestUnique"} and "reward" in value:
		return "known-adaptation", "quest reward context", responsibilities + ["onUse"]
	if value.get("itemId") is False:
		return "known-adaptation", "explicit ground/top-item selectors from base map", responsibilities
	return "automatic", "selected item attributes; retain existing gameplay handler", responsibilities


def consumers(repository: Path, datapack: Path, definitions: set[Path], tables: set[str]) -> tuple[list[dict], dict[str, str], list[dict]]:
	result, sources, issues = [], {}, []
	roots = {repository / "data", datapack}
	for path in sorted({path for root in roots if root.is_dir() for path in root.rglob("*.lua")}):
		if path in definitions:
			continue
		content = path.read_bytes()
		if not any(table.encode("utf-8") in content for table in tables):
			continue
		try:
			tokens = tokenize(content.decode("utf-8"), max_tokens=1_000_000)
		except (LuaLexError, UnicodeError) as error:
			issues.append({"file": path.relative_to(repository).as_posix(), "message": f"consumer scan failed: {error}"})
			continue
		found = [token for token in tokens if token.kind == "identifier" and token.value in tables]
		if not found:
			continue
		relative = path.relative_to(repository).as_posix()
		sources[relative] = fingerprint(content)
		local = path.relative_to(datapack).as_posix() if path.is_relative_to(datapack) else relative
		for table in sorted({str(token.value) for token in found}):
			uses = [token for token in found if token.value == table]
			aliases = []
			for index in range(2, len(tokens)):
				if tokens[index].value == table and tokens[index - 1].value == "=" and tokens[index - 2].kind == "identifier":
					aliases.append({"name": tokens[index - 2].value, "line": tokens[index - 2].line})
			result.append({"file": relative, "table": table, "lines": sorted({token.line for token in uses}), "aliases": aliases, "classification": "known-adaptation" if local in ADAPTERS else "needs-analysis", "destination": ADAPTERS.get(local, "review consumer before applying migration")})
	return result, sources, issues


def analyze(repository: Path, datapack_name: str, *, selected_file: str | None = None, selected_table: str | None = None, entries: list[str] | None = None) -> dict:
	repository = repository.resolve()
	datapack = within(repository, datapack_name)
	files, issues = loader_files(datapack)
	constants, constant_sources = constants_from_datapack(repository, datapack)
	sources = {f"{datapack_name}/startup/tables/load.lua": fingerprint((datapack / "startup/tables/load.lua").read_bytes()), **constant_sources}
	declarations, table_inventory = [], []
	for path in files:
		relative = path.relative_to(datapack).as_posix()
		if not path.is_file():
			issues.append({"file": relative, "message": "loader file is missing"})
			continue
		content = path.read_bytes()
		sources[path.relative_to(repository).as_posix()] = fingerprint(content)
		reader = Reader(content.decode("utf-8"))
		assignments = reader.assignments()
		if not assignments:
			issues.append({"file": relative, "message": "no static table assignment recognized"})
		for assignment in assignments:
			if assignment.value.kind != "table":
				issues.append({"file": relative, "line": assignment.span.line, "message": f"unsupported declaration {assignment.name}"})
				continue
			table = assignment.name
			table_inventory.append({"file": relative, "table": table, "entries": len(assignment.value.value), "classification": "configuration" if table in KNOWN_TABLES - {"QuestKeysUpdate"} else "runtime-state" if table == "QuestKeysUpdate" else "needs-analysis"})
			counts = Counter()
			for field in assignment.value.value:
				try:
					key = evaluate(field.key, constants)
				except Unresolved:
					key = f"unresolved-at-{field.key.span.line}"
				counts[str(key)] += 1
			occurrences = Counter()
			for field in assignment.value.value:
				try:
					key = str(evaluate(field.key, constants))
				except Unresolved:
					key = f"unresolved-at-{field.key.span.line}"
				occurrences[key] += 1
				selected = (selected_file is None or relative == selected_file) and (selected_table is None or table == selected_table) and (not entries or key in entries)
				entry = {"file": relative, "table": table, "key": key, "occurrence": occurrences[key], "line": field.span.line, "column": field.span.column, "start": field.span.start, "end": field.span.end, "fingerprint": fingerprint(reader.source[field.span.start:field.span.end].encode("utf-8")), "selected": selected, "constants": sorted(symbols(field.value)), "issues": []}
				try:
					value = evaluate(field.value, constants)
					classification, destination, responsibilities = classify(table, value)
					entry.update(value=json_value(value), classification=classification, destination=destination, responsibilities=responsibilities)
				except Unresolved as error:
					entry.update(classification="needs-analysis", destination="resolve source expression", responsibilities=[])
					entry["issues"].append({"line": error.span.line, "column": error.span.column, "message": str(error)})
				if counts[key] > 1:
					entry.update(classification="needs-analysis", destination="characterize duplicate declaration without activating shadowed data")
					entry["issues"].append({"line": field.span.line, "message": f"key {key} occurs {counts[key]} times in {table}; no automatic winner"})
				declarations.append(entry)
	consumer_list, consumer_sources, consumer_issues = consumers(repository, datapack, set(files), {table["table"] for table in table_inventory})
	sources.update(consumer_sources)
	issues.extend(consumer_issues)
	selected = [entry for entry in declarations if entry["selected"]]
	if (selected_file or selected_table or entries) and not selected:
		raise ValueError("the selection did not match any declaration")
	return {"schemaVersion": 1, "toolVersion": "2.0.0", "datapack": datapack_name, "sources": dict(sorted(sources.items())), "files": [path.relative_to(datapack).as_posix() for path in files], "tables": table_inventory, "declarations": declarations, "consumers": consumer_list, "issues": issues, "summary": {"files": len(files), "tables": len(table_inventory), "declarations": len(declarations), "selected": len(selected), "consumers": len(consumer_list), "classifications": dict(sorted(Counter(entry["classification"] for entry in selected).items()))}}
