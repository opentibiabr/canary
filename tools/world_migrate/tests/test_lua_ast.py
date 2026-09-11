from __future__ import annotations

import unittest

from tools.world_migrate.lua_ast import Reader, Unresolved, evaluate


class LuaConfigurationTests(unittest.TestCase):
	def value(self, source, constants=None):
		return evaluate(Reader("Config = " + source).assignments()[0].value, constants)

	def test_duplicate_keys_remain_visible_before_evaluation(self):
		assignment = Reader("Config = { [12107] = {itemId=2772}, [12107] = {itemId=1662} }").assignments()[0]
		self.assertEqual(len(assignment.value.value), 2)
		with self.assertRaisesRegex(Unresolved, "duplicate table key"):
			evaluate(assignment.value)

	def test_literals_preserve_lua_string_and_number_values(self):
		self.assertEqual(self.value('{text=[=[\nfirst\r\nsecond]=], count=0017, hex=0x1f, number=-4.25e1, yes=true, no=false}'), {"text": "first\nsecond", "count": 17, "hex": 31, "number": -42.5, "yes": True, "no": False})
		self.assertEqual(self.value('"before\\\r\nafter"'), "before\nafter")

	def test_nested_tables_and_proven_constants(self):
		self.assertEqual(self.value('{position=Position(100, 101, 7), reward={{10,2}}, storage=Storage.Test}', {"Storage.Test": 120}), {"position": {"x": 100, "y": 101, "z": 7}, "reward": {1: {1: 10, 2: 2}}, "storage": 120})

	def test_dynamic_values_and_missing_constants_are_not_executed_or_guessed(self):
		for source in ('{value=os.execute("write")}', '{value=1 + 2}', '{value=UNKNOWN}', '{value=1e999}'):
			with self.subTest(source=source), self.assertRaises(Unresolved):
				self.value(source)

	def test_source_range_preserves_surrounding_comments(self):
		source = '-- introduction\nConfig = {\n -- keep this\n [0x20] = {text="olá"}, -- trailing\n}\n'
		field = Reader(source).assignments()[0].value.value[0]
		self.assertEqual(source[field.span.start:field.span.end], '[0x20] = {text="olá"}')

	def test_empty_tables_and_multiple_assignments_are_visible(self):
		assignments = Reader('One = {}\nTwo = { key = 17 }\n').assignments()
		self.assertEqual([assignment.name for assignment in assignments], ["One", "Two"])
		self.assertEqual(evaluate(assignments[0].value), {})

	def test_function_assignments_are_not_treated_as_top_level_config(self):
		assignments = Reader('function build()\n Config = {value=1}\nend\nReal = {}').assignments()
		self.assertEqual([assignment.name for assignment in assignments], ["Real"])


if __name__ == "__main__":
	unittest.main()
