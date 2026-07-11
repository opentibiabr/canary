#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_retention as validator


class GameplayAnalyticsRetentionValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.schema = validator.SCHEMA.read_text(encoding="utf-8")
        self.runner = validator.RUNNER.read_text(encoding="utf-8")
        self.test = validator.TEST.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_retention_contract(self) -> None:
        validator.validate_schema(self.schema)
        validator.validate_runner(self.runner)
        validator.validate_test(self.test)
        validator.validate_docs(self.docs)

    def test_rejects_default_raw_deletion(self) -> None:
        broken = self.runner.replace(
            'DELETE_RAW_SESSIONS="${DELETE_RAW_SESSIONS:-false}"',
            'DELETE_RAW_SESSIONS="${DELETE_RAW_SESSIONS:-true}"',
            1,
        )
        with self.assertRaisesRegex(AssertionError, "disabled by default"):
            validator.validate_runner(broken)

    def test_rejects_uncheckpointed_delete(self) -> None:
        broken = self.runner.replace(
            "started_at < UNIX_TIMESTAMP(DATE_ADD('${aggregate_through}', INTERVAL 1 DAY))",
            "started_at < UNIX_TIMESTAMP('${retention_cutoff} 00:00:00')",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "checkpoint"):
            validator.validate_runner(broken)

    def test_rejects_unbounded_delete(self) -> None:
        broken = self.runner.replace("LIMIT ${DELETE_BATCH_SIZE}", "", 1)
        with self.assertRaisesRegex(AssertionError, "batched"):
            validator.validate_runner(broken)

    def test_rejects_non_idempotent_aggregate(self) -> None:
        broken = self.runner.replace("ON DUPLICATE KEY UPDATE", "ON DUPLICATE KEY IGNORE", 1)
        with self.assertRaisesRegex(AssertionError, "ON DUPLICATE KEY UPDATE"):
            validator.validate_runner(broken)


if __name__ == "__main__":
    unittest.main()
