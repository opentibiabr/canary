#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics_deployment as validator


class GameplayAnalyticsDeploymentValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.env_example = validator.ENV_EXAMPLE.read_text(encoding="utf-8")
        self.install = validator.INSTALL.read_text(encoding="utf-8")
        self.docs = validator.DOCS.read_text(encoding="utf-8")

    def test_repository_deployment_contract(self) -> None:
        validator.validate_env_example(self.env_example)
        validator.validate_install_script(self.install)
        validator.validate_docs(self.docs)

    def test_rejects_committed_password(self) -> None:
        broken = self.env_example.replace("DB_PASSWORD=CHANGE_ME", "DB_PASSWORD=hunter2", 1)
        with self.assertRaisesRegex(AssertionError, "placeholder database password"):
            validator.validate_env_example(broken)

    def test_rejects_missing_env_key(self) -> None:
        broken = "\n".join(line for line in self.env_example.splitlines() if not line.startswith("DB_NAME="))
        with self.assertRaisesRegex(AssertionError, "missing keys"):
            validator.validate_env_example(broken)

    def test_rejects_missing_placeholder_guard(self) -> None:
        broken = self.install.replace(
            'if [[ "${DB_PASSWORD}" == "CHANGE_ME" ]]; then\n\techo "DB_PASSWORD still has the placeholder value from gameplay-analytics.env.example; set the real database password before installing" >&2\n\texit 1\nfi\n\n',
            "",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "placeholder password"):
            validator.validate_install_script(broken)

    def test_rejects_config_file_write(self) -> None:
        broken = self.install + '\necho "enabled = true" > data-otservbr-global/scripts/config/gameplay_analytics.lua\n'
        with self.assertRaisesRegex(AssertionError, "never write to the Lua configuration"):
            validator.validate_install_script(broken)

    def test_rejects_in_place_config_edit(self) -> None:
        broken = self.install + "\nsed -i 's/enabled = false/enabled = true/' data-otservbr-global/scripts/config/gameplay_analytics.lua\n"
        with self.assertRaisesRegex(AssertionError, "never edit the Lua configuration"):
            validator.validate_install_script(broken)

    def test_rejects_missing_rollback_section(self) -> None:
        broken = self.docs.replace("## Rollback", "## Notes")
        with self.assertRaisesRegex(AssertionError, "Rollback"):
            validator.validate_docs(broken)


if __name__ == "__main__":
    unittest.main()
