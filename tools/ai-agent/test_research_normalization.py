from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location(
    "normalize_research", ROOT / "tools/ai-agent/normalize_research.py"
)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)
normalize = MODULE.normalize


class ResearchNormalizationTests(unittest.TestCase):
    def content_index(self):
        return {
            "entries": [
                {
                    "type": "monster",
                    "name": "Dragon",
                    "path": "data-otservbr-global/monster/dragons/dragon.lua",
                    "datapack": "data-otservbr-global",
                },
                {
                    "type": "npc",
                    "name": "Benjamin",
                    "path": "data-otservbr-global/npc/benjamin.lua",
                    "datapack": "data-otservbr-global",
                },
            ]
        }

    def test_matches_existing_canary_entity_case_insensitively(self):
        raw = {
            "documentId": "dragon_research",
            "entities": [
                {
                    "id": "dragon",
                    "type": "monster",
                    "name": "  dragon ",
                    "canonical": True,
                    "sourceRefs": ["wiki"],
                    "facts": {},
                }
            ],
        }
        result = normalize(raw, self.content_index())
        self.assertEqual(result["summary"]["matchedInCanary"], 1)
        self.assertEqual(result["entities"][0]["canary"]["status"], "matched")
        self.assertTrue(result["entities"][0]["canary"]["matches"][0]["path"].endswith("dragon.lua"))

    def test_marks_missing_custom_content(self):
        raw = {
            "documentId": "custom",
            "entities": [
                {
                    "id": "forgotten_forge",
                    "type": "quest",
                    "name": "Forgotten Forge",
                    "canonical": False,
                    "sourceRefs": ["custom_design"],
                    "facts": {"classification": "custom-ots-content"},
                }
            ],
        }
        result = normalize(raw, self.content_index())
        self.assertEqual(result["summary"]["missingInCanary"], 1)
        self.assertFalse(result["entities"][0]["canonical"])

    def test_rejects_duplicate_and_invalid_entities(self):
        raw = {
            "documentId": "bad",
            "entities": [
                {"id": "same", "type": "monster", "name": "Dragon", "sourceRefs": [], "facts": {}},
                {"id": "same", "type": "npc", "name": "Benjamin", "sourceRefs": [], "facts": {}},
                {"id": "../escape", "type": "item", "name": "Gold Coin", "sourceRefs": [], "facts": {}},
            ],
        }
        result = normalize(raw, self.content_index())
        errors = [item for item in result["findings"] if item["level"] == "error"]
        self.assertEqual(len(errors), 2)


if __name__ == "__main__":
    unittest.main()
