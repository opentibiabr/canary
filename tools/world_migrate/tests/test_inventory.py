from __future__ import annotations

import io
import tempfile
import unittest
from contextlib import chdir, redirect_stderr, redirect_stdout
from pathlib import Path

from tools.world_migrate.cli import _workspace_path, main
from tools.world_migrate.inventory import analyze, loader_files, within


class MigrationInventoryTests(unittest.TestCase):
	def setUp(self):
		self.temp = tempfile.TemporaryDirectory()
		self.addCleanup(self.temp.cleanup)
		self.root = Path(self.temp.name)
		self.pack = self.root / "data-example"
		self.write("startup/tables/load.lua", 'dofile(DATA_DIRECTORY .. "/startup/tables/item.lua")\ndofile(DATA_DIRECTORY .. "/startup/tables/empty.lua")')
		self.write("startup/tables/item.lua", 'ItemAction = {[17]={itemId=2,itemPos={{x=100,y=101,z=7}}}, [17]={itemId=3,itemPos={{x=100,y=102,z=7}}}}\nItemUnique = {[18]={itemId=2,itemPos={x=101,y=101,z=7}}}')
		self.write("startup/tables/empty.lua", "DailyRewardAction = {}")
		self.write("scripts/test.lua", 'local settings = ItemAction\nlocal function use() return settings[17] end')

	def write(self, name, text):
		path = self.pack / name
		path.parent.mkdir(parents=True, exist_ok=True)
		path.write_text(text, encoding="utf-8")

	def snapshot(self):
		return {p.relative_to(self.root).as_posix(): p.read_bytes() for p in self.root.rglob("*") if p.is_file()}

	def test_analysis_covers_empty_tables_duplicates_and_aliases_without_writes(self):
		before = self.snapshot()
		report = analyze(self.root, "data-example")
		self.assertEqual(before, self.snapshot())
		self.assertEqual(report["summary"]["tables"], 3)
		self.assertEqual(report["tables"][-1]["entries"], 0)
		self.assertEqual([e["classification"] for e in report["declarations"][:2]], ["needs-analysis"] * 2)
		self.assertEqual(report["consumers"][0]["aliases"], [{"name": "settings", "line": 1}])
		self.assertEqual(report["consumers"][0]["classification"], "needs-analysis")

	def test_selection_keeps_full_inventory_and_leaves_other_declarations_unselected(self):
		report = analyze(self.root, "data-example", selected_table="ItemUnique", entries=["18"])
		self.assertEqual(report["summary"]["selected"], 1)
		self.assertEqual(report["summary"]["declarations"], 3)
		self.assertFalse(report["declarations"][0]["selected"])

	def test_unmatched_selection_is_an_error(self):
		with self.assertRaisesRegex(ValueError, "did not match"):
			analyze(self.root, "data-example", entries=["999"])

	def test_dynamic_loader_is_reported_without_evaluating_it(self):
		self.write("startup/tables/load.lua", "dofile(getPath())")
		files, issues = loader_files(self.pack)
		self.assertEqual(files, [])
		self.assertEqual(len(issues), 1)
		self.assertIn("dynamic", issues[0]["message"])

	def test_loader_path_cannot_escape_datapack(self):
		self.write("startup/tables/load.lua", 'dofile(DATA_DIRECTORY .. "/../../outside.lua")')
		with self.assertRaisesRegex(ValueError, "leaves its root"):
			loader_files(self.pack)

	def test_cli_paths_are_canonicalized_inside_the_repository(self):
		self.assertEqual(within(self.root, "artifacts/report.json"), self.root / "artifacts/report.json")
		with self.assertRaisesRegex(ValueError, "leaves its root"):
			within(self.root, "../report.json")
		with chdir(self.root):
			self.assertEqual(Path(_workspace_path("artifacts/report.json")), self.root / "artifacts/report.json")
			with self.assertRaisesRegex(ValueError, "leaves its root"):
				_workspace_path("../report.json")

	def test_cli_rejects_a_report_outside_the_repository(self):
		outside = self.root.parent / f"{self.root.name}-outside-report.json"
		self.addCleanup(outside.unlink, missing_ok=True)
		with chdir(self.root), redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
			result = main(["analyze", "--datapack", "data-example", "--all", "--report", f"../{outside.name}"])
		self.assertEqual(result, 2)
		self.assertFalse(outside.exists())

	def test_publication_backups_and_drafts_are_not_live_consumers(self):
		before = analyze(self.root, "data-example")
		for name in ("world/migrations/.recovery/old/source.lua", "world/test.world.json.transactions/old/script.lua", "world/draft/script-1.draft.lua"):
			self.write(name, "return ItemAction[17]")
		after = analyze(self.root, "data-example")
		self.assertEqual(before["consumers"], after["consumers"])
		self.assertEqual(before["sources"], after["sources"])


if __name__ == "__main__":
	unittest.main()
