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

MAP_URL_FILES = (
    "config.lua.dist",
    "docker/data/start.sh",
    "docker/.env.dist",
    "docker/docker-compose.yml",
    "docker/DOCKER.md",
)

MYAAC_CLIENT_FILES = (
    "docker/.env.dist",
    "docker/docker-compose.yml",
    "docker/DOCKER.md",
    "docker/quickstart/myaac/bootstrap.php",
)


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


def read_core_metadata() -> CoreMetadata:
    core = read_text("src/core.hpp")
    release_match = re.search(r'SERVER_RELEASE_VERSION\s*=\s*"([^"]+)"', core)
    client_match = re.search(r"CLIENT_VERSION\s*=\s*(\d+)", core)
    if not release_match:
        raise RuntimeError("SERVER_RELEASE_VERSION was not found in src/core.hpp")
    if not client_match:
        raise RuntimeError("CLIENT_VERSION was not found in src/core.hpp")
    return CoreMetadata(release_version=release_match.group(1), client_version=int(client_match.group(1)))


def write_if_changed(path: str, text: str) -> str:
    current = read_text(path)
    if current == text:
        return current
    write_text(path, text)
    return text


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

    # Iterate over the map files to update their URL/versions
    map_files = MAP_URL_FILES
    for file_path in map_files:
        if os.path.exists(file_path):
            file_text = read_text(file_path)
            # Apply map URL logic if needed
            file_text = replace_map_urls(file_text, tag)
            changed.extend(write_if_changed(file_path, file_text))

    if include_local_config:
        # Handle MYAAC specific replacements
        for file_path in MYAAC_CLIENT_FILES:
            if os.path.exists(file_path):
                file_text = replace_myaac_client_version(read_text(file_path), effective_client_version)
                changed.extend(write_if_changed(file_path, file_text))

    return changed


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update release metadata for the Canary repository.")
    parser.add_argument("--version", required=True, help="Release version (e.g., 15.25.0)")
    parser.add_argument("--client", type=int, required=True, help="Client version (e.g., 5250)")
    parser.add_argument("--local", action="store_true", help="Include local config overrides")
    args = parser.parse_args()

    tag = f"v{args.version}"
    metadata = update_release_metadata(args.version, args.client, args.local)
    
    if not metadata:
        print("No files were updated.")
        sys.exit(0)
    
    print(f"Updated release version to {tag}.")
    sys.exit(0)