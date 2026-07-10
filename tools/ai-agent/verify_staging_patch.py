#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import tempfile
from pathlib import Path, PurePosixPath

PROHIBITED_SUFFIXES = (".otbm", "items.otb")


def _safe_relative(value: str) -> str:
    path = PurePosixPath(value)
    if path.is_absolute() or not path.parts or ".." in path.parts:
        raise ValueError(f"unsafe relative path: {value}")
    normalized = path.as_posix()
    if normalized.lower().endswith(PROHIBITED_SUFFIXES):
        raise ValueError(f"prohibited target path: {value}")
    return normalized


def _run_git_apply(workspace: Path, patch_file: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "apply", *args, str(patch_file)],
        cwd=workspace,
        text=True,
        capture_output=True,
        check=False,
    )


def verify(plan: dict, patch_text: str) -> dict:
    findings: list[dict] = []

    if plan.get("automaticApplyAllowed") is not False:
        raise ValueError("staging plan must explicitly forbid automatic apply")
    if plan.get("manualApprovalRequired") is not True:
        raise ValueError("staging plan must require manual approval")
    if plan.get("status") != "ready-for-manual-application":
        findings.append({
            "level": "blocker",
            "category": "plan",
            "message": "staging plan is not ready for manual application",
        })
    if not plan.get("patchGenerated"):
        findings.append({
            "level": "blocker",
            "category": "patch",
            "message": "staging plan does not declare a generated patch",
        })
    if not patch_text.strip():
        findings.append({
            "level": "blocker",
            "category": "patch",
            "message": "staging patch is empty",
        })

    expected: dict[str, str] = {}
    for item in plan.get("files", []):
        target = _safe_relative(str(item["targetPath"]))
        if item.get("operation") != "create":
            findings.append({
                "level": "blocker",
                "category": "operation",
                "message": f"unsupported staging operation for isolated verification: {target}",
            })
            continue
        expected[target] = str(item["sha256"])

    if not expected:
        findings.append({
            "level": "blocker",
            "category": "files",
            "message": "staging plan contains no verifiable create operations",
        })

    if any(item["level"] == "blocker" for item in findings):
        return _report(plan, findings, checked=False, applied=False, rollback=False, files=0)

    with tempfile.TemporaryDirectory(prefix="canary-staging-verify-") as temporary:
        workspace = Path(temporary)
        patch_file = workspace.parent / f"{workspace.name}.patch"
        patch_file.write_text(patch_text, encoding="utf-8")
        try:
            check = _run_git_apply(workspace, patch_file, "--check")
            if check.returncode != 0:
                findings.append({
                    "level": "blocker",
                    "category": "apply-check",
                    "message": check.stderr.strip() or "git apply --check failed",
                })
                return _report(plan, findings, checked=False, applied=False, rollback=False, files=0)

            applied = _run_git_apply(workspace, patch_file)
            if applied.returncode != 0:
                findings.append({
                    "level": "blocker",
                    "category": "apply",
                    "message": applied.stderr.strip() or "git apply failed",
                })
                return _report(plan, findings, checked=True, applied=False, rollback=False, files=0)

            verified_files = 0
            for target, expected_digest in expected.items():
                path = workspace / target
                if not path.is_file():
                    findings.append({
                        "level": "blocker",
                        "category": "result",
                        "message": f"patch did not create expected file: {target}",
                    })
                    continue
                digest = hashlib.sha256(path.read_bytes()).hexdigest()
                if digest != expected_digest:
                    findings.append({
                        "level": "blocker",
                        "category": "checksum",
                        "message": f"applied file checksum mismatch: {target}",
                    })
                    continue
                verified_files += 1

            reverse_check = _run_git_apply(workspace, patch_file, "--reverse", "--check")
            if reverse_check.returncode != 0:
                findings.append({
                    "level": "blocker",
                    "category": "rollback-check",
                    "message": reverse_check.stderr.strip() or "reverse apply check failed",
                })
                return _report(plan, findings, checked=True, applied=True, rollback=False, files=verified_files)

            reversed_patch = _run_git_apply(workspace, patch_file, "--reverse")
            rollback_ok = reversed_patch.returncode == 0
            if not rollback_ok:
                findings.append({
                    "level": "blocker",
                    "category": "rollback",
                    "message": reversed_patch.stderr.strip() or "reverse apply failed",
                })
            for target in expected:
                if (workspace / target).exists():
                    rollback_ok = False
                    findings.append({
                        "level": "blocker",
                        "category": "rollback",
                        "message": f"rollback left target behind: {target}",
                    })

            return _report(
                plan,
                findings,
                checked=True,
                applied=True,
                rollback=rollback_ok,
                files=verified_files,
            )
        finally:
            patch_file.unlink(missing_ok=True)


def _report(plan: dict, findings: list[dict], checked: bool, applied: bool, rollback: bool, files: int) -> dict:
    blockers = [item for item in findings if item["level"] == "blocker"]
    verified = checked and applied and rollback and not blockers
    return {
        "schemaVersion": "1.0",
        "taskId": plan.get("taskId"),
        "status": "verified-in-isolated-sandbox" if verified else "blocked",
        "verified": verified,
        "automaticApplyAllowed": False,
        "manualApprovalRequired": True,
        "summary": {
            "blockerCount": len(blockers),
            "verifiedFileCount": files,
            "applyCheckPassed": checked,
            "applyPassed": applied,
            "rollbackPassed": rollback,
        },
        "findings": findings,
        "scope": "temporary isolated filesystem only",
        "prohibitedAutomaticTargets": ["main", "active datapack", "OTBM", "items.otb", "production server"],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--plan", required=True, type=Path)
    parser.add_argument("--patch", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    report = verify(
        json.loads(args.plan.read_text(encoding="utf-8")),
        args.patch.read_text(encoding="utf-8"),
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(report["summary"], indent=2))
    return 0 if report["verified"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
