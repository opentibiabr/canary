from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from tools.canary_audit.cli import _write_artifacts
from tools.canary_audit.runner import run_audit
from tools.canary_audit.schema_tools import (
	SchemaError,
	load_and_validate_json,
	stable_json,
	validate_all_schemas,
	validate_instance,
)

from .helpers import (
	BASELINE_PATH,
	CONFIG_PATH,
	appearances_payload,
	repository_config,
)


class SchemaAndDeterministicIntegrationTests(unittest.TestCase):
	def test_bundled_schemas_config_and_baseline_are_valid(self) -> None:
		validate_all_schemas()
		load_and_validate_json(CONFIG_PATH, "config.schema.json")
		load_and_validate_json(BASELINE_PATH, "baseline.schema.json")

	def test_config_schema_requires_an_excluded_directory(self) -> None:
		config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
		config["excludedDirectories"] = []

		with self.assertRaises(SchemaError):
			validate_instance("config.schema.json", config)

	def test_same_workspace_produces_byte_stable_schema_valid_artifacts(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			self._write_minimal_workspace(root)
			config = repository_config()
			kwargs = {
				"selected_profiles": ("canary", "otservbr-global"),
				"base_sha": "a" * 40,
				"head_sha": "b" * 40,
				"prefer_git": False,
			}

			first = run_audit(root, config, **kwargs)
			second = run_audit(root, config, **kwargs)
			_write_artifacts(root, "artifacts/test-audit", first)
			after_output = run_audit(root, config, **kwargs)
			with_stale_waiver = run_audit(
				root,
				config,
				waived_fingerprints=frozenset({"c" * 64}),
				**kwargs,
			)

		self.assertFalse(first.incomplete)
		self.assertEqual(stable_json(first.project_index), stable_json(second.project_index))
		self.assertEqual(stable_json(first.symbol_registry), stable_json(second.symbol_registry))
		self.assertEqual(stable_json(first.reference_report), stable_json(second.reference_report))
		self.assertEqual(first.summary_markdown, second.summary_markdown)
		self.assertEqual(stable_json(first.project_index), stable_json(after_output.project_index))
		self.assertEqual(stable_json(first.symbol_registry), stable_json(after_output.symbol_registry))
		self.assertEqual(stable_json(first.reference_report), stable_json(after_output.reference_report))
		validate_instance("project-index.schema.json", first.project_index)
		validate_instance("symbol-registry.schema.json", first.symbol_registry)
		validate_instance("reference-report.schema.json", first.reference_report)

		self.assertEqual(with_stale_waiver.reference_report["summary"]["staleWaiverCount"], 1)

	@staticmethod
	def _write(root: Path, relative: str, content: str | bytes) -> None:
		path = root / relative
		path.parent.mkdir(parents=True, exist_ok=True)
		if isinstance(content, bytes):
			path.write_bytes(content)
		else:
			path.write_text(content, encoding="utf-8")

	@classmethod
	def _write_minimal_workspace(cls, root: Path) -> None:
		cls._write(root, "data/items/appearances.dat", appearances_payload(321))
		cls._write(root, "data/items/items.xml", '<items><item id="321" name="test item" /></items>')
		cls._write(
			root,
			"data/XML/storages.xml",
			'<storages><range start="1000000" end="1000010"><storage name="test.one" key="1" /></range></storages>',
		)
		cls._write(root, "data/libs/core/global_storage.lua", "Global = { Storage = { Shared = 70000 } }")
		cls._write(
			root,
			"data-canary/lib/core/storages.lua",
			"Storage = { Canary = 80000 }\nGlobalStorage = { Canary = 81000 }",
		)
		cls._write(
			root,
			"data-otservbr-global/lib/core/storages.lua",
			"Storage = { Global = 90000 }\nGlobalStorage = { Global = 91000 }",
		)
		cls._write(
			root,
			"data-canary/monster/canary_test.lua",
			'''local mType = Game.createMonsterType("Canary Test")
mType:register({})
Game.createMonster("Canary Test", position)
local action = Action()
action:id(321)
action:register()
''',
		)
		cls._write(
			root,
			"data-otservbr-global/monster/global_test.lua",
			'''local mType = Game.createMonsterType("Global Test")
mType:register({})
Game.createMonster("Global Test", position)
''',
		)


if __name__ == "__main__":
	unittest.main()
