from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools.world_migrate.dispatch import resolve_action_dispatch, resolve_move_sequence, scan_file


class DispatchAnalysisTests(unittest.TestCase):
	def test_position_action_hides_other_registered_numeric_handlers(self) -> None:
		position = {"kind": "Action", "event": "onUse", "installed": True, "file": "position.lua", "selectors": {"position": [{"x": 10, "y": 20, "z": 7}], "uid": [], "aid": [], "itemId": []}}
		aid = {"kind": "Action", "event": "onUse", "installed": True, "file": "aid.lua", "selectors": {"position": [], "uid": [], "aid": [4000], "itemId": []}}
		resolved = resolve_action_dispatch([aid, position], {"position": {"x": 10, "y": 20, "z": 7}, "aid": 4000, "uid": 0, "itemId": 1949})
		self.assertEqual(resolved["source"], "position")
		self.assertEqual(resolved["executed"][0]["file"], "position.lua")

	def test_world_ownership_is_per_instance_with_shared_aid(self) -> None:
		legacy = {"kind": "Action", "event": "onUse", "installed": True, "file": "shared.lua", "selectors": {"position": [], "uid": [], "aid": [4000], "itemId": []}}
		migrated = resolve_action_dispatch([legacy], {"position": {}, "aid": 4000, "uid": 0, "itemId": 1}, world="world.object.one")
		remaining = resolve_action_dispatch([legacy], {"position": {}, "aid": 4000, "uid": 0, "itemId": 1})
		self.assertEqual(migrated["executed"], ["world.object.one"])
		self.assertEqual(remaining["executed"][0]["file"], "shared.lua")

	def test_shared_mutable_callback_state_blocks_automatic_extraction(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			file = root / "shared.lua"
			file.write_text("""
local state = 0
local event = MoveEvent()
function event.onEquip(player, item, slot, isCheck)
    state = state + 1
    return true
end
function event.onDeEquip(player, item, slot)
    return state > 0
end
event:type("equip")
event:aid(5000)
event:register()
""", encoding="utf-8")
			registrations, _ = scan_file(file, root)
			self.assertEqual(len(registrations), 1)
			self.assertEqual(registrations[0]["equivalence"], "pending")
			self.assertIn("state", registrations[0]["dependencies"]["mutableCapturedLocals"])

	def test_same_file_duplicate_is_rejected_and_registration_tries_the_next_category(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			file = root / "ordered.lua"
			file.write_text("""
local first = Action()
function first.onUse() return true end
first:id(100)
first:register()

local second = Action()
function second.onUse() return true end
second:id(100)
second:aid(5000)
second:register()
""", encoding="utf-8")
			registrations, issues = scan_file(file, root)
			self.assertFalse(issues)
			self.assertEqual(registrations[0]["registrationCategory"], "itemId")
			self.assertEqual(registrations[1]["rejectedSelectors"]["itemId"], [100])
			self.assertEqual(registrations[1]["registrationCategory"], "aid")
			self.assertEqual(registrations[1]["installedSelectors"]["aid"], [5000])

	def test_move_sequence_keeps_tile_then_item_order_and_stop_semantics(self) -> None:
		position = {"kind": "MoveEvent", "event": "onStepIn", "installed": True, "file": "tile.lua", "selectors": {"position": [{"x": 1, "y": 2, "z": 3}], "uid": [], "aid": [], "itemId": []}}
		uid = {"kind": "MoveEvent", "event": "onStepIn", "installed": True, "file": "uid.lua", "selectors": {"position": [], "uid": [9000], "aid": [], "itemId": []}}
		aid = {"kind": "MoveEvent", "event": "onStepIn", "installed": True, "file": "aid.lua", "selectors": {"position": [], "uid": [], "aid": [200], "itemId": []}}
		resolved = resolve_move_sequence([aid, uid, position], {"position": {"x": 1, "y": 2, "z": 3}, "items": [{"uid": 9000, "aid": 200, "itemId": 1}, {"uid": 0, "aid": 200, "itemId": 2}]}, "onStepIn")
		self.assertEqual([entry["file"] for entry in resolved["executedInOrder"]], ["tile.lua", "uid.lua", "aid.lua"])
		self.assertTrue(resolved["stopsOnZero"])


if __name__ == "__main__":
	unittest.main()
