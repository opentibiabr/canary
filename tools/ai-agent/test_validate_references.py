from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("validate_references.py")
SPEC = importlib.util.spec_from_file_location("validate_references", MODULE_PATH)
assert SPEC and SPEC.loader
validate_references = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(validate_references)


class ReferenceValidatorTests(unittest.TestCase):
    def test_reports_missing_references(self) -> None:
        content = {
            "entries": [
                {"type": "monster", "name": "Dragon", "path": "dragon.lua", "references": {}},
                {
                    "type": "quest",
                    "name": "Test Quest",
                    "path": "quest.lua",
                    "references": {
                        "monster": ["Dragon", "Missing Beast"],
                        "npc": ["Missing Guide"],
                        "item": [2160, 999999],
                        "storage": [58001, 58002],
                    },
                },
            ]
        }
        registry = {
            "namespaces": {
                "itemId": {"entries": [{"value": 2160}]},
                "storage": {"entries": [{"value": 58001}]},
            }
        }

        report = validate_references.validate(content, registry)
        types = {finding["type"] for finding in report["findings"]}

        self.assertEqual(report["summary"]["findingCount"], 4)
        self.assertEqual(
            types,
            {"missing-monster", "missing-npc", "missing-item-id", "unregistered-storage"},
        )

    def test_accepts_known_references(self) -> None:
        content = {
            "entries": [
                {"type": "monster", "name": "Dragon", "path": "dragon.lua", "references": {}},
                {"type": "npc", "name": "Guide", "path": "guide.lua", "references": {}},
                {
                    "type": "quest",
                    "name": "Quest",
                    "path": "quest.lua",
                    "references": {
                        "monster": ["dragon"],
                        "npc": ["GUIDE"],
                        "item": [2160],
                        "storage": [58001],
                    },
                },
            ]
        }
        registry = {
            "namespaces": {
                "itemId": {"entries": [{"value": 2160}]},
                "storage": {"entries": [{"value": 58001}]},
            }
        }

        report = validate_references.validate(content, registry)
        self.assertEqual(report["summary"]["findingCount"], 0)


if __name__ == "__main__":
    unittest.main()
