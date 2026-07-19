from __future__ import annotations

import unittest

from tools.canary_audit.lua_lexer import (
	LuaLexError,
	call_arguments,
	collect_simple_constants,
	matching_delimiters,
	tokenize,
)


class LuaLexerTests(unittest.TestCase):
	def test_comments_do_not_emit_code_tokens(self) -> None:
		tokens = tokenize(
			"""
-- local FAKE = 100
--[=[
Game.createMonster("Comment Beast", position)
local ALSO_FAKE = 200
]=]
local REAL_ID = 300
"""
		)
		values = [token.value for token in tokens]

		self.assertNotIn("FAKE", values)
		self.assertNotIn("ALSO_FAKE", values)
		self.assertNotIn("Comment Beast", values)
		self.assertIn("REAL_ID", values)
		self.assertEqual(collect_simple_constants(tokens), {"REAL_ID": 300})

	def test_long_string_is_one_string_token_not_executable_code(self) -> None:
		tokens = tokenize(
			"local text = [==[Game.createMonster('Not Executed', position)]==]\nlocal ID = 17"
		)
		string_tokens = [token for token in tokens if token.kind == "string"]

		self.assertEqual(len(string_tokens), 1)
		self.assertIn("Game.createMonster", string_tokens[0].value)
		self.assertEqual(collect_simple_constants(tokens)["ID"], 17)

	def test_z_escape_removes_following_whitespace_and_tracks_lines(self) -> None:
		tokens = tokenize('local NAME = "Canary\\z\n\t  Keeper"\nlocal NEXT = 22')
		constants = collect_simple_constants(tokens)
		next_token = next(token for token in tokens if token.value == "NEXT")

		self.assertEqual(constants["NAME"], "CanaryKeeper")
		self.assertEqual(constants["NEXT"], 22)
		self.assertEqual(next_token.line, 3)

	def test_crlf_continuation_and_leading_zero_integer_are_supported(self) -> None:
		tokens = tokenize('local NAME = "Canary\\\r\nKeeper"\r\nlocal ID = 0017')

		self.assertEqual(collect_simple_constants(tokens), {"NAME": "CanaryKeeper", "ID": 17})

	def test_numeric_hexadecimal_and_unicode_string_escapes_are_decoded(self) -> None:
		tokens = tokenize(r'local NAME = "\x43\u{61}\110ary"')

		self.assertEqual(collect_simple_constants(tokens), {"NAME": "Canary"})

	def test_unsupported_string_escape_is_not_silently_fabricated(self) -> None:
		with self.assertRaisesRegex(LuaLexError, "unsupported string escape"):
			tokenize(r'local NAME = "wrong\qname"')

	def test_token_limit_fails_during_lexing(self) -> None:
		with self.assertRaisesRegex(LuaLexError, "token count exceeds"):
			tokenize("one two three", max_tokens=2)

	def test_simple_constants_include_local_aliases_and_uppercase_globals(self) -> None:
		tokens = tokenize(
			"""
local npcName = "Canary"
ITEM_ID = 0x10
mutableName = "ignored"
local derived = npcName
"""
		)

		self.assertEqual(
			collect_simple_constants(tokens),
			{"npcName": "Canary", "ITEM_ID": 16},
		)

	def test_call_arguments_preserve_nested_tables_and_calls(self) -> None:
		tokens = tokenize("fn(1, nested(2, 3), { value = 4, list = { 5, 6 } })")
		open_parenthesis = next(index for index, token in enumerate(tokens) if token.value == "(")
		arguments = call_arguments(tokens, open_parenthesis)

		self.assertIsNotNone(arguments)
		self.assertEqual(len(arguments or ()), 3)
		self.assertEqual((arguments or ())[0][0].value, 1)

	def test_nested_call_argument_work_stays_linear(self) -> None:
		depth = 2000
		tokens = tokenize(("ItemType(" * depth) + "1" + (")" * depth))
		pairs = matching_delimiters(tokens)
		openers = [index for index, token in enumerate(tokens) if token.kind == "symbol" and token.value == "("]

		arguments = [call_arguments(tokens, opener, pairs) for opener in openers]
		materialized_tokens = sum(
			len(argument)
			for call in arguments
			for argument in (call or ())
		)

		self.assertEqual(len(arguments), depth)
		self.assertLessEqual(materialized_tokens, depth * 3)

	def test_unterminated_long_comment_reports_its_origin(self) -> None:
		with self.assertRaises(LuaLexError) as raised:
			tokenize("\n--[=[ never closed")

		self.assertEqual(raised.exception.line, 2)
		self.assertGreaterEqual(raised.exception.column, 3)


if __name__ == "__main__":
	unittest.main()
