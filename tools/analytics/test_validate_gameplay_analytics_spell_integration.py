#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_spell_integration as validator


class GameplayAnalyticsSpellIntegrationValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.helper = validator.HELPER.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")
        self.integrated = {path: path.read_text(encoding="utf-8") for path in validator.INTEGRATED_FILES}

    def test_repository_spell_integration_contract(self) -> None:
        validator.validate_helper(self.helper)
        for path, text in self.integrated.items():
            validator.validate_integrated_file(path, text)
        validator.validate_no_double_counting_regressions()
        validator.validate_docs(self.docs)

    def test_rejects_helper_without_nil_guard(self) -> None:
        broken = self.helper.replace("if not analytics then\n\t\treturn execute()\n\tend", "")
        with self.assertRaisesRegex(AssertionError, "no-op when analytics is unavailable"):
            validator.validate_helper(broken)

    def test_rejects_helper_calling_forbidden_functions_directly(self) -> None:
        broken = self.helper + "\nAnalytics.recordManaSpent(caster, 10)\n"
        with self.assertRaisesRegex(AssertionError, "must never call"):
            validator.validate_helper(broken)

    def test_rejects_integrated_file_missing_helper_load(self) -> None:
        path = validator.INTEGRATED_FILES[0]
        broken = self.integrated[path].replace('dofile("data/scripts/lib/gameplay_analytics_spell.lua")', "")
        with self.assertRaisesRegex(AssertionError, "shared spell analytics helper"):
            validator.validate_integrated_file(path, broken)

    def test_rejects_integrated_file_reloading_core(self) -> None:
        path = validator.INTEGRATED_FILES[0]
        broken = self.integrated[path] + f'\nlocal Analytics = dofile("{validator.CORE_PATH}")\n'
        with self.assertRaisesRegex(AssertionError, "must not reload"):
            validator.validate_integrated_file(path, broken)

    def test_rejects_integrated_file_without_live_global(self) -> None:
        path = validator.INTEGRATED_FILES[0]
        broken = self.integrated[path].replace("GameplayAnalytics", "nil")
        with self.assertRaisesRegex(AssertionError, "live GameplayAnalytics global"):
            validator.validate_integrated_file(path, broken)

    def test_rejects_integrated_file_with_direct_recording_call(self) -> None:
        path = validator.INTEGRATED_FILES[0]
        broken = self.integrated[path] + "\nAnalytics.recordHealing(creature, creature, 10, 0)\n"
        with self.assertRaisesRegex(AssertionError, "must never call"):
            validator.validate_integrated_file(path, broken)

    def test_rejects_missing_double_counting_docs(self) -> None:
        broken = self.docs.replace("double-count", "duplicate")
        with self.assertRaisesRegex(AssertionError, "double-count"):
            validator.validate_docs(broken)


if __name__ == "__main__":
    unittest.main()
