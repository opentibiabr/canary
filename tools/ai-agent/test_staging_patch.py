from __future__ import annotations

import hashlib
import importlib.util
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = ROOT / "tools/ai-agent/generate_staging_patch.py"
SPEC = importlib.util.spec_from_file_location("generate_staging_patch", MODULE_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class StagingPatchTests(unittest.TestCase):
    def _handoff(self, content: bytes, status: str = "ready-for-manual-review") -> dict:
        return {
            "taskId": "sample",
            "handoffStatus": status,
            "automaticApplyAllowed": False,
            "manualApprovalRequired": True,
            "files": [
                {
                    "previewPath": "sample/npc/example.lua",
                    "targetPath": "data-otservbr-global/npc/example.lua",
                    "sha256": hashlib.sha256(content).hexdigest(),
                }
            ],
        }

    def test_generates_new_file_patch_without_writing_repository(self):
        content = b"return true\n"
        with tempfile.TemporaryDirectory() as generated_dir, tempfile.TemporaryDirectory() as repository_dir:
            source = Path(generated_dir) / "sample/npc/example.lua"
            source.parent.mkdir(parents=True)
            source.write_bytes(content)

            result, patch = MODULE.generate(self._handoff(content), Path(generated_dir), Path(repository_dir))

            self.assertEqual(result["status"], "ready-for-manual-application")
            self.assertTrue(result["patchGenerated"])
            self.assertIn("b/data-otservbr-global/npc/example.lua", patch)
            self.assertFalse((Path(repository_dir) / "data-otservbr-global/npc/example.lua").exists())

    def test_existing_target_blocks_patch(self):
        content = b"return true\n"
        with tempfile.TemporaryDirectory() as generated_dir, tempfile.TemporaryDirectory() as repository_dir:
            source = Path(generated_dir) / "sample/npc/example.lua"
            source.parent.mkdir(parents=True)
            source.write_bytes(content)
            target = Path(repository_dir) / "data-otservbr-global/npc/example.lua"
            target.parent.mkdir(parents=True)
            target.write_text("existing\n", encoding="utf-8")

            result, patch = MODULE.generate(self._handoff(content), Path(generated_dir), Path(repository_dir))

            self.assertEqual(result["status"], "blocked")
            self.assertFalse(result["patchGenerated"])
            self.assertEqual(patch, "")
            self.assertIn("collision", {item["category"] for item in result["findings"]})

    def test_blocked_handoff_never_generates_patch(self):
        content = b"return true\n"
        with tempfile.TemporaryDirectory() as generated_dir, tempfile.TemporaryDirectory() as repository_dir:
            source = Path(generated_dir) / "sample/npc/example.lua"
            source.parent.mkdir(parents=True)
            source.write_bytes(content)

            result, patch = MODULE.generate(
                self._handoff(content, status="blocked"), Path(generated_dir), Path(repository_dir)
            )

            self.assertEqual(result["status"], "blocked")
            self.assertFalse(result["patchGenerated"])
            self.assertEqual(patch, "")

    def test_rejects_prohibited_and_unsafe_paths(self):
        content = b"x"
        handoff = self._handoff(content)
        handoff["files"][0]["targetPath"] = "../items.otb"
        with tempfile.TemporaryDirectory() as generated_dir, tempfile.TemporaryDirectory() as repository_dir:
            source = Path(generated_dir) / "sample/npc/example.lua"
            source.parent.mkdir(parents=True)
            source.write_bytes(content)
            with self.assertRaises(ValueError):
                MODULE.generate(handoff, Path(generated_dir), Path(repository_dir))


if __name__ == "__main__":
    unittest.main()
