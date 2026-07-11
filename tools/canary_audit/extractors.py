"""Typed extractors for Canary Lua, XML, and appearances protobuf data."""

from __future__ import annotations

import heapq
import io
import xml.sax
from dataclasses import dataclass, field, replace
from pathlib import Path
from typing import BinaryIO, Generic, Iterable, TypeVar
from xml.sax.handler import feature_external_ges, feature_external_pes

from .config import AuditConfig, StorageTable

from .lua_lexer import (
	LuaLexError,
	Token,
	binding_occurrence_counts,
	call_arguments,
	StaticBinding,
	collect_static_bindings,
	dotted_identifier,
	is_assignment_operator,
	lexical_scope_end_positions,
	matching_delimiters,
	resolve_scalar,
	tokenize,
)
from .models import Diagnostic, Fact, Location
from .workspace import DiscoveredFile, WorkspaceError, read_utf8


T = TypeVar("T")


class ExtractionLimitError(RuntimeError):
	pass


class BoundedList(list[T], Generic[T]):
	"""A list that refuses the first element beyond a deterministic scan limit."""

	def __init__(self, limit: int, label: str) -> None:
		super().__init__()
		self.limit = limit
		self.label = label

	def append(self, value: T) -> None:
		if len(self) >= self.limit:
			raise ExtractionLimitError(f"{self.label} exceeded configured limit {self.limit}")
		super().append(value)

	def extend(self, values: Iterable[T]) -> None:
		for value in values:
			self.append(value)


@dataclass
class ExtractionResult:
	facts: list[Fact] = field(default_factory=list)
	diagnostics: list[Diagnostic] = field(default_factory=list)

	@classmethod
	def bounded(cls, config: AuditConfig, path: str) -> "ExtractionResult":
		return cls(
			facts=BoundedList(config.max_facts_per_file, f"facts for {path}"),
			diagnostics=BoundedList(config.max_diagnostics_per_file, f"diagnostics for {path}"),
		)

	def extend(self, other: "ExtractionResult") -> None:
		self.facts.extend(other.facts)
		self.diagnostics.extend(other.diagnostics)


def _fact_context(config: AuditConfig, path: str) -> tuple[str, tuple[str, ...]] | None:
	layer = config.layer_for_path(path)
	if layer is None:
		return None
	profiles = config.profiles_for_layer(layer)
	return (layer, profiles) if profiles else None


def _location(path: str, token: Token) -> Location:
	return Location(path=path, line=token.line, column=token.column)


def _expression_text(tokens: Iterable[Token]) -> str:
	parts = []
	for token in tokens:
		if token.kind == "string":
			parts.append(repr(token.value))
		else:
			parts.append(str(token.value))
	return "".join(parts)[:160] or "<empty>"


def _assignment_calls(
	tokens: tuple[Token, ...],
	delimiter_pairs: dict[int, int],
	allowed_callees: frozenset[str],
) -> list[tuple[str, str, tuple[tuple[Token, ...], ...], Token]]:
	result = []
	for index in range(len(tokens) - 4):
		variable = tokens[index]
		if variable.kind != "identifier" or not is_assignment_operator(tokens, index + 1):
			continue
		if (
			index > 0
			and tokens[index - 1].kind == "symbol"
			and tokens[index - 1].value in {".", ":", "[", "{", ","}
		):
			continue
		callee_start = index + 2
		if tokens[callee_start].kind != "identifier":
			continue
		callee = str(tokens[callee_start].value)
		open_parenthesis = callee_start + 1
		if (
			callee_start + 3 < len(tokens)
			and tokens[callee_start + 1].kind == "symbol"
			and tokens[callee_start + 1].value == "."
			and tokens[callee_start + 2].kind == "identifier"
		):
			callee = f"{callee}.{tokens[callee_start + 2].value}"
			open_parenthesis = callee_start + 3
		if callee not in allowed_callees:
			continue
		if (
			open_parenthesis >= len(tokens)
			or tokens[open_parenthesis].kind != "symbol"
			or tokens[open_parenthesis].value != "("
		):
			continue
		arguments = call_arguments(tokens, open_parenthesis, delimiter_pairs)
		if arguments is not None:
			result.append((str(variable.value), callee, arguments, variable))
	return result


def _method_calls(
	tokens: tuple[Token, ...],
	delimiter_pairs: dict[int, int],
	allowed_methods: frozenset[str],
) -> list[tuple[str, str, tuple[tuple[Token, ...], ...], Token]]:
	result = []
	for index in range(len(tokens) - 3):
		receiver = tokens[index]
		if (
			receiver.kind != "identifier"
			or tokens[index + 1].kind != "symbol"
			or tokens[index + 1].value not in {":", "."}
		):
			continue
		if (
			index > 0
			and tokens[index - 1].kind == "symbol"
			and tokens[index - 1].value in {".", ":"}
		):
			continue
		method = tokens[index + 2]
		if (
			method.kind != "identifier"
			or tokens[index + 3].kind != "symbol"
			or tokens[index + 3].value != "("
		):
			continue
		if str(method.value) not in allowed_methods:
			continue
		if (
			index > 0
			and tokens[index - 1].kind == "identifier"
			and tokens[index - 1].value == "function"
		):
			continue
		arguments = call_arguments(tokens, index + 3, delimiter_pairs)
		if arguments is not None:
			result.append((str(receiver.value), str(method.value), arguments, method))
	return result


def _direct_calls(
	tokens: tuple[Token, ...],
	delimiter_pairs: dict[int, int],
	allowed_names: frozenset[str],
) -> list[tuple[str, tuple[tuple[Token, ...], ...], Token]]:
	result = []
	for index in range(len(tokens) - 1):
		name = tokens[index]
		if (
			name.kind != "identifier"
			or tokens[index + 1].kind != "symbol"
			or tokens[index + 1].value != "("
		):
			continue
		if str(name.value) not in allowed_names:
			continue
		if index > 0 and (
			(tokens[index - 1].kind == "symbol" and tokens[index - 1].value in {":", "."})
			or (tokens[index - 1].kind == "identifier" and tokens[index - 1].value == "function")
		):
			continue
		arguments = call_arguments(tokens, index + 1, delimiter_pairs)
		if arguments is not None:
			result.append((str(name.value), arguments, name))
	return result


def _static_or_unresolved_fact(
	*,
	domain: str,
	role: str,
	argument: tuple[Token, ...],
	constants: dict[str, StaticBinding],
	layer: str,
	profiles: tuple[str, ...],
	path: str,
	token: Token,
	extractor: str,
	owner: str,
	allow_symbol: bool = False,
) -> Fact:
	value = resolve_scalar(argument, constants)
	symbol = dotted_identifier(argument)
	if isinstance(value, str) and not value.strip():
		value = None
	is_constant_alias = (
		len(argument) == 1
		and argument[0].kind == "identifier"
		and str(argument[0].value) in constants
	)
	if value is not None and (allow_symbol or symbol is None or is_constant_alias):
		return Fact(
			domain=domain,
			role=role,  # type: ignore[arg-type]
			value=value,
			layer=layer,
			profiles=profiles,
			location=_location(path, argument[0] if argument else token),
			extractor=extractor,
			confidence="derived" if len(argument) == 1 and argument[0].kind == "identifier" else "exact",
			symbol=symbol if allow_symbol else None,
			owner=owner,
		)
	return Fact(
		domain=domain,
		role="unresolved",
		value=_expression_text(argument),
		layer=layer,
		profiles=profiles,
		location=_location(path, argument[0] if argument else token),
		extractor=extractor,
		confidence="dynamic",
		owner=owner,
	)


CONSTRUCTOR_TYPES = {
	"Action": "Action",
	"MoveEvent": "MoveEvent",
	"Weapon": "Weapon",
	"Spell": "Spell",
	"CombatSpell": "Spell",
	"RuneSpell": "Spell",
}

SELECTOR_RULES = {
	("Action", "id"): ("item.server_id", "reference"),
	("Action", "aid"): ("action.action_id", "registration"),
	("Action", "uid"): ("action.unique_id", "registration"),
	("MoveEvent", "id"): ("item.server_id", "reference"),
	("MoveEvent", "aid"): ("movement.action_id", "registration"),
	("MoveEvent", "uid"): ("movement.unique_id", "registration"),
	("Weapon", "id"): ("item.server_id", "reference"),
	("Spell", "id"): ("spell.id", "registration"),
}


def extract_lua(path: DiscoveredFile, config: AuditConfig) -> ExtractionResult:
	result = ExtractionResult.bounded(config, path.path)
	context = _fact_context(config, path.path)
	if context is None or PurePathName(path.path).startswith("#"):
		return result
	layer, profiles = context
	try:
		text = read_utf8(path, config.max_text_file_bytes)
		tokens = tokenize(text, config.max_lua_tokens)
	except WorkspaceError as error:
		result.diagnostics.append(Diagnostic("scan.read-error", str(error), "error", Location(path.path)))
		return result
	except LuaLexError as error:
		result.diagnostics.append(
			Diagnostic("scan.lua-syntax", str(error), "error", Location(path.path, error.line, error.column))
		)
		return result

	constants = collect_static_bindings(tokens)
	delimiter_pairs = matching_delimiters(tokens)
	assignments = _assignment_calls(
		tokens,
		delimiter_pairs,
		frozenset((*CONSTRUCTOR_TYPES, "Game.createMonsterType", "Game.createNpcType")),
	)
	methods = _method_calls(
		tokens,
		delimiter_pairs,
		frozenset(
			{
				"register",
				"id",
				"aid",
				"uid",
				"addItem",
				"removeItem",
				"getItemCount",
				"getStorageValue",
				"setStorageValue",
				"createMonster",
				"createNpc",
				"createItem",
			}
		),
	)
	occurrence_counts = binding_occurrence_counts(tokens)
	scope_end_by_location = {
		(token.line, token.column): scope_end
		for token, scope_end in zip(tokens, lexical_scope_end_positions(tokens), strict=True)
	}
	object_candidates: dict[str, list[tuple[str, Token, tuple[int, int] | None]]] = {}
	definition_candidates: dict[str, list[tuple[str, tuple[Token, ...], Token]]] = {}

	for variable, callee, arguments, token in assignments:
		scope_end = scope_end_by_location[(token.line, token.column)]
		if callee in CONSTRUCTOR_TYPES:
			object_candidates.setdefault(variable, []).append((CONSTRUCTOR_TYPES[callee], token, scope_end))
		elif callee in {"Game.createMonsterType", "Game.createNpcType"}:
			object_type = "MonsterType" if callee.endswith("MonsterType") else "NpcType"
			object_candidates.setdefault(variable, []).append((object_type, token, scope_end))
			if arguments:
				domain = "monster.name" if object_type == "MonsterType" else "npc.name"
				definition_candidates.setdefault(variable, []).append((domain, arguments[0], token))

	objects = {
		variable: candidates[0][0]
		for variable, candidates in object_candidates.items()
		if len(candidates) == 1 and occurrence_counts.get(variable) == 1
	}
	object_assignment_positions = {
		variable: (candidates[0][1].line, candidates[0][1].column)
		for variable, candidates in object_candidates.items()
		if variable in objects
	}
	object_scope_ends = {
		variable: candidates[0][2]
		for variable, candidates in object_candidates.items()
		if variable in objects
	}

	def object_is_visible(receiver: str, token: Token) -> bool:
		position = (token.line, token.column)
		if receiver not in objects or object_assignment_positions[receiver] >= position:
			return False
		scope_end = object_scope_ends[receiver]
		return scope_end is None or position < scope_end

	registration_lists: dict[str, list[tuple[int, int]]] = {}
	for receiver, method, _, token in methods:
		if method == "register" and object_is_visible(receiver, token):
			registration_lists.setdefault(receiver, []).append((token.line, token.column))
	registration_positions = {
		receiver: tuple(sorted(positions))
		for receiver, positions in registration_lists.items()
	}
	registered = frozenset(registration_positions)

	for variable, candidates in definition_candidates.items():
		if variable not in registered or len(candidates) != 1:
			continue
		domain, argument, token = candidates[0]
		result.facts.append(
			_static_or_unresolved_fact(
				domain=domain,
				role="definition",
				argument=argument,
				constants=constants,
				layer=layer,
				profiles=profiles,
				path=path.path,
				token=token,
				extractor="lua.registered-type",
				owner=objects[variable],
			)
		)

	for receiver, method, arguments, token in methods:
		if method == "register" or not arguments:
			continue
		object_type = objects.get(receiver) if object_is_visible(receiver, token) else None
		rule = SELECTOR_RULES.get((object_type or "", method))
		registered_after_selector = any(
			position > (token.line, token.column)
			for position in registration_positions.get(receiver, ())
		)
		if rule is not None and registered_after_selector:
			domain, role = rule
			for argument in arguments:
				selector_fact = _static_or_unresolved_fact(
						domain=domain,
						role=role,
						argument=argument,
						constants=constants,
						layer=layer,
						profiles=profiles,
						path=path.path,
						token=token,
						extractor="lua.selector",
						owner=f"{object_type}.{method}",
					)
				result.facts.append(selector_fact)
				if method == "id" and object_type in {"Action", "MoveEvent", "Weapon"}:
					binding_domain = {
						"Action": "action.item_id",
						"MoveEvent": "movement.item_id",
						"Weapon": "weapon.item_id",
					}[object_type]
					result.facts.append(
						Fact(
							domain=binding_domain,
							role="registration" if selector_fact.role != "unresolved" else "unresolved",
							value=selector_fact.value,
							layer=layer,
							profiles=profiles,
							location=selector_fact.location,
							extractor="lua.selector",
							confidence=selector_fact.confidence,
							owner=f"{object_type}.{method}",
						)
					)
			continue

		if method in {"addItem", "removeItem", "getItemCount"}:
			item_fact = _static_or_unresolved_fact(
					domain="item.server_id",
					role="reference",
					argument=arguments[0],
					constants=constants,
					layer=layer,
					profiles=profiles,
					path=path.path,
					token=token,
					extractor="lua.method-call",
					owner=method,
				)
			if item_fact.role != "unresolved" and isinstance(item_fact.value, str):
				item_fact = replace(item_fact, domain="item.name")
			result.facts.append(item_fact)
		elif method in {"getStorageValue", "setStorageValue"}:
			domain = "storage.global" if receiver == "Game" else "storage.player"
			result.facts.append(
				_static_or_unresolved_fact(
					domain=domain,
					role="reference",
					argument=arguments[0],
					constants=constants,
					layer=layer,
					profiles=profiles,
					path=path.path,
					token=token,
					extractor="lua.storage-call",
					owner=f"{receiver}.{method}",
					allow_symbol=True,
				)
			)
		elif receiver == "Game" and method in {"createMonster", "createNpc", "createItem"}:
			domain = {
				"createMonster": "monster.name",
				"createNpc": "npc.name",
				"createItem": "item.server_id",
			}[method]
			game_fact = _static_or_unresolved_fact(
					domain=domain,
					role="reference",
					argument=arguments[0],
					constants=constants,
					layer=layer,
					profiles=profiles,
					path=path.path,
					token=token,
					extractor="lua.game-call",
					owner=f"Game.{method}",
				)
			if method == "createItem" and game_fact.role != "unresolved" and isinstance(game_fact.value, str):
				game_fact = replace(game_fact, domain="item.name")
			result.facts.append(game_fact)

	for name, arguments, token in _direct_calls(tokens, delimiter_pairs, frozenset({"ItemType"})):
		if name == "ItemType" and arguments:
			item_fact = _static_or_unresolved_fact(
					domain="item.server_id",
					role="reference",
					argument=arguments[0],
					constants=constants,
					layer=layer,
					profiles=profiles,
					path=path.path,
					token=token,
					extractor="lua.direct-call",
					owner="ItemType",
				)
			if item_fact.role != "unresolved" and isinstance(item_fact.value, str):
				item_fact = replace(item_fact, domain="item.name")
			result.facts.append(item_fact)

	for table in config.storage_tables:
		if table.path == path.path:
			result.extend(
				_extract_storage_table(
					tokens,
					path.path,
					layer,
					profiles,
					table,
					config,
					delimiter_pairs,
				)
			)
	return result


def PurePathName(path: str) -> str:
	return path.rsplit("/", 1)[-1]


def _table_leaves(
	tokens: tuple[Token, ...],
	open_brace: int,
	prefix: tuple[str, ...],
	brace_pairs: dict[int, int],
) -> list[tuple[tuple[str, ...], int | str, Token]]:
	leaves: list[tuple[tuple[str, ...], int | str, Token]] = []
	stack = [(open_brace, prefix)]
	while stack:
		current_open, current_prefix = stack.pop()
		close_brace = brace_pairs.get(current_open)
		if close_brace is None:
			continue
		index = current_open + 1
		while index < close_brace:
			if (
				tokens[index].kind == "identifier"
				and index + 2 < close_brace
				and is_assignment_operator(tokens, index + 1)
			):
				key = str(tokens[index].value)
				value_token = tokens[index + 2]
				if value_token.kind == "symbol" and value_token.value == "{":
					stack.append((index + 2, (*current_prefix, key)))
					index = brace_pairs.get(index + 2, close_brace) + 1
					continue
				if value_token.kind in {"number", "string"}:
					leaves.append(((*current_prefix, key), value_token.value, value_token))
			index += 1
	return leaves


def _all_table_leaves(
	tokens: tuple[Token, ...],
	delimiter_pairs: dict[int, int],
) -> list[tuple[tuple[str, ...], int | str, Token]]:
	result: list[tuple[tuple[str, ...], int | str, Token]] = []
	depth = 0
	index = 0
	while index + 2 < len(tokens):
		if (
			depth == 0
			and tokens[index].kind == "identifier"
			and is_assignment_operator(tokens, index + 1)
			and tokens[index + 2].kind == "symbol"
			and tokens[index + 2].value == "{"
		):
			result.extend(
				_table_leaves(tokens, index + 2, (str(tokens[index].value),), delimiter_pairs)
			)
			matching = delimiter_pairs.get(index + 2)
			index = (matching + 1) if matching is not None else len(tokens)
			continue
		if tokens[index].kind == "symbol" and tokens[index].value == "{":
			depth += 1
		elif tokens[index].kind == "symbol" and tokens[index].value == "}":
			depth = max(0, depth - 1)
		index += 1
	return result


def _extract_storage_table(
	tokens: tuple[Token, ...],
	path: str,
	layer: str,
	profiles: tuple[str, ...],
	table: StorageTable,
	config: AuditConfig,
	delimiter_pairs: dict[int, int],
) -> ExtractionResult:
	result = ExtractionResult.bounded(config, path)
	root_parts = tuple(table.root.split("."))
	for parts, value, token in _all_table_leaves(tokens, delimiter_pairs):
		if parts[: len(root_parts)] != root_parts or not isinstance(value, int):
			continue
		result.facts.append(
			Fact(
				domain=table.domain,
				role="definition",
				value=value,
				layer=layer,
				profiles=profiles,
				location=_location(path, token),
				extractor="lua.storage-table",
				confidence="exact",
				symbol=".".join(parts),
				owner=table.root,
			)
		)
	return result


def _read_varint(stream: BinaryIO) -> int | None:
	value = 0
	shift = 0
	for _ in range(10):
		byte = stream.read(1)
		if not byte:
			return None if shift == 0 else _raise_value("truncated protobuf varint")
		value |= (byte[0] & 0x7F) << shift
		if not byte[0] & 0x80:
			return value
		shift += 7
	raise ValueError("protobuf varint exceeds 10 bytes")


def _raise_value(message: str) -> None:
	raise ValueError(message)


def _skip_field(stream: BinaryIO, wire_type: int) -> None:
	if wire_type == 0:
		if _read_varint(stream) is None:
			raise ValueError("truncated protobuf field")
	elif wire_type == 1:
		if len(stream.read(8)) != 8:
			raise ValueError("truncated fixed64 field")
	elif wire_type == 2:
		length = _read_varint(stream)
		if length is None or length > 64 * 1024 * 1024 or len(stream.read(length)) != length:
			raise ValueError("invalid length-delimited protobuf field")
	elif wire_type == 5:
		if len(stream.read(4)) != 4:
			raise ValueError("truncated fixed32 field")
	else:
		raise ValueError(f"unsupported protobuf wire type: {wire_type}")


def _appearance_metadata(payload: bytes) -> tuple[int | None, bool]:
	stream = io.BytesIO(payload)
	item_id: int | None = None
	has_flags = False
	while True:
		key = _read_varint(stream)
		if key is None:
			return item_id, has_flags
		field_number = key >> 3
		wire_type = key & 7
		if field_number == 0:
			raise ValueError("protobuf field number zero is invalid")
		if field_number == 1 and wire_type == 0:
			item_id = _read_varint(stream)
			if item_id is None:
				raise ValueError("truncated Appearance item id")
			continue
		if field_number == 3 and wire_type == 2:
			length = _read_varint(stream)
			if length is None or length > 16 * 1024 * 1024 or len(stream.read(length)) != length:
				raise ValueError("invalid Appearance flags message")
			has_flags = True
			continue
		_skip_field(stream, wire_type)


def extract_appearances(path: DiscoveredFile, config: AuditConfig) -> ExtractionResult:
	result = ExtractionResult.bounded(config, path.path)
	context = _fact_context(config, path.path)
	if context is None:
		return result
	layer, profiles = context
	result.facts.append(
		Fact(
			domain="item.server_id",
			role="definition",
			value=0,
			end_value=99,
			layer=layer,
			profiles=profiles,
			location=Location("src/items/items.cpp", 335, 1),
			extractor="cpp.item-fluid-range",
			owner="Items::parseItemNode",
		)
	)
	item_ids: list[int] = []
	try:
		with path.absolute_path.open("rb") as stream:
			appearance_index = 0
			while True:
				key = _read_varint(stream)
				if key is None:
					break
				field_number = key >> 3
				wire_type = key & 7
				if field_number == 0:
					raise ValueError("protobuf field number zero is invalid")
				if field_number == 1 and wire_type == 2:
					length = _read_varint(stream)
					if length is None or length > 16 * 1024 * 1024:
						raise ValueError("invalid Appearance message length")
					payload = stream.read(length)
					if len(payload) != length:
						raise ValueError("truncated Appearance message")
					appearance_index += 1
					if appearance_index > config.max_facts_per_file:
						raise ExtractionLimitError(
							f"Appearance entries for {path.path} exceeded configured limit {config.max_facts_per_file}"
						)
					item_id, has_flags = _appearance_metadata(payload)
					identity = str(item_id) if item_id is not None else f"appearance:{appearance_index}"
					if not has_flags:
						result.diagnostics.append(
							Diagnostic(
								"protobuf.item-missing-flags",
								f"Appearance item {identity} has no flags and is ignored by the runtime",
								"error",
								Location(path.path),
								identity,
							)
						)
						continue
					if item_id is None:
						result.diagnostics.append(
							Diagnostic(
								"protobuf.item-missing-id",
								f"Appearance entry {appearance_index} has no item id",
								"error",
								Location(path.path),
								identity,
							)
						)
						continue
					if item_id > 65535:
						result.diagnostics.append(
							Diagnostic(
								"protobuf.item-id-out-of-range",
								f"Appearance item id {item_id} exceeds the uint16 runtime domain",
								"error",
								Location(path.path),
								str(item_id),
							)
						)
						continue
					item_ids.append(item_id)
				else:
					_skip_field(stream, wire_type)
	except (OSError, ValueError) as error:
		item_ids.clear()
		result.diagnostics.append(
			Diagnostic("scan.protobuf-error", f"cannot parse {path.path}: {error}", "error", Location(path.path))
		)
	if len(item_ids) != len(set(item_ids)):
		result.diagnostics.append(
			Diagnostic(
				"protobuf.duplicate-item-id",
				"Appearances.object contains duplicate item IDs",
				"error",
				Location(path.path),
			)
		)
	unique_ids = sorted(set(item_ids))
	if unique_ids:
		start = previous = unique_ids[0]
		for item_id in (*unique_ids[1:], None):
			if item_id is not None and item_id == previous + 1:
				previous = item_id
				continue
			result.facts.append(
				Fact(
					domain="item.server_id",
					role="definition",
					value=start,
					end_value=previous if previous != start else None,
					layer=layer,
					profiles=profiles,
					location=Location(path.path),
					extractor="protobuf.appearances",
					owner="Appearances.object",
				)
			)
			if item_id is None:
				break
			start = previous = item_id
	return result


class CanaryXmlHandler(xml.sax.ContentHandler):
	def __init__(
		self,
		path: str,
		layer: str,
		profiles: tuple[str, ...],
		*,
		item_override: bool,
		storage_registry: bool,
		max_facts: int,
		max_diagnostics: int,
	) -> None:
		super().__init__()
		self.path = path
		self.layer = layer
		self.profiles = profiles
		self.item_override = item_override
		self.storage_registry = storage_registry
		self.locator: xml.sax.xmlreader.Locator | None = None
		self.facts: list[Fact] = BoundedList(max_facts, f"XML facts for {path}")
		self.diagnostics: list[Diagnostic] = BoundedList(max_diagnostics, f"XML diagnostics for {path}")
		self.max_ranges = max_facts
		self.current_storage_range: tuple[int, int] | None = None
		self.storage_ranges: list[tuple[int, int, Location]] = []

	def setDocumentLocator(self, locator: xml.sax.xmlreader.Locator) -> None:  # noqa: N802
		self.locator = locator

	def current_location(self) -> Location:
		if self.locator is None:
			return Location(self.path)
		return Location(self.path, self.locator.getLineNumber(), self.locator.getColumnNumber() + 1)

	def startElement(self, name: str, attributes: xml.sax.xmlreader.AttributesImpl) -> None:  # noqa: N802
		location = self.current_location()
		lower_name = name.casefold()
		if self.item_override and lower_name == "item":
			self._item(attributes, location)
		if self.storage_registry:
			if lower_name == "range":
				self._storage_range(attributes, location)
			elif lower_name == "storage":
				self._storage(attributes, location)
		if lower_name in {"monster", "singlespawn"} and "name" in attributes:
			self.facts.append(self._name_reference("monster.name", attributes["name"], location, lower_name))
		elif lower_name == "npc" and "name" in attributes:
			self.facts.append(self._name_reference("npc.name", attributes["name"], location, lower_name))

	def endElement(self, name: str) -> None:  # noqa: N802
		if self.storage_registry and name.casefold() == "range":
			self.current_storage_range = None

	def finalize(self) -> None:
		"""Validate storage-range overlaps with an O(n log n) sweep."""
		events: dict[int, tuple[list[int], list[int]]] = {}
		entries: dict[int, tuple[int, int, Location]] = {}
		for serial, interval in enumerate(self.storage_ranges):
			start, end, _ = interval
			entries[serial] = interval
			events.setdefault(start, ([], []))[0].append(serial)
			events.setdefault(end + 1, ([], []))[1].append(serial)
		positions = sorted(events)
		active: set[int] = set()
		location_heap: list[tuple[str, int, int, int]] = []
		for index, position in enumerate(positions[:-1]):
			additions, removals = events[position]
			for serial in removals:
				active.discard(serial)
			for serial in additions:
				active.add(serial)
				location = entries[serial][2]
				heapq.heappush(
					location_heap,
					(location.path, location.line, location.column, serial),
				)
			segment_end = positions[index + 1] - 1
			if len(active) < 2 or position > segment_end:
				continue
			while location_heap and location_heap[0][3] not in active:
				heapq.heappop(location_heap)
			if not location_heap:
				continue
			representative = entries[location_heap[0][3]][2]
			identity = f"{position}-{segment_end}"
			self.diagnostics.append(
				Diagnostic(
					"xml.overlapping-storage-range",
					f"storage ranges overlap in {identity} across {len(active)} declarations",
					"error",
					representative,
					identity=identity,
				)
			)

	def _name_reference(self, domain: str, value: str, location: Location, owner: str) -> Fact:
		return Fact(
			domain=domain,
			role="reference",
			value=value,
			layer=self.layer,
			profiles=self.profiles,
			location=location,
			extractor="xml.content-reference",
			owner=owner,
		)

	def _item(self, attributes: xml.sax.xmlreader.AttributesImpl, location: Location) -> None:
		try:
			if "id" in attributes:
				start = end = int(attributes["id"])
			elif "fromid" in attributes and "toid" in attributes:
				start = int(attributes["fromid"])
				end = int(attributes["toid"])
			else:
				return
			if start < 0 or end < start:
				raise ValueError(f"invalid item override range {start}-{end}")
		except ValueError as error:
			identity = f"{attributes.get('id', attributes.get('fromid', '?'))}-{attributes.get('id', attributes.get('toid', '?'))}"
			self.diagnostics.append(
				Diagnostic("xml.invalid-item-range", str(error), "error", location, identity=identity)
			)
			return
		self.facts.append(
			Fact(
				domain="item.server_id",
				role="reference",
				value=start,
				end_value=end if end != start else None,
				layer=self.layer,
				profiles=self.profiles,
				location=location,
				extractor="xml.item-override",
				owner="items.xml override",
			)
		)

	def _storage_range(self, attributes: xml.sax.xmlreader.AttributesImpl, location: Location) -> None:
		if len(self.storage_ranges) >= self.max_ranges:
			raise ExtractionLimitError(
				f"storage ranges for {self.path} exceeded configured limit {self.max_ranges}"
			)
		try:
			start = int(attributes["start"])
			end = int(attributes["end"])
			if start < 0 or end < start:
				raise ValueError("storage range end precedes start")
		except (KeyError, ValueError) as error:
			self.current_storage_range = None
			identity = f"{attributes.get('start', '?')}-{attributes.get('end', '?')}"
			self.diagnostics.append(
				Diagnostic("xml.invalid-storage-range", str(error), "error", location, identity=identity)
			)
			return
		self.storage_ranges.append((start, end, location))
		self.current_storage_range = (start, end)

	def _storage(self, attributes: xml.sax.xmlreader.AttributesImpl, location: Location) -> None:
		if self.current_storage_range is None:
			identity = f"{attributes.get('name', '?')}:{attributes.get('key', '?')}"
			self.diagnostics.append(
				Diagnostic(
					"xml.storage-outside-range",
					"storage is not nested in a valid range",
					"error",
					location,
					identity=identity,
				)
			)
			return
		try:
			key = int(attributes["key"])
			name = attributes["name"]
			value = self.current_storage_range[0] + key
			if value < self.current_storage_range[0] or value > self.current_storage_range[1]:
				raise ValueError(f"storage key {key} falls outside its range")
		except (KeyError, ValueError) as error:
			identity = f"{attributes.get('name', '?')}:{attributes.get('key', '?')}"
			self.diagnostics.append(
				Diagnostic("xml.invalid-storage", str(error), "error", location, identity=identity)
			)
			return
		self.facts.append(
			Fact(
				domain="storage.player",
				role="definition",
				value=value,
				layer=self.layer,
				profiles=self.profiles,
				location=location,
				extractor="xml.storage-registry",
				symbol=name,
				owner="storages.xml",
			)
		)


def extract_xml(path: DiscoveredFile, config: AuditConfig) -> ExtractionResult:
	result = ExtractionResult.bounded(config, path.path)
	context = _fact_context(config, path.path)
	if context is None:
		return result
	layer, profiles = context
	if path.size_bytes > config.max_xml_file_bytes:
		result.diagnostics.append(
			Diagnostic(
				"scan.xml-size-limit",
				f"XML file exceeds configured {config.max_xml_file_bytes}-byte limit: {path.path}",
				"error",
				Location(path.path),
			)
		)
		return result
	handler = CanaryXmlHandler(
		path.path,
		layer,
		profiles,
		item_override=path.path in config.item_override_files,
		storage_registry=path.path in config.storage_xml_files,
		max_facts=config.max_facts_per_file,
		max_diagnostics=config.max_diagnostics_per_file,
	)
	try:
		parser = xml.sax.make_parser()
		for feature in (feature_external_ges, feature_external_pes):
			try:
				parser.setFeature(feature, False)
			except (xml.sax.SAXNotRecognizedException, xml.sax.SAXNotSupportedException) as error:
				result.diagnostics.append(
					Diagnostic(
						"scan.xml-security",
						f"XML parser cannot disable external entities: {error}",
						"error",
						Location(path.path),
					)
				)
				return result
		parser.setContentHandler(handler)
		with path.absolute_path.open("rb") as source:
			parser.parse(source)
	except (OSError, xml.sax.SAXException) as error:
		result.diagnostics.append(
			Diagnostic("scan.xml-error", f"cannot parse {path.path}: {error}", "error", Location(path.path))
		)
		return result
	handler.finalize()
	content_groups: dict[tuple[str, int | str, str | None], list[Fact]] = {}
	other_facts: list[Fact] = []
	for fact in handler.facts:
		if fact.extractor != "xml.content-reference":
			other_facts.append(fact)
			continue
		content_groups.setdefault((fact.domain, fact.value, fact.owner), []).append(fact)
	collapsed_references = []
	for matches in content_groups.values():
		first = min(matches, key=lambda fact: fact.sort_key())
		collapsed_references.append(
			replace(first, attributes=(("occurrenceCount", str(len(matches))),))
		)
	result.facts.extend(sorted((*other_facts, *collapsed_references), key=lambda fact: fact.sort_key()))
	result.diagnostics.extend(handler.diagnostics)
	return result


def extract_file(path: DiscoveredFile, config: AuditConfig) -> ExtractionResult:
	if config.layer_for_path(path.path) is None:
		return ExtractionResult()
	try:
		if path.path in config.item_catalog_files:
			return extract_appearances(path, config)
		if path.extension == ".lua":
			return extract_lua(path, config)
		if path.extension == ".xml":
			return extract_xml(path, config)
	except ExtractionLimitError as error:
		return ExtractionResult(
			diagnostics=[Diagnostic("scan.extraction-limit", str(error), "error", Location(path.path))]
		)
	return ExtractionResult()
