#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_migrations as validator


class GameplayAnalyticsMigrationValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.schema = validator.SCHEMA.read_text(encoding="utf-8")
        self.runner = validator.RUNNER.read_text(encoding="utf-8")
        self.guard = validator.SCHEMA_GUARD.read_text(encoding="utf-8")
        self.runtime = validator.RUNTIME.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_migration_contract(self) -> None:
        validator.validate_schema(self.schema)
        validator.validate_migrations()
        validator.validate_runner(self.runner)
        validator.validate_guard(self.guard)
        validator.validate_runtime(self.runtime)
        validator.validate_docs(self.docs)

    def test_rejects_missing_baseline(self) -> None:
        broken = self.schema.replace("VALUES (1, 'baseline', '')", "VALUES (0, 'unknown', '')", 1)
        with self.assertRaisesRegex(AssertionError, "baseline"):
            validator.validate_schema(broken)

    def test_rejects_runner_without_checksum_validation(self) -> None:
        broken = self.runner.replace("checksum mismatch", "migration differs", 1)
        with self.assertRaisesRegex(AssertionError, "checksum mismatch"):
            validator.validate_runner(broken)

    def test_rejects_guard_that_allows_old_schema(self) -> None:
        broken = self.guard.replace("not Analytics.checkSchema()", "false", 1)
        with self.assertRaisesRegex(AssertionError, "blocked"):
            validator.validate_guard(broken)

    def test_rejects_wrong_schema_load_order(self) -> None:
        schema = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")'
        batching = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")'
        broken = self.runtime.replace(f"{schema}\n{batching}", f"{batching}\n{schema}", 1)
        with self.assertRaisesRegex(AssertionError, "load order"):
            validator.validate_runtime(broken)


if __name__ == "__main__":
    unittest.main()
