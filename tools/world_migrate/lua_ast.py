"""Bounded structural reader for configuration literals, without executing Lua.

The auditor lexer owns comments, strings and token locations. This reader keeps
every table field (including duplicate keys), source ranges and unresolved
expressions. Unsupported code is a located diagnostic, never a guessed value.
"""

from __future__ import annotations

import math
import re
from dataclasses import dataclass
from typing import Any, Mapping

from tools.canary_audit.lua_lexer import (
	LuaLexError,
	Token,
	_read_quoted,
	lexical_scope_end_positions,
	matching_delimiters,
	tokenize,
)


@dataclass(frozen=True)
class Span:
	start: int
	end: int
	line: int
	column: int


@dataclass(frozen=True)
class Field:
	key: Node
	value: Node
	span: Span


@dataclass(frozen=True)
class Node:
	kind: str
	value: Any
	span: Span


@dataclass(frozen=True)
class Assignment:
	name: str
	value: Node
	span: Span
	local: bool = False


class Unresolved(ValueError):
	def __init__(self, message: str, span: Span):
		super().__init__(message)
		self.span = span


# Numeric lexing is deliberately separate from expression parsing. The auditor
# needs integer tokens; migration also accepts finite decimal/hex floats.
NUMBER = re.compile(r"(?:0[xX](?:[0-9a-fA-F]+(?:\.[0-9a-fA-F]*)?|\.[0-9a-fA-F]+)(?:[pP][+-]?\d+)?|(?:\d+(?:\.(?!\.)\d*)?|\.\d+)(?:[eE][+-]?\d+)?)")


class Reader:
	def __init__(self, source: str):
		if len(source.encode("utf-8")) > 16 * 1024 * 1024:
			raise ValueError("Lua source exceeds 16 MiB")
		self.source = source
		self.tokens = tokenize(source, max_tokens=1_000_000)
		self.pairs = matching_delimiters(self.tokens)
		self.lines = [0]
		self.lines.extend(index + 1 for index, char in enumerate(source) if char == "\n")
		self.offsets = [self.lines[t.line - 1] + t.column - 1 for t in self.tokens]

	def span(self, start: int, end: int) -> Span:
		token = self.tokens[start]
		last = self.tokens[end - 1]
		finish = self.offsets[end - 1] + len(str(last.value))
		if last.kind == "string":
			finish = self.string(end - 1)[1]
		elif last.kind == "number":
			literal = NUMBER.match(self.source, self.offsets[end - 1])
			if literal:
				finish = literal.end()
		return Span(self.offsets[start], finish, token.line, token.column)

	def string(self, index: int) -> tuple[str, int]:
		start = self.offsets[index]
		if self.source[start] in "\"'":
			_, end, _, _ = _read_quoted(self.source, start, 1, 1)
			# Lua's escaped physical newline contributes a newline to the value.
			raw = self.source[start:end].replace("\\\r\n", "\\n").replace("\\\n", "\\n").replace("\\\r", "\\n")
			return _read_quoted(raw, 0, 1, 1)[0], end
		opener = re.match(r"\[(=*)\[", self.source[start:])
		assert opener is not None
		closing = "]" + opener[1] + "]"
		content = start + len(opener[0])
		end = self.source.index(closing, content)
		value = self.source[content:end].replace("\r\n", "\n").replace("\r", "\n")
		return value.removeprefix("\n"), end + len(closing)

	def value(self, start: int, end: int, depth: int = 0) -> Node:
		span = self.span(start, end)
		if depth > 128:
			raise Unresolved("configuration nesting exceeds 128", span)
		tokens = self.tokens
		first = tokens[start]
		if first.value == "{" and self.pairs.get(start) == end - 1:
			fields: list[Field] = []
			index = start + 1
			implicit = 1
			while index < end - 1:
				field_start = index
				if tokens[index].value == "[" and index in self.pairs:
					closing = self.pairs[index]
					if closing + 1 >= end or tokens[closing + 1].value != "=":
						return Node("unknown", "invalid keyed table field", span)
					key = self.value(index + 1, closing, depth + 1)
					index = closing + 2
				elif tokens[index].kind == "identifier" and index + 1 < end and tokens[index + 1].value == "=":
					key = Node("scalar", str(tokens[index].value), self.span(index, index + 1))
					index += 2
				else:
					key = Node("scalar", implicit, self.span(index, index + 1))
					implicit += 1
				value_start = index
				while index < end - 1 and not (tokens[index].kind == "symbol" and tokens[index].value in {",", ";"}):
					index = self.pairs.get(index, index) + 1
				if index == value_start:
					return Node("unknown", "missing table value", span)
				value = self.value(value_start, index, depth + 1)
				fields.append(Field(key, value, self.span(field_start, index)))
				index += 1
			return Node("table", tuple(fields), span)
		if first.value == "(" and self.pairs.get(start) == end - 1:
			return self.value(start + 1, end - 1, depth + 1)
		if first.kind == "string" and end == start + 1:
			return Node("scalar", self.string(start)[0], span)
		if end == start + 1 and first.kind == "identifier" and first.value in {"true", "false", "nil"}:
			return Node("scalar", {"true": True, "false": False, "nil": None}[str(first.value)], span)
		raw = self.source[span.start:span.end].strip()
		sign = -1 if raw.startswith("-") else 1
		number = raw[1:].strip() if sign == -1 else raw
		if NUMBER.fullmatch(number):
			try:
				if number.lower().startswith("0x"):
					value = float.fromhex(number) if any(c in number.lower() for c in ".p") else int(number, 16)
				else:
					value = float(number) if any(c in number.lower() for c in ".e") else int(number, 10)
				if isinstance(value, float) and not math.isfinite(value):
					raise ValueError("non-finite number")
				return Node("scalar", sign * value, span)
			except (ValueError, OverflowError):
				return Node("unknown", "number is not finite", span)
		if first.kind == "identifier":
			index = start + 1
			name = str(first.value)
			while index < end:
				if index + 1 < end and tokens[index].value == "." and tokens[index + 1].kind == "identifier":
					name += "." + str(tokens[index + 1].value)
					index += 2
				elif index + 2 < end and tokens[index].value == "[" and self.pairs.get(index) == index + 2:
					key = self.value(index + 1, index + 2, depth + 1)
					if key.kind != "scalar" or type(key.value) is not int:
						break
					name += f"[{key.value}]"
					index += 3
				else:
					break
			if index == end:
				return Node("symbol", name, span)
			if name == "Position" and index < end and tokens[index].value == "(" and self.pairs.get(index) == end - 1:
				args = []
				index += 1
				arg_start = index
				while index < end - 1:
					if tokens[index].value == "," and tokens[index].kind == "symbol":
						args.append(self.value(arg_start, index, depth + 1))
						arg_start = index + 1
					index = self.pairs.get(index, index) + 1
				if arg_start < end - 1:
					args.append(self.value(arg_start, end - 1, depth + 1))
				return Node("position", tuple(args), span)
		return Node("unknown", "dynamic or unsupported expression", span)

	def assignments(self) -> tuple[Assignment, ...]:
		result = []
		scopes = lexical_scope_end_positions(self.tokens)
		i = 0
		while i < len(self.tokens) - 2:
			token = self.tokens[i]
			if token.kind != "identifier" or scopes[i] is not None:
				i = self.pairs.get(i, i) + 1
				continue
			start = i
			parts = [str(token.value)]
			i += 1
			while i + 1 < len(self.tokens) and self.tokens[i].value == "." and self.tokens[i + 1].kind == "identifier":
				parts.append(str(self.tokens[i + 1].value))
				i += 2
			if i + 1 >= len(self.tokens) or self.tokens[i].value != "=" or self.tokens[i + 1].value == "=":
				continue
			value_start = i + 1
			end = self.pairs.get(value_start, value_start) + 1
			# A statement ends at a new line only if no expression continuation
			# follows. Dynamic assignments remain unresolved as a whole.
			while end < len(self.tokens):
				next_token = self.tokens[end]
				if next_token.value == ";":
					break
				if next_token.line > self.tokens[end - 1].line and next_token.value not in {".", "+", "-", "*", "/", "and", "or", "("}:
					break
				end = self.pairs.get(end, end) + 1
			result.append(Assignment(".".join(parts), self.value(value_start, end), self.span(start, end), start > 0 and self.tokens[start - 1].value == "local"))
			i = end
		return tuple(result)


def evaluate(node: Node, constants: Mapping[str, Any] | None = None, *, reject_duplicates: bool = True) -> Any:
	constants = constants or {}
	if node.kind == "scalar":
		return node.value
	if node.kind == "symbol":
		if node.value not in constants:
			raise Unresolved(f"unproven constant {node.value}", node.span)
		return constants[node.value]
	if node.kind == "position":
		values = [evaluate(arg, constants) for arg in node.value]
		if len(values) != 3 or any(type(value) is not int for value in values):
			raise Unresolved("Position requires three static integers", node.span)
		return dict(zip(("x", "y", "z"), values))
	if node.kind == "table":
		result = {}
		seen = set()
		for field in node.value:
			key = evaluate(field.key, constants)
			if type(key) not in {str, int, float, bool}:
				raise Unresolved("unsupported or nil table key", field.key.span)
			# Lua keeps booleans distinct from numeric keys.
			identity = ("boolean" if isinstance(key, bool) else "value", key)
			if identity in seen and reject_duplicates:
				raise Unresolved(f"duplicate table key {key!r}", field.key.span)
			seen.add(identity)
			value = evaluate(field.value, constants, reject_duplicates=reject_duplicates)
			if value is None:
				result.pop(key, None)
			else:
				result[key] = value
		return result
	raise Unresolved(str(node.value), node.span)


def json_value(value: Any) -> Any:
	"""Represent Lua lists as JSON arrays and scalar-keyed records as objects."""
	if isinstance(value, dict):
		if value and all(type(k) is int for k in value) and set(value) == set(range(1, len(value) + 1)):
			return [json_value(value[index]) for index in range(1, len(value) + 1)]
		return {str(key): json_value(child) for key, child in value.items()}
	return value
