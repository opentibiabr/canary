#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_supply_loot_integration as validator


class GameplayAnalyticsSupplyLootValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.prices = validator.PRICES.read_text(encoding="utf-8")
        self.loot_helper = validator.LOOT_HELPER.read_text(encoding="utf-8")
        self.loot_callback = validator.LOOT_CALLBACK.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")
        self.supply_files = {path: path.read_text(encoding="utf-8") for path in validator.SUPPLY_FILES}

    def test_repository_supply_loot_contract(self) -> None:
        validator.validate_prices(self.prices)
        validator.validate_loot_helper(self.loot_helper)
        validator.validate_loot_callback(self.loot_callback)
        for path, text in self.supply_files.items():
            validator.validate_supply_integration(path, text)

    def test_rejects_price_entry_without_source_comment(self) -> None:
        broken = self.prices.replace("[266] = { buy = 50 }, -- health potion", "[266] = { buy = 50 },")
        with self.assertRaisesRegex(AssertionError, "source comment"):
            validator.validate_prices(broken)

    def test_rejects_guessed_fallback(self) -> None:
        broken = self.prices.replace("return (entry and entry.buy) or 0", "return (entry and entry.buy) or 100")
        with self.assertRaisesRegex(AssertionError, "never a guess"):
            validator.validate_prices(broken)

    def test_rejects_loot_helper_without_guard(self) -> None:
        broken = self.loot_helper.replace("if not analytics or not player or not items then\n\t\treturn\n\tend", "")
        with self.assertRaisesRegex(AssertionError, "no-op when analytics"):
            validator.validate_loot_helper(broken)

    def test_rejects_loot_callback_iterating_party(self) -> None:
        broken = self.loot_callback + "\nlocal participants = player:getParty():getMembers()\n"
        with self.assertRaisesRegex(AssertionError, "double-count"):
            validator.validate_loot_callback(broken)

    def test_rejects_non_recursive_loot_callback(self) -> None:
        broken = self.loot_callback.replace("corpse:getItems(true)", "corpse:getItems(false)")
        with self.assertRaisesRegex(AssertionError, "nested corpse containers"):
            validator.validate_loot_callback(broken)

    def test_rejects_loot_callback_reloading_core(self) -> None:
        broken = self.loot_callback + f'\nlocal Analytics = dofile("{validator.CORE_PATH}")\n'
        with self.assertRaisesRegex(AssertionError, "must not reload"):
            validator.validate_loot_callback(broken)

    def test_rejects_supply_integration_missing_price_table(self) -> None:
        path = validator.SUPPLY_FILES[0]
        broken = self.supply_files[path].replace('dofile("data/scripts/lib/gameplay_analytics_prices.lua")', "")
        with self.assertRaisesRegex(AssertionError, "must load the shared price table"):
            validator.validate_supply_integration(path, broken)

    def test_rejects_supply_integration_reloading_core(self) -> None:
        path = validator.SUPPLY_FILES[0]
        broken = self.supply_files[path] + f'\nlocal Analytics = dofile("{validator.CORE_PATH}")\n'
        with self.assertRaisesRegex(AssertionError, "must not reload"):
            validator.validate_supply_integration(path, broken)


if __name__ == "__main__":
    unittest.main()
