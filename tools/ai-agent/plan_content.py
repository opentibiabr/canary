#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from id_allocator import find_range
from io_utils import atomic_write_json, dumps_json, read_json


def _stem(name: str) -> str:
    value = re.sub(r"[^a-z0-9_-]+", "_", name.lower()).strip("_")
    if not value:
        raise ValueError("name does not produce a safe filename")
    return value


def _component_path(task_id: str, component: dict) -> str:
    component_type = component["type"]
    extension = ".xml" if component_type == "raid" else ".lua"
    return f'artifacts/generated-content/{task_id}/{component_type}/{_stem(component["name"])}{extension}'


def plan(task, content, registry, reservations):
    task_id = task["taskId"]
    task_type = task["type"]
    name = task["name"]
    datapack = task["targetDatapack"]
    result = {
        "taskId": task_id,
        "type": task_type,
        "name": name,
        "targetDatapack": datapack,
        "dryRun": task.get("dryRun"),
        "newFiles": [],
        "modifyFiles": [],
        "proposedStorage": [],
        "proposedActionIds": [],
        "proposedUniqueIds": [],
        "monsterReferences": [],
        "npcReferences": [],
        "itemReferences": [],
        "requiredEvents": [],
        "implementationOrder": [
            "validate task spec",
            "reserve identifiers",
            "render Canary-compatible preview",
            "human review",
            "manual apply",
        ],
        "testPlan": [
            "run unit tests",
            "validate content plan",
            "validate generated manifest",
            "check Canary registration markers",
            "review generated previews",
        ],
        "rollbackPlan": [
            "discard preview artifacts",
            "release reserved identifiers if not used",
        ],
        "manualSteps": [],
        "mapRequirements": [],
        "warnings": [],
        "blockers": [],
        "riskLevel": "low",
    }

    if task_type == "quest":
        quest = task.get("quest", {})
        result["newFiles"] = [f"artifacts/generated-content/{task_id}/quest/{_stem(name)}.lua"]
        result["proposedStorage"] = [
            {
                "id": quest.get("storage", {}).get(
                    "progress", find_range(registry, reservations, "storage", 1, 300000, 399999)[0]
                ),
                "purpose": "quest progress",
            }
        ]
        for action_id in quest.get("requiredActionIds", []):
            result["proposedActionIds"].append({"id": action_id, "purpose": "requested quest action"})
        result["monsterReferences"] = [monster for stage in quest.get("stages", []) for monster in stage.get("monsters", [])]
        result["npcReferences"] = [quest.get("starterNpc")] if quest.get("starterNpc") else []
        result["itemReferences"] = [reward.get("itemId") for reward in quest.get("rewards", []) if reward.get("itemId")]
        if quest.get("mapRequirements"):
            result["mapRequirements"] = quest["mapRequirements"]
            result["manualSteps"].append("Apply map changes manually; OTBM files are never edited by this pipeline.")
    elif task_type == "content_bundle":
        bundle = task["contentBundle"]
        components = bundle["components"]
        result["newFiles"] = [_component_path(task_id, component) for component in components]
        result["componentPlan"] = [
            {
                "id": component["id"],
                "type": component["type"],
                "name": component["name"],
                "path": _component_path(task_id, component),
                "dependsOn": component.get("dependsOn", []),
            }
            for component in components
        ]
        for reservation in bundle.get("requestedIds", []):
            namespace = reservation["namespace"]
            count = int(reservation.get("count", 1))
            minimum = int(reservation.get("min", 1))
            maximum = int(reservation.get("max", 2147483647))
            start, end = find_range(registry, reservations, namespace, count, minimum, maximum)
            key = {
                "storage": "proposedStorage",
                "actionId": "proposedActionIds",
                "uniqueId": "proposedUniqueIds",
            }[namespace]
            purpose = reservation.get("purpose", "content bundle identifier")
            for value in range(start, end + 1):
                result[key].append({"id": value, "purpose": purpose})
        result["mapRequirements"] = bundle.get("mapRequirements", [])
        if result["mapRequirements"]:
            result["manualSteps"].append("Create and place map elements manually; OTBM files are never edited by this pipeline.")
        result["manualSteps"].extend(bundle.get("manualSteps", []))
        result["riskLevel"] = "medium" if result["mapRequirements"] else "low"
    elif task_type == "instance":
        result["newFiles"] = [f"artifacts/generated-content/{task_id}/instance/{_stem(name)}.lua"]
        result["manualSteps"] = ["Create or edit map areas manually outside this dry-run pipeline."]
        result["mapRequirements"] = task.get("instance", {}).get("mapRequirements", [])
        result["riskLevel"] = "medium"
    else:
        extension = ".xml" if task_type == "raid" else ".lua"
        result["newFiles"] = [f"artifacts/generated-content/{task_id}/{task_type}/{_stem(name)}{extension}"]
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--content-index", required=True)
    parser.add_argument("--registry", required=True)
    parser.add_argument("--reservations", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    result = plan(
        read_json(args.task),
        read_json(args.content_index),
        read_json(args.registry),
        read_json(args.reservations),
    )
    atomic_write_json(args.output, result)
    print(dumps_json(result), end="")


if __name__ == "__main__":
    raise SystemExit(main())
