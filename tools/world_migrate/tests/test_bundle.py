from __future__ import annotations

import json
import shutil
import struct
from pathlib import Path
from unittest.mock import patch

from tools.world_migrate.bundle import apply_bundle, read_json, revert_bundle, validate_bundle, write_new, json_bytes, sha
from tools.world_migrate.convert import generate
from tools.world_migrate.inventory import analyze
from tools.world_migrate.tests.test_world_tool import NativeWorldToolFixture


class MigrationBundleTests(NativeWorldToolFixture):
	def setUp(self):
		super().setUp()
		self.pack = self.root / "data-example"
		self.world = self.pack / "world"
		self.world.mkdir(parents=True)
		(self.root / "data/items").mkdir(parents=True)
		for name in ("items.xml", "appearances.dat"):
			shutil.copyfile(self.root / name, self.root / "data/items" / name)
		shutil.copyfile(self.root / "example.otbm", self.world / "example.otbm")
		self.catalog = self.world / "example.world.json"
		write_new(self.catalog, json_bytes({"schemaVersion": 2, "id": "test", "map": "example.otbm", "items": "../../data/items/items.xml", "layers": []}))
		self.source = self.pack / "startup/tables/item.lua"
		write_new(self.pack / "startup/tables/load.lua", b'dofile(DATA_DIRECTORY .. "/startup/tables/item.lua")\r\n')
		write_new(self.source, b'-- preserved comment\r\nItemAction = {[13107]={itemId=200,itemPos={{x=100,y=100,z=7}}}, [13108]={itemId=300,itemPos={{x=100,y=100,z=7}}}}\r\n')
		self.report = self.root / "analysis.json"
		self.directory = self.root / "bundle"
		self.original_source = self.source.read_bytes()
		self.original_catalog = self.catalog.read_bytes()
		write_new(self.report, json_bytes(analyze(self.root, "data-example", selected_table="ItemAction", entries=["13107"])))

	def generated(self):
		result = generate(self.root, self.report, self.directory, self.exe)
		self.assertEqual(result["pending"], 0)
		self.assertEqual(self.source.read_bytes(), self.original_source)
		self.assertEqual(self.catalog.read_bytes(), self.original_catalog)
		return result

	def test_full_offline_lifecycle_keeps_unselected_lua_and_map_bytes(self):
		result = self.generated()
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		applied = apply_bundle(self.root, self.directory, self.exe, offline=True)
		self.assertFalse(applied["alreadyApplied"])
		self.assertTrue(apply_bundle(self.root, self.directory, self.exe, offline=True)["alreadyApplied"])
		catalog = read_json(self.catalog)
		layer = read_json(self.world / catalog["layers"][0]["file"])
		self.assertEqual(len(layer["objects"]), 1)
		self.assertEqual(layer["objects"][0]["attributes"], {"aid": 13107})
		record_path = self.world / catalog["migrations"][0]
		record = read_json(record_path)
		self.assertEqual(record["claims"][0]["source"]["key"], "13107")
		self.assertEqual(record["claims"][0]["occurrence"], "1.item")
		self.assertFalse(revert_bundle(self.root, record_path, self.exe, offline=True)["alreadyReverted"])
		self.assertEqual(self.catalog.read_bytes(), self.original_catalog)
		self.assertTrue(revert_bundle(self.root, record_path, self.exe, offline=True)["alreadyReverted"])
		self.assertFalse(apply_bundle(self.root, self.directory, self.exe, offline=True)["alreadyApplied"])
		self.assertEqual(self.source.read_bytes(), self.original_source)
		self.assertEqual((self.world / "example.otbm").read_bytes(), self.map)
		self.assertTrue(result["id"].startswith("migration-"))

	def test_changed_source_is_rejected_before_generation_or_publication(self):
		self.generated()
		self.source.write_bytes(self.original_source + b"-- local edit\r\n")
		with self.assertRaisesRegex(ValueError, "Source changed"):
			generate(self.root, self.report, self.root / "new-bundle", self.exe)
		with self.assertRaisesRegex(ValueError, "Source changed"):
			apply_bundle(self.root, self.directory, self.exe, offline=True)
		self.assertEqual(self.catalog.read_bytes(), self.original_catalog)

	def test_first_catalog_is_created_only_on_apply_and_removed_by_revert(self):
		self.catalog.unlink()
		result = generate(self.root, self.report, self.directory, self.exe)
		self.assertEqual(result["pending"], 0)
		self.assertFalse(self.catalog.exists())
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		applied = apply_bundle(self.root, self.directory, self.exe, offline=True)
		self.assertEqual(read_json(self.catalog)["map"], "example.otbm")
		self.assertTrue(apply_bundle(self.root, self.directory, self.exe, offline=True)["alreadyApplied"])
		self.assertTrue(revert_bundle(self.root, self.root / applied["receipt"], self.exe, offline=True)["reverted"])
		self.assertFalse(self.catalog.exists())
		self.assertEqual(self.source.read_bytes(), self.original_source)
		self.assertEqual((self.world / "example.otbm").read_bytes(), self.map)

	def test_first_catalog_requires_an_unambiguous_map_and_supports_explicit_target(self):
		self.catalog.unlink()
		(self.world / "second.otbm").write_bytes(self.map)
		with self.assertRaisesRegex(ValueError, "unambiguous OTBM"):
			generate(self.root, self.report, self.directory, self.exe)
		target = self.world / "catalogs/example.world.json"
		result = generate(self.root, self.report, self.directory, self.exe, project_file=target, map_override=self.world / "example.otbm")
		self.assertEqual(result["pending"], 0)
		self.assertFalse(target.exists())
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])

	def test_catalog_created_concurrently_is_not_adopted_as_an_overwrite_baseline(self):
		from tools.world_migrate.bundle import create_bundle
		self.catalog.unlink()
		def concurrent_catalog(*args, **kwargs):
			self.catalog.write_bytes(self.original_catalog)
			return create_bundle(*args, **kwargs)
		with patch("tools.world_migrate.convert.create_bundle", side_effect=concurrent_catalog):
			with self.assertRaisesRegex(ValueError, "catalog appeared"):
				generate(self.root, self.report, self.directory, self.exe)
		self.assertEqual(self.catalog.read_bytes(), self.original_catalog)

	def test_nested_new_catalog_resolves_migrated_behavior_descriptors(self):
		self.catalog.unlink()
		self.source.write_bytes(b'ChestUnique = {[6000]={itemId=200,itemPos={x=100,y=100,z=7},storage=60001,reward={{400,1}}}}\n')
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		target = self.world / "catalogs/example.world.json"
		result = generate(self.root, self.report, self.directory, self.exe, project_file=target, map_override=self.world / "example.otbm")
		self.assertEqual(result["pending"], 0)
		catalog = read_json(self.directory / "after/data-example/world/catalogs/example.world.json")
		self.assertEqual(catalog["behaviorCatalog"], ["../behaviors/quest_reward.behavior.json"])
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])

	def test_books_and_creation_keep_content_order_and_do_not_create_the_same_root_item_twice(self):
		loader = self.pack / "startup/tables/load.lua"
		loader.write_bytes(loader.read_bytes() + b'dofile(DATA_DIRECTORY .. "/startup/tables/create_item.lua")\ndofile(DATA_DIRECTORY .. "/startup/tables/writeable.lua")\n')
		write_new(self.pack / "startup/tables/create_item.lua", b'CreateItemOnMap = {[400]={itemPos={{x=100,y=100,z=7}}}}\n')
		write_new(self.pack / "startup/tables/writeable.lua", 'BookDocumentTable = {{itemId=400,containerId=300,position={x=100,y=100,z=7},text="Primeiro livro"},{itemId=400,containerId=300,position={x=100,y=100,z=7},text="Segundo livro"},{itemId=400,position={x=100,y=100,z=7},text="Livro recolhível"}}\nSignTable = {}\n'.encode('utf-8'))
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		self.generated()
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		data = read_json(self.directory / "bundle.json")
		catalog = read_json(self.directory / "after" / data["catalog"])
		objects = [obj for layer in catalog["layers"] for obj in read_json(self.directory / "after/data-example/world" / layer["file"])["objects"]]
		books = [obj for obj in objects if obj.get("lifecycle") == "refillOnStartup"]
		self.assertEqual(len(books), 3)
		self.assertEqual([obj["attributes"]["text"] for obj in books], ["Primeiro livro", "Segundo livro", "Livro recolhível"])
		self.assertEqual([obj["source"]["placement"].get("order") for obj in books], [0, 0, None])

	def test_json_edited_after_migration_is_never_overwritten_by_apply_or_revert(self):
		self.generated()
		applied = apply_bundle(self.root, self.directory, self.exe, offline=True)
		catalog = read_json(self.catalog)
		layer_path = self.world / catalog["layers"][0]["file"]
		edited = layer_path.read_bytes() + b"\n"
		layer_path.write_bytes(edited)
		with self.assertRaisesRegex(ValueError, "conflicts"):
			apply_bundle(self.root, self.directory, self.exe, offline=True)
		with self.assertRaisesRegex(ValueError, "conflicts"):
			revert_bundle(self.root, self.root / applied["receipt"], self.exe, offline=True)
		self.assertEqual(layer_path.read_bytes(), edited)

	def test_pending_consumer_blocks_apply_even_when_json_is_valid(self):
		write_new(self.pack / "scripts/custom.lua", b"local alias = ItemAction\nreturn alias[13107]\n")
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example", selected_table="ItemAction", entries=["13107"])))
		self.generated()
		with self.assertRaisesRegex(ValueError, "unresolved Lua consumers"):
			apply_bundle(self.root, self.directory, self.exe, offline=True)
		self.assertEqual(self.catalog.read_bytes(), self.original_catalog)

	def test_reward_adapter_migrates_consumer_text_and_patches_only_a_recognized_revision(self):
		root = Path(__file__).resolve().parents[3]
		consumer = "scripts/actions/system/quest_reward_common.lua"
		contract = read_json(root / "tools/world_migrate/consumer_adapters.json")["files"][consumer]
		after = (root / "data-otservbr-global" / consumer).read_text(encoding="utf-8")
		lines = after.splitlines()
		delta, patches = 0, []
		for patch in contract["patches"]:
			patches.append((patch["startLine"] + delta, patch))
			delta += len(patch["after"]) - len(patch["before"])
		for start, patch in reversed(patches):
			lines[start:start + len(patch["after"])] = patch["before"]
		before = "\n".join(lines) + "\n"
		self.assertEqual(sha(before.encode("utf-8")), contract["beforeSha256"])
		write_new(self.pack / consumer, before.replace("\n", "\r\n").encode("utf-8"))
		self.source.write_bytes(b'ChestUnique = {[6013]={itemId=200,itemPos={x=100,y=100,z=7},storage=60001,randomReward={{400,2}},reward={{nil,nil}}}}\r\n')
		self.original_source = self.source.read_bytes()
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		self.generated()
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		self.assertEqual((self.directory / "after/data-example" / consumer).read_text(encoding="utf-8"), after)
		layer = read_json(self.directory / "after/data-example/world/systems/item.layer.json")
		params = layer["objects"][0]["behaviors"][0]["parameters"]
		self.assertEqual(params["reward"], [])
		self.assertEqual(params["randomReward"], [{"itemId": 400, "count": 2}])
		self.assertIn("Hardek *", params["rewardText"])

	def test_a_custom_loader_at_a_known_filename_is_not_silently_accepted(self):
		write_new(self.pack / "startup/others/functions.lua", b"local function loader() return ItemAction[13107] end\n")
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		self.generated()
		with self.assertRaisesRegex(ValueError, "unresolved Lua consumers"):
			validate_bundle(self.root, self.directory, self.exe)

	def reward_with_base_uid(self):
		# The existing UID consumer is a book inside a container, not itemPos.
		self.map = self.map.replace(struct.pack("<H", 45000), struct.pack("<H", 5000))
		(self.world / "example.otbm").write_bytes(self.map)
		self.source.write_bytes(b'ChestUnique = {[5000]={itemId=200,itemPos={x=100,y=100,z=7},storage=60001,reward={{400,1}}}}\n')
		consumer = "scripts/actions/system/quest_reward_common.lua"
		root = Path(__file__).resolve().parents[3]
		write_new(self.pack / consumer, (root / "data-otservbr-global" / consumer).read_bytes())
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		entry = read_json(self.report)["declarations"][0]
		return {key: entry[key] for key in ("file", "table", "key", "occurrence", "fingerprint")}

	def test_uid_collision_requires_review_and_preserves_implicit_nested_reward_consumer(self):
		identity = self.reward_with_base_uid()
		generate(self.root, self.report, self.root / "unresolved", self.exe)
		with self.assertRaisesRegex(ValueError, "UID"):
			validate_bundle(self.root, self.root / "unresolved", self.exe)
		resolution = self.root / "decisions.json"
		write_new(resolution, json_bytes({"schemaVersion": 1, "datapack": "data-example", "mapSha256": sha(self.map), "decisions": [dict(identity, action="world-identity", reason="Keep the original UID and use instance dispatch on the configured item.")], "conflicts": []}))
		result = generate(self.root, self.report, self.directory, self.exe, resolutions_file=resolution)
		self.assertEqual(result["pending"], 0)
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		objects = read_json(self.directory / "after/data-example/world/systems/item.layer.json")["objects"]
		main, parent, child = objects
		self.assertEqual(main["attributes"], {"uid": 0})
		self.assertEqual(parent["source"]["selector"]["itemId"], 300)
		self.assertEqual(child["source"]["selector"], {"container": parent["id"], "itemId": 400})
		self.assertNotIn("attributes", child)
		self.assertEqual(main["behaviors"], child["behaviors"])
		self.assertEqual(child["behaviors"][0]["parameters"]["emptyItemId"], 200)
		self.assertEqual((self.world / "example.otbm").read_bytes(), self.map)

	def test_overwritten_uid_does_not_activate_the_earlier_reward_on_that_item(self):
		first = self.reward_with_base_uid()
		self.source.write_bytes(self.source.read_bytes() + b'CorpseUnique = {[6000]={itemId=200,itemPos={x=100,y=100,z=7}}}\n')
		self.report.write_bytes(json_bytes(analyze(self.root, "data-example")))
		entries = read_json(self.report)["declarations"]
		second = {key: entries[1][key] for key in first}
		resolution = self.root / "decisions.json"
		write_new(resolution, json_bytes({"schemaVersion": 1, "datapack": "data-example", "mapSha256": sha(self.map), "decisions": [], "conflicts": [{"attribute": "uid", "sources": [first, second], "winner": second["fingerprint"], "reason": "The corpse loader runs after the chest loader."}]}))
		result = generate(self.root, self.report, self.directory, self.exe, resolutions_file=resolution)
		self.assertEqual(result["pending"], 0)
		self.assertTrue(validate_bundle(self.root, self.directory, self.exe)["valid"])
		objects = read_json(self.directory / "after/data-example/world/systems/item.layer.json")["objects"]
		self.assertEqual(objects[0]["attributes"], {"uid": 6000})
		self.assertNotIn("behaviors", objects[0])
		self.assertEqual(objects[-1]["behaviors"][0]["id"], "quest.reward")

	def test_bundle_snapshot_edits_and_missing_offline_confirmation_are_rejected(self):
		self.generated()
		with self.assertRaisesRegex(ValueError, "confirm-offline"):
			apply_bundle(self.root, self.directory, self.exe, offline=False)
		metadata = read_json(self.directory / "bundle.json")
		path = self.directory / metadata["files"][0]["after"]
		path.write_bytes(path.read_bytes() + b" ")
		with self.assertRaisesRegex(ValueError, "snapshot was changed"):
			validate_bundle(self.root, self.directory, self.exe)
