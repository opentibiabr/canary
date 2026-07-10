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


def _safe_name(value: object) -> bool:
    return (
        isinstance(value, str)
        and bool(value.strip())
        and not any(part in value for part in ("/", "\\", "..", "\x00"))
    )


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


def validate(data):
    findings = []

    def err(message):
        findings.append({"level": "error", "message": message})

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

    stages = data.get("quest", {}).get("stages", []) if task_type == "quest" else data.get("stages", [])
    ids = [stage.get("id") for stage in stages if isinstance(stage, dict)]
    if len(ids) != len(set(ids)):
        err("stage ids must be unique")

    known = set(ids)
    for stage in stages:
        for dependency in stage.get("dependsOn", []):
            if dependency not in known:
                err(f"unknown stage reference: {dependency}")

    rewards = (data.get("quest", {}) or data).get("rewards", [])
    for reward in rewards:
        if any(isinstance(reward.get(key), int) and reward[key] < 0 for key in ["count", "experience", "money"]):
            err("reward values must not be negative")

    if task_type == "quest" and "quest" not in data:
        err("quest payload is required")

    if task_type == "content_bundle":
        bundle = data.get("contentBundle")
        if not isinstance(bundle, dict):
            err("contentBundle payload is required")
        else:
            if not source_ids:
                err("content bundles require at least one provenance source")
            components = bundle.get("components")
            if not isinstance(components, list) or not components:
                err("contentBundle.components must be a non-empty array")
            else:
                component_ids = []
                for index, component in enumerate(components):
                    if not isinstance(component, dict):
                        err(f"contentBundle component {index} must be an object")
                        continue
                    component_id = component.get("id")
                    if not isinstance(component_id, str) or not SAFE_TASK_ID.fullmatch(component_id):
                        err(f"contentBundle component {index} has invalid id")
                    else:
                        component_ids.append(component_id)
                    if component.get("type") not in BUNDLE_COMPONENT_TYPES:
                        err(f"contentBundle component {index} has invalid type")
                    if not _safe_name(component.get("name")):
                        err(f"contentBundle component {index} has invalid name")
                    source_refs = component.get("sourceRefs")
                    if not isinstance(source_refs, list) or not source_refs:
                        err(f"contentBundle component {index} requires sourceRefs")
                    else:
                        for source_ref in source_refs:
                            if source_ref not in source_ids:
                                err(f"contentBundle component {index} references unknown source: {source_ref}")
                if len(component_ids) != len(set(component_ids)):
                    err("contentBundle component ids must be unique")

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
