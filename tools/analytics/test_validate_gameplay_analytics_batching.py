#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_batching as validator


class GameplayAnalyticsBatchingValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.config = validator.CONFIG.read_text(encoding="utf-8")
        self.batching = validator.BATCHING.read_text(encoding="utf-8")
        self.runtime = validator.RUNTIME.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_batching_contract(self) -> None:
        validator.validate_config(self.config)
        validator.validate_batching(self.batching)
        validator.validate_runtime(self.runtime)
        validator.validate_docs(self.docs)

    def test_rejects_unbounded_batch_size(self) -> None:
        broken = self.batching.replace(
            "clampInteger(Analytics.config.detailBatchSize, 1, 1000, 250)",
            "tonumber(Analytics.config.detailBatchSize) or 250",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "bounded"):
            validator.validate_batching(broken)

    def test_rejects_single_row_detail_path(self) -> None:
        broken = self.batching.replace('table.concat(batch, ",")', 'batch[1]', 1)
        with self.assertRaisesRegex(AssertionError, "multi-row"):
            validator.validate_batching(broken)

    def test_rejects_wrong_load_order(self) -> None:
        batching = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")'
        reliability = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")'
        broken = self.runtime.replace(
            f"{batching}\n{reliability}",
            f"{reliability}\n{batching}",
            1,
        )
        self.assertNotEqual(broken, self.runtime, "load-order mutation must alter the runtime fixture")
        with self.assertRaisesRegex(AssertionError, "load order"):
            validator.validate_runtime(broken)

    def test_rejects_missing_failure_requeue(self) -> None:
        broken = self.batching.replace("\t\t\tAnalytics.enqueue(session)\n", "", 1)
        with self.assertRaisesRegex(AssertionError, "requeued"):
            validator.validate_batching(broken)


if __name__ == "__main__":
    unittest.main()
