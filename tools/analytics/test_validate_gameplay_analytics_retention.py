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

    def test_rejects_upsert_only_daily_aggregate(self) -> None:
        broken = self.runner.replace("DELETE FROM analytics_daily_balance WHERE session_date", "-- no full-day delete")
        with self.assertRaisesRegex(AssertionError, "delete the complete day"):
            validator.validate_runner(broken)

    def test_rejects_missing_party_split(self) -> None:
        broken = self.runner.replace("analytics_daily_party_balance", "analytics_daily_balance", 1)
        with self.assertRaisesRegex(AssertionError, "analytics_daily_party_balance"):
            validator.validate_runner(broken)

    def test_rejects_missing_rolling_window(self) -> None:
        broken = self.runner.replace('REAGGREGATE_DAYS="${REAGGREGATE_DAYS:-7}"', 'REAGGREGATE_DAYS="${REAGGREGATE_DAYS:-0}"', 1)
        with self.assertRaisesRegex(AssertionError, "bounded recent window"):
            validator.validate_runner(broken)

    def test_rejects_aggregate_level_shared_clamp(self) -> None:
        safe = "COALESCE(SUM(LEAST(COALESCE(shared_experience_seconds, 0), combat_seconds)), 0)"
        unsafe = "LEAST(COALESCE(SUM(shared_experience_seconds), 0), COALESCE(SUM(combat_seconds), 0))"
        broken = self.runner.replace(safe, unsafe)
        with self.assertRaises(AssertionError):
            validator.validate_runner(broken)


if __name__ == "__main__":
    unittest.main()
