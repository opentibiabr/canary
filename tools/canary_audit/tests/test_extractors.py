from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools.canary_audit.extractors import extract_appearances, extract_lua, extract_xml

from .helpers import appearances_payload, discovered_file, encode_varint, repository_config


class LuaExtractorTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_comments_constants_and_registered_type_definition(self) -> None:
		source = r'''
-- local fakeType = Game.createMonsterType("Comment Beast")
-- fakeType:register({})
local monsterName = "Canary\z
	 Keeper"
local monsterType = Game.createMonsterType(monsterName)
monsterType:register({})
Game.createMonster("CanaryKeeper", position)
local unregistered = Game.createMonsterType("Not Registered")
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data-canary/monster/test.lua", source)
			result = extract_lua(path, self.config)

		definitions = [fact for fact in result.facts if fact.role == "definition"]
		references = [fact for fact in result.facts if fact.role == "reference"]

		self.assertFalse(result.diagnostics)
		self.assertEqual([(fact.domain, fact.value) for fact in definitions], [("monster.name", "CanaryKeeper")])
		self.assertIn(("monster.name", "CanaryKeeper"), [(fact.domain, fact.value) for fact in references])
		self.assertNotIn("Comment Beast", [fact.value for fact in result.facts])
		self.assertNotIn("Not Registered", [fact.value for fact in result.facts])

	def test_action_item_selector_is_distinct_from_action_and_spell_ids(self) -> None:
		source = '''
local action = Action()
action:id(2160)
action:aid(5000)
action:uid(6000)
action:register()

local spell = Spell("instant")
spell:id(5000)
spell:register()
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/actions/test.lua", source)
			result = extract_lua(path, self.config)

		facts = {(fact.domain, fact.role, fact.value, fact.owner) for fact in result.facts}
		self.assertIn(("item.server_id", "reference", 2160, "Action.id"), facts)
		self.assertIn(("action.item_id", "registration", 2160, "Action.id"), facts)
		self.assertIn(("action.action_id", "registration", 5000, "Action.aid"), facts)
		self.assertIn(("action.unique_id", "registration", 6000, "Action.uid"), facts)
		self.assertIn(("spell.id", "registration", 5000, "Spell.id"), facts)
		self.assertNotIn(("action.action_id", "registration", 5000, "Spell.id"), facts)

	def test_dynamic_call_is_unresolved_instead_of_fabricated(self) -> None:
		source = '''
local action = Action()
action:id(config.itemId)
action:register()
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/actions/dynamic.lua", source)
			result = extract_lua(path, self.config)

		unresolved = [fact for fact in result.facts if fact.role == "unresolved"]
		self.assertEqual({fact.domain for fact in unresolved}, {"item.server_id", "action.item_id"})
		self.assertTrue(all(fact.confidence == "dynamic" for fact in unresolved))

	def test_dynamic_reassignment_invalidates_literal_alias(self) -> None:
		source = "local ITEM_ID = 100\nITEM_ID = getId()\nGame.createItem(ITEM_ID)"
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/dynamic_alias.lua", source)
			result = extract_lua(path, self.config)

		item_facts = [fact for fact in result.facts if fact.domain == "item.server_id"]
		self.assertEqual([(fact.role, fact.value) for fact in item_facts], [("unresolved", "ITEM_ID")])

	def test_aliases_are_not_resolved_across_function_scopes_or_shadowing(self) -> None:
		source = '''function first()
	print("end")
	local ITEM_ID = 100
	Game.createItem(ITEM_ID)
end
function second()
	local ITEM_ID = 200
	Game.createItem(ITEM_ID)
end
Game.createItem(ITEM_ID)
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/scoped_alias.lua", source)
			result = extract_lua(path, self.config)

		item_facts = [fact for fact in result.facts if fact.domain == "item.server_id"]
		self.assertEqual(len(item_facts), 3)
		self.assertTrue(all(fact.role == "unresolved" for fact in item_facts))

	def test_comparison_does_not_invalidate_action_object(self) -> None:
		source = '''local action = Action()
if action == nil then return end
action:id(2160)
action:register()
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/actions/comparison.lua", source)
			result = extract_lua(path, self.config)

		self.assertIn(
			("item.server_id", "reference", 2160),
			{(fact.domain, fact.role, fact.value) for fact in result.facts},
		)

	def test_reused_constructor_variable_is_not_misclassified(self) -> None:
		source = '''local event = Action()
event:id(2160)
event = MoveEvent()
event:id(3000)
event:register()
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/scripts/actions/reused.lua", source)
			result = extract_lua(path, self.config)

		self.assertFalse([fact for fact in result.facts if fact.extractor == "lua.selector"])

	def test_string_item_overload_uses_item_name_domain(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(
				Path(temporary),
				"data/scripts/item_name.lua",
				'Game.createItem("gold coin")',
			)
			result = extract_lua(path, self.config)

		self.assertEqual(
			[(fact.domain, fact.role, fact.value) for fact in result.facts],
			[("item.name", "reference", "gold coin")],
		)


class XmlAndProtobufExtractorTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_minimal_appearances_protobuf_defines_ids_and_fluid_range(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(
				Path(temporary),
				"data/items/appearances.dat",
				appearances_payload(100, 321, 65535),
			)
			result = extract_appearances(path, self.config)

		self.assertFalse(result.diagnostics)
		self.assertIn((0, 99), [(fact.value, fact.end_value) for fact in result.facts])
		self.assertEqual(
			{fact.value for fact in result.facts if fact.end_value is None},
			{100, 321, 65535},
		)
		self.assertTrue(all(fact.role == "definition" for fact in result.facts))

	def test_truncated_appearances_protobuf_is_an_explicit_diagnostic(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/items/appearances.dat", b"\x0a\x05\x08")
			result = extract_appearances(path, self.config)

		self.assertEqual([item.code for item in result.diagnostics], ["scan.protobuf-error"])

	def test_appearance_requires_flags_and_uint16_id(self) -> None:
		messages = (
			b"\x08" + encode_varint(100),
			b"\x1a\x00",
			b"\x08" + encode_varint(65536) + b"\x1a\x00",
		)
		payload = b"".join(b"\x0a" + encode_varint(len(message)) + message for message in messages)
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/items/appearances.dat", payload)
			result = extract_appearances(path, self.config)

		self.assertEqual(
			{diagnostic.code for diagnostic in result.diagnostics},
			{
				"protobuf.item-missing-flags",
				"protobuf.item-missing-id",
				"protobuf.item-id-out-of-range",
			},
		)
		self.assertEqual([(fact.value, fact.end_value) for fact in result.facts], [(0, 99)])

	def test_appearance_parser_validates_fields_after_id(self) -> None:
		message = b"\x08" + encode_varint(321) + b"\x1a\x00\x22\x05x"
		payload = b"\x0a" + encode_varint(len(message)) + message
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/items/appearances.dat", payload)
			result = extract_appearances(path, self.config)

		self.assertEqual([diagnostic.code for diagnostic in result.diagnostics], ["scan.protobuf-error"])
		self.assertEqual([(fact.value, fact.end_value) for fact in result.facts], [(0, 99)])

	def test_item_xml_ranges_are_references_not_authoritative_definitions(self) -> None:
		xml = '''<?xml version="1.0"?>
<items>
	<item id="321" name="one" />
	<item fromid="400" toid="402" name="range" />
</items>
'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/items/items.xml", xml)
			result = extract_xml(path, self.config)

		self.assertFalse(result.diagnostics)
		self.assertEqual(
			[(fact.role, fact.value, fact.end_value) for fact in result.facts],
			[("reference", 321, None), ("reference", 400, 402)],
		)

	def test_invalid_item_xml_range_is_reported(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(
				Path(temporary),
				"data/items/items.xml",
				'<items><item fromid="402" toid="400" /></items>',
			)
			result = extract_xml(path, self.config)

		self.assertEqual([item.code for item in result.diagnostics], ["xml.invalid-item-range"])
		self.assertFalse(result.facts)

	def test_world_xml_names_are_references_not_definitions(self) -> None:
		xml = '''<spawns>
	<monster name="Dragon" />
	<singlespawn name="Demon" />
	<npc name="Canary" />
</spawns>'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data-canary/world/spawns.xml", xml)
			result = extract_xml(path, self.config)

		self.assertEqual(
			{(fact.domain, fact.role, fact.value) for fact in result.facts},
			{
				("monster.name", "reference", "Dragon"),
				("monster.name", "reference", "Demon"),
				("npc.name", "reference", "Canary"),
			},
		)

	def test_storage_xml_range_overlap_and_out_of_range_are_reported(self) -> None:
		xml = '''<storages>
	<range start="100" end="110"><storage name="valid" key="1" /></range>
	<range start="105" end="120"><storage name="invalid" key="20" /></range>
</storages>'''
		with tempfile.TemporaryDirectory() as temporary:
			path = discovered_file(Path(temporary), "data/XML/storages.xml", xml)
			result = extract_xml(path, self.config)

		self.assertEqual(
			{item.code for item in result.diagnostics},
			{"xml.overlapping-storage-range", "xml.invalid-storage"},
		)
		self.assertEqual([(fact.value, fact.symbol) for fact in result.facts], [(101, "valid")])


if __name__ == "__main__":
	unittest.main()
