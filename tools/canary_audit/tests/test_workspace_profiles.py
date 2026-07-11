from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from tools.canary_audit.cli import _artifact_output_directory
from tools.canary_audit.config import ConfigError, load_config
from tools.canary_audit.rules import evaluate_rules
from tools.canary_audit.workspace import (
	WorkspaceError,
	atomic_write_text,
	discover_files,
	resolve_workspace_path,
	safe_relative_path,
)

from .helpers import fact, repository_config


class WorkspacePathSafetyTests(unittest.TestCase):
	def test_artifact_output_is_confined_to_excluded_artifact_root(self) -> None:
		config = repository_config()

		self.assertEqual(
			_artifact_output_directory(config, "artifacts/canary-audit"),
			"artifacts/canary-audit",
		)
		with self.assertRaises(ConfigError):
			_artifact_output_directory(config, "reports/canary-audit")

	def test_safe_relative_path_accepts_normal_posix_path(self) -> None:
		self.assertEqual(safe_relative_path("artifacts/audit/report.json"), "artifacts/audit/report.json")

	def test_safe_relative_path_rejects_escape_absolute_and_windows_paths(self) -> None:
		invalid = (
			"",
			"../outside",
			"nested/../../outside",
			"/absolute/path",
			"C:\\absolute\\path",
			"nested\\windows",
			"CON",
			"reports/NUL.txt",
			"devices/com1.log",
		)
		for value in invalid:
			with self.subTest(value=value), self.assertRaises(WorkspaceError):
				safe_relative_path(value)

	def test_safe_relative_path_rejects_explicit_dot_segments(self) -> None:
		for value in ("./report.json", "artifacts/./report.json"):
			with self.subTest(value=value), self.assertRaises(WorkspaceError):
				safe_relative_path(value)

	def test_config_paths_reject_explicit_dot_segments(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			config_path = Path(temporary) / "config.json"
			config_path.write_text(
				json.dumps(
					{
						"schemaVersion": 1,
						"layers": [{"name": "core", "root": "./data"}],
						"profiles": [{"name": "canary", "layers": ["core"]}],
						"baselinePath": "tools/canary_audit/baseline.json",
					}
				),
				encoding="utf-8",
			)

			with self.assertRaises(ConfigError):
				load_config(config_path)

	def test_resolve_and_atomic_write_reject_symlink_leaf(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			target = root / "target.txt"
			target.write_text("target", encoding="utf-8")
			link = root / "report.txt"
			try:
				link.symlink_to(target)
			except OSError as error:
				self.skipTest(f"symlinks are unavailable: {error}")

			with self.assertRaises(WorkspaceError):
				resolve_workspace_path(root, "report.txt", must_exist=True)
			with self.assertRaises(WorkspaceError):
				atomic_write_text(root, "report.txt", "replacement")
			self.assertEqual(target.read_text(encoding="utf-8"), "target")

	def test_parent_symlink_cannot_escape_workspace(self) -> None:
		with tempfile.TemporaryDirectory() as workspace, tempfile.TemporaryDirectory() as external:
			root = Path(workspace)
			external_root = Path(external)
			(external_root / "secret.txt").write_text("secret", encoding="utf-8")
			link = root / "linked"
			try:
				link.symlink_to(external_root, target_is_directory=True)
			except OSError as error:
				self.skipTest(f"directory symlinks are unavailable: {error}")

			with self.assertRaises(WorkspaceError):
				resolve_workspace_path(root, "linked/secret.txt", must_exist=True)

	def test_walk_discovery_does_not_follow_symlinks(self) -> None:
		with tempfile.TemporaryDirectory() as workspace, tempfile.TemporaryDirectory() as external:
			root = Path(workspace)
			(root / "data").mkdir()
			(root / "data/real.lua").write_text("return true", encoding="utf-8")
			external_root = Path(external)
			(external_root / "escaped.lua").write_text("return false", encoding="utf-8")
			try:
				(root / "data/linked").symlink_to(external_root, target_is_directory=True)
			except OSError as error:
				self.skipTest(f"directory symlinks are unavailable: {error}")

			files = discover_files(root, frozenset(), prefer_git=False)

			self.assertEqual([item.path for item in files], ["data/real.lua"])


class LoadProfileTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_config_models_shared_core_and_mutually_exclusive_datapacks(self) -> None:
		self.assertEqual(self.config.profile_by_name["canary"].layers, ("core", "canary"))
		self.assertEqual(
			self.config.profile_by_name["otservbr-global"].layers,
			("core", "otservbr-global"),
		)
		self.assertEqual(self.config.profiles_for_layer("core"), ("canary", "otservbr-global"))
		self.assertEqual(self.config.layer_for_path("data/scripts/test.lua"), "core")
		self.assertEqual(self.config.layer_for_path("data-canary/monster/test.lua"), "canary")
		self.assertEqual(
			self.config.layer_for_path("data-otservbr-global/npc/test.lua"),
			"otservbr-global",
		)

	def test_equal_definitions_in_separate_datapacks_do_not_collide(self) -> None:
		facts = (
			fact(
				domain="monster.name",
				role="definition",
				value="Shared Name",
				path="data-canary/monster/one.lua",
				profiles=("canary",),
				layer="canary",
			),
			fact(
				domain="monster.name",
				role="definition",
				value="shared name",
				path="data-otservbr-global/monster/two.lua",
				profiles=("otservbr-global",),
				layer="otservbr-global",
			),
		)

		findings = evaluate_rules(facts, self.config, ("canary", "otservbr-global"))

		self.assertFalse([item for item in findings if item.rule_id == "definition.duplicate-value"])

	def test_reference_cannot_be_satisfied_by_other_datapack(self) -> None:
		facts = (
			fact(
				domain="monster.name",
				role="reference",
				value="Global Only",
				path="data-canary/scripts/spawn.lua",
				profiles=("canary",),
				layer="canary",
			),
			fact(
				domain="monster.name",
				role="definition",
				value="Global Only",
				path="data-otservbr-global/monster/global_only.lua",
				profiles=("otservbr-global",),
				layer="otservbr-global",
			),
		)

		findings = evaluate_rules(facts, self.config, ("canary", "otservbr-global"))

		missing = [item for item in findings if item.rule_id == "reference.missing-definition"]
		self.assertEqual(len(missing), 1)
		self.assertEqual(missing[0].profile, "canary")

	def test_reference_does_not_count_as_its_own_definition(self) -> None:
		facts = (
			fact(
				domain="item.server_id",
				role="reference",
				value=321,
				path="data-canary/scripts/action.lua",
				profiles=("canary",),
				layer="canary",
			),
		)

		findings = evaluate_rules(facts, self.config, ("canary",))

		self.assertEqual(len(findings), 1)
		self.assertEqual(findings[0].rule_id, "reference.missing-definition")
		self.assertEqual(findings[0].value, 321)


if __name__ == "__main__":
	unittest.main()
