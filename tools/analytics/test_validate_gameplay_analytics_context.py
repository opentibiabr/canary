#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_context as validator


class GameplayAnalyticsContextValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.config = validator.CONFIG.read_text(encoding="utf-8")
        self.context = validator.CONTEXT.read_text(encoding="utf-8")
        self.batching = validator.BATCHING.read_text(encoding="utf-8")
        self.schema_guard = validator.SCHEMA_GUARD.read_text(encoding="utf-8")
        self.runtime = validator.RUNTIME.read_text(encoding="utf-8")
        self.migration = validator.MIGRATION.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_context_contract(self) -> None:
        validator.validate_config(self.config)
        validator.validate_context(self.context)
        validator.validate_migration(self.migration)
        validator.validate_batching(self.batching)
        validator.validate_schema_guard(self.schema_guard)
        validator.validate_runtime(self.runtime)
        validator.validate_docs(self.docs)

    def test_rejects_unthrottled_sampling(self) -> None:
        broken = self.context.replace(
            "timestamp - session.contextLastAt < sampleInterval",
            "false",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "throttled"):
            validator.validate_context(broken)

    def test_rejects_uncapped_context_gap(self) -> None:
        broken = self.context.replace(
            "delta = math.min(delta, clampInteger(Analytics.config.contextMaxGapSeconds, 1, 120, 10))",
            "delta = math.max(delta, clampInteger(Analytics.config.contextMaxGapSeconds, 1, 120, 10))",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "capped"):
            validator.validate_context(broken)

    def test_rejects_exact_coordinate_fallback(self) -> None:
        broken = self.context.replace(
            'string.format("grid:%d:%d:%d", math.floor(position.x / gridSize), math.floor(position.y / gridSize), position.z)',
            'string.format("position:%d:%d:%d", position.x, position.y, position.z)',
            1,
        )
        with self.assertRaisesRegex(AssertionError, "coarse grid"):
            validator.validate_context(broken)

    def test_rejects_missing_session_context_upsert(self) -> None:
        broken = self.batching.replace("`hunt_area`=VALUES(`hunt_area`),", "", 1)
        self.assertNotEqual(broken, self.batching, "upsert mutation must alter the batching fixture")
        with self.assertRaisesRegex(AssertionError, "hunt_area"):
            validator.validate_batching(broken)

    def test_rejects_wrong_context_load_order(self) -> None:
        core = 'local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")'
        context = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_context.lua")'
        schema = 'Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")'
        broken = self.runtime.replace(
            f"{core}\n{context}\n{schema}",
            f"{core}\n{schema}\n{context}",
            1,
        )
        self.assertNotEqual(broken, self.runtime, "load-order mutation must alter the runtime fixture")
        with self.assertRaisesRegex(AssertionError, "load order"):
            validator.validate_runtime(broken)


if __name__ == "__main__":
    unittest.main()
