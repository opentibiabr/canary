"""Isolated fresh/mixed deployment and path-boundary regressions; no network."""
import io
from pathlib import Path
import struct
import sys
import tempfile
from unittest.mock import patch
import zipfile
import zlib

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/store"))
import deploy_store_images as deploy
import fetch_missing_store_offer_icons as fetch
from png_validation import validate_png


def main():
    images = deploy.collect_images()
    with tempfile.TemporaryDirectory(prefix="canary-store-icons-") as directory:
        base = Path(directory)
        fetch.ROOT = base / "repository"
        inventory = base / "inventory.txt"
        destination = base / "http"
        # Every shipped icon installs offline, including the composite bundles.
        inventory.write_text("\n".join(images), encoding="utf-8")
        sys.argv = ["fetch", str(inventory), "--deploy", str(destination)]
        fetch.main()
        assert all((destination / name).read_bytes() == data for name, data in images.items())
        # Mixed lists must prefer the repository, even when an archive is needed.
        bundle = "64/Bundle_Burning_Ash_1525.png"
        probe = "64/Review_Probe.png"
        archive = base / "fallback.zip"
        with zipfile.ZipFile(archive, "w") as output:
            output.writestr("store/" + bundle, b"must never replace the repository preview")
            output.writestr("store/" + probe, images[bundle])
        inventory.write_text(bundle + "\n" + probe, encoding="utf-8")
        mixed = base / "mixed"
        sys.argv = ["fetch", str(inventory), "--deploy", str(mixed), "--archive", str(archive)]
        fetch.main()
        assert (mixed / bundle).read_bytes() == images[bundle]
        assert (mixed / probe).read_bytes() == images[bundle]
        def chunk(kind, contents):
            return struct.pack(">I", len(contents)) + kind + contents + struct.pack(">I", zlib.crc32(kind + contents))

        signature = b"\x89PNG\r\n\x1a\n"
        header = chunk(b"IHDR", struct.pack(">IIBBBBB", 1, 1, 8, 6, 0, 0, 0))
        end = chunk(b"IEND", b"")
        valid = signature + header + chunk(b"IDAT", zlib.compress(b"\x00\xff\x00\x00\xff")) + end
        assert validate_png(valid) == (1, 1)
        broken_pixels = signature + header + chunk(b"IDAT", b"not a zlib stream") + end
        # A later APNG frame must also decode, not just the initial PNG frame.
        animated = io.BytesIO()
        with Image.new("RGBA", (1, 1), "red") as first, Image.new("RGBA", (1, 1), "blue") as second:
            first.save(animated, format="PNG", save_all=True, append_images=[second], duration=100)
        animated_data = animated.getvalue()
        assert validate_png(animated_data) == (1, 1)
        offset, damaged_animation = 8, bytearray(signature)
        while offset < len(animated_data):
            length = struct.unpack(">I", animated_data[offset:offset + 4])[0]
            kind = animated_data[offset + 4:offset + 8]
            contents = animated_data[offset + 8:offset + 8 + length]
            if kind == b"fdAT":
                contents = contents[:4] + b"invalid compressed frame"
            damaged_animation.extend(chunk(kind, contents))
            offset += length + 12
        broken_crc = bytearray(valid); broken_crc[len(signature) + len(header) - 1] ^= 1
        for index, malformed in enumerate((signature, valid[:24], valid[:-1], bytes(broken_crc), broken_pixels, bytes(damaged_animation))):
            try:
                validate_png(malformed)
            except ValueError:
                pass
            else:
                raise AssertionError("Accepted truncated or invalid PNG")
            # Neither installer may write even a valid prepared companion first.
            invalid_root = base / ("invalid-root-" + str(index))
            (invalid_root / "64").mkdir(parents=True)
            (invalid_root / bundle).write_bytes(images[bundle])
            (invalid_root / probe).write_bytes(malformed)
            (invalid_root / "legacy-offer-icons.json").write_text("[]", encoding="utf-8")
            with zipfile.ZipFile(invalid_root / "legacy-offer-icons.zip", "w"):
                pass
            rejected = base / ("rejected-deploy-" + str(index))
            with patch.object(deploy, "ROOT", invalid_root):
                sys.argv = ["deploy", "--deploy", str(rejected)]
                try:
                    deploy.main()
                except ValueError:
                    pass
                else:
                    raise AssertionError("Deployer installed an invalid PNG")
            assert not rejected.exists()
            with zipfile.ZipFile(archive, "w") as output:
                output.writestr("store/" + probe, malformed)
            inventory.write_text(bundle + "\n" + probe, encoding="utf-8")
            rejected = base / ("rejected-fetch-" + str(index))
            sys.argv = ["fetch", str(inventory), "--deploy", str(rejected), "--archive", str(archive)]
            try:
                fetch.main()
            except ValueError:
                pass
            else:
                raise AssertionError("Fetcher installed an invalid PNG")
            assert not rejected.exists()
        for name in ("../escape.png", "64/../../escape.png", "64/C:escape.png", "64\\escape.png"):
            inventory.write_text(name, encoding="utf-8")
            sys.argv = ["fetch", str(inventory), "--deploy", str(base / "unsafe")]
            try:
                fetch.main()
            except ValueError:
                pass
            else:
                raise AssertionError("Accepted unsafe inventory name")
            assert not (base / "unsafe").exists()
        # A child directory symlink must not escape the explicitly selected root.
        outside, linked = base / "outside", base / "linked"
        outside.mkdir()
        linked.mkdir()
        try:
            (linked / "64").symlink_to(outside, target_is_directory=True)
        except OSError:
            print("SKIP: directory symlink creation unavailable on this host")
        else:
            try:
                deploy.safe_target(linked, "64/escape.png")
            except ValueError:
                pass
            else:
                raise AssertionError("Accepted escaping destination symlink")
    print("PASS: offline full install, mixed-source precedence, complete PNG validation, no partial invalid installs and path boundaries")


if __name__ == "__main__":
    main()
