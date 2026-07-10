#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from io_utils import atomic_write_json, dumps_json, read_json
from path_policy import require_safe_write

HEADER = "-- Generated preview — not active game content\n"


def _safe_stem(name: str) -> str:
    stem = re.sub(r"[^a-z0-9_-]+", "_", name.lower()).strip("_")
    if not stem:
        raise ValueError("name does not produce a safe filename")
    return stem


def render(task, plan, outdir):
    output_root = Path(outdir)
    base = output_root / task["taskId"]
    require_safe_write(base, output_root=output_root)
    base.mkdir(parents=True, exist_ok=True)

    files = []
    kind = task["type"]
    stem = _safe_stem(task["name"])

    if kind in {"quest", "npc", "spell", "raid", "monster"}:
        extension = ".xml" if kind in {"monster", "raid"} else ".lua"
        path = base / kind / f"{stem}{extension}"
        require_safe_write(path, output_root=output_root)
        path.parent.mkdir(parents=True, exist_ok=True)
        body = (
            HEADER
            + f'-- Task: {task["taskId"]}\n-- Type: {kind}\n-- Name: {task["name"]}\n'
            + f'return {{ name = {task["name"]!r}, dryRun = true }}\n'
        )
        if extension == ".xml":
            body = (
                "<!-- Generated preview — not active game content -->\n"
                + f'<!-- Task: {task["taskId"]}; Type: {kind}; Name: {task["name"]} -->\n'
            )
        path.write_text(body, encoding="utf-8")
        files.append(path)
    else:
        path = base / "MANUAL_IMPLEMENTATION_REQUIRED.md"
        require_safe_write(path, output_root=output_root)
        path.write_text(
            "# Manual implementation required\n\nGenerated preview — not active game content.\n",
            encoding="utf-8",
        )
        files.append(path)

    manifest_path = base / "MANIFEST.json"
    require_safe_write(manifest_path, output_root=output_root)
    manifest = {
        "taskId": task["taskId"],
        "files": [
            {
                "path": str(path.relative_to(output_root)).replace("\\", "/"),
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in sorted(files)
        ],
    }
    atomic_write_json(manifest_path, manifest)
    return manifest


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--plan", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()
    manifest = render(read_json(args.task), read_json(args.plan), args.output_dir)
    print(dumps_json(manifest), end="")


if __name__ == "__main__":
    raise SystemExit(main())
