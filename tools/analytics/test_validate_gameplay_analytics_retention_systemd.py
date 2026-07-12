#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_retention_systemd as validator


class GameplayAnalyticsRetentionSystemdValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.env_example = validator.ENV_EXAMPLE.read_text(encoding="utf-8")
        self.service = validator.SERVICE.read_text(encoding="utf-8")
        self.timer = validator.TIMER.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_retention_systemd_contract(self) -> None:
        validator.validate_env_example(self.env_example)
        validator.validate_service(self.service)
        validator.validate_timer(self.timer)
        validator.validate_docs(self.docs)

    def test_rejects_default_raw_deletion_enabled(self) -> None:
        broken = self.env_example.replace("DELETE_RAW_SESSIONS=false", "DELETE_RAW_SESSIONS=true", 1)
        with self.assertRaisesRegex(AssertionError, "default raw deletion to false"):
            validator.validate_env_example(broken)

    def test_rejects_committed_password(self) -> None:
        broken = self.env_example.replace("DB_PASSWORD=CHANGE_ME", "DB_PASSWORD=hunter2", 1)
        with self.assertRaisesRegex(AssertionError, "placeholder database password"):
            validator.validate_env_example(broken)

    def test_rejects_missing_reaggregate_window(self) -> None:
        broken = self.env_example.replace("REAGGREGATE_DAYS=7\n", "", 1)
        with self.assertRaisesRegex(AssertionError, "REAGGREGATE_DAYS"):
            validator.validate_env_example(broken)

    def test_rejects_unbounded_reaggregate_default(self) -> None:
        broken = self.env_example.replace("REAGGREGATE_DAYS=7", "REAGGREGATE_DAYS=3650", 1)
        with self.assertRaisesRegex(AssertionError, "seven-day rolling rebuild"):
            validator.validate_env_example(broken)

    def test_rejects_non_oneshot_service(self) -> None:
        broken = self.service.replace("Type=oneshot", "Type=simple", 1)
        with self.assertRaisesRegex(AssertionError, "Type=oneshot"):
            validator.validate_service(broken)

    def test_rejects_service_with_install_section(self) -> None:
        broken = self.service + "\n[Install]\nWantedBy=multi-user.target\n"
        with self.assertRaisesRegex(AssertionError, "activated only by its timer"):
            validator.validate_service(broken)

    def test_rejects_timer_without_persistent(self) -> None:
        broken = self.timer.replace("Persistent=true\n", "", 1)
        with self.assertRaisesRegex(AssertionError, "Persistent=true"):
            validator.validate_timer(broken)

    def test_rejects_missing_uninstall_docs(self) -> None:
        broken = self.docs.replace("### Uninstall", "### Removal")
        with self.assertRaisesRegex(AssertionError, "Uninstall"):
            validator.validate_docs(broken)


if __name__ == "__main__":
    unittest.main()
