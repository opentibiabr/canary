#!/usr/bin/env python3
"""Generate a concise Markdown risk report from AI-agent audit artifacts."""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path
from typing import Any

SEVERITY_ORDER = {"error": 0, "warning": 1, "info": 2}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def build_report(
    registry: dict[str, Any],
    content: dict[str, Any],
    references: dict[str, Any],
    max_items: int = 50,
) -> str:
    findings: list[dict[str, Any]] = []

    for conflict in registry.get("conflicts", []):
        findings.append({
            "severity": conflict.get("severity", "warning"),
            "type": f"duplicate-{conflict['namespace']}-definition",
            "value": conflict["value"],
            "source": ", ".join(sorted({source["path"] for source in conflict.get("sources", [])})),
        })

    for duplicate in content.get("duplicates", []):
        findings.append({
            "severity": "info" if duplicate.get("crossDatapack") else "warning",
            "type": "duplicate-content-definition",
            "value": f"{duplicate['type']}: {duplicate['name']}",
            "source": ", ".join(duplicate.get("paths", [])),
        })

    findings.extend(references.get("findings", []))
    findings.sort(key=lambda item: (
        SEVERITY_ORDER.get(item.get("severity", "info"), 9),
        item.get("type", ""),
        item.get("source", ""),
        str(item.get("value", "")),
    ))

    counts: dict[str, int] = defaultdict(int)
    for finding in findings:
        counts[finding.get("severity", "info")] += 1

    lines = [
        "# AI Agent Risk Report",
        "",
        "## Summary",
        "",
        f"- Errors: {counts['error']}",
        f"- Warnings: {counts['warning']}",
        f"- Informational: {counts['info']}",
        f"- Total findings: {len(findings)}",
        "",
        "## Recommended handling",
        "",
        "- Errors block generated content from being committed.",
        "- Warnings require review before merge.",
        "- Informational findings are recorded but do not block work.",
        "",
        "## Prioritized findings",
        "",
    ]

    if not findings:
        lines.append("No findings detected.")
        return "\n".join(lines) + "\n"

    for index, finding in enumerate(findings[:max_items], start=1):
        severity = finding.get("severity", "info").upper()
        finding_type = finding.get("type", "unknown")
        value = finding.get("value", "")
        source = finding.get("source", "")
        lines.append(f"{index}. **{severity} — {finding_type}**: `{value}`")
        if source:
            lines.append(f"   - Source: `{source}`")

    remaining = len(findings) - max_items
    if remaining > 0:
        lines.extend(["", f"_Additional findings omitted: {remaining}. See JSON artifacts for the full list._"])

    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--registry", type=Path, required=True)
    parser.add_argument("--content", type=Path, required=True)
    parser.add_argument("--references", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--max-items", type=int, default=50)
    args = parser.parse_args()

    report = build_report(
        load_json(args.registry),
        load_json(args.content),
        load_json(args.references),
        max_items=args.max_items,
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
