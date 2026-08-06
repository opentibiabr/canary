"""Safe, deterministic discovery and atomic workspace I/O."""

from __future__ import annotations

import os
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Iterable


class WorkspaceError(RuntimeError):
	pass


WINDOWS_DEVICE_NAMES = {
	"CON",
	"PRN",
	"AUX",
	"NUL",
	*(f"COM{index}" for index in range(1, 10)),
	*(f"LPT{index}" for index in range(1, 10)),
}

GIT_COMMAND_TIMEOUT_SECONDS = 30


@dataclass(frozen=True)
class DiscoveredFile:
	path: str
	absolute_path: Path
	size_bytes: int
	extension: str


def safe_relative_path(value: str, field_name: str = "path") -> str:
	if not value or "\\" in value:
		raise WorkspaceError(f"{field_name} must be a non-empty POSIX path")
	try:
		value.encode("utf-8", errors="strict")
	except UnicodeError as error:
		raise WorkspaceError(f"{field_name} must be valid UTF-8") from error
	raw_parts = value.split("/")
	if any(part in {"", ".", ".."} for part in raw_parts):
		raise WorkspaceError(f"{field_name} must be normalized and stay inside the repository: {value!r}")
	path = PurePosixPath(value)
	if path.is_absolute() or any(part in {"", ".", ".."} for part in path.parts):
		raise WorkspaceError(f"{field_name} must stay inside the repository: {value!r}")
	for part in path.parts:
		device = part.rstrip(" .").split(".", 1)[0].upper()
		if device in WINDOWS_DEVICE_NAMES:
			raise WorkspaceError(f"{field_name} uses a reserved device name: {part!r}")
	return path.as_posix()


def safe_relative_directory(value: str, field_name: str = "directory") -> str:
	"""Normalize trailing separators on a repository-local directory."""
	return safe_relative_path(value.rstrip("/"), field_name)


def _is_within(path: Path, root: Path) -> bool:
	try:
		path.relative_to(root)
		return True
	except ValueError:
		return False


def _reject_symlink_components(root: Path, relative: str, include_leaf: bool = True) -> None:
	current = root
	parts = PurePosixPath(relative).parts
	if not include_leaf:
		parts = parts[:-1]
	for part in parts:
		current = current / part
		if current.is_symlink():
			raise WorkspaceError(f"symlink path components are not allowed: {relative}")


def resolve_workspace_path(
	root: Path,
	relative: str,
	*,
	must_exist: bool = False,
	reject_leaf_symlink: bool = True,
) -> Path:
	root = root.resolve(strict=True)
	normalized = safe_relative_path(relative)
	_reject_symlink_components(root, normalized, include_leaf=reject_leaf_symlink)
	candidate = (root / PurePosixPath(normalized)).resolve(strict=must_exist)
	if not _is_within(candidate, root):
		raise WorkspaceError(f"path escapes repository workspace: {relative!r}")
	return candidate


def _git_file_names(root: Path) -> list[str] | None:
	try:
		result = subprocess.run(
			["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
			cwd=root,
			check=True,
			stdout=subprocess.PIPE,
			stderr=subprocess.PIPE,
			timeout=GIT_COMMAND_TIMEOUT_SECONDS,
		)
		return sorted(
			path.decode("utf-8", errors="strict").replace("\\", "/")
			for path in result.stdout.split(b"\0")
			if path
		)
	except (FileNotFoundError, subprocess.CalledProcessError, subprocess.TimeoutExpired, UnicodeError):
		return None


def _walk_file_names(root: Path, excluded_directories: frozenset[str]) -> list[str]:
	paths: list[str] = []

	def fail_walk(error: OSError) -> None:
		raise WorkspaceError(f"cannot enumerate repository workspace: {error}") from error

	for directory, directory_names, file_names in os.walk(
		root,
		topdown=True,
		onerror=fail_walk,
		followlinks=False,
	):
		base = Path(directory)
		kept_directories = []
		for name in sorted(directory_names):
			candidate = base / name
			if name in excluded_directories or candidate.is_symlink():
				continue
			kept_directories.append(name)
		directory_names[:] = kept_directories
		for name in sorted(file_names):
			candidate = base / name
			if candidate.is_symlink():
				continue
			paths.append(candidate.relative_to(root).as_posix())
	return sorted(paths)


def discover_files(
	root: Path,
	excluded_directories: frozenset[str],
	*,
	prefer_git: bool = True,
) -> tuple[DiscoveredFile, ...]:
	"""Discover each repository file once without following symlinks."""
	root = root.resolve(strict=True)
	names = _git_file_names(root) if prefer_git else None
	if names is None:
		names = _walk_file_names(root, excluded_directories)

	result: list[DiscoveredFile] = []
	seen: set[str] = set()
	for raw_name in names:
		name = safe_relative_path(raw_name, "discovered path")
		if name in seen:
			continue
		seen.add(name)
		parts = PurePosixPath(name).parts
		if any(part in excluded_directories for part in parts):
			continue
		path = resolve_workspace_path(root, name, must_exist=True)
		if path.is_symlink() or not path.is_file():
			continue
		try:
			size = path.stat().st_size
		except OSError as error:
			raise WorkspaceError(f"cannot stat {name}: {error}") from error
		result.append(
			DiscoveredFile(
				path=name,
				absolute_path=path,
				size_bytes=size,
				extension=PurePosixPath(name).suffix.lower(),
			)
		)
	return tuple(sorted(result, key=lambda item: item.path))


def read_utf8(path: DiscoveredFile, max_bytes: int) -> str:
	if path.size_bytes > max_bytes:
		raise WorkspaceError(
			f"text file exceeds configured {max_bytes}-byte limit: {path.path} ({path.size_bytes} bytes)"
		)
	try:
		return path.absolute_path.read_bytes().decode("utf-8-sig", errors="strict")
	except (OSError, UnicodeError) as error:
		raise WorkspaceError(f"cannot read UTF-8 file {path.path}: {error}") from error


def atomic_write_text(root: Path, relative: str, content: str) -> Path:
	"""Replace one repository-local file without exposing partial contents."""
	normalized = safe_relative_path(relative, "output path")
	target = resolve_workspace_path(root, normalized, must_exist=False)
	parent_relative = PurePosixPath(normalized).parent.as_posix()
	if parent_relative != ".":
		parent = resolve_workspace_path(root, parent_relative, must_exist=False)
		parent.mkdir(parents=True, exist_ok=True)
	else:
		parent = root.resolve(strict=True)
	_reject_symlink_components(root.resolve(strict=True), normalized, include_leaf=True)

	temporary_name: str | None = None
	try:
		with tempfile.NamedTemporaryFile(
			mode="w",
			encoding="utf-8",
			newline="\n",
			prefix=f".{target.name}.",
			suffix=".tmp",
			dir=parent,
			delete=False,
		) as temporary:
			temporary_name = temporary.name
			temporary.write(content)
			temporary.flush()
			os.fsync(temporary.fileno())
		os.replace(temporary_name, target)
	except OSError as error:
		if temporary_name:
			try:
				Path(temporary_name).unlink(missing_ok=True)
			except OSError:
				pass
		raise WorkspaceError(f"cannot atomically write {normalized}: {error}") from error
	return target


def git_revision(root: Path) -> str | None:
	try:
		return subprocess.run(
			["git", "rev-parse", "HEAD"],
			cwd=root,
			check=True,
			text=True,
			stdout=subprocess.PIPE,
			stderr=subprocess.DEVNULL,
			timeout=GIT_COMMAND_TIMEOUT_SECONDS,
		).stdout.strip()
	except (FileNotFoundError, subprocess.CalledProcessError, subprocess.TimeoutExpired, UnicodeError):
		return None


def git_dirty(root: Path) -> bool | None:
	try:
		output = subprocess.run(
			["git", "status", "--porcelain=v1", "--untracked-files=normal"],
			cwd=root,
			check=True,
			text=True,
			stdout=subprocess.PIPE,
			stderr=subprocess.DEVNULL,
			timeout=GIT_COMMAND_TIMEOUT_SECONDS,
		).stdout
		return bool(output.strip())
	except (FileNotFoundError, subprocess.CalledProcessError, subprocess.TimeoutExpired, UnicodeError):
		return None


def relative_outputs(output_directory: str, file_names: Iterable[str]) -> tuple[str, ...]:
	directory = safe_relative_directory(output_directory, "output directory")
	return tuple(f"{directory}/{safe_relative_path(name, 'output file name')}" for name in file_names)
