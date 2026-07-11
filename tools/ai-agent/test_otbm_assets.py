from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_assets import ASSET_INDEX_FORMAT, build_asset_index, resolve_catalog


class ClientAssetIndexTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.assets = self.root / "assets"
        self.assets.mkdir()
        (self.root / "package.json").write_text(
            json.dumps({"name": "Tibia", "version": "15.24", "buildVersion": 1524}),
            encoding="utf-8",
        )
        (self.assets / "assets.json.sha256").write_text("fixture-assets-hash\n", encoding="utf-8")
        (self.assets / "appearances-fixture.dat").write_bytes(b"appearances")
        (self.assets / "sprites-1.lzma").write_bytes(b"sprite-sheet-one")
        (self.assets / "sprites-2.lzma").write_bytes(b"sprite-sheet-two")
        self.write_catalog(
            [
                {"type": "appearances", "file": "appearances-fixture.dat"},
                {"type": "sprite", "file": "sprites-1.lzma", "firstspriteid": 0, "lastspriteid": 99, "spritetype": 0},
                {"type": "sprite", "file": "sprites-2.lzma", "firstspriteid": 100, "lastspriteid": 199, "spritetype": 1},
            ]
        )

    def tearDown(self) -> None:
        self.temp.cleanup()

    def write_catalog(self, entries: object) -> None:
        (self.assets / "catalog-content.json").write_text(json.dumps(entries), encoding="utf-8")

    def test_indexes_valid_assets_from_client_root(self) -> None:
        report = build_asset_index(self.root)
        self.assertEqual(report["format"], ASSET_INDEX_FORMAT)
        self.assertTrue(report["ok"], report["issues"])
        self.assertEqual(report["package"]["version"], "15.24")
        self.assertEqual(report["summary"]["appearancesEntries"], 1)
        self.assertEqual(report["summary"]["spriteEntries"], 2)
        self.assertEqual(report["coverage"]["declaredSpriteCount"], 200)
        self.assertEqual(report["coverage"]["gaps"], [])
        self.assertEqual(report["coverage"]["overlaps"], [])
        self.assertEqual(len(report["appearances"][0]["sha256"]), 64)
        self.assertEqual(report["assetIdentifier"]["value"], "fixture-assets-hash")

    def test_accepts_assets_directory_or_catalog_path(self) -> None:
        catalog = self.assets / "catalog-content.json"
        self.assertEqual(resolve_catalog(self.assets), catalog.resolve())
        self.assertEqual(resolve_catalog(catalog), catalog.resolve())
        self.assertTrue(build_asset_index(self.assets)["ok"])
        self.assertTrue(build_asset_index(catalog)["ok"])

    def test_reports_missing_asset_file(self) -> None:
        (self.assets / "sprites-2.lzma").unlink()
        report = build_asset_index(self.root)
        self.assertFalse(report["ok"])
        self.assertIn("missing_asset_file", {issue["code"] for issue in report["issues"]})
        self.assertEqual(report["summary"]["missingSpriteFiles"], 1)

    def test_rejects_overlapping_ranges(self) -> None:
        self.write_catalog(
            [
                {"type": "appearances", "file": "appearances-fixture.dat"},
                {"type": "sprite", "file": "sprites-1.lzma", "firstspriteid": 0, "lastspriteid": 120, "spritetype": 0},
                {"type": "sprite", "file": "sprites-2.lzma", "firstspriteid": 100, "lastspriteid": 199, "spritetype": 1},
            ]
        )
        report = build_asset_index(self.root)
        self.assertFalse(report["ok"])
        self.assertEqual(report["coverage"]["overlaps"], [{"from": 100, "to": 120}])
        self.assertIn("overlapping_sprite_ranges", {issue["code"] for issue in report["issues"]})

    def test_reports_gaps_without_rejecting_package(self) -> None:
        self.write_catalog(
            [
                {"type": "appearances", "file": "appearances-fixture.dat"},
                {"type": "sprite", "file": "sprites-1.lzma", "firstspriteid": 0, "lastspriteid": 99, "spritetype": 0},
                {"type": "sprite", "file": "sprites-2.lzma", "firstspriteid": 150, "lastspriteid": 199, "spritetype": 1},
            ]
        )
        report = build_asset_index(self.root)
        self.assertTrue(report["ok"])
        self.assertEqual(report["coverage"]["gaps"], [{"from": 100, "to": 149}])
        self.assertIn("sprite_range_gap", {issue["code"] for issue in report["issues"]})

    def test_rejects_unsafe_paths_and_duplicate_appearances(self) -> None:
        self.write_catalog(
            [
                {"type": "appearances", "file": "appearances-fixture.dat"},
                {"type": "appearances", "file": "../outside.dat"},
                {"type": "sprite", "file": "sprites-1.lzma", "firstspriteid": 0, "lastspriteid": 99, "spritetype": 0},
            ]
        )
        report = build_asset_index(self.root)
        codes = {issue["code"] for issue in report["issues"]}
        self.assertFalse(report["ok"])
        self.assertIn("unsafe_asset_filename", codes)
        self.assertIn("appearances_entry_count", codes)

    def test_supports_content_wrapper_and_skipping_hashes(self) -> None:
        entries = json.loads((self.assets / "catalog-content.json").read_text(encoding="utf-8"))
        self.write_catalog({"content": entries})
        report = build_asset_index(self.root, hash_files=False)
        self.assertTrue(report["ok"])
        self.assertIsNone(report["catalog"]["sha256"])
        self.assertIsNone(report["sprites"][0]["sha256"])
        self.assertFalse(report["summary"]["hashesCalculated"])
        self.assertIn("catalog_content_wrapper", {issue["code"] for issue in report["issues"]})

    def test_missing_package_json_is_a_warning_in_summary(self) -> None:
        (self.root / "package.json").unlink()
        report = build_asset_index(self.root)
        self.assertTrue(report["ok"])
        self.assertEqual(report["issueSummary"]["warning"], 1)
        self.assertIn("missing_package_json", {issue["code"] for issue in report["issues"]})


if __name__ == "__main__":
    unittest.main()
