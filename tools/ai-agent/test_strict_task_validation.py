from __future__ import annotations

import copy
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from validate_task_spec import validate


BASE = {
    "schemaVersion": "1.0",
    "taskId": "strict_bundle",
    "type": "content_bundle",
    "name": "Strict Bundle",
    "description": "Validation fixture.",
    "targetDatapack": "data-otservbr-global",
    "dryRun": True,
    "requestedBy": "test",
    "tags": ["test"],
    "sources": [
        {
            "id": "design",
            "kind": "manual",
            "title": "Design brief",
            "checkedAt": "2026-07-10",
            "confidence": "high",
        }
    ],
    "contentBundle": {
        "components": [
            {
                "id": "starter_npc",
                "type": "npc",
                "name": "Starter NPC",
                "dependsOn": [],
                "sourceRefs": ["design"],
            },
            {
                "id": "starter_quest",
                "type": "quest",
                "name": "Starter Quest",
                "dependsOn": ["starter_npc"],
                "sourceRefs": ["design"],
            },
        ],
        "requestedIds": [
            {
                "namespace": "storage",
                "count": 1,
                "min": 390000,
                "max": 399999,
                "purpose": "quest progress",
            }
        ],
        "mapRequirements": ["Place the starter NPC."],
        "manualSteps": ["Review generated Lua."],
    },
}


class StrictTaskValidationTests(unittest.TestCase):
    def test_valid_bundle_passes(self):
        self.assertTrue(validate(copy.deepcopy(BASE))["ok"])

    def test_unknown_component_dependency_fails(self):
        task = copy.deepcopy(BASE)
        task["contentBundle"]["components"][1]["dependsOn"] = ["missing_component"]
        report = validate(task)
        self.assertFalse(report["ok"])
        self.assertTrue(any("unknown dependency" in finding["message"] for finding in report["findings"]))

    def test_unsupported_payload_field_fails(self):
        task = {
            "schemaVersion": "1.0",
            "taskId": "quest_fixture",
            "type": "quest",
            "name": "Quest Fixture",
            "description": "Validation fixture.",
            "targetDatapack": "data-otservbr-global",
            "dryRun": True,
            "requestedBy": "test",
            "tags": ["test"],
            "quest": {"requiredLevel": 10, "unknownField": True},
        }
        report = validate(task)
        self.assertFalse(report["ok"])
        self.assertTrue(any("unsupported field: unknownField" in finding["message"] for finding in report["findings"]))

    def test_invalid_identifier_range_fails(self):
        task = copy.deepcopy(BASE)
        task["contentBundle"]["requestedIds"][0]["min"] = 400000
        task["contentBundle"]["requestedIds"][0]["max"] = 399999
        report = validate(task)
        self.assertFalse(report["ok"])
        self.assertTrue(any("min greater than max" in finding["message"] for finding in report["findings"]))

    def test_non_matching_payload_fails(self):
        task = copy.deepcopy(BASE)
        task["quest"] = {"requiredLevel": 10}
        report = validate(task)
        self.assertFalse(report["ok"])
        self.assertTrue(any("unexpected payload" in finding["message"] for finding in report["findings"]))


if __name__ == "__main__":
    unittest.main()
