#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from build_promotion_handoff import build as build_handoff
from build_promotion_handoff import write_markdown as write_handoff_markdown
from evaluate_promotion_readiness import evaluate as evaluate_readiness
from evaluate_promotion_readiness import write_markdown as write_readiness_markdown
from generate_staging_patch import generate as generate_staging_patch
from id_allocator import add_reservation
from io_utils import atomic_write_json, dumps_json, read_json
from normalize_research import normalize
from plan_content import plan as make_plan
from render_content import render
from research_provenance import write_report
from research_to_task import build_draft
from validate_content_plan import validate as validate_plan
from validate_task_spec import validate as validate_task


def _reserve_plan_identifiers(reservations: dict, task: dict, plan: dict) -> None:
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


def run(
    research: dict,
    registry: dict,
    content_index: dict,
    reservations: dict,
    output: Path,
    target_datapack: str = "data-otservbr-global",
    repository_root: Path = Path("."),
) -> tuple[int, dict]:
    output.mkdir(parents=True, exist_ok=True)

    normalized = normalize(research, content_index)
    atomic_write_json(output / "NORMALIZED_RESEARCH.json", normalized)
    if any(item.get("level") == "error" for item in normalized.get("findings", [])):
        summary = {"ok": False, "stage": "normalize", "reason": "research validation errors"}
        atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
        return 1, summary

    task, conflict_report = build_draft(normalized, target_datapack)
    atomic_write_json(output / "TASK_SPEC.generated.json", task)
    atomic_write_json(output / "RESEARCH_CONFLICTS.json", conflict_report)

    if conflict_report.get("conflicts"):
        summary = {
            "ok": False,
            "stage": "conflict-check",
            "reason": "existing Canary content matched research entities",
            "blockedConflicts": len(conflict_report["conflicts"]),
            "generatedComponents": conflict_report["summary"]["generatedComponents"],
        }
        atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
        return 2, summary

    if not conflict_report.get("summary", {}).get("generatedComponents"):
        summary = {"ok": False, "stage": "task-draft", "reason": "no supported missing entities to generate"}
        atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
        return 3, summary

    specification = validate_task(task)
    atomic_write_json(output / "TASK_SPEC_VALIDATION.json", specification)
    if not specification["ok"]:
        summary = {"ok": False, "stage": "task-validation", "reason": "generated task failed validation"}
        atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
        return 4, summary

    write_report(task, output / "RESEARCH_PROVENANCE.md")
    plan = make_plan(task, content_index, registry, reservations)
    atomic_write_json(output / "CONTENT_PLAN.json", plan)

    _reserve_plan_identifiers(reservations, task, plan)
    atomic_write_json(output / "ID_RESERVATIONS.working.json", reservations)

    plan_validation = validate_plan(plan, registry, reservations)
    atomic_write_json(output / "CONTENT_PLAN_VALIDATION.json", plan_validation)
    if not plan_validation["ok"]:
        summary = {"ok": False, "stage": "plan-validation", "reason": "generated content plan failed validation"}
        atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
        return 5, summary

    generated_root = output / "generated-content"
    manifest = render(task, plan, generated_root)
    readiness = evaluate_readiness(task, plan, manifest, generated_root)
    atomic_write_json(output / "PROMOTION_READINESS.json", readiness)
    write_readiness_markdown(readiness, output / "PROMOTION_READINESS.md")

    handoff = build_handoff(task, plan, manifest, readiness, generated_root)
    atomic_write_json(output / "PROMOTION_HANDOFF.json", handoff)
    write_handoff_markdown(handoff, output / "PROMOTION_HANDOFF.md")

    staging, patch = generate_staging_patch(handoff, generated_root, repository_root)
    atomic_write_json(output / "STAGING_PATCH_PLAN.json", staging)
    (output / "STAGING_CONTENT.patch").write_text(patch, encoding="utf-8")

    summary = {
        "ok": True,
        "stage": "complete",
        "taskId": task["taskId"],
        "normalizedEntities": normalized["summary"]["entityCount"],
        "generatedComponents": conflict_report["summary"]["generatedComponents"],
        "previewFiles": len(manifest["files"]),
        "reservedIdentifiers": sum(
            len(plan.get(key, [])) for key in ("proposedStorage", "proposedActionIds", "proposedUniqueIds")
        ),
        "promotionStatus": readiness["status"],
        "promotionBlockers": readiness["summary"]["blockerCount"],
        "handoffStatus": handoff["handoffStatus"],
        "handoffFiles": len(handoff["files"]),
        "stagingPatchStatus": staging["status"],
        "stagingPatchGenerated": staging["patchGenerated"],
        "stagingPatchBlockers": staging["summary"]["blockerCount"],
        "automaticPromotionAllowed": False,
        "automaticApplyAllowed": False,
    }
    atomic_write_json(output / "RESEARCH_PIPELINE_RESULT.json", summary)
    return 0, summary


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--research", required=True, type=Path)
    parser.add_argument("--registry", required=True, type=Path)
    parser.add_argument("--content-index", required=True, type=Path)
    parser.add_argument("--reservations", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--target-datapack", default="data-otservbr-global")
    parser.add_argument("--repository-root", type=Path, default=Path("."))
    args = parser.parse_args()

    code, summary = run(
        json.loads(args.research.read_text(encoding="utf-8")),
        read_json(args.registry),
        read_json(args.content_index),
        read_json(args.reservations),
        args.output,
        args.target_datapack,
        args.repository_root,
    )
    print(dumps_json(summary), end="")
    return code


if __name__ == "__main__":
    raise SystemExit(main())
