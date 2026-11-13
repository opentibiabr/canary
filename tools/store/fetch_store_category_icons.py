"""Fetch the category icons referenced by the local Game Store catalog.

Keeps a distributable copy in data/images/store/13 and optionally deploys it to
the same 13/ directory under a supplied HTTP Store asset root. Existing files
with different content are refused rather than silently overwritten.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import re
import struct
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
BASE = "https://static.tibia.com/images/store/13/"
ALIASES = {
    "Category_HouseFurniture.png": "Category_Furniture.png",
    "Category_HouseUpgrades.png": "Category_Houseupgrades.png",
    "Category_UsefulThings.png": "Category_Convenience.png",
    # No dedicated official Tickets image was found; use its parent icon.
    "Category_Tickets.png": "Category_Tournament.png",
}


def save(path, content):
    if path.exists() and path.read_bytes() != content:
        raise FileExistsError(f"Refusing to overwrite a different existing icon: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)


def fetch(name):
    url = BASE + ALIASES.get(name, name)
    request = urllib.request.Request(url, headers={
        "User-Agent": "Mozilla/5.0",
        "Referer": "https://www.tibia.com/",
    })
    with urllib.request.urlopen(request, timeout=20) as response:
        content = response.read(65537)
        assert response.status == 200
    assert len(content) <= 65536 and content[:8] == b"\x89PNG\r\n\x1a\n", name
    assert struct.unpack_from(">II", content, 16) == (13, 13), name
    return name, url, content


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--deploy", type=Path, help="HTTP Store asset root (containing 13/ and 64/)")
    args = parser.parse_args()
    names = sorted({name
                    for path in (ROOT / "data/modules/scripts/gamestore/catalog").glob("*.lua")
                    for name in re.findall(r'"(Category_[^"/]+\.png)"', path.read_text(encoding="utf-8"))})
    assert names
    assets = ROOT / "data/images/store"
    manifest = []
    with ThreadPoolExecutor(max_workers=6) as executor:
        results = list(executor.map(fetch, names))
    for name, url, content in results:
        save(assets / "13" / name, content)
        if args.deploy:
            save(args.deploy / "13" / name, content)
        manifest.append({"file": "13/" + name, "source": url,
                         "sha256": hashlib.sha256(content).hexdigest(), "bytes": len(content)})
    (assets / "category-icons.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {len(results)} referenced category/subcategory icons downloaded and validated as 13x13 PNGs")
    if args.deploy:
        print(f"PASS: deployed all icons to {args.deploy / '13'}")
    for alias, original in ALIASES.items():
        if alias in names:
            print(f"Alias: {alias} <- {original}")


if __name__ == "__main__":
    main()
