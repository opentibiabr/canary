#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from io_utils import read_json


def build_report(task: dict) -> str:
    sources = {source["id"]: source for source in task.get("sources", [])}
    lines = [
        "# Research provenance report",
        "",
        f'- task: {task.get("name", "")}',
        f'- task id: {task.get("taskId", "")}',
        f'- content type: {task.get("type", "")}',
        "",
        "## Sources",
        "",
    ]

    if not sources:
        lines.append("- No sources declared.")
    else:
        for source_id in sorted(sources):
            source = sources[source_id]
            lines.extend(
                [
                    f"### {source['title']}",
                    "",
                    f"- id: `{source_id}`",
                    f"- kind: `{source['kind']}`",
                    f"- checked: `{source['checkedAt']}`",
                    f"- confidence: `{source['confidence']}`",
                ]
            )
            if source.get("url"):
                lines.append(f"- url: {source['url']}")
            if source.get("notes"):
                lines.append(f"- notes: {source['notes']}")
            lines.append("")

    lines.extend(["## Component attribution", ""])
    bundle = task.get("contentBundle", {})
    components = bundle.get("components", []) if isinstance(bundle, dict) else []
    if not components:
        lines.append("- No bundle components declared.")
    else:
        for component in components:
            refs = component.get("sourceRefs", [])
            lines.append(f"### {component.get('name', component.get('id', 'component'))}")
            lines.append("")
            lines.append(f"- component id: `{component.get('id', '')}`")
            lines.append(f"- type: `{component.get('type', '')}`")
            lines.append(f"- source refs: {', '.join(f'`{ref}`' for ref in refs)}")
            source_kinds = {sources[ref]["kind"] for ref in refs if ref in sources}
            if source_kinds == {"manual", "repository"} or source_kinds == {"manual"}:
                lines.append("- classification: custom OTS design, not canonical Tibia content")
            elif "inference" in source_kinds:
                lines.append("- classification: partially inferred; human verification required")
            else:
                lines.append("- classification: source-backed research; implementation still requires Canary review")
            lines.append("")

    lines.extend(
        [
            "## Usage rules",
            "",
            "- Canary repository files are the source of truth for implementation shape and Lua APIs.",
            "- Official or community sources may support game facts, but must not be copied verbatim into dialogue or prose.",
            "- Inferences must remain explicitly marked and must not be promoted to high confidence without verification.",
            "- This report is a dry-run artifact and does not authorize writes to an active datapack, OTBM, or items.otb.",
            "",
        ]
    )
    return "\n".join(lines)


def write_report(task: dict, output: str | Path) -> Path:
    path = Path(output)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(build_report(task), encoding="utf-8")
    return path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    write_report(read_json(args.task), args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
