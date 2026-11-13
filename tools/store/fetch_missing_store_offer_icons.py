"""Deploy only missing HTTP icons from the Store image pack referenced by OTClient.

First export the production catalog inventory with list_store_http_images.lua.
Only explicitly inventoried PNG entries are read; archive files are never
executed or extracted wholesale, and existing deployed files are preserved.
"""
import argparse
import hashlib
import io
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import tempfile
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[2]
URL = "https://dl.dropboxusercontent.com/s/5b00ubu1erapu9q/store.zip"


def png_content(data):
    if data[:8] == b"\x89PNG\r\n\x1a\n":
        return data
    # One legacy pack entry is a GIF despite its .png filename. Convert only
    # that known format to a genuine static PNG using the Windows image codec.
    assert data[:6] in (b"GIF87a", b"GIF89a") and os.name == "nt"
    with tempfile.TemporaryDirectory(prefix="canary-store-icon-") as directory:
        source, target = Path(directory) / "source.gif", Path(directory) / "target.png"
        source.write_bytes(data)
        env = dict(os.environ, CANARY_ICON_INPUT=str(source), CANARY_ICON_OUTPUT=str(target))
        command = (
            "Add-Type -AssemblyName System.Drawing; "
            "$storeIcon = [System.Drawing.Image]::FromFile($env:CANARY_ICON_INPUT); "
            "try { $storeIcon.Save($env:CANARY_ICON_OUTPUT, [System.Drawing.Imaging.ImageFormat]::Png) } "
            "finally { $storeIcon.Dispose() }"
        )
        subprocess.run(["powershell", "-NoProfile", "-NonInteractive", "-Command", command],
                       env=env, check=True, capture_output=True)
        return target.read_bytes()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inventory", type=Path)
    parser.add_argument("--deploy", type=Path, required=True, help="HTTP Store asset root")
    parser.add_argument("--archive", type=Path, help="Previously downloaded Store ZIP")
    args = parser.parse_args()
    names = args.inventory.read_text(encoding="utf-8").splitlines()
    assert names and len(set(names)) == len(names)
    assert all(re.fullmatch(r"(?:13|64)/[A-Za-z0-9_.-]+\.png", n) and ".." not in n for n in names)
    missing = [n for n in names if not (args.deploy / n).is_file()]
    if not missing:
        print(f"PASS: all {len(names)} catalog HTTP images already exist; nothing overwritten")
        return
    if args.archive:
        raw = args.archive.read_bytes()
    else:
        with urllib.request.urlopen(URL, timeout=30) as response:
            raw = response.read(32 * 1024 * 1024 + 1)
    assert len(raw) <= 32 * 1024 * 1024
    archive_hash = hashlib.sha256(raw).hexdigest()
    prepared = []
    assets = ROOT / "data/images/store"
    with zipfile.ZipFile(io.BytesIO(raw)) as archive:
        for filename in missing:
            entry = archive.getinfo("store/" + filename)
            assert entry.file_size <= 1024 * 1024 and not entry.is_dir()
            original = archive.read(entry)
            data = png_content(original)
            assert data[:8] == b"\x89PNG\r\n\x1a\n", filename
            size = int(filename.split("/")[0])
            width, height = struct.unpack_from(">II", data, 16)
            if size == 13:
                assert (width, height) == (13, 13), filename
            else:
                # Legacy bed artwork includes a 32x64 and a 96x96 source;
                # retain original pixels and let the Store scale its preview.
                assert 1 <= width <= 128 and 1 <= height <= 128, filename
            local = assets / filename
            assert not local.exists() or local.read_bytes() == data, filename
            prepared.append((filename, data, data != original))
    manifest_path = assets / "offer-icons.json"
    manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else []
    by_name = {entry["file"]: entry for entry in manifest}
    for filename, data, converted in prepared:
        for base in (assets, args.deploy):
            target = base / filename
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists():
                assert target.read_bytes() == data, target
            else:
                with target.open("xb") as output:
                    output.write(data)
        by_name[filename] = {
            "file": filename, "source": URL, "archive_entry": "store/" + filename,
            "archive_sha256": archive_hash, "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data),
            "converted_gif_first_frame": converted,
        }
    manifest_path.write_text(json.dumps([by_name[n] for n in sorted(by_name)], indent=2) + "\n", encoding="utf-8")
    print(f"PASS: installed {len(prepared)} missing PNGs in the repository and {args.deploy}")
    print(f"PASS: preserved {len(names) - len(prepared)} existing catalog images")


if __name__ == "__main__":
    main()
