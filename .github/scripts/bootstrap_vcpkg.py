#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from pathlib import Path


def run(*args: str, cwd: Path | None = None) -> None:
    subprocess.run(args, cwd=cwd, check=True)


def main() -> int:
    root = Path(__file__).resolve().parents[2]
    manifest = json.loads((root / "vcpkg.json").read_text(encoding="utf-8"))
    baseline = manifest["builtin-baseline"]
    vcpkg_root = Path(os.environ.get("VCPKG_ROOT", root / ".tools" / "vcpkg"))

    if not (vcpkg_root / ".git").exists():
        vcpkg_root.parent.mkdir(parents=True, exist_ok=True)
        run("git", "clone", "https://github.com/microsoft/vcpkg.git", str(vcpkg_root))

    run("git", "fetch", "--quiet", "origin", baseline, cwd=vcpkg_root)
    run("git", "checkout", "--quiet", "--detach", baseline, cwd=vcpkg_root)

    bootstrap = "bootstrap-vcpkg.bat" if os.name == "nt" else "bootstrap-vcpkg.sh"
    run(str(vcpkg_root / bootstrap), "-disableMetrics", cwd=vcpkg_root)
    print(vcpkg_root)
    return 0


if __name__ == "__main__":
    sys.exit(main())
