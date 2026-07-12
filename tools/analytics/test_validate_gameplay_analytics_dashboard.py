#!/usr/bin/env python3
from __future__ import annotations

import json
import unittest

import validate_gameplay_analytics_dashboard as validator


class GameplayAnalyticsDashboardValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.views = validator.VIEWS.read_text(encoding="utf-8")
        self.dashboard_raw = validator.DASHBOARD.read_text(encoding="utf-8")
        self.datasource_example = validator.DATASOURCE_EXAMPLE.read_text(encoding="utf-8")
        self.dashboard_provisioning_example = validator.DASHBOARD_PROVISIONING_EXAMPLE.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_dashboard_contract(self) -> None:
        validator.validate_views(self.views)
        validator.validate_dashboard(self.dashboard_raw)
        validator.validate_datasource_example(self.datasource_example)
        validator.validate_dashboard_provisioning_example(self.dashboard_provisioning_example)
        validator.validate_docs(self.docs)

    def test_rejects_invalid_json(self) -> None:
        with self.assertRaisesRegex(AssertionError, "not valid"):
            validator.validate_dashboard(self.dashboard_raw + "{not json")

    def test_rejects_missing_view(self) -> None:
        broken = self.views.replace(
            "CREATE OR REPLACE VIEW `analytics_dead_letter_health`",
            "CREATE OR REPLACE VIEW `renamed_view`",
        )
        with self.assertRaisesRegex(AssertionError, "missing repeatable reporting view"):
            validator.validate_views(broken)

    def test_rejects_party_view_using_combined_aggregate(self) -> None:
        broken = self.views.replace("FROM `analytics_daily_party_balance`", "FROM `analytics_daily_balance`", 1)
        with self.assertRaisesRegex(AssertionError, "dedicated party aggregate"):
            validator.validate_views(broken)

    def test_rejects_uncapped_shared_experience(self) -> None:
        broken = self.views.replace("LEAST(100.00, ", "", 1).replace(" AS `shared_experience_percent`", " AS `shared_experience_percent`", 1)
        with self.assertRaisesRegex(AssertionError, "100 percent"):
            validator.validate_views(broken)

    def test_rejects_missing_panel(self) -> None:
        dashboard = json.loads(self.dashboard_raw)
        dashboard["panels"] = [panel for panel in dashboard["panels"] if panel.get("title") != "Pending dead-letter sessions"]
        with self.assertRaisesRegex(AssertionError, "missing required panels"):
            validator.validate_dashboard(json.dumps(dashboard))

    def test_rejects_per_player_variable(self) -> None:
        dashboard = json.loads(self.dashboard_raw)
        dashboard["templating"]["list"].append({"name": "player", "type": "query"})
        with self.assertRaisesRegex(AssertionError, "per-player variables"):
            validator.validate_dashboard(json.dumps(dashboard))

    def test_rejects_non_mariadb_datasource(self) -> None:
        dashboard = json.loads(self.dashboard_raw)
        dashboard["panels"][1]["datasource"]["type"] = "postgres"
        with self.assertRaisesRegex(AssertionError, "mysql \(MariaDB-compatible\) datasource"):
            validator.validate_dashboard(json.dumps(dashboard))

    def test_rejects_committed_datasource_password(self) -> None:
        broken = self.datasource_example.replace("CHANGE_ME", "db.example.com")
        with self.assertRaisesRegex(AssertionError, "placeholder connection values"):
            validator.validate_datasource_example(broken)

    def test_rejects_plaintext_password_field(self) -> None:
        broken = self.datasource_example.replace(
            "datasources:",
            "datasources:\n  - password: hunter2",
        )
        with self.assertRaisesRegex(AssertionError, "must live under secureJsonData"):
            validator.validate_datasource_example(broken)

    def test_rejects_missing_upgrade_docs(self) -> None:
        broken = self.docs.replace("## Upgrade", "## Notes")
        with self.assertRaisesRegex(AssertionError, "Upgrade"):
            validator.validate_docs(broken)


if __name__ == "__main__":
    unittest.main()
