#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from verify_staging_patch import verify


class StagingPatchVerifierTests(unittest.TestCase):
    def _fixture(self) -> tuple[dict, str]:
        content = "return true\n"
        digest = hashlib.sha256(content.encode("utf-8")).hexdigest()
        target = "data-otservbr-global/scripts/quests/example.lua"
        patch = (
            f"diff --git a/{target} b/{target}\n"
            "new file mode 100644\n"
            "--- /dev/null\n"
            f"+++ b/{target}\n"
            "@@ -0,0 +1 @@\n"
            "+return true\n"
        )
        plan = {
            "taskId": "example",
            "status": "ready-for-manual-application",
            "patchGenerated": True,
            "automaticApplyAllowed": False,
            "manualApprovalRequired": True,
            "files": [
                {
                    "targetPath": target,
                    "sha256": digest,
                    "operation": "create",
                }
            ],
        }
        return plan, patch

    def test_applies_verifies_and_rolls_back_in_isolated_sandbox(self) -> None:
        plan, patch = self._fixture()
        report = verify(plan, patch)

        self.assertTrue(report["verified"])
        self.assertEqual(report["status"], "verified-in-isolated-sandbox")
        self.assertEqual(report["summary"]["verifiedFileCount"], 1)
        self.assertTrue(report["summary"]["applyCheckPassed"])
        self.assertTrue(report["summary"]["applyPassed"])
        self.assertTrue(report["summary"]["rollbackPassed"])
        self.assertFalse(report["automaticApplyAllowed"])

    def test_rejects_checksum_mismatch(self) -> None:
        plan, patch = self._fixture()
        plan["files"][0]["sha256"] = "0" * 64

        report = verify(plan, patch)

        self.assertFalse(report["verified"])
        self.assertEqual(report["status"], "blocked")
        self.assertIn("checksum", {item["category"] for item in report["findings"]})

    def test_rejects_blocked_plan_without_applying(self) -> None:
        plan, patch = self._fixture()
        plan["status"] = "blocked"

        report = verify(plan, patch)

        self.assertFalse(report["verified"])
        self.assertFalse(report["summary"]["applyCheckPassed"])
        self.assertIn("plan", {item["category"] for item in report["findings"]})

    def test_rejects_prohibited_target(self) -> None:
        plan, patch = self._fixture()
        plan["files"][0]["targetPath"] = "data/world.otbm"

        with self.assertRaisesRegex(ValueError, "prohibited target path"):
            verify(plan, patch)


if __name__ == "__main__":
    unittest.main()
