from __future__ import annotations

import json
import shutil
from pathlib import Path

from tools.world_migrate.bundle import apply_bundle, read_json, revert_bundle, validate_bundle, write_new, json_bytes
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

	def test_bundle_snapshot_edits_and_missing_offline_confirmation_are_rejected(self):
		self.generated()
		with self.assertRaisesRegex(ValueError, "confirm-offline"):
			apply_bundle(self.root, self.directory, self.exe, offline=False)
		metadata = read_json(self.directory / "bundle.json")
		path = self.directory / metadata["files"][0]["after"]
		path.write_bytes(path.read_bytes() + b" ")
		with self.assertRaisesRegex(ValueError, "snapshot was changed"):
			validate_bundle(self.root, self.directory, self.exe)
