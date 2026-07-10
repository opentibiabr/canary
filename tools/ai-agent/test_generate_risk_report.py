from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("generate_risk_report.py")
SPEC = importlib.util.spec_from_file_location("generate_risk_report", MODULE_PATH)
assert SPEC and SPEC.loader
generate_risk_report = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(generate_risk_report)


class RiskReportTests(unittest.TestCase):
    def test_prioritizes_errors_before_warnings_and_info(self) -> None:
        registry = {
            "conflicts": [
                {
                    "namespace": "actionId",
                    "value": 1000,
                    "severity": "warning",
                    "sources": [{"path": "a.lua"}, {"path": "b.lua"}],
                }
            ]
        }
        content = {
            "duplicates": [
                {
                    "type": "monster",
                    "name": "dragon",
                    "paths": ["one.lua", "two.lua"],
                    "crossDatapack": True,
                }
            ]
        }
        references = {
            "findings": [
                {
                    "severity": "error",
                    "type": "missing-item-id",
                    "source": "quest.lua",
                    "value": 999999,
                }
            ]
        }

        report = generate_risk_report.build_report(registry, content, references)

        self.assertIn("- Errors: 1", report)
        self.assertIn("- Warnings: 1", report)
        self.assertIn("- Informational: 1", report)
        self.assertLess(report.index("ERROR — missing-item-id"), report.index("WARNING — duplicate-actionId-definition"))

    def test_reports_clean_state(self) -> None:
        report = generate_risk_report.build_report({"conflicts": []}, {"duplicates": []}, {"findings": []})
        self.assertIn("No findings detected.", report)


if __name__ == "__main__":
    unittest.main()
