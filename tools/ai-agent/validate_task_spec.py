#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from io_utils import atomic_write_json, dumps_json, read_json

TYPES = {"quest", "monster", "npc", "spell", "raid", "instance", "content_bundle"}
BUNDLE_COMPONENT_TYPES = {"quest", "monster", "npc", "spell", "raid"}
SOURCE_KINDS = {"official", "community-wiki", "repository", "manual", "inference"}
CONFIDENCE_LEVELS = {"high", "medium", "low"}
SAFE_TASK_ID = re.compile(r"^[a-z0-9][a-z0-9_-]{0,63}$")
DATE_VALUE = re.compile(r"^\d{4}-\d{2}-\d{2}$")

PAYLOAD_KEYS = {
    "quest": {
        "cooldown",
        "dependsOnQuests",
        "requiredActionIds",
        "requiredLevel",
        "requiredUniqueIds",
        "requiredVocations",
        "repeatable",
        "rewards",
        "starterNpc",
        "storage",
        "stages",
        "mapRequirements",
    },
    "monster": {
        "health",
        "maxHealth",
        "experience",
        "speed",
        "race",
        "corpse",
        "outfit",
        "flags",
        "attacks",
        "defenses",
        "elements",
        "immunities",
        "voices",
        "loot",
        "summons",
        "events",
    },
    "npc": {"outfit", "flags", "dialogue", "shop", "voices", "events"},
    "spell": {
        "words",
        "level",
        "mana",
        "cooldown",
        "groupCooldown",
        "vocations",
        "premium",
        "aggressive",
        "target",
        "range",
        "damage",
        "effects",
    },
    "raid": {"interval", "margin", "repeatable", "steps"},
    "instance": {
        "template",
        "entry",
        "exit",
        "duration",
        "capacity",
        "resetPolicy",
        "map",
        "mapRequirements",
        "encounters",
        "rewards",
    },
}
CONTENT_BUNDLE_KEYS = {"components", "requestedIds", "mapRequirements", "manualSteps"}
COMPONENT_KEYS = {"id", "type", "name", "dependsOn", "sourceRefs"}
REQUESTED_ID_KEYS = {"namespace", "count", "min", "max", "purpose"}
ID_NAMESPACES = {"storage", "actionId", "uniqueId"}


def _safe_name(value: object) -> bool:
    return (
        isinstance(value, str)
        and bool(value.strip())
        and not any(part in value for part in ("/", "\\", "..", "\x00"))
    )


def _unknown_keys(value: dict, allowed: set[str]) -> list[str]:
    return sorted(set(value) - allowed)


def _validate_sources(data: dict, err) -> set[str]:
    sources = data.get("sources", [])
    if not isinstance(sources, list):
        err("sources must be an array")
        return set()

    source_ids = []
    for index, source in enumerate(sources):
        if not isinstance(source, dict):
            err(f"source {index} must be an object")
            continue
        source_id = source.get("id")
        if not isinstance(source_id, str) or not SAFE_TASK_ID.fullmatch(source_id):
            err(f"source {index} has invalid id")
        else:
            source_ids.append(source_id)
        if source.get("kind") not in SOURCE_KINDS:
            err(f"source {index} has invalid kind")
        if not _safe_name(source.get("title")):
            err(f"source {index} has invalid title")
        checked_at = source.get("checkedAt")
        if not isinstance(checked_at, str) or not DATE_VALUE.fullmatch(checked_at):
            err(f"source {index} has invalid checkedAt date")
        if source.get("confidence") not in CONFIDENCE_LEVELS:
            err(f"source {index} has invalid confidence")
        url = source.get("url")
        if url is not None and (not isinstance(url, str) or not url.startswith("https://")):
            err(f"source {index} URL must use https")
        if source.get("kind") in {"official", "community-wiki", "repository"} and not url:
            err(f"source {index} requires a URL")

    if len(source_ids) != len(set(source_ids)):
        err("source ids must be unique")
    return set(source_ids)


def _validate_typed_payload(data: dict, task_type: str, err) -> None:
    payload_names = set(PAYLOAD_KEYS)
    present_payloads = {name for name in payload_names if name in data}

    if task_type in PAYLOAD_KEYS:
        if task_type not in data:
            err(f"{task_type} payload is required")
            return
        unexpected_payloads = sorted(present_payloads - {task_type})
        for payload_name in unexpected_payloads:
            err(f"unexpected payload for task type {task_type}: {payload_name}")

        payload = data.get(task_type)
        if not isinstance(payload, dict):
            err(f"{task_type} payload must be an object")
            return
        for key in _unknown_keys(payload, PAYLOAD_KEYS[task_type]):
            err(f"{task_type} payload contains unsupported field: {key}")
    elif present_payloads:
        for payload_name in sorted(present_payloads):
            err(f"unexpected payload for task type {task_type}: {payload_name}")


def _validate_requested_ids(requested_ids: object, err) -> None:
    if requested_ids is None:
        return
    if not isinstance(requested_ids, list):
        err("contentBundle.requestedIds must be an array")
        return

    for index, request in enumerate(requested_ids):
        if not isinstance(request, dict):
            err(f"contentBundle requested id {index} must be an object")
            continue
        for key in _unknown_keys(request, REQUESTED_ID_KEYS):
            err(f"contentBundle requested id {index} contains unsupported field: {key}")
        missing = sorted(REQUESTED_ID_KEYS - set(request))
        for key in missing:
            err(f"contentBundle requested id {index} is missing field: {key}")
        if request.get("namespace") not in ID_NAMESPACES:
            err(f"contentBundle requested id {index} has invalid namespace")
        for key in ("count", "min", "max"):
            value = request.get(key)
            if not isinstance(value, int) or isinstance(value, bool) or value < 1:
                err(f"contentBundle requested id {index} has invalid {key}")
        if isinstance(request.get("min"), int) and isinstance(request.get("max"), int) and request["min"] > request["max"]:
            err(f"contentBundle requested id {index} has min greater than max")
        if not _safe_name(request.get("purpose")):
            err(f"contentBundle requested id {index} has invalid purpose")


def _validate_content_bundle(data: dict, source_ids: set[str], err) -> None:
    bundle = data.get("contentBundle")
    if not isinstance(bundle, dict):
        err("contentBundle payload is required")
        return

    for key in _unknown_keys(bundle, CONTENT_BUNDLE_KEYS):
        err(f"contentBundle contains unsupported field: {key}")

    if not source_ids:
        err("content bundles require at least one provenance source")

    components = bundle.get("components")
    if not isinstance(components, list) or not components:
        err("contentBundle.components must be a non-empty array")
    else:
        component_ids = []
        dependencies: list[tuple[int, str]] = []
        for index, component in enumerate(components):
            if not isinstance(component, dict):
                err(f"contentBundle component {index} must be an object")
                continue
            for key in _unknown_keys(component, COMPONENT_KEYS):
                err(f"contentBundle component {index} contains unsupported field: {key}")
            missing = sorted(COMPONENT_KEYS - set(component))
            for key in missing:
                err(f"contentBundle component {index} is missing field: {key}")

            component_id = component.get("id")
            if not isinstance(component_id, str) or not SAFE_TASK_ID.fullmatch(component_id):
                err(f"contentBundle component {index} has invalid id")
            else:
                component_ids.append(component_id)
            if component.get("type") not in BUNDLE_COMPONENT_TYPES:
                err(f"contentBundle component {index} has invalid type")
            if not _safe_name(component.get("name")):
                err(f"contentBundle component {index} has invalid name")

            depends_on = component.get("dependsOn")
            if not isinstance(depends_on, list):
                err(f"contentBundle component {index} dependsOn must be an array")
            else:
                if len(depends_on) != len(set(depends_on)):
                    err(f"contentBundle component {index} has duplicate dependencies")
                for dependency in depends_on:
                    if not isinstance(dependency, str) or not SAFE_TASK_ID.fullmatch(dependency):
                        err(f"contentBundle component {index} has invalid dependency")
                    else:
                        dependencies.append((index, dependency))

            source_refs = component.get("sourceRefs")
            if not isinstance(source_refs, list) or not source_refs:
                err(f"contentBundle component {index} requires sourceRefs")
            else:
                if len(source_refs) != len(set(source_refs)):
                    err(f"contentBundle component {index} has duplicate sourceRefs")
                for source_ref in source_refs:
                    if source_ref not in source_ids:
                        err(f"contentBundle component {index} references unknown source: {source_ref}")

        if len(component_ids) != len(set(component_ids)):
            err("contentBundle component ids must be unique")
        known_components = set(component_ids)
        for index, dependency in dependencies:
            if dependency not in known_components:
                err(f"contentBundle component {index} references unknown dependency: {dependency}")
            elif dependency == components[index].get("id"):
                err(f"contentBundle component {index} cannot depend on itself")

    _validate_requested_ids(bundle.get("requestedIds"), err)

    for field in ("mapRequirements", "manualSteps"):
        value = bundle.get(field)
        if value is not None and (not isinstance(value, list) or not all(isinstance(item, str) and item.strip() for item in value)):
            err(f"contentBundle.{field} must be an array of non-empty strings")


def validate(data):
    findings = []

    def err(message):
        findings.append({"level": "error", "message": message})

    if not isinstance(data, dict):
        return {
            "ok": False,
            "findings": [{"level": "error", "message": "task specification must be an object"}],
            "summary": {"findingCount": 1},
        }

    for key in [
        "schemaVersion",
        "taskId",
        "type",
        "name",
        "description",
        "targetDatapack",
        "dryRun",
        "requestedBy",
        "tags",
    ]:
        if key not in data:
            err(f"missing required field: {key}")

    task_id = data.get("taskId")
    if not isinstance(task_id, str) or not SAFE_TASK_ID.fullmatch(task_id):
        err("taskId must use lowercase letters, digits, hyphens, or underscores and be at most 64 characters")

    if not _safe_name(data.get("name")):
        err("name must be non-empty and must not contain path separators, traversal sequences, or null bytes")

    task_type = data.get("type")
    if task_type not in TYPES:
        err("invalid task type")
    if data.get("dryRun") is not True:
        err("dryRun must be true")

    source_ids = _validate_sources(data, err)
    _validate_typed_payload(data, task_type, err)

    stages = data.get("quest", {}).get("stages", []) if task_type == "quest" and isinstance(data.get("quest"), dict) else []
    if not isinstance(stages, list):
        err("quest.stages must be an array")
        stages = []
    ids = [stage.get("id") for stage in stages if isinstance(stage, dict)]
    if len(ids) != len(set(ids)):
        err("stage ids must be unique")

    known = set(ids)
    for stage in stages:
        if not isinstance(stage, dict):
            err("quest stage must be an object")
            continue
        dependencies = stage.get("dependsOn", [])
        if not isinstance(dependencies, list):
            err("quest stage dependsOn must be an array")
            continue
        for dependency in dependencies:
            if dependency not in known:
                err(f"unknown stage reference: {dependency}")

    rewards = data.get("quest", {}).get("rewards", []) if task_type == "quest" and isinstance(data.get("quest"), dict) else []
    if not isinstance(rewards, list):
        err("quest.rewards must be an array")
        rewards = []
    for reward in rewards:
        if not isinstance(reward, dict):
            err("quest reward must be an object")
            continue
        if any(isinstance(reward.get(key), int) and reward[key] < 0 for key in ["count", "experience", "money"]):
            err("reward values must not be negative")

    if task_type == "content_bundle":
        _validate_content_bundle(data, source_ids, err)
    elif "contentBundle" in data:
        err(f"unexpected payload for task type {task_type}: contentBundle")

    return {
        "ok": not any(finding["level"] == "error" for finding in findings),
        "findings": findings,
        "summary": {"findingCount": len(findings)},
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--output")
    args = parser.parse_args()
    report = validate(read_json(args.task))
    if args.output:
        atomic_write_json(args.output, report)
    print(dumps_json(report), end="")
    return 0 if report["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
