from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools.world_migrate.bundle import json_bytes, sha
from tools.world_migrate.inventory import analyze
from tools.world_migrate.resolutions import Resolutions


class ResolutionTests(unittest.TestCase):
	def setUp(self):
		self.temp = tempfile.TemporaryDirectory()
		self.addCleanup(self.temp.cleanup)
		self.root = Path(self.temp.name)
		self.pack = self.root / "data-example"
		tables = self.pack / "startup/tables"
		tables.mkdir(parents=True)
		(tables / "load.lua").write_text('dofile(DATA_DIRECTORY .. "/startup/tables/item.lua")\n', encoding="utf-8")
		self.source = tables / "item.lua"
		self.content = b'ItemAction = {\n [100] = {itemId=200,itemPos={{x=100,y=100,z=7}}},\n [101] = {itemId=200,itemPos={{x=100,y=100,z=7}}}\n}\n'
		self.source.write_bytes(self.content)
		self.report = analyze(self.root, "data-example")

	def test_declaration_identity_is_portable_but_source_guard_keeps_exact_bytes(self):
		self.source.write_bytes(self.content.replace(b"\n", b"\r\n"))
		windows = analyze(self.root, "data-example")
		self.assertEqual([e["fingerprint"] for e in self.report["declarations"]], [e["fingerprint"] for e in windows["declarations"]])
		self.assertNotEqual(self.report["sources"], windows["sources"])

	def test_no_implicit_conflict_winner_or_cross_map_decision(self):
		resolutions = Resolutions(self.root, self.report, "map", {})
		with self.assertRaisesRegex(ValueError, "explicit characterization"):
			resolutions.replace(*self.report["declarations"], "aid")
		file = self.root / "resolutions.json"
		file.write_bytes(json_bytes({"schemaVersion": 1, "datapack": "data-example", "mapSha256": "another", "decisions": [], "conflicts": []}))
		with self.assertRaisesRegex(ValueError, "different OTBM"):
			Resolutions(self.root, self.report, "map", {}, file)

	def test_changed_characterized_consumer_is_rejected(self):
		entry = self.report["declarations"][0]
		decision = {key: entry[key] for key in ("file", "table", "key", "occurrence", "fingerprint")}
		decision.update(action="convert", reason="Characterized fixture", dependencies=[{"file": self.source.relative_to(self.root).as_posix(), "sha256": sha(self.content)}])
		file = self.root / "resolutions.json"
		file.write_bytes(json_bytes({"schemaVersion": 1, "datapack": "data-example", "mapSha256": "map", "decisions": [decision], "conflicts": []}))
		sources = {}
		Resolutions(self.root, self.report, "map", sources, file)
		self.assertIn(self.source.relative_to(self.root).as_posix(), sources)
		self.source.write_bytes(self.content + b"-- customized\n")
		with self.assertRaisesRegex(ValueError, "consumer changed"):
			Resolutions(self.root, self.report, "map", {}, file)
