"""Deploy loose Store images and the checked-in legacy preview archive."""
import argparse
import hashlib
import json
import re
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[2] / "data/images/store"


def safe_target(base, name):
    if not re.fullmatch(r"(?:13|64)/[A-Za-z0-9_.()' &-]+\.png", name) or ".." in name:
        raise ValueError("Invalid Store image filename")
    root = base.resolve()
    target = (root / name).resolve()
    if not target.is_relative_to(root):
        raise ValueError("Image path escapes the selected Store directory")
    return target


def collect_images():
    images = {}
    for size in ("13", "64"):
        for path in (ROOT / size).glob("*.png"):
            images[f"{size}/{path.name}"] = path.read_bytes()
    manifest = json.loads((ROOT / "legacy-offer-icons.json").read_text(encoding="utf-8"))
    with zipfile.ZipFile(ROOT / "legacy-offer-icons.zip") as archive:
        for entry in manifest:
            name = entry["file"]
            safe_target(ROOT, name)
            parts = Path(name).parts
            if len(parts) != 2 or parts[0] != "64" or not parts[1].endswith(".png") or ".." in parts[1] or "\\" in name:
                raise ValueError(f"Unsafe image path: {name}")
            data = archive.read(name)
            if hashlib.sha256(data).hexdigest() != entry["sha256"]:
                raise ValueError(f"Image checksum mismatch: {name}")
            if name in images and images[name] != data:
                raise ValueError(f"Conflicting image sources: {name}")
            images[name] = data
    for name, data in images.items():
        if data[:8] != b"\x89PNG\r\n\x1a\n":
            raise ValueError(f"Not a PNG: {name}")
    return images


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--deploy", type=Path, help="HTTP Store root containing 13/ and 64/")
    args = parser.parse_args()
    images = collect_images()
    if args.deploy:
        # Validate every existing target before writing anything.
        for name, data in images.items():
            target = safe_target(args.deploy, name)
            if target.exists() and target.read_bytes() != data:
                raise ValueError(f"Refusing to replace different image: {target}")
        for name, data in images.items():
            target = safe_target(args.deploy, name)
            target.parent.mkdir(parents=True, exist_ok=True)
            if not target.exists():
                with target.open("xb") as output:
                    output.write(data)
    print(f"PASS: {len(images)} validated Store images" + (f" deployed to {args.deploy}" if args.deploy else ""))


if __name__ == "__main__":
    main()
