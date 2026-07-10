from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/ai-agent"))
sys.path.insert(0, str(ROOT / "tools/ai-agent/lib"))

from id_allocator import add_reservation, find_range
from path_policy import is_safe_write
from task_validation import *  # noqa: F401,F403


def load(name):
    path = ROOT / "tools/ai-agent" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


validate_task = load("validate_task_spec").validate
make_plan = load("plan_content").plan
validate_plan = load("validate_content_plan").validate
render = load("render_content").render


class PipelineTests(unittest.TestCase):
    def registry(self):
        return {
            "namespaces": {
                "storage": {"entries": {"300000": []}},
                "actionId": {"entries": {}},
                "uniqueId": {"entries": {}},
                "itemId": {"entries": {"2160": []}},
            }
        }

    def reservations(self):
        return {"schemaVersion": "1.0", "reservations": []}

    def task(self):
        return json.loads((ROOT / "docs/ai-agent/examples/forgotten_forge.quest.json").read_text())

    def test_allocator_finds_free_range_deterministically(self):
        self.assertEqual(find_range(self.registry(), self.reservations(), "storage", 2, 300000, 300010), (300001, 300002))
        self.assertEqual(find_range(self.registry(), self.reservations(), "storage", 2, 300000, 300010), (300001, 300002))

    def test_allocator_overlap_and_release(self):
        reservations = self.reservations()
        add_reservation(reservations, "a", "storage", 10, 12, "data", "x")
        with self.assertRaises(ValueError):
            add_reservation(reservations, "b", "storage", 12, 13, "data", "x")
        reservations["reservations"][0]["status"] = "released"
        self.assertEqual(find_range({}, reservations, "storage", 1, 10, 10), (10, 10))

    def test_allocator_no_range_and_invalid_namespace(self):
        with self.assertRaises(RuntimeError):
            find_range(self.registry(), self.reservations(), "storage", 1, 300000, 300000)
        with self.assertRaises(ValueError):
            find_range({}, {}, "bad", 1)

    def test_task_validator_quest(self):
        self.assertTrue(validate_task(self.task())["ok"])

    def test_task_validator_missing_reference(self):
        task = self.task()
        task["quest"]["stages"][1]["dependsOn"] = ["missing"]
        self.assertFalse(validate_task(task)["ok"])

    def test_task_validator_rejects_path_traversal(self):
        task = self.task()
        task["taskId"] = "../escape"
        self.assertFalse(validate_task(task)["ok"])
        task = self.task()
        task["name"] = "../../items.otb"
        self.assertFalse(validate_task(task)["ok"])

    def test_planner_and_plan_validator(self):
        registry = self.registry()
        reservations = self.reservations()
        add_reservation(reservations, "forgotten_forge", "storage", 300001, 300001, "data-otservbr-global", "x")
        plan = make_plan(self.task(), {}, registry, reservations)
        self.assertIn("rollbackPlan", plan)
        self.assertTrue(validate_plan(plan, registry, reservations)["ok"])

    def test_renderer_writes_only_artifacts(self):
        (ROOT / "artifacts").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=ROOT / "artifacts") as directory:
            task = self.task()
            plan = make_plan(task, {}, self.registry(), self.reservations())
            manifest = render(task, plan, directory)
            self.assertEqual(len(manifest["files"]), 1)
            self.assertIn("sha256", manifest["files"][0])

    def test_renderer_rejects_escaping_task_id(self):
        (ROOT / "artifacts").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=ROOT / "artifacts") as directory:
            task = self.task()
            task["taskId"] = "../escape"
            with self.assertRaises(ValueError):
                render(task, {}, directory)

    def test_path_policy_rejects_repository_prefix_escape(self):
        fake_root = ROOT / "artifacts" / "repo"
        outside = ROOT / "artifacts" / "repository-escape" / "file.txt"
        ok, _ = is_safe_write(outside, root=fake_root, output_root=fake_root / "artifacts")
        self.assertFalse(ok)

    def test_instance_basic_plan(self):
        task = self.task()
        task["type"] = "instance"
        task["taskId"] = "inst"
        task["instance"] = {"mapRequirements": ["manual room"]}
        plan = make_plan(task, {}, self.registry(), self.reservations())
        self.assertIn("manual", " ".join(plan["manualSteps"]).lower())

    def test_plan_blocks_otbm_and_items_otb(self):
        plan = {
            "targetDatapack": ".",
            "newFiles": ["data/map/world.otbm", "items.otb"],
            "modifyFiles": [],
            "rollbackPlan": ["x"],
            "testPlan": ["x"],
        }
        self.assertFalse(validate_plan(plan, self.registry(), self.reservations())["ok"])


if __name__ == "__main__":
    unittest.main()
