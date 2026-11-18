import importlib.util
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("world_smoke", ROOT / ".github/scripts/smoke_test_canary.py")
smoke = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(smoke)


class LegacyStartupWarningTests(unittest.TestCase):
    def setUp(self):
        self.message = smoke.legacy_warning("data-canary")
        self.warning = f"[2026-09-11 12:00:00.000] [warning] {self.message} "

    def test_expected_warning_is_required_once(self):
        smoke.assert_clean_log(self.warning, True, self.message)
        smoke.assert_clean_log(self.warning.replace("] [warning]", "] [thread 12] [warning]"), True, self.message)
        for content in ["[info] server online!", self.warning + "\n" + self.warning]:
            with self.assertRaises(RuntimeError):
                smoke.assert_clean_log(content, True, self.message)

    def test_other_warning_or_error_is_not_exempt(self):
        for extra in ["[warning] Another problem", "[error] database unavailable"]:
            with self.assertRaises(RuntimeError):
                smoke.assert_clean_log(self.warning + "\n" + extra, True, self.message)
        with self.assertRaises(RuntimeError):
            smoke.assert_clean_log(self.warning, True)


if __name__ == "__main__":
    unittest.main()
