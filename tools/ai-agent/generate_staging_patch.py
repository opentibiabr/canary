#!/usr/bin/env python3
from __future__ import annotations

import argparse
import difflib
import hashlib
import json
from pathlib import Path, PurePosixPath

PROHIBITED_SUFFIXES = (".otbm", "items.otb")


def _safe_relative(value: str) -> str:
    path = PurePosixPath(value)
    if path.is_absolute() or not path.parts or ".." in path.parts:
        raise ValueError(f"unsafe relative path: {value}")
    normalized = path.as_posix()
    lowered = normalized.lower()
    if lowered.endswith(PROHIBITED_SUFFIXES):
        raise ValueError(f"prohibited target path: {value}")
    return normalized


def _new_file_patch(target_path: str, source_text: str) -> list[str]:
    source_lines = source_text.splitlines(keepends=True)
    diff = list(
        difflib.unified_diff(
            [],
            source_lines,
            fromfile="/dev/null",
            tofile=f"b/{target_path}",
            lineterm="",
        )
    )
    return [
        f"diff --git a/{target_path} b/{target_path}",
        "new file mode 100644",
        *diff,
    ]


def generate(handoff: dict, generated_root: Path, repository_root: Path) -> tuple[dict, str]:
    if handoff.get("automaticApplyAllowed") is not False:
        raise ValueError("handoff must explicitly forbid automatic apply")
    if handoff.get("manualApprovalRequired") is not True:
        raise ValueError("handoff must require manual approval")

    findings: list[dict] = []
    patches: list[str] = []
    files: list[dict] = []

    if handoff.get("handoffStatus") != "ready-for-manual-review":
        findings.append({
            "level": "blocker",
            "category": "handoff",
            "message": "promotion handoff is not ready for manual review",
        })

    for item in handoff.get("files", []):
        preview_path = _safe_relative(str(item["previewPath"]))
        target_path = _safe_relative(str(item["targetPath"]))
        source = generated_root / preview_path
        target = repository_root / target_path

        if not source.is_file():
            findings.append({
                "level": "blocker",
                "category": "source",
                "message": f"missing generated source: {preview_path}",
            })
            continue

        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if digest != item.get("sha256"):
            findings.append({
                "level": "blocker",
                "category": "checksum",
                "message": f"source checksum mismatch: {preview_path}",
            })
            continue

        operation = "create"
        if target.exists():
            operation = "collision"
            findings.append({
                "level": "blocker",
                "category": "collision",
                "message": f"target already exists and requires manual merge: {target_path}",
            })

        files.append({
            "previewPath": preview_path,
            "targetPath": target_path,
            "sha256": digest,
            "operation": operation,
        })

        if operation == "create":
            patches.extend(_new_file_patch(target_path, source.read_text(encoding="utf-8")))

    blockers = [item for item in findings if item["level"] == "blocker"]
    status = "ready-for-manual-application" if not blockers and files else "blocked"
    patch_text = "\n".join(patches)
    if patch_text and not patch_text.endswith("\n"):
        patch_text += "\n"

    result = {
        "schemaVersion": "1.0",
        "taskId": handoff.get("taskId"),
        "status": status,
        "automaticApplyAllowed": False,
        "manualApprovalRequired": True,
        "patchGenerated": status == "ready-for-manual-application",
        "summary": {
            "fileCount": len(files),
            "blockerCount": len(blockers),
            "patchBytes": len(patch_text.encode("utf-8")) if status == "ready-for-manual-application" else 0,
        },
        "files": files,
        "findings": findings,
        "applicationInstructions": [
            "Inspect the patch and generated files on a dedicated ai/** test branch.",
            "Apply only after human approval using git apply --check followed by git apply.",
            "Run reference validation, Lua tests, and isolated runtime smoke tests.",
            "Open a separate implementation PR; never apply directly to main or production.",
        ],
        "rollbackInstructions": [
            "Revert the implementation commit or remove only files listed in this plan.",
            "Release unused identifier reservations.",
            "Re-run validation after rollback.",
        ],
        "prohibitedAutomaticTargets": ["main", "active datapack", "OTBM", "items.otb", "production server"],
    }
    return result, patch_text if result["patchGenerated"] else ""


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--handoff", required=True, type=Path)
    parser.add_argument("--generated-root", required=True, type=Path)
    parser.add_argument("--repository-root", required=True, type=Path)
    parser.add_argument("--json-output", required=True, type=Path)
    parser.add_argument("--patch-output", required=True, type=Path)
    args = parser.parse_args()

    result, patch = generate(
        json.loads(args.handoff.read_text(encoding="utf-8")),
        args.generated_root,
        args.repository_root,
    )
    args.json_output.parent.mkdir(parents=True, exist_ok=True)
    args.patch_output.parent.mkdir(parents=True, exist_ok=True)
    args.json_output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    args.patch_output.write_text(patch, encoding="utf-8")
    print(json.dumps(result["summary"], indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
