#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
TAG_RE = re.compile(r"^v(?P<version>\d+\.\d+\.\d+)$")
MAP_URL_RE = re.compile(r"https://github\.com/opentibiabr/canary/releases/download/v\d+\.\d+\.\d+/otservbr\.otbm")

MAP_URL_FILES = [
    "config.lua.dist",
    "docker/data/start.sh",
    "docker/.env.dist",
    "docker/docker-compose.yml",
    "docker/DOCKER.md",
]

MYAAC_CLIENT_FILES = [
    "docker/.env.dist",
    "docker/docker-compose.yml",
    "docker/DOCKER.md",
    "docker/quickstart/myaac/bootstrap.php",
]


@dataclass(frozen=True)
class CoreMetadata:
    release_version: str
    client_version: int


def repo_path(path: str) -> Path:
    return REPO_ROOT / path


def read_text(path: str) -> str:
    return repo_path(path).read_text(encoding="utf-8")


def write_text(path: str, text: str) -> None:
    repo_path(path).write_text(text, encoding="utf-8", newline="")


def run_git(args: list[str]) -> str:
    result = subprocess.run(["git", *args], cwd=REPO_ROOT, text=True, capture_output=True, check=False)
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def parse_tag(tag: str) -> str:
    match = TAG_RE.match(tag)
    if not match:
        raise ValueError(f"release tag must use stable SemVer format vX.Y.Z, got {tag!r}")
    return match.group("version")


def map_url_for_tag(tag: str) -> str:
    return f"https://github.com/opentibiabr/canary/releases/download/{tag}/otservbr.otbm"


def read_core_metadata() -> CoreMetadata:
    core = read_text("src/core.hpp")
    release_match = re.search(r'SERVER_RELEASE_VERSION\s*=\s*"([^"]+)"', core)
    client_match = re.search(r"CLIENT_VERSION\s*=\s*(\d+)", core)
    if not release_match:
        raise RuntimeError("SERVER_RELEASE_VERSION was not found in src/core.hpp")
    if not client_match:
        raise RuntimeError("CLIENT_VERSION was not found in src/core.hpp")
    return CoreMetadata(release_version=release_match.group(1), client_version=int(client_match.group(1)))


def client_display(client_version: int) -> str:
    return f"{client_version // 100}.{client_version % 100:02d}"


def replace_once(pattern: str, replacement: str, text: str, label: str) -> str:
    updated, count = re.subn(pattern, replacement, text, count=1)
    if count != 1:
        raise RuntimeError(f"failed to update {label}")
    return updated


def replace_map_urls(text: str, tag: str) -> str:
    return MAP_URL_RE.sub(map_url_for_tag(tag), text)


def replace_myaac_client_version(text: str, client_version: int) -> str:
    replacements = [
        (r"MYAAC_CLIENT_VERSION=\d+", f"MYAAC_CLIENT_VERSION={client_version}"),
        (r'MYAAC_CLIENT_VERSION: "\$\{MYAAC_CLIENT_VERSION:-\d+\}"', f'MYAAC_CLIENT_VERSION: "${{MYAAC_CLIENT_VERSION:-{client_version}}}"'),
        (r"env_value\('MYAAC_CLIENT_VERSION', '\d+'\)", f"env_value('MYAAC_CLIENT_VERSION', '{client_version}')"),
    ]
    updated = text
    for pattern, replacement in replacements:
        updated = re.sub(pattern, replacement, updated)
    return updated


def update_release_metadata(version: str, client_version: int | None, include_local_config: bool) -> list[str]:
    tag = f"v{version}"
    changed: list[str] = []

    core = read_text("src/core.hpp")
    effective_client_version = client_version
    if effective_client_version is None:
        effective_client_version = read_core_metadata().client_version
    core = replace_once(
        r'SERVER_RELEASE_VERSION\s*=\s*"[^"]+"',
        f'SERVER_RELEASE_VERSION = "{version}"',
        core,
        "SERVER_RELEASE_VERSION",
    )
    core = replace_once(
        r"CLIENT_VERSION\s*=\s*\d+",
        f"CLIENT_VERSION = {effective_client_version}",
        core,
        "CLIENT_VERSION",
    )
    changed.extend(write_if_changed("src/core.hpp", core))

    map_files = list(MAP_URL_FILES)
    if include_local_config and repo_path("config.lua").exists():
        map_files.append("config.lua")

    for path in map_files:
        updated = replace_map_urls(read_text(path), tag)
        changed.extend(write_if_changed(path, updated))

    for path in MYAAC_CLIENT_FILES:
        updated = replace_myaac_client_version(read_text(path), effective_client_version)
        changed.extend(write_if_changed(path, updated))

    return changed


def materialize_release_metadata(tag: str, include_local_config: bool) -> list[str]:
    version = parse_tag(tag)
    return update_release_metadata(version, None, include_local_config)


def write_if_changed(path: str, updated: str) -> list[str]:
    current = read_text(path)
    if current == updated:
        return []
    write_text(path, updated)
    return [path]


def semver_tags_merged_into(tag: str) -> list[str]:
    output = run_git(["tag", "--merged", f"{tag}^{{commit}}", "--sort=-version:refname", "--list", "v[0-9]*.[0-9]*.[0-9]*"])
    return [line.strip() for line in output.splitlines() if line.strip()]


def previous_semver_tag(tag: str) -> str:
    for candidate in semver_tags_merged_into(tag):
        if candidate != tag and TAG_RE.match(candidate):
            return candidate
    return ""


def check_release_metadata(tag: str, include_local_config: bool, strict: bool) -> dict[str, str]:
    version = parse_tag(tag)
    expected_map_url = map_url_for_tag(tag)
    metadata = read_core_metadata()
    errors: list[str] = []

    if strict and metadata.release_version != version:
        errors.append(f"src/core.hpp SERVER_RELEASE_VERSION is {metadata.release_version}, expected {version}")

    map_files = list(MAP_URL_FILES)
    if include_local_config and repo_path("config.lua").exists():
        map_files.append("config.lua")

    for path in map_files:
        text = read_text(path)
        urls = sorted(set(MAP_URL_RE.findall(text)))
        if not urls:
            errors.append(f"{path} does not contain a Canary otservbr.otbm release URL")
            continue
        stale_urls = [url for url in urls if url != expected_map_url]
        if strict and stale_urls:
            errors.append(f"{path} has stale map URL(s): {', '.join(stale_urls)}; expected {expected_map_url}")

    expected_client = str(metadata.client_version)
    for path in MYAAC_CLIENT_FILES:
        text = read_text(path)
        if f"MYAAC_CLIENT_VERSION={expected_client}" in text:
            continue
        if f'MYAAC_CLIENT_VERSION:-{expected_client}' in text:
            continue
        if f"env_value('MYAAC_CLIENT_VERSION', '{expected_client}')" in text:
            continue
        errors.append(f"{path} does not default MYAAC_CLIENT_VERSION to CLIENT_VERSION {expected_client}")

    if errors:
        for error in errors:
            print(f"::error::{error}")
        raise RuntimeError("release metadata check failed")

    return {
        "tag": tag,
        "version": version,
        "client_version": expected_client,
        "client_display": client_display(metadata.client_version),
        "map_url": expected_map_url,
        "previous_tag": previous_semver_tag(tag),
    }


def write_github_outputs(outputs: dict[str, str]) -> None:
    output_path = os.environ.get("GITHUB_OUTPUT")
    if not output_path:
        return
    with open(output_path, "a", encoding="utf-8") as output:
        for key, value in outputs.items():
            print(f"{key}={value}", file=output)


def main() -> int:
    parser = argparse.ArgumentParser(description="Update or validate Canary release metadata.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    update_parser = subparsers.add_parser("update", help="Update tracked release metadata before tagging.")
    update_parser.add_argument("--version", required=True, help="Release version without the leading v, for example 3.6.0.")
    update_parser.add_argument("--client-version", type=int, help="Optional protocol integer, for example 1511.")
    update_parser.add_argument("--include-local-config", action="store_true", help="Also update ignored config.lua when present.")

    materialize_parser = subparsers.add_parser("materialize", help="Update release metadata in the current checkout from a tag.")
    materialize_parser.add_argument("--tag", required=True, help="Release tag, for example v3.6.0.")
    materialize_parser.add_argument("--include-local-config", action="store_true", help="Also update ignored config.lua when present.")

    check_parser = subparsers.add_parser("check", help="Validate release metadata for an existing tag.")
    check_parser.add_argument("--tag", required=True, help="Release tag, for example v3.6.0.")
    check_parser.add_argument("--include-local-config", action="store_true", help="Also validate ignored config.lua when present.")
    check_parser.add_argument("--strict", action="store_true", help="Require tracked metadata to already match the tag.")

    args = parser.parse_args()
    try:
        if args.command == "update":
            parse_tag(f"v{args.version}")
            changed = update_release_metadata(args.version, args.client_version, args.include_local_config)
            if changed:
                print("Updated release metadata:")
                for path in changed:
                    print(f"- {path}")
            else:
                print("Release metadata is already up to date.")
            return 0

        if args.command == "materialize":
            changed = materialize_release_metadata(args.tag, args.include_local_config)
            if changed:
                print(f"Materialized release metadata for {args.tag}:")
                for path in changed:
                    print(f"- {path}")
            else:
                print(f"Release metadata is already materialized for {args.tag}.")
            return 0

        outputs = check_release_metadata(args.tag, args.include_local_config, args.strict)
        write_github_outputs(outputs)
        print(f"Release metadata is valid for {args.tag}.")
        return 0
    except Exception as exc:
        print(f"::error::{exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
