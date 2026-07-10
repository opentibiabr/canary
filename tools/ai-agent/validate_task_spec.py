#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from io_utils import atomic_write_json, dumps_json, read_json

TYPES = {"quest", "monster", "npc", "spell", "raid", "instance", "content_bundle"}
SAFE_TASK_ID = re.compile(r"^[a-z0-9][a-z0-9_-]{0,63}$")


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

    name = data.get("name")
    if not isinstance(name, str) or not name.strip():
        err("name must be a non-empty string")
    elif any(part in name for part in ("/", "\\", "..", "\x00")):
        err("name must not contain path separators, traversal sequences, or null bytes")

    if data.get("type") not in TYPES:
        err("invalid task type")
    if data.get("dryRun") is not True:
        err("dryRun must be true")

    stages = data.get("quest", {}).get("stages", []) if data.get("type") == "quest" else data.get("stages", [])
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

    if data.get("type") == "quest" and "quest" not in data:
        err("quest payload is required")

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
