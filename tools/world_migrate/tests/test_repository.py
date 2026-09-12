"""Keep complete migration coverage without freezing authored JSON values."""

from pathlib import Path
import unittest

from tools.world_migrate.bundle import read_json, sha
from tools.world_migrate.gameplay import adapt_consumers
from tools.world_migrate.inventory import analyze
from tools.world_migrate.resolutions import identity


class RepositoryMigrationTests(unittest.TestCase):
	@classmethod
	def setUpClass(cls):
		cls.root = Path(__file__).resolve().parents[3]
		cls.coverage = read_json(Path(__file__).parent / "fixtures/global-coverage.json")
		cls.report = analyze(cls.root, cls.coverage["datapack"])
		cls.world = cls.root / cls.coverage["datapack"] / "world"
		cls.catalog = read_json(cls.world / "otservbr.world.json")
		cls.record = read_json(cls.world / "migrations" / (cls.coverage["migration"] + ".json"))

	def test_every_legacy_declaration_has_an_explicit_destination(self):
		self.assertFalse(self.report["issues"])
		self.assertEqual({identity(e) for e in self.report["declarations"]}, {identity(e) for e in self.coverage["declarations"]})
		claims = {(c["source"]["table"], c["source"]["key"], c["source"]["declaration"], c["source"]["fingerprint"]) for c in self.record["claims"]}
		for entry in self.coverage["declarations"]:
			with self.subTest(table=entry["table"], key=entry["key"], occurrence=entry["occurrence"]):
				self.assertIn(entry["status"], {"converted", "already-world", "inactive", "runtime-state"})
				if entry["status"] in {"converted", "already-world"}:
					self.assertIn((entry["table"], entry["key"], entry["occurrence"], entry["fingerprint"]), claims)
				else:
					self.assertTrue(entry["reason"])

	def test_frozen_compatibility_sources_match_ownership_records(self):
		for source in self.record["sources"]:
			file = self.world / "migrations" / source["file"]
			self.assertEqual(sha(file.read_text(encoding="utf-8").encode("utf-8")), source["sha256"], source["file"])

	def test_world_consumers_are_adapted_and_every_claim_resolves(self):
		tables = {e["table"] for e in self.report["declarations"]}
		consumers, patches = adapt_consumers(self.root, self.root / self.coverage["datapack"], self.report["consumers"], tables)
		self.assertFalse(patches, "Repository consumers must already contain their adapters")
		self.assertTrue(all(c["status"] in {"adapted", "preserved"} for c in consumers))
		objects = {o["id"]: o for layer in self.catalog["layers"] for o in read_json(self.world / layer["file"])["objects"]}
		for claim in self.record["claims"]:
			self.assertIn(claim["object"], objects)
		implicit = [c for c in self.record["claims"] if c["occurrence"] == "uid-consumer"]
		self.assertEqual(len(implicit), sum(e["implicitConsumers"] for e in self.coverage["declarations"]))
		for claim in implicit:
			self.assertTrue(objects[claim["object"]]["behaviors"])
