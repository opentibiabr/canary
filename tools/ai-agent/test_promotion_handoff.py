from __future__ import annotations

import importlib.util
import hashlib
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def load(name):
    path = ROOT / "tools/ai-agent" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


build = load("build_promotion_handoff").build


class PromotionHandoffTests(unittest.TestCase):
    def task(self):
        return {
            "taskId": "forge",
            "targetDatapack": "data-otservbr-global",
            "dryRun": True,
        }

    def plan(self):
        return {
            "proposedStorage": [{"id": 390000, "purpose": "progress"}],
            "proposedActionIds": [{"id": 59000, "purpose": "lever"}],
            "proposedUniqueIds": [],
            "mapRequirements": ["place lever manually"],
        }

    def readiness(self, findings=None):
        return {
            "automaticPromotionAllowed": False,
            "findings": findings or [],
            "requiredTests": ["runtime smoke test"],
        }

    def test_builds_target_mapping_and_preserves_safety(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "forge/monster/the_ashen_sentinel.lua"
            path.parent.mkdir(parents=True)
            path.write_text("return true\n", encoding="utf-8")
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            manifest = {"files": [{"path": "forge/monster/the_ashen_sentinel.lua", "sha256": digest}]}

            bundle = build(self.task(), self.plan(), manifest, self.readiness(), root)

            self.assertEqual(bundle["handoffStatus"], "ready-for-manual-review")
            self.assertFalse(bundle["automaticApplyAllowed"])
            self.assertTrue(bundle["manualApprovalRequired"])
            self.assertEqual(
                bundle["files"][0]["targetPath"],
                "data-otservbr-global/monster/the_ashen_sentinel.lua",
            )
            self.assertEqual(bundle["identifiers"]["storage"][0]["id"], 390000)
            self.assertIn("OTBM", bundle["prohibitedAutomaticTargets"])

    def test_blockers_keep_handoff_blocked(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "forge/npc/forge_keeper.lua"
            path.parent.mkdir(parents=True)
            path.write_text("return true\n", encoding="utf-8")
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            manifest = {"files": [{"path": "forge/npc/forge_keeper.lua", "sha256": digest}]}
            findings = [{"level": "blocker", "category": "dialogue", "message": "TODO remains"}]

            bundle = build(self.task(), self.plan(), manifest, self.readiness(findings), root)
            self.assertEqual(bundle["handoffStatus"], "blocked")
            self.assertEqual(bundle["blockers"], findings)

    def test_rejects_checksum_mismatch_and_path_traversal(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "forge/quest/forge.lua"
            path.parent.mkdir(parents=True)
            path.write_text("return true\n", encoding="utf-8")
            with self.assertRaises(ValueError):
                build(
                    self.task(),
                    self.plan(),
                    {"files": [{"path": "forge/quest/forge.lua", "sha256": "bad"}]},
                    self.readiness(),
                    root,
                )
            with self.assertRaises(ValueError):
                build(
                    self.task(),
                    self.plan(),
                    {"files": [{"path": "../escape.lua", "sha256": "bad"}]},
                    self.readiness(),
                    root,
                )


if __name__ == "__main__":
    unittest.main()
