from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("scan_project.py")
SPEC = importlib.util.spec_from_file_location("scan_project", MODULE_PATH)
assert SPEC and SPEC.loader
scan_project = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(scan_project)


class ProjectScannerTests(unittest.TestCase):
    def test_classifies_core_content(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "src").mkdir()
            (root / "src" / "game.cpp").write_text("int main() {}\n", encoding="utf-8")
            (root / "data" / "monsters").mkdir(parents=True)
            (root / "data" / "monsters" / "dragon.lua").write_text("return {}\n", encoding="utf-8")
            (root / "world.otbm").write_bytes(b"OTBM")

            index = scan_project.build_index(root)

            self.assertEqual(index["summary"]["fileCount"], 3)
            self.assertIn("engine", index["categories"])
            self.assertIn("monsters", index["categories"])
            self.assertIn("maps", index["categories"])
            self.assertIn("lua", index["categories"])

    def test_skips_build_directories(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "build").mkdir()
            (root / "build" / "generated.cpp").write_text("ignored", encoding="utf-8")
            (root / "README.md").write_text("included", encoding="utf-8")

            index = scan_project.build_index(root)

            self.assertEqual(index["summary"]["fileCount"], 1)
            self.assertEqual(index["files"][0]["path"], "README.md")


if __name__ == "__main__":
    unittest.main()
