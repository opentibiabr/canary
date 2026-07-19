from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from tools.canary_audit.cli import _load_config_and_baseline
from tools.canary_audit.models import Diagnostic, Location, finding_fingerprint
from tools.canary_audit.runner import _semantic_diagnostic_findings
from tools.canary_audit.rules import evaluate_rules
from tools.canary_audit.schema_tools import SchemaError, validate_instance

from .helpers import CONFIG_PATH, fact, repository_config


class FingerprintAndBaselineTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_fingerprint_excludes_lines_and_canonicalizes_paths(self) -> None:
		first = finding_fingerprint(
			"definition.duplicate-value",
			"canary",
			"monster.name",
			"DRAGON",
			["data-canary/monster/b.lua", "data-canary/monster/a.lua"],
		)
		second = finding_fingerprint(
			"definition.duplicate-value",
			"canary",
			"monster.name",
			"dragon",
			["data-canary/monster/a.lua", "data-canary/monster/b.lua", "data-canary/monster/a.lua"],
		)

		self.assertEqual(first, second)

	def test_rule_fingerprint_stays_stable_when_lines_move(self) -> None:
		def findings_at(first_line: int, second_line: int):
			facts = (
				fact(
					domain="monster.name",
					role="definition",
					value="Dragon",
					path="data-canary/monster/a.lua",
					profiles=("canary",),
					layer="canary",
					line=first_line,
				),
				fact(
					domain="monster.name",
					role="definition",
					value="dragon",
					path="data-canary/monster/b.lua",
					profiles=("canary",),
					layer="canary",
					line=second_line,
				),
			)
			return evaluate_rules(facts, self.config, ("canary",))

		first = findings_at(1, 2)
		moved = findings_at(101, 202)

		self.assertEqual(len(first), 1)
		self.assertEqual(first[0].fingerprint, moved[0].fingerprint)

	def test_semantic_diagnostic_identity_distinguishes_same_rule_and_file(self) -> None:
		diagnostics = (
			Diagnostic(
				"xml.invalid-item-range",
				"first invalid range",
				"error",
				Location("data/items/items.xml", 10, 1),
				"20-10",
			),
			Diagnostic(
				"xml.invalid-item-range",
				"second invalid range",
				"error",
				Location("data/items/items.xml", 20, 1),
				"40-30",
			),
		)

		findings = _semantic_diagnostic_findings(
			diagnostics,
			self.config,
			frozenset({"canary"}),
			frozenset(),
		)

		self.assertEqual(len({finding.fingerprint for finding in findings}), 2)

	def test_repeated_semantic_identity_invalidates_single_occurrence_waiver(self) -> None:
		first = Diagnostic(
			"xml.invalid-item-range",
			"invalid range",
			"error",
			Location("data/items/items.xml", 10, 1),
			"20-10",
		)
		single = _semantic_diagnostic_findings(
			(first,),
			self.config,
			frozenset({"canary"}),
			frozenset(),
		)[0]
		second = Diagnostic(
			"xml.invalid-item-range",
			"invalid range",
			"error",
			Location("data/items/items.xml", 20, 1),
			"20-10",
		)

		repeated = _semantic_diagnostic_findings(
			(first, second),
			self.config,
			frozenset({"canary"}),
			frozenset({single.fingerprint}),
		)

		self.assertEqual(len(repeated), 1)
		self.assertNotEqual(repeated[0].fingerprint, single.fingerprint)
		self.assertEqual(repeated[0].baseline_status, "new")
		self.assertEqual(len(repeated[0].locations), 2)

	def test_matching_baseline_fingerprint_waives_finding(self) -> None:
		facts = (
			fact(
				domain="action.action_id",
				role="registration",
				value=5000,
				path="data-canary/scripts/actions/a.lua",
				profiles=("canary",),
				layer="canary",
			),
			fact(
				domain="action.action_id",
				role="registration",
				value=5000,
				path="data-canary/scripts/actions/b.lua",
				profiles=("canary",),
				layer="canary",
			),
		)
		finding = evaluate_rules(facts, self.config, ("canary",))[0]

		waived = evaluate_rules(facts, self.config, ("canary",), frozenset({finding.fingerprint}))

		self.assertEqual(waived[0].baseline_status, "waived")

	def test_baseline_schema_requires_hash_and_engineering_reason(self) -> None:
		valid = {
			"schemaVersion": 1,
			"waivers": [{"fingerprint": "a" * 64, "reason": "Known legacy collision awaiting migration."}],
		}
		validate_instance("baseline.schema.json", valid)

		for invalid in (
			{"schemaVersion": 1, "waivers": [{"fingerprint": "short", "reason": "Long enough reason"}]},
			{"schemaVersion": 1, "waivers": [{"fingerprint": "a" * 64, "reason": "short"}]},
		):
			with self.subTest(invalid=invalid), self.assertRaises(SchemaError):
				validate_instance("baseline.schema.json", invalid)

	def test_expired_baseline_waiver_is_not_loaded(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			config_path = root / "tools/canary_audit/config.json"
			baseline_path = root / "tools/canary_audit/baseline.json"
			config_path.parent.mkdir(parents=True)
			config_path.write_text(CONFIG_PATH.read_text(encoding="utf-8"), encoding="utf-8")
			baseline_path.write_text(
				json.dumps(
					{
						"schemaVersion": 1,
						"waivers": [
							{
								"fingerprint": "a" * 64,
								"reason": "Expired legacy waiver for test coverage.",
								"expiresOn": "2000-01-01",
							},
							{
								"fingerprint": "b" * 64,
								"reason": "Active legacy waiver for test coverage.",
								"expiresOn": "2999-01-01",
							},
						],
					}
				),
				encoding="utf-8",
			)

			_, waivers = _load_config_and_baseline(root, "tools/canary_audit/config.json")

		self.assertEqual(waivers, frozenset({"b" * 64}))


if __name__ == "__main__":
	unittest.main()
