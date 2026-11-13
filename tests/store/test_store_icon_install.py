"""Isolated fresh/mixed deployment and path-boundary regressions; no network."""
from pathlib import Path
import sys
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools/store"))
import deploy_store_images as deploy
import fetch_missing_store_offer_icons as fetch


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
    print("PASS: offline full install, mixed-source precedence, traversal/drive rejection and destination boundaries")


if __name__ == "__main__":
    main()
