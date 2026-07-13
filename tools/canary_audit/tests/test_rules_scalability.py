from __future__ import annotations

import unittest
from dataclasses import replace
from unittest.mock import patch

from tools.canary_audit import rules as rules_module
from tools.canary_audit.rules import (
	MAX_FINDING_LOCATIONS,
	_NumericDefinitionIndex,
	_missing_numeric_ranges,
	_numeric_definition_index,
	_overlapping_numeric_segments,
	evaluate_rules,
)

from .helpers import fact, repository_config


class NoSliceTuple(tuple):
	def __getitem__(self, key):
		if isinstance(key, slice):
			raise AssertionError("interval scans must not allocate tuple slices")
		return super().__getitem__(key)


class NumericIntervalRuleTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_numeric_index_precomputes_starts_and_range_scan_avoids_slices(self) -> None:
		definitions = (
			self._definition(0, 9, "data/items/first.dat"),
			self._definition(20, 29, "data/items/second.dat"),
		)
		built = _numeric_definition_index(definitions)
		index = _NumericDefinitionIndex(NoSliceTuple(built.intervals), built.starts)
		reference = fact(
			domain="item.server_id",
			role="reference",
			value=5,
			end_value=25,
			path="data/items/items.xml",
			profiles=("canary",),
			layer="core",
		)

		self.assertEqual(index.starts, (0, 20))
		self.assertEqual(_missing_numeric_ranges(reference, index), [(10, 19)])

	def test_chain_overlap_reports_only_exact_points(self) -> None:
		definitions = (
			self._definition(1, 3, "data/items/a.dat"),
			self._definition(3, 5, "data/items/b.dat"),
			self._definition(5, 7, "data/items/c.dat"),
		)

		findings = evaluate_rules(definitions, self.config, ("canary",))

		self.assertEqual([finding.value for finding in findings], [3, 5])
		self.assertEqual(
			[[location.path for location in finding.locations] for finding in findings],
			[
				["data/items/a.dat", "data/items/b.dat"],
				["data/items/b.dat", "data/items/c.dat"],
			],
		)

	def test_nested_overlap_splits_when_active_definition_set_changes(self) -> None:
		definitions = (
			self._definition(1, 10, "data/items/a.dat"),
			self._definition(3, 8, "data/items/b.dat"),
			self._definition(5, 6, "data/items/c.dat"),
		)

		findings = evaluate_rules(definitions, self.config, ("canary",))

		self.assertEqual([finding.value for finding in findings], ["3-4", "5-6", "7-8"])
		self.assertEqual(
			[location.path for location in findings[1].locations],
			["data/items/a.dat", "data/items/b.dat", "data/items/c.dat"],
		)

	def test_nested_overlap_evidence_is_bounded(self) -> None:
		definitions = tuple(
			self._definition(index, 1000 - index, f"data/items/{index:03}.dat")
			for index in range(MAX_FINDING_LOCATIONS + 5)
		)

		segments = list(_overlapping_numeric_segments(definitions))
		_, _, evidence, overlap_count = max(segments, key=lambda segment: segment[3])

		self.assertEqual(overlap_count, MAX_FINDING_LOCATIONS + 5)
		self.assertEqual(len(evidence), MAX_FINDING_LOCATIONS)

	@staticmethod
	def _definition(start: int, end: int, path: str):
		return fact(
			domain="item.server_id",
			role="definition",
			value=start,
			end_value=end,
			path=path,
			profiles=("canary",),
			layer="core",
		)


class FindingLimitTests(unittest.TestCase):
	def setUp(self) -> None:
		self.config = repository_config()

	def test_exact_limit_is_allowed(self) -> None:
		config = replace(self.config, max_findings=2)

		findings = evaluate_rules(self._missing_references(2), config, ("canary",))

		self.assertEqual(len(findings), 2)

	def test_limit_stops_generation_without_materializing_all_findings(self) -> None:
		config = replace(self.config, max_findings=2)
		original_build = rules_module._build_finding
		references = self._missing_references(100)
		build_count = 0

		def counted_build(**kwargs):
			nonlocal build_count
			build_count += 1
			return original_build(**kwargs)

		with patch.object(rules_module, "_build_finding", side_effect=counted_build):
			with self.assertRaisesRegex(RuntimeError, "maxFindings=2"):
				evaluate_rules(references, config, ("canary",))

		self.assertEqual(build_count, 3)

	@staticmethod
	def _missing_references(count: int):
		return tuple(
			fact(
				domain="item.server_id",
				role="reference",
				value=10_000 + index,
				path=f"data-canary/scripts/reference_{index}.lua",
				profiles=("canary",),
				layer="canary",
			)
			for index in range(count)
		)


if __name__ == "__main__":
	unittest.main()
