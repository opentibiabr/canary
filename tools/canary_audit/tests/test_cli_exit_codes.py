from __future__ import annotations

import io
import unittest
from contextlib import redirect_stderr
from unittest.mock import patch

from tools.canary_audit.cli import EXIT_INCOMPLETE, EXIT_USAGE, main
from tools.canary_audit.schema_tools import SchemaError
from tools.canary_audit.workspace import WorkspaceError

from .helpers import REPOSITORY_ROOT


class CliExitCodeTests(unittest.TestCase):
	def test_invalid_scan_argument_returns_usage_exit(self) -> None:
		stderr = io.StringIO()

		with redirect_stderr(stderr):
			status = main(
				["scan", "--output-dir", "reports/canary-audit"],
				repository_root=REPOSITORY_ROOT,
			)

		self.assertEqual(status, EXIT_USAGE)
		self.assertIn("output directory", stderr.getvalue())

	def test_operational_scan_failure_returns_incomplete_exit(self) -> None:
		stderr = io.StringIO()

		with patch("tools.canary_audit.cli._scan", side_effect=WorkspaceError("write failed")):
			with redirect_stderr(stderr):
				status = main(["scan"], repository_root=REPOSITORY_ROOT)

		self.assertEqual(status, EXIT_INCOMPLETE)
		self.assertIn("internal scan failure", stderr.getvalue())

	def test_bundled_schema_failure_returns_incomplete_exit(self) -> None:
		stderr = io.StringIO()

		with patch(
			"tools.canary_audit.cli.validate_all_schemas",
			side_effect=SchemaError("broken bundled schema"),
		):
			with redirect_stderr(stderr):
				status = main(["validate-schemas"], repository_root=REPOSITORY_ROOT)

		self.assertEqual(status, EXIT_INCOMPLETE)
		self.assertIn("internal schema failure", stderr.getvalue())


if __name__ == "__main__":
	unittest.main()
