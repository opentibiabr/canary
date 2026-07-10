from __future__ import annotations

from pathlib import Path

BLOCKED_SUFFIXES = {".otbm"}
BLOCKED_NAMES = {"items.otb"}


def repo_root() -> Path:
    return Path(__file__).resolve().parents[3]


def _resolve(path: str | Path, root: Path) -> Path:
    candidate = Path(path)
    return candidate.resolve() if candidate.is_absolute() else (root / candidate).resolve()


def is_safe_write(
    path: str | Path,
    *,
    root: str | Path | None = None,
    output_root: str | Path | None = None,
    allow_reservations: bool = False,
) -> tuple[bool, str]:
    root_path = Path(root).resolve() if root else repo_root()
    resolved_path = _resolve(path, root_path)

    try:
        relative = resolved_path.relative_to(root_path).as_posix()
    except ValueError:
        return False, f"path escapes repository root: {resolved_path.as_posix()}"

    if resolved_path.name in BLOCKED_NAMES or resolved_path.suffix.lower() in BLOCKED_SUFFIXES:
        return False, f"blocked protected file: {relative}"
    if relative == "main" or relative.startswith("main/"):
        return False, "writes to main are forbidden"
    if relative.startswith(("data/", "data-canary/", "data-otservbr-global/")):
        return False, f"active datapack writes are forbidden: {relative}"
    if allow_reservations and relative.endswith("ID_RESERVATIONS.json"):
        return True, "allowed reservations file"

    # An explicitly supplied output root is a hard sandbox boundary. Do not
    # fall through to broader writable-root rules when the path escapes it.
    if output_root is not None:
        resolved_output_root = _resolve(output_root, root_path)
        try:
            resolved_output_root.relative_to(root_path)
        except ValueError:
            return False, f"output root escapes repository root: {resolved_output_root.as_posix()}"

        try:
            resolved_path.relative_to(resolved_output_root)
            return True, "allowed output root"
        except ValueError:
            return False, f"path escapes output root: {resolved_path.as_posix()}"

    if relative.startswith("artifacts/"):
        return True, "allowed artifacts path"
    return False, f"path is outside dry-run writable roots: {relative}"


def require_safe_write(path: str | Path, **kwargs: object) -> None:
    ok, message = is_safe_write(path, **kwargs)
    if not ok:
        raise ValueError(message)
