from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("scan_ids.py")
SPEC = importlib.util.spec_from_file_location("scan_ids", MODULE_PATH)
assert SPEC and SPEC.loader
scan_ids = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(scan_ids)


class IdentifierScannerTests(unittest.TestCase):
    def test_detects_supported_identifier_types(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "sample.lua").write_text(
                """
local storage = 58001
player:setStorageValue(58002, 1)
local actionId = 47001
local uniqueId = 48001
Game.createItem(45001, 1, position)
""".strip(),
                encoding="utf-8",
            )
            (root / "sample.xml").write_text(
                '<action actionid="47002" itemid="45002" uniqueid="48002"/>',
                encoding="utf-8",
            )

            registry = scan_ids.build_registry(root)
            namespaces = registry["namespaces"]

            self.assertEqual(
                {entry["value"] for entry in namespaces["storage"]["entries"]},
                {58001, 58002},
            )
            self.assertEqual(
                {entry["value"] for entry in namespaces["actionId"]["entries"]},
                {47001, 47002},
            )
            self.assertEqual(
                {entry["value"] for entry in namespaces["uniqueId"]["entries"]},
                {48001, 48002},
            )
            self.assertEqual(
                {entry["value"] for entry in namespaces["itemId"]["entries"]},
                {45001, 45002},
            )

    def test_reports_cross_file_reuse_as_warning(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "one.lua").write_text("local actionId = 47001", encoding="utf-8")
            (root / "two.xml").write_text('<action actionid="47001"/>', encoding="utf-8")

            registry = scan_ids.build_registry(root)
            conflicts = registry["conflicts"]

            self.assertEqual(len(conflicts), 1)
            self.assertEqual(conflicts[0]["namespace"], "actionId")
            self.assertEqual(conflicts[0]["value"], 47001)
            self.assertEqual(conflicts[0]["severity"], "warning")


if __name__ == "__main__":
    unittest.main()
