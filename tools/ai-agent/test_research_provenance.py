from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/ai-agent"))
sys.path.insert(0, str(ROOT / "tools/ai-agent/lib"))

from research_provenance import build_report
from validate_task_spec import validate


class ResearchProvenanceTests(unittest.TestCase):
    def bundle_task(self):
        path = ROOT / "docs/ai-agent/examples/forgotten_forge.content-bundle.json"
        return json.loads(path.read_text(encoding="utf-8"))

    def test_example_has_valid_provenance(self):
        task = self.bundle_task()
        self.assertTrue(validate(task)["ok"])
        self.assertEqual(len(task["sources"]), 3)

    def test_component_requires_known_source_reference(self):
        task = self.bundle_task()
        task["contentBundle"]["components"][0]["sourceRefs"] = ["missing-source"]
        report = validate(task)
        self.assertFalse(report["ok"])
        self.assertTrue(any("unknown source" in finding["message"] for finding in report["findings"]))

    def test_remote_sources_require_https(self):
        task = self.bundle_task()
        task["sources"][1]["url"] = "http://example.invalid"
        self.assertFalse(validate(task)["ok"])

    def test_custom_design_is_not_presented_as_canonical(self):
        report = build_report(self.bundle_task())
        self.assertIn("custom OTS design, not canonical Tibia content", report)
        self.assertIn("Canary repository files are the source of truth", report)
        self.assertIn("https://tibia.fandom.com/wiki/", report)


if __name__ == "__main__":
    unittest.main()
