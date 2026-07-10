#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from id_allocator import add_reservation
from io_utils import atomic_write_json, dumps_json, read_json
from plan_content import plan as make_plan
from render_content import render
from research_provenance import write_report
from validate_content_plan import validate as validate_plan
from validate_task_spec import validate as validate_task


def _reserve_plan_identifiers(reservations, task, plan):
    mappings = [
        ("storage", "proposedStorage"),
        ("actionId", "proposedActionIds"),
        ("uniqueId", "proposedUniqueIds"),
    ]
    for namespace, key in mappings:
        for entry in plan.get(key, []):
            value = int(entry["id"])
            add_reservation(
                reservations,
                task["taskId"],
                namespace,
                value,
                value,
                task["targetDatapack"],
                entry.get("purpose", "planned content identifier"),
            )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--registry", required=True)
    parser.add_argument("--content-index", required=True)
    parser.add_argument("--reservations", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    output = Path(args.output)
    output.mkdir(parents=True, exist_ok=True)
    task = read_json(args.task)
    registry = read_json(args.registry)
    content = read_json(args.content_index)
    reservations = read_json(args.reservations)
    atomic_write_json(output / "TASK_SPEC.json", task)

    specification = validate_task(task)
    atomic_write_json(output / "TASK_SPEC_VALIDATION.json", specification)
    if not specification["ok"]:
        return 1

    write_report(task, output / "RESEARCH_PROVENANCE.md")

    plan = make_plan(task, content, registry, reservations)
    atomic_write_json(output / "CONTENT_PLAN.json", plan)

    _reserve_plan_identifiers(reservations, task, plan)
    atomic_write_json(output / "ID_RESERVATIONS.working.json", reservations)

    validation = validate_plan(plan, registry, reservations)
    atomic_write_json(output / "CONTENT_PLAN_VALIDATION.json", validation)
    if not validation["ok"]:
        return 1

    manifest = render(task, plan, output / "generated-content")
    preview_count = len(manifest["files"])
    lines = [
        "# Content pipeline summary",
        "",
        f'- task: {task["name"]}',
        "- status: passed",
        f"- preview files: {preview_count}",
        f"- declared sources: {len(task.get('sources', []))}",
        f"- reserved identifiers: {sum(len(plan.get(key, [])) for key in ('proposedStorage', 'proposedActionIds', 'proposedUniqueIds'))}",
        f"- artifacts: {output.as_posix()}",
        "",
        "## Manual steps",
    ] + [f"- {step}" for step in plan.get("manualSteps", [])]
    (output / "CONTENT_PIPELINE_SUMMARY.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(
        dumps_json(
            {
                "ok": True,
                "output": str(output),
                "previewFiles": preview_count,
                "sourceCount": len(task.get("sources", [])),
            }
        ),
        end="",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
