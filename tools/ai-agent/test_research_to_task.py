from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/ai-agent"))


def load(name: str):
    path = ROOT / "tools/ai-agent" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


build_draft = load("research_to_task").build_draft
validate_task = load("validate_task_spec").validate


class ResearchToTaskTests(unittest.TestCase):
    def normalized(self):
        return {
            "sourceDocument": "forge_research",
            "entities": [
                {
                    "id": "existing_dragon",
                    "type": "monster",
                    "name": "Dragon",
                    "canonical": True,
                    "sourceRefs": ["wiki"],
                    "facts": {},
                    "canary": {
                        "status": "matched",
                        "matches": [{"path": "data/monster/dragon.lua", "datapack": "data", "name": "Dragon"}],
                    },
                },
                {
                    "id": "forge_quest",
                    "type": "quest",
                    "name": "Forge Research Quest",
                    "canonical": False,
                    "sourceRefs": ["design"],
                    "facts": {},
                    "canary": {"status": "missing", "matches": []},
                },
                {
                    "id": "forge_npc",
                    "type": "npc",
                    "name": "Forge Researcher",
                    "canonical": False,
                    "sourceRefs": ["design"],
                    "facts": {},
                    "canary": {"status": "missing", "matches": []},
                },
                {
                    "id": "reward_item",
                    "type": "item",
                    "name": "Research Token",
                    "canonical": False,
                    "sourceRefs": ["design"],
                    "facts": {},
                    "canary": {"status": "missing", "matches": []},
                },
            ],
        }

    def test_existing_entities_are_blocked_and_never_generated(self):
        task, report = build_draft(self.normalized())
        component_ids = {item["id"] for item in task["contentBundle"]["components"]}
        self.assertNotIn("existing_dragon", component_ids)
        self.assertEqual(report["summary"]["blockedConflicts"], 1)
        self.assertFalse(report["summary"]["readyForPipeline"])

    def test_unsupported_items_are_manual_only(self):
        task, report = build_draft(self.normalized())
        component_ids = {item["id"] for item in task["contentBundle"]["components"]}
        self.assertNotIn("reward_item", component_ids)
        self.assertEqual(report["summary"]["skippedUnsupported"], 1)

    def test_quest_depends_on_generated_support_components(self):
        raw = self.normalized()
        raw["entities"] = [item for item in raw["entities"] if item["id"] not in {"existing_dragon", "reward_item"}]
        task, report = build_draft(raw)
        quest = next(item for item in task["contentBundle"]["components"] if item["type"] == "quest")
        self.assertEqual(quest["dependsOn"], ["forge_npc"])
        self.assertTrue(report["summary"]["readyForPipeline"])
        self.assertTrue(validate_task(task)["ok"])

    def test_empty_research_is_not_pipeline_ready(self):
        task, report = build_draft({"sourceDocument": "empty", "entities": []})
        self.assertEqual(task["contentBundle"]["components"], [])
        self.assertFalse(report["summary"]["readyForPipeline"])


if __name__ == "__main__":
    unittest.main()
