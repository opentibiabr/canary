#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_reliability as validator


class GameplayAnalyticsReliabilityValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.config = validator.CONFIG.read_text(encoding="utf-8")
        self.schema = validator.SCHEMA.read_text(encoding="utf-8")
        self.reliability = validator.RELIABILITY.read_text(encoding="utf-8")
        self.runtime = validator.RUNTIME.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_reliability_contract(self) -> None:
        validator.validate_config(self.config)
        validator.validate_schema(self.schema)
        validator.validate_reliability(self.reliability)
        validator.validate_runtime(self.runtime)
        validator.validate_docs(self.docs)

    def test_rejects_unbounded_retries(self) -> None:
        broken = self.reliability.replace(
            "session.retryCount > maxRetryAttempts()",
            "false",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "bounded"):
            validator.validate_reliability(broken)

    def test_rejects_missing_exponential_backoff(self) -> None:
        broken = self.reliability.replace("2 ^ exponent", "1", 1)
        with self.assertRaisesRegex(AssertionError, "exponential backoff"):
            validator.validate_reliability(broken)

    def test_rejects_non_idempotent_dead_letter_schema(self) -> None:
        broken = self.schema.replace(
            "UNIQUE KEY `analytics_dead_letters_uuid` (`session_uuid`)",
            "KEY `analytics_dead_letters_uuid` (`session_uuid`)",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "idempotent"):
            validator.validate_schema(broken)

    def test_rejects_runtime_without_reliability_layer(self) -> None:
        broken = self.runtime.replace(
            'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")',
            "",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "explicitly load"):
            validator.validate_runtime(broken)

    def test_rejects_missing_flush_failure_counter(self) -> None:
        broken = self.reliability.replace(
            "Analytics._reliabilityCurrentFlushFailures",
            "Analytics.discardedFlushFailureCounter",
        )
        with self.assertRaisesRegex(AssertionError, "counted once"):
            validator.validate_reliability(broken)

    def test_rejects_missing_health_field(self) -> None:
        broken = self.reliability.replace("\tlastFlushDurationMs = 0,\n", "", 1)
        with self.assertRaisesRegex(AssertionError, "health fields"):
            validator.validate_reliability(broken)

    def test_rejects_unbounded_dead_letter_queue(self) -> None:
        broken = self.config.replace("\tdeadLetterQueueLimit = 1000,\n", "", 1)
        with self.assertRaisesRegex(AssertionError, "deadLetterQueueLimit"):
            validator.validate_config(broken)

    def test_rejects_database_disabled_retry_retention(self) -> None:
        broken = self.reliability.replace(
            "\t\tlocal queued = #Analytics.queue\n\t\tAnalytics.deadLetterQueue = {}",
            "\t\tlocal queued = #Analytics.queue",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "drain delayed retries"):
            validator.validate_reliability(broken)


if __name__ == "__main__":
    unittest.main()
