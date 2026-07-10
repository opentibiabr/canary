from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("scan_content.py")
SPEC = importlib.util.spec_from_file_location("scan_content", MODULE_PATH)
assert SPEC and SPEC.loader
scan_content = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(scan_content)


class ContentScannerTests(unittest.TestCase):
    def test_indexes_content_and_references(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            monster_dir = root / "data" / "monsters"
            quest_dir = root / "data" / "quests"
            monster_dir.mkdir(parents=True)
            quest_dir.mkdir(parents=True)

            (monster_dir / "dragon.lua").write_text(
                'local mType = Game.createMonsterType("Dragon")\nlocal monster = {}\nmonster.name = "Dragon"\n',
                encoding="utf-8",
            )
            (quest_dir / "dragon_quest.lua").write_text(
                'local name = "Dragon Quest"\nGame.createMonster("Dragon", position)\nplayer:addItem(2160, 1)\nplayer:setStorageValue(58001, 1)\n',
                encoding="utf-8",
            )

            index = scan_content.build_index(root)

            self.assertEqual(index["summary"]["entryCount"], 2)
            self.assertEqual(index["summary"]["countsByType"]["monster"], 1)
            self.assertEqual(index["summary"]["countsByType"]["quest"], 1)

            quest = next(entry for entry in index["entries"] if entry["type"] == "quest")
            self.assertEqual(quest["references"]["monster"], ["Dragon"])
            self.assertEqual(quest["references"]["item"], [2160])
            self.assertEqual(quest["references"]["storage"], [58001])

    def test_reports_duplicate_definitions(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            npc_dir = root / "data" / "npcs"
            npc_dir.mkdir(parents=True)
            (npc_dir / "one.lua").write_text('local name = "Guide"', encoding="utf-8")
            (npc_dir / "two.lua").write_text('local name = "Guide"', encoding="utf-8")

            index = scan_content.build_index(root)

            self.assertEqual(index["summary"]["duplicateDefinitions"], 1)
            self.assertEqual(index["duplicates"][0]["type"], "npc")


if __name__ == "__main__":
    unittest.main()
