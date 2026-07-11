from __future__ import annotations

import sys
import unittest
from pathlib import Path

MODULE_DIR = Path(__file__).parent
REPOSITORY_ROOT = MODULE_DIR.parent.parent
sys.path.insert(0, str(MODULE_DIR))

from otbm_catalog import load_item_catalog


class RepositoryItemCatalogTests(unittest.TestCase):
    def test_repository_items_xml_builds_a_catalog(self) -> None:
        items_xml = REPOSITORY_ROOT / "data/items/items.xml"
        self.assertTrue(items_xml.is_file(), f"Missing repository item definitions: {items_xml}")
        catalog = load_item_catalog(items_xml)
        self.assertGreater(len(catalog.items), 1000)
        self.assertGreater(sum(1 for item in catalog.items.values() if item.name), 100)
        self.assertEqual(len(catalog.sha256), 64)


if __name__ == "__main__":
    unittest.main()
