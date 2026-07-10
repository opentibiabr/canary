#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path

BLOCKING_MARKERS = {
    "dialogue": ["TODO: implement reviewed quest dialogue", "TODO: replace numeric placeholders"],
    "monster-balance": ["TODO: balance after review", "monster.health = 1000 -- TODO", "monster.corpse = 0 -- TODO"],
    "loot": ["monster.loot = {} -- TODO"],
}


def evaluate(task: dict, plan: dict, manifest: dict, generated_root: Path) -> dict:
    findings: list[dict] = []
    components = task.get("contentBundle", {}).get("components", [])
    component_types = {item.get("type") for item in components}

    if task.get("dryRun") is not True:
        findings.append({"level": "blocker", "category": "safety", "message": "task must remain dry-run"})

    if plan.get("mapRequirements"):
        findings.append({"level": "blocker", "category": "map", "message": "manual map work is still required"})

    if plan.get("proposedStorage"):
        findings.append({"level": "blocker", "category": "storage-constants", "message": "reserved storage IDs must be promoted to reviewed constants"})

    if plan.get("proposedActionIds") or plan.get("proposedUniqueIds"):
        findings.append({"level": "blocker", "category": "map-identifiers", "message": "action/unique IDs require reviewed map integration"})

    for item in manifest.get("files", []):
        path = generated_root / item["path"]
        if not path.exists():
            findings.append({"level": "blocker", "category": "manifest", "message": f"missing generated file: {item['path']}"})
            continue
        text = path.read_text(encoding="utf-8")
        for category, markers in BLOCKING_MARKERS.items():
            for marker in markers:
                if marker in text:
                    findings.append({"level": "blocker", "category": category, "message": f"unresolved preview marker in {item['path']}: {marker}"})

    required_tests = [
        "task schema validation",
        "content plan validation",
        "reference validation after manual integration",
        "runtime smoke test in an isolated test server",
        "quest progression and reward regression test",
    ]
    if "npc" in component_types:
        required_tests.append("NPC dialogue branch test")
    if "monster" in component_types:
        required_tests.extend(["monster combat balance review", "loot and corpse item validation"])

    blockers = [item for item in findings if item["level"] == "blocker"]
    status = "ready-for-human-promotion" if not blockers else "not-ready"
    return {
        "schemaVersion": "1.0",
        "taskId": task.get("taskId"),
        "status": status,
        "readyForHumanPromotion": not blockers,
        "automaticPromotionAllowed": False,
        "summary": {
            "blockerCount": len(blockers),
            "findingCount": len(findings),
            "requiredTestCount": len(required_tests),
        },
        "findings": findings,
        "requiredTests": required_tests,
        "manualApprovalRequired": True,
        "prohibitedAutomaticTargets": ["active datapack", "OTBM", "items.otb", "production server"],
    }


def write_markdown(report: dict, output: Path) -> None:
    lines = [
        "# Promotion readiness report",
        "",
        f"- task: {report.get('taskId')}",
        f"- status: {report['status']}",
        f"- blockers: {report['summary']['blockerCount']}",
        "- automatic promotion: forbidden",
        "- manual approval: required",
        "",
        "## Findings",
        "",
    ]
    lines.extend(f"- [{item['level']}] {item['category']}: {item['message']}" for item in report["findings"])
    if not report["findings"]:
        lines.append("- No automated blockers found. Human review is still required.")
    lines.extend(["", "## Required tests", ""])
    lines.extend(f"- {item}" for item in report["requiredTests"])
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task", required=True, type=Path)
    parser.add_argument("--plan", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--generated-root", required=True, type=Path)
    parser.add_argument("--json-output", required=True, type=Path)
    parser.add_argument("--markdown-output", required=True, type=Path)
    args = parser.parse_args()

    report = evaluate(
        json.loads(args.task.read_text(encoding="utf-8")),
        json.loads(args.plan.read_text(encoding="utf-8")),
        json.loads(args.manifest.read_text(encoding="utf-8")),
        args.generated_root,
    )
    args.json_output.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_output.parent.mkdir(parents=True, exist_ok=True)
    args.json_output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    write_markdown(report, args.markdown_output)
    print(json.dumps(report["summary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
