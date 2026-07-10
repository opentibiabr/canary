from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = ROOT / "tools/ai-agent/evaluate_promotion_readiness.py"
spec = importlib.util.spec_from_file_location("evaluate_promotion_readiness", MODULE_PATH)
module = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(module)


class PromotionReadinessTests(unittest.TestCase):
    def test_preview_todos_and_manual_map_work_block_promotion(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            preview = root / "task/monster/boss.lua"
            preview.parent.mkdir(parents=True)
            preview.write_text("monster.loot = {} -- TODO: verify items and chances against approved design\n", encoding="utf-8")
            task = {
                "taskId": "task",
                "dryRun": True,
                "contentBundle": {"components": [{"id": "boss", "type": "monster", "name": "Boss"}]},
            }
            plan = {
                "mapRequirements": ["build arena"],
                "proposedStorage": [{"id": 390000}],
                "proposedActionIds": [{"id": 59000}],
            }
            manifest = {"files": [{"path": "task/monster/boss.lua"}]}
            report = module.evaluate(task, plan, manifest, root)
            categories = {item["category"] for item in report["findings"]}
            self.assertFalse(report["readyForHumanPromotion"])
            self.assertFalse(report["automaticPromotionAllowed"])
            self.assertIn("map", categories)
            self.assertIn("storage-constants", categories)
            self.assertIn("map-identifiers", categories)
            self.assertIn("loot", categories)
            self.assertIn("loot and corpse item validation", report["requiredTests"])

    def test_clean_reviewed_bundle_is_only_ready_for_human_promotion(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            preview = root / "task/quest/quest.lua"
            preview.parent.mkdir(parents=True)
            preview.write_text("return { reviewed = true }\n", encoding="utf-8")
            task = {
                "taskId": "task",
                "dryRun": True,
                "contentBundle": {"components": [{"id": "quest", "type": "quest", "name": "Quest"}]},
            }
            report = module.evaluate(task, {"mapRequirements": []}, {"files": [{"path": "task/quest/quest.lua"}]}, root)
            self.assertTrue(report["readyForHumanPromotion"])
            self.assertEqual(report["status"], "ready-for-human-promotion")
            self.assertFalse(report["automaticPromotionAllowed"])
            self.assertTrue(report["manualApprovalRequired"])


if __name__ == "__main__":
    unittest.main()
