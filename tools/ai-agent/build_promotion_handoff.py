#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath

TARGET_ROOTS = {
    "quest": "scripts/quests",
    "npc": "npc",
    "monster": "monster",
    "spell": "scripts/spells",
    "raid": "raids",
    "instance": "scripts/instances",
}


def _safe_relative(path: str) -> str:
    value = PurePosixPath(path)
    if value.is_absolute() or ".." in value.parts:
        raise ValueError(f"unsafe relative path: {path}")
    return value.as_posix()


def _target_for(task: dict, preview_path: str) -> str:
    relative = PurePosixPath(_safe_relative(preview_path))
    if len(relative.parts) < 3:
        raise ValueError(f"unexpected preview path: {preview_path}")
    component_type = relative.parts[-2]
    if component_type not in TARGET_ROOTS:
        raise ValueError(f"unsupported preview component type: {component_type}")
    datapack = _safe_relative(str(task["targetDatapack"]))
    return str(PurePosixPath(datapack) / TARGET_ROOTS[component_type] / relative.name)


def build(task: dict, plan: dict, manifest: dict, readiness: dict, generated_root: Path) -> dict:
    if readiness.get("automaticPromotionAllowed") is not False:
        raise ValueError("readiness report must explicitly forbid automatic promotion")
    if task.get("dryRun") is not True:
        raise ValueError("handoff source task must remain dry-run")

    files: list[dict] = []
    for item in manifest.get("files", []):
        preview_path = _safe_relative(str(item["path"]))
        source = generated_root / preview_path
        if not source.exists() or not source.is_file():
            raise FileNotFoundError(f"missing preview file: {preview_path}")
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if digest != item.get("sha256"):
            raise ValueError(f"manifest checksum mismatch: {preview_path}")
        files.append({
            "previewPath": preview_path,
            "targetPath": _target_for(task, preview_path),
            "sha256": digest,
            "operation": "manual-copy-after-review",
        })

    files.sort(key=lambda item: item["targetPath"])
    blockers = list(readiness.get("findings", []))
    return {
        "schemaVersion": "1.0",
        "taskId": task.get("taskId"),
        "targetDatapack": task.get("targetDatapack"),
        "handoffStatus": "blocked" if blockers else "ready-for-manual-review",
        "automaticApplyAllowed": False,
        "manualApprovalRequired": True,
        "files": files,
        "identifiers": {
            "storage": plan.get("proposedStorage", []),
            "actionId": plan.get("proposedActionIds", []),
            "uniqueId": plan.get("proposedUniqueIds", []),
        },
        "mapRequirements": plan.get("mapRequirements", []),
        "requiredTests": readiness.get("requiredTests", []),
        "blockers": blockers,
        "integrationSteps": [
            "Review every preview file and remove all unresolved placeholders.",
            "Create reviewed Storage namespace constants before copying quest scripts.",
            "Apply action and unique IDs only during manual map integration.",
            "Copy approved files to the listed target paths on a dedicated branch.",
            "Run reference validation and isolated runtime smoke tests.",
            "Open a separate implementation PR; never deploy directly to production.",
        ],
        "rollbackSteps": [
            "Revert the implementation commit or remove only the listed target files.",
            "Release unused identifier reservations.",
            "Restore the pre-change map backup if manual OTBM work was performed.",
            "Re-run reference validation and runtime smoke tests after rollback.",
        ],
        "prohibitedAutomaticTargets": ["active datapack", "OTBM", "items.otb", "production server"],
    }


def write_markdown(bundle: dict, output: Path) -> None:
    lines = [
        "# Promotion handoff bundle",
        "",
        f"- task: {bundle.get('taskId')}",
        f"- target datapack: {bundle.get('targetDatapack')}",
        f"- status: {bundle['handoffStatus']}",
        "- automatic apply: forbidden",
        "- manual approval: required",
        "",
        "## File mapping",
        "",
    ]
    lines.extend(f"- `{item['previewPath']}` → `{item['targetPath']}` (`{item['sha256']}`)" for item in bundle["files"])
    if not bundle["files"]:
        lines.append("- No files in handoff.")
    lines.extend(["", "## Integration steps", ""])
    lines.extend(f"- {item}" for item in bundle["integrationSteps"])
    lines.extend(["", "## Required tests", ""])
    lines.extend(f"- {item}" for item in bundle["requiredTests"])
    lines.extend(["", "## Rollback", ""])
    lines.extend(f"- {item}" for item in bundle["rollbackSteps"])
    lines.extend(["", "## Blockers", ""])
    if bundle["blockers"]:
        lines.extend(f"- [{item.get('category', 'unknown')}] {item.get('message', '')}" for item in bundle["blockers"])
    else:
        lines.append("- No automated blockers. Human approval is still mandatory.")
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task", required=True, type=Path)
    parser.add_argument("--plan", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--readiness", required=True, type=Path)
    parser.add_argument("--generated-root", required=True, type=Path)
    parser.add_argument("--json-output", required=True, type=Path)
    parser.add_argument("--markdown-output", required=True, type=Path)
    args = parser.parse_args()

    bundle = build(
        json.loads(args.task.read_text(encoding="utf-8")),
        json.loads(args.plan.read_text(encoding="utf-8")),
        json.loads(args.manifest.read_text(encoding="utf-8")),
        json.loads(args.readiness.read_text(encoding="utf-8")),
        args.generated_root,
    )
    args.json_output.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_output.parent.mkdir(parents=True, exist_ok=True)
    args.json_output.write_text(json.dumps(bundle, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    write_markdown(bundle, args.markdown_output)
    print(json.dumps({"status": bundle["handoffStatus"], "files": len(bundle["files"])}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
