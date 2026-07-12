#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gameplay_analytics_hunt_areas_lib import HuntAreaError, format_lua_table, parse_candidate_file, parse_lua_config, validate_areas  # noqa: E402

FIXTURES = Path(__file__).resolve().parent / "fixtures/hunt_areas"


class HuntAreaParsingTest(unittest.TestCase):
    def test_parses_valid_candidate_file(self) -> None:
        areas = parse_candidate_file(FIXTURES / "valid.json")
        self.assertEqual(len(areas), 3)
        self.assertEqual(areas[0].name, "fixture-area-alpha")
        self.assertEqual((areas[0].from_x, areas[0].from_y, areas[0].from_z), (100, 100, 7))
        self.assertEqual((areas[0].to_x, areas[0].to_y, areas[0].to_z), (199, 199, 7))

    def test_parses_lua_hunt_areas_block(self) -> None:
        text = """
        return {
            enabled = false,
            huntAreas = {
                {
                    name = "lua-fixture-area",
                    from = { x = 10, y = 20, z = 7 },
                    to = { x = 30, y = 40, z = 7 },
                },
            },
            detailLevel = 1,
        }
        """
        areas = parse_lua_config(text, "fixture")
        self.assertEqual(len(areas), 1)
        self.assertEqual(areas[0].name, "lua-fixture-area")
        self.assertEqual((areas[0].from_x, areas[0].from_y, areas[0].from_z), (10, 20, 7))

    def test_parses_empty_lua_hunt_areas(self) -> None:
        areas = parse_lua_config("return { huntAreas = {}, enabled = false }", "fixture")
        self.assertEqual(areas, [])

    def test_rejects_missing_hunt_areas_block(self) -> None:
        with self.assertRaisesRegex(HuntAreaError, "could not find"):
            parse_lua_config("return { enabled = false }", "fixture")

    def test_rejects_inverted_coordinates(self) -> None:
        with self.assertRaisesRegex(HuntAreaError, "must not be greater than"):
            parse_candidate_file(FIXTURES / "malformed_coordinates.json")

    def test_rejects_out_of_range_floor(self) -> None:
        with self.assertRaisesRegex(HuntAreaError, "valid floor range"):
            parse_candidate_file(FIXTURES / "out_of_range.json")


class HuntAreaValidationTest(unittest.TestCase):
    def test_accepts_non_overlapping_areas(self) -> None:
        areas = parse_candidate_file(FIXTURES / "valid.json")
        self.assertEqual(validate_areas(areas), [])

    def test_rejects_overlapping_areas(self) -> None:
        areas = parse_candidate_file(FIXTURES / "overlapping.json")
        problems = validate_areas(areas)
        self.assertEqual(len(problems), 1)
        self.assertIn("overlapping hunt areas", problems[0])

    def test_rejects_case_insensitive_duplicate_names(self) -> None:
        areas = parse_candidate_file(FIXTURES / "duplicate_name.json")
        problems = validate_areas(areas)
        self.assertEqual(len(problems), 1)
        self.assertIn("duplicate hunt area name", problems[0])

    def test_same_footprint_different_floor_does_not_overlap(self) -> None:
        areas = parse_candidate_file(FIXTURES / "valid.json")
        alpha = next(a for a in areas if a.name == "fixture-area-alpha")
        gamma = next(a for a in areas if a.name == "fixture-area-gamma-different-floor")
        self.assertFalse(alpha.overlaps(gamma))


class HuntAreaFormattingTest(unittest.TestCase):
    def test_format_lua_table_round_trips(self) -> None:
        areas = parse_candidate_file(FIXTURES / "valid.json")
        lua_text = format_lua_table(areas)
        self.assertTrue(lua_text.startswith("huntAreas = {"))
        self.assertTrue(lua_text.endswith("}"))
        reparsed = parse_lua_config(f"return {{ {lua_text} }}", "round-trip")
        self.assertEqual(len(reparsed), len(areas))
        self.assertEqual({a.name for a in reparsed}, {a.name for a in areas})


if __name__ == "__main__":
    unittest.main()
