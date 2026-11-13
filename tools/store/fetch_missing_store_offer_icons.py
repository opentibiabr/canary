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
import struct
import subprocess
import tempfile
import urllib.request
import zipfile

from deploy_store_images import collect_images, safe_target

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


def regular_input(path, suffix, maximum):
    resolved = path.resolve(strict=True)
    if resolved.suffix.lower() != suffix or not resolved.is_file() or resolved.stat().st_size > maximum:
        raise ValueError("Expected a bounded regular " + suffix + " input file")
    return resolved


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inventory", type=Path)
    parser.add_argument("--deploy", type=Path, required=True, help="HTTP Store asset root")
    parser.add_argument("--archive", type=Path, help="Previously downloaded Store ZIP")
    args = parser.parse_args()
    inventory = regular_input(args.inventory, ".txt", 512 * 1024)
    names = inventory.read_text(encoding="utf-8").splitlines()
    if not names or len(set(names)) != len(names):
        raise ValueError("Expected a nonempty unique image inventory")
    targets = {name: safe_target(args.deploy, name) for name in names}
    missing = [name for name in names if not targets[name].is_file()]
    if not missing:
        print(f"PASS: all {len(names)} catalog HTTP images already exist; nothing overwritten")
        return

    # Prefer each repository-backed preview individually, even in a mixed list.
    supplied = collect_images()
    prepared = {name: supplied[name] for name in missing if name in supplied}
    unknown = [name for name in missing if name not in supplied]
    additions = []
    if unknown:
        if args.archive:
            archive_path = regular_input(args.archive, ".zip", 32 * 1024 * 1024)
            raw = archive_path.read_bytes()
        else:
            with urllib.request.urlopen(URL, timeout=30) as response:
                raw = response.read(32 * 1024 * 1024 + 1)
        if len(raw) > 32 * 1024 * 1024:
            raise ValueError("Store archive is too large")
        archive_hash = hashlib.sha256(raw).hexdigest()
        with zipfile.ZipFile(io.BytesIO(raw)) as archive:
            for name in unknown:
                entry = archive.getinfo("store/" + name)
                if entry.is_dir() or entry.file_size > 1024 * 1024:
                    raise ValueError("Invalid Store archive entry")
                original = archive.read(entry)
                data = png_content(original)
                width, height = struct.unpack(">II", data[16:24])
                if not (1 <= width <= 128 and 1 <= height <= 128):
                    raise ValueError("Invalid preview dimensions")
                prepared[name] = data
                additions.append({"file": name, "source": URL, "archive_entry": "store/" + name,
                                  "archive_sha256": archive_hash, "sha256": hashlib.sha256(data).hexdigest(),
                                  "bytes": len(data), "converted_gif_first_frame": data != original})
    # Prepare everything before creating files, and check repository output paths too.
    assets = ROOT / "data/images/store"
    for name in unknown:
        local = safe_target(assets, name)
        if local.exists() and local.read_bytes() != prepared[name]:
            raise ValueError("Refusing to overwrite a different repository preview")
    for name, data in prepared.items():
        target = targets[name]
        target.parent.mkdir(parents=True, exist_ok=True)
        with target.open("xb") as output:
            output.write(data)
        if name in unknown:
            local = safe_target(assets, name)
            local.parent.mkdir(parents=True, exist_ok=True)
            if not local.exists():
                with local.open("xb") as output:
                    output.write(data)
    if additions:
        manifest_path = assets / "offer-icons.json"
        manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else []
        by_name = {entry["file"]: entry for entry in manifest}
        by_name.update({entry["file"]: entry for entry in additions})
        manifest_path.write_text(json.dumps([by_name[name] for name in sorted(by_name)], indent=2) + "\n", encoding="utf-8")
    print(f"PASS: installed {len(prepared)} missing previews; repository images take precedence")


if __name__ == "__main__":
    main()
