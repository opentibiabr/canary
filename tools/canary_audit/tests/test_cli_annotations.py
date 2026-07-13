from __future__ import annotations

import io
import unittest
from contextlib import redirect_stdout

from tools.canary_audit.cli import (
	_annotation_escape_data,
	_annotation_escape_property,
	_emit_annotations,
)
from tools.canary_audit.models import Diagnostic, Finding, Location
from tools.canary_audit.runner import AuditArtifacts


class GitHubAnnotationTests(unittest.TestCase):
	@staticmethod
	def _artifacts(
		*,
		findings: tuple[Finding, ...] = (),
		diagnostics: tuple[Diagnostic, ...] = (),
	) -> AuditArtifacts:
		return AuditArtifacts(
			project_index={},
			symbol_registry={},
			reference_report={},
			summary_markdown="",
			findings=findings,
			diagnostics=diagnostics,
			blocking_count=0,
			incomplete=False,
		)

	@staticmethod
	def _finding(severity: str) -> Finding:
		return Finding(
			rule_id="reference:test,case",
			severity=severity,  # type: ignore[arg-type]
			confidence="exact",
			profile="canary",
			domain="monster.name",
			value="Test",
			message="value: one,two%\nnext",
			locations=(Location("data-canary/monster/test,file.lua", 7, 3),),
			fingerprint="a" * 64,
		)

	def test_property_escaping_adds_colon_and_comma_to_data_escaping(self) -> None:
		value = "50%:first,second\r\n"

		self.assertEqual(_annotation_escape_data(value), "50%25:first,second%0D%0A")
		self.assertEqual(_annotation_escape_property(value), "50%25%3Afirst%2Csecond%0D%0A")

	def test_diagnostic_uses_property_and_data_escape_rules(self) -> None:
		diagnostic = Diagnostic(
			code="scan.test",
			message="bad: one,two%\nnext",
			severity="error",
			location=Location("data-canary/test,file.lua", 2, 5),
		)
		output = io.StringIO()

		with redirect_stdout(output):
			_emit_annotations(self._artifacts(diagnostics=(diagnostic,)), "error")

		self.assertEqual(
			output.getvalue(),
			"::error file=data-canary/test%2Cfile.lua,line=2,col=5::bad: one,two%25%0Anext\n",
		)

	def test_finding_severity_maps_info_to_notice(self) -> None:
		levels = {"info": "notice", "warning": "warning", "error": "error"}
		for severity, annotation_level in levels.items():
			with self.subTest(severity=severity):
				output = io.StringIO()
				with redirect_stdout(output):
					_emit_annotations(self._artifacts(findings=(self._finding(severity),)), "info")

				self.assertEqual(
					output.getvalue(),
					f"::{annotation_level} file=data-canary/monster/test%2Cfile.lua,line=7,col=3,"
					"title=reference%3Atest%2Ccase::value: one,two%25%0Anext\n",
				)


if __name__ == "__main__":
	unittest.main()
