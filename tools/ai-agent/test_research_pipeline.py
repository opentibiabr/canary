from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/ai-agent"))
sys.path.insert(0, str(ROOT / "tools/ai-agent/lib"))

from run_research_pipeline import run


class ResearchPipelineTests(unittest.TestCase):
    def registry(self):
        return {
            "namespaces": {
                "storage": {"entries": {}},
                "actionId": {"entries": {}},
                "uniqueId": {"entries": {}},
                "itemId": {"entries": {}},
            }
        }

    def reservations(self):
        return {"schemaVersion": "1.0", "reservations": []}

    def conflict_free_research(self):
        return json.loads(
            (ROOT / "docs/ai-agent/examples/forgotten_forge.research.json").read_text(encoding="utf-8")
        )

    def test_complete_pipeline_generates_three_previews_and_five_ids(self):
        (ROOT / "artifacts").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=ROOT / "artifacts") as directory:
            code, summary = run(
                self.conflict_free_research(),
                self.registry(),
                {"entries": []},
                self.reservations(),
                Path(directory),
            )

            self.assertEqual(code, 0)
            self.assertTrue(summary["ok"])
            self.assertEqual(summary["generatedComponents"], 3)
            self.assertEqual(summary["previewFiles"], 3)
            self.assertEqual(summary["reservedIdentifiers"], 5)
            self.assertEqual(summary["stagingVerificationStatus"], "blocked")
            self.assertFalse(summary["stagingVerified"])
            self.assertGreater(summary["stagingVerificationBlockers"], 0)
            self.assertFalse(summary["stagingRollbackVerified"])
            self.assertEqual(summary["finalStatus"], "blocked-before-human-implementation")

            root = Path(directory)
            task = json.loads((root / "TASK_SPEC.generated.json").read_text(encoding="utf-8"))
            conflicts = json.loads((root / "RESEARCH_CONFLICTS.json").read_text(encoding="utf-8"))
            manifest = json.loads(
                (root / "generated-content" / task["taskId"] / "MANIFEST.json").read_text(encoding="utf-8")
            )
            verification = json.loads((root / "STAGING_VERIFICATION.json").read_text(encoding="utf-8"))
            self.assertTrue(task["dryRun"])
            self.assertTrue(conflicts["summary"]["readyForPipeline"])
            self.assertEqual(manifest["format"], "canary-preview-v1")
            self.assertFalse(verification["verified"])
            self.assertEqual(verification["scope"], "temporary isolated filesystem only")
            self.assertFalse(verification["automaticApplyAllowed"])
            self.assertTrue(verification["manualApprovalRequired"])

    def test_existing_canary_entity_blocks_before_planning_or_rendering(self):
        research = {
            "schemaVersion": "1.0",
            "documentId": "dragon_research",
            "entities": [
                {
                    "id": "dragon_monster",
                    "type": "monster",
                    "name": "Dragon",
                    "canonical": True,
                    "sourceRefs": ["tibiawiki"],
                    "facts": {},
                }
            ],
        }
        content_index = {
            "entries": [
                {
                    "type": "monster",
                    "name": "Dragon",
                    "path": "data-otservbr-global/monster/dragon.lua",
                    "datapack": "data-otservbr-global",
                }
            ]
        }

        (ROOT / "artifacts").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=ROOT / "artifacts") as directory:
            output = Path(directory)
            code, summary = run(research, self.registry(), content_index, self.reservations(), output)

            self.assertEqual(code, 2)
            self.assertFalse(summary["ok"])
            self.assertEqual(summary["stage"], "conflict-check")
            self.assertEqual(summary["blockedConflicts"], 1)
            self.assertFalse((output / "CONTENT_PLAN.json").exists())
            self.assertFalse((output / "generated-content").exists())
            self.assertFalse((output / "STAGING_VERIFICATION.json").exists())


if __name__ == "__main__":
    unittest.main()
