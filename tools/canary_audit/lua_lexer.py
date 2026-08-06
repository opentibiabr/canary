"""Small Lua lexer for conservative, comment-safe static extraction."""

from __future__ import annotations

import re
from collections import defaultdict
from dataclasses import dataclass
from typing import Iterable, Mapping


@dataclass(frozen=True)
class Token:
	kind: str
	value: str | int
	line: int
	column: int


@dataclass(frozen=True)
class StaticBinding:
	value: int | str
	line: int
	column: int
	scope_end_line: int | None = None
	scope_end_column: int | None = None


class LuaLexError(ValueError):
	def __init__(self, message: str, line: int, column: int) -> None:
		super().__init__(message)
		self.line = line
		self.column = column


def _long_bracket_level(text: str, index: int) -> int | None:
	if index >= len(text) or text[index] != "[":
		return None
	cursor = index + 1
	while cursor < len(text) and text[cursor] == "=":
		cursor += 1
	return cursor - index - 1 if cursor < len(text) and text[cursor] == "[" else None


def _advance(segment: str, line: int, column: int) -> tuple[int, int]:
	newlines = segment.count("\n")
	if newlines:
		return line + newlines, len(segment.rsplit("\n", 1)[-1]) + 1
	return line, column + len(segment)


def _read_long_bracket(text: str, index: int, level: int, line: int, column: int) -> tuple[str, int, int, int]:
	opener_length = level + 2
	closing = "]" + ("=" * level) + "]"
	content_start = index + opener_length
	end = text.find(closing, content_start)
	if end < 0:
		raise LuaLexError("unterminated long bracket", line, column)
	finish = end + len(closing)
	segment = text[index:finish]
	new_line, new_column = _advance(segment, line, column)
	return text[content_start:end], finish, new_line, new_column


ESCAPES = {
	"a": "\a",
	"b": "\b",
	"f": "\f",
	"n": "\n",
	"r": "\r",
	"t": "\t",
	"v": "\v",
	"\\": "\\",
	'"': '"',
	"'": "'",
}


def _read_quoted(text: str, index: int, line: int, column: int) -> tuple[str, int, int, int]:
	quote = text[index]
	cursor = index + 1
	characters: list[str] = []
	current_line = line
	current_column = column + 1
	while cursor < len(text):
		character = text[cursor]
		if character == quote:
			return "".join(characters), cursor + 1, current_line, current_column + 1
		if character == "\\":
			if cursor + 1 >= len(text):
				break
			next_character = text[cursor + 1]
			if next_character == "z":
				cursor += 2
				current_column += 2
				while cursor < len(text) and text[cursor].isspace():
					current_line, current_column = _advance(text[cursor], current_line, current_column)
					cursor += 1
				continue
			if next_character in {"\r", "\n"}:
				cursor += 2
				if next_character == "\r" and cursor < len(text) and text[cursor] == "\n":
					cursor += 1
				current_line += 1
				current_column = 1
				continue
			if next_character in ESCAPES:
				characters.append(ESCAPES[next_character])
				cursor += 2
				current_column += 2
				continue
			if next_character.isdigit():
				end = cursor + 1
				while end < len(text) and end < cursor + 4 and text[end].isdigit():
					end += 1
				value = int(text[cursor + 1 : end], 10)
				if value > 255:
					raise LuaLexError("decimal string escape exceeds 255", current_line, current_column)
				characters.append(chr(value))
				current_column += end - cursor
				cursor = end
				continue
			if next_character == "x":
				raw = text[cursor + 2 : cursor + 4]
				if len(raw) != 2 or any(character not in "0123456789abcdefABCDEF" for character in raw):
					raise LuaLexError("invalid hexadecimal string escape", current_line, current_column)
				characters.append(chr(int(raw, 16)))
				cursor += 4
				current_column += 4
				continue
			if next_character == "u":
				if cursor + 2 >= len(text) or text[cursor + 2] != "{":
					raise LuaLexError("invalid Unicode string escape", current_line, current_column)
				closing = text.find("}", cursor + 3)
				raw = text[cursor + 3 : closing] if closing >= 0 else ""
				if (
					not raw
					or len(raw) > 8
					or any(character not in "0123456789abcdefABCDEF" for character in raw)
				):
					raise LuaLexError("invalid Unicode string escape", current_line, current_column)
				value = int(raw, 16)
				if value > 0x10FFFF or 0xD800 <= value <= 0xDFFF:
					raise LuaLexError("Unicode string escape is not a scalar value", current_line, current_column)
				characters.append(chr(value))
				consumed = closing - cursor + 1
				cursor = closing + 1
				current_column += consumed
				continue
			raise LuaLexError(
				f"unsupported string escape \\{next_character}",
				current_line,
				current_column,
			)
		if character == "\n":
			raise LuaLexError("newline in quoted string", current_line, current_column)
		characters.append(character)
		cursor += 1
		current_column += 1
	throw_line = current_line
	throw_column = current_column
	raise LuaLexError("unterminated quoted string", throw_line, throw_column)


def tokenize(text: str, max_tokens: int | None = None) -> tuple[Token, ...]:
	tokens: list[Token] = []

	def emit(token: Token) -> None:
		if max_tokens is not None and len(tokens) >= max_tokens:
			raise LuaLexError(f"Lua token count exceeds configured limit {max_tokens}", token.line, token.column)
		tokens.append(token)

	index = 0
	line = 1
	column = 1
	length = len(text)
	while index < length:
		character = text[index]
		if character.isspace():
			line, column = _advance(character, line, column)
			index += 1
			continue

		if text.startswith("--", index):
			level = _long_bracket_level(text, index + 2)
			if level is not None:
				_, index, line, column = _read_long_bracket(text, index + 2, level, line, column + 2)
				continue
			end = text.find("\n", index + 2)
			if end < 0:
				break
			segment = text[index:end]
			line, column = _advance(segment, line, column)
			index = end
			continue

		start_line = line
		start_column = column
		if character in {'"', "'"}:
			value, index, line, column = _read_quoted(text, index, line, column)
			emit(Token("string", value, start_line, start_column))
			continue

		level = _long_bracket_level(text, index)
		if level is not None:
			value, index, line, column = _read_long_bracket(text, index, level, line, column)
			emit(Token("string", value, start_line, start_column))
			continue

		if character.isalpha() or character == "_":
			cursor = index + 1
			while cursor < length and (text[cursor].isalnum() or text[cursor] == "_"):
				cursor += 1
			value = text[index:cursor]
			emit(Token("identifier", value, line, column))
			line, column = _advance(value, line, column)
			index = cursor
			continue

		if character.isdigit():
			cursor = index + 1
			if character == "0" and cursor < length and text[cursor] in {"x", "X"}:
				cursor += 1
				while cursor < length and text[cursor] in "0123456789abcdefABCDEF":
					cursor += 1
			else:
				while cursor < length and text[cursor].isdigit():
					cursor += 1
			raw = text[index:cursor]
			try:
				value = int(raw, 16) if raw.lower().startswith("0x") else int(raw, 10)
			except ValueError as error:
				raise LuaLexError(f"invalid integer literal {raw!r}", line, column) from error
			emit(Token("number", value, line, column))
			line, column = _advance(raw, line, column)
			index = cursor
			continue

		emit(Token("symbol", character, line, column))
		index += 1
		column += 1

	return tuple(tokens)


def is_assignment_operator(tokens: tuple[Token, ...], index: int) -> bool:
	if tokens[index].kind != "symbol" or tokens[index].value != "=":
		return False
	previous = (
		tokens[index - 1].value
		if index and tokens[index - 1].kind == "symbol"
		else None
	)
	following = (
		tokens[index + 1].value
		if index + 1 < len(tokens) and tokens[index + 1].kind == "symbol"
		else None
	)
	return previous not in {"=", "~", "<", ">"} and following != "="


def _literal_ends_assignment(tokens: tuple[Token, ...], index: int) -> bool:
	"""Conservatively reject literals that are only the first term of an expression."""
	if index + 1 >= len(tokens):
		return True
	following = tokens[index + 1]
	if (following.kind == "symbol" and following.value == ";") or (
		following.kind == "identifier" and following.value in {"end", "else", "elseif", "until"}
	):
		return True
	continuations = {
		".", "[", "(", "+", "-", "*", "/", "%", "^", "#", "&", "|", "~", "<", ">", "=",
		"and", "or", "..", "//", "<<", ">>",
	}
	if (
		(following.kind == "symbol" and following.value in continuations)
		or (following.kind == "identifier" and following.value in {"and", "or"})
	):
		return False
	return following.line > tokens[index].line


def _block_scopes(tokens: tuple[Token, ...]) -> tuple[tuple[int | None, ...], dict[int, int]]:
	"""Map tokens to conservative lexical block bounds used for local aliases."""
	stack: list[tuple[str, int]] = []
	scope_at: list[int | None] = []
	scope_ends: dict[int, int] = {}
	for index, token in enumerate(tokens):
		value = token.value if token.kind == "identifier" else None
		if value in {"end", "until"}:
			if stack:
				_, start = stack.pop()
				scope_ends[start] = index
			scope_at.append(stack[-1][1] if stack else None)
			continue
		if value in {"else", "elseif"} and stack and stack[-1][0] == "if":
			_, start = stack.pop()
			scope_ends[start] = index
			stack.append(("if", index))
			scope_at.append(index)
			continue
		if value in {"function", "if", "do", "repeat"}:
			stack.append((str(value), index))
		scope_at.append(stack[-1][1] if stack else None)
	last_index = max(0, len(tokens) - 1)
	for _, start in stack:
		scope_ends.setdefault(start, last_index)
	return tuple(scope_at), scope_ends


def _binding_occurrences(tokens: tuple[Token, ...]) -> dict[str, set[tuple[int, int]]]:
	"""Collect writes and declarations that can invalidate a scalar alias."""
	occurrences: dict[str, set[tuple[int, int]]] = defaultdict(set)

	for equals_index, token in enumerate(tokens):
		if not is_assignment_operator(tokens, equals_index):
			continue
		cursor = equals_index - 1
		while cursor >= 0 and tokens[cursor].kind == "identifier":
			name_token = tokens[cursor]
			occurrences[str(name_token.value)].add((name_token.line, name_token.column))
			if cursor < 2 or tokens[cursor - 1].value != ",":
				break
			cursor -= 2

	for index, token in enumerate(tokens):
		if token.kind == "identifier" and token.value == "local" and index + 1 < len(tokens):
			cursor = index + 1
			if tokens[cursor].kind == "identifier" and tokens[cursor].value == "function":
				cursor += 1
				if cursor < len(tokens) and tokens[cursor].kind == "identifier":
					declared = tokens[cursor]
					occurrences[str(declared.value)].add((declared.line, declared.column))
				continue
			while cursor < len(tokens) and tokens[cursor].kind == "identifier":
				declared = tokens[cursor]
				occurrences[str(declared.value)].add((declared.line, declared.column))
				cursor += 1
				if cursor >= len(tokens) or tokens[cursor].value != ",":
					break
				cursor += 1

		if token.kind == "identifier" and token.value == "function":
			cursor = index + 1
			while cursor < len(tokens) and tokens[cursor].value != "(":
				cursor += 1
			if cursor >= len(tokens):
				continue
			depth = 1
			cursor += 1
			while cursor < len(tokens) and depth:
				parameter = tokens[cursor]
				if parameter.value == "(":
					depth += 1
				elif parameter.value == ")":
					depth -= 1
				elif depth == 1 and parameter.kind == "identifier":
					occurrences[str(parameter.value)].add((parameter.line, parameter.column))
				cursor += 1

		if token.kind == "identifier" and token.value == "for":
			cursor = index + 1
			while cursor < len(tokens) and tokens[cursor].kind == "identifier":
				declared = tokens[cursor]
				occurrences[str(declared.value)].add((declared.line, declared.column))
				cursor += 1
				if cursor >= len(tokens) or tokens[cursor].value != ",":
					break
				cursor += 1

	return occurrences


def binding_occurrence_counts(tokens: tuple[Token, ...]) -> dict[str, int]:
	"""Return conservative per-name write/declaration counts for object-flow checks."""
	return {name: len(locations) for name, locations in _binding_occurrences(tokens).items()}


def lexical_scope_end_positions(
	tokens: tuple[Token, ...],
) -> tuple[tuple[int, int] | None, ...]:
	"""Return the inclusive lexical block end for each token, or None at top level."""
	scope_at, scope_ends = _block_scopes(tokens)
	result: list[tuple[int, int] | None] = []
	for scope_id in scope_at:
		if scope_id is None:
			result.append(None)
			continue
		end = tokens[scope_ends[scope_id]]
		result.append((end.line, end.column))
	return tuple(result)


def collect_static_bindings(tokens: tuple[Token, ...]) -> dict[str, StaticBinding]:
	"""Return scalar bindings that are unique, literal, ordered, and lexically visible."""
	occurrences = _binding_occurrences(tokens)
	scope_at, scope_ends = _block_scopes(tokens)
	candidates: dict[str, list[StaticBinding]] = defaultdict(list)
	for index in range(len(tokens) - 2):
		name_token = tokens[index]
		if name_token.kind != "identifier" or not is_assignment_operator(tokens, index + 1):
			continue
		is_local = (
			index > 0
			and tokens[index - 1].kind == "identifier"
			and tokens[index - 1].value == "local"
		)
		is_constant = bool(re.fullmatch(r"[A-Z][A-Z0-9_]*", str(name_token.value)))
		if not (is_local or is_constant):
			continue
		if not is_local and scope_at[index] is not None:
			continue
		if index > 0 and tokens[index - 1].value in {".", ":", "[", "{", ","}:
			continue
		value_token = tokens[index + 2]
		if value_token.kind not in {"number", "string"} or not _literal_ends_assignment(tokens, index + 2):
			continue
		name = str(name_token.value)
		if len(occurrences.get(name, ())) != 1:
			continue
		scope_id = scope_at[index] if is_local else None
		scope_end = tokens[scope_ends[scope_id]] if scope_id is not None else None
		candidates[name].append(
			StaticBinding(
				value_token.value,
				name_token.line,
				name_token.column,
				scope_end.line if scope_end is not None else None,
				scope_end.column if scope_end is not None else None,
			)
		)
	return {name: values[0] for name, values in candidates.items() if len(values) == 1}


def collect_simple_constants(tokens: tuple[Token, ...]) -> dict[str, int | str]:
	"""Compatibility view of unambiguous local aliases and uppercase constants."""
	return {name: binding.value for name, binding in collect_static_bindings(tokens).items()}


def dotted_identifier(tokens: Iterable[Token]) -> str | None:
	items = tuple(tokens)
	if not items or items[0].kind != "identifier":
		return None
	parts = [str(items[0].value)]
	index = 1
	while index < len(items):
		if (
			index + 1 >= len(items)
			or items[index].kind != "symbol"
			or items[index].value != "."
			or items[index + 1].kind != "identifier"
		):
			return None
		parts.append(str(items[index + 1].value))
		index += 2
	return ".".join(parts)


def resolve_scalar(
	tokens: Iterable[Token],
	constants: Mapping[str, int | str | StaticBinding],
) -> int | str | None:
	items = tuple(tokens)
	if len(items) == 1:
		token = items[0]
		if token.kind in {"number", "string"}:
			return token.value
		if token.kind == "identifier":
			binding = constants.get(str(token.value))
			if isinstance(binding, StaticBinding):
				if (binding.line, binding.column) >= (token.line, token.column):
					return None
				if binding.scope_end_line is not None and (
					(token.line, token.column)
					>= (binding.scope_end_line, binding.scope_end_column or 1)
				):
					return None
				return binding.value
			return binding
	return dotted_identifier(items)


def matching_delimiters(tokens: tuple[Token, ...]) -> dict[int, int]:
	"""Return balanced opener-to-closer positions in one linear pass."""
	open_to_close = {"(": ")", "{": "}", "[": "]"}
	close_to_open = {value: key for key, value in open_to_close.items()}
	stack: list[tuple[str, int]] = []
	pairs: dict[int, int] = {}
	for index, token in enumerate(tokens):
		if token.kind != "symbol":
			continue
		value = str(token.value)
		if value in open_to_close:
			stack.append((value, index))
			continue
		if value not in close_to_open:
			continue
		if not stack or stack[-1][0] != close_to_open[value]:
			stack.clear()
			continue
		_, opener = stack.pop()
		pairs[opener] = index
	return pairs


def call_arguments(
	tokens: tuple[Token, ...],
	open_parenthesis: int,
	delimiter_pairs: Mapping[int, int] | None = None,
) -> tuple[tuple[Token, ...], ...] | None:
	if (
		open_parenthesis >= len(tokens)
		or tokens[open_parenthesis].kind != "symbol"
		or tokens[open_parenthesis].value != "("
	):
		return None
	pairs = delimiter_pairs if delimiter_pairs is not None else matching_delimiters(tokens)
	close_parenthesis = pairs.get(open_parenthesis)
	if close_parenthesis is None:
		return None
	arguments: list[tuple[Token, ...]] = []
	current: list[Token] = []
	index = open_parenthesis + 1
	while index < close_parenthesis:
		token = tokens[index]
		if token.kind == "symbol" and token.value in {"(", "{", "["}:
			nested_close = pairs.get(index)
			if nested_close is None or nested_close > close_parenthesis:
				return None
			# Nested expressions are dynamic to the scalar resolver. Keep only their
			# shape and jump over the body so nested calls do not cause O(n^2) scans.
			current.extend((token, tokens[nested_close]))
			index = nested_close + 1
			continue
		if token.kind == "symbol" and token.value == ",":
			arguments.append(tuple(current))
			current = []
			index += 1
			continue
		current.append(token)
		index += 1
	if current or arguments:
		arguments.append(tuple(current))
	return tuple(arguments)


def find_matching_brace(tokens: tuple[Token, ...], open_brace: int) -> int | None:
	depth = 0
	for index in range(open_brace, len(tokens)):
		value = tokens[index].value if tokens[index].kind == "symbol" else None
		if value == "{":
			depth += 1
		elif value == "}":
			depth -= 1
			if depth == 0:
				return index
	return None
