from __future__ import annotations

from pathlib import Path

from tools.canary_audit.config import AuditConfig, load_config
from tools.canary_audit.models import Fact, Location
from tools.canary_audit.workspace import DiscoveredFile


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
CONFIG_PATH = REPOSITORY_ROOT / "tools/canary_audit/config.json"
BASELINE_PATH = REPOSITORY_ROOT / "tools/canary_audit/baseline.json"


def repository_config() -> AuditConfig:
	return load_config(CONFIG_PATH)


def discovered_file(root: Path, logical_path: str, content: str | bytes) -> DiscoveredFile:
	absolute_path = root / logical_path
	absolute_path.parent.mkdir(parents=True, exist_ok=True)
	data = content.encode("utf-8") if isinstance(content, str) else content
	absolute_path.write_bytes(data)
	return DiscoveredFile(
		path=logical_path,
		absolute_path=absolute_path,
		size_bytes=len(data),
		extension=Path(logical_path).suffix.lower(),
	)


def fact(
	*,
	domain: str,
	role: str,
	value: int | str,
	path: str,
	profiles: tuple[str, ...],
	layer: str,
	line: int = 1,
	end_value: int | None = None,
	symbol: str | None = None,
	owner: str | None = None,
) -> Fact:
	return Fact(
		domain=domain,
		role=role,  # type: ignore[arg-type]
		value=value,
		end_value=end_value,
		layer=layer,
		profiles=profiles,
		location=Location(path, line, 1),
		extractor="test",
		symbol=symbol,
		owner=owner,
	)


def encode_varint(value: int) -> bytes:
	if value < 0:
		raise ValueError("varints must be non-negative")
	result = bytearray()
	while value >= 0x80:
		result.append((value & 0x7F) | 0x80)
		value >>= 7
	result.append(value)
	return bytes(result)


def appearances_payload(*item_ids: int) -> bytes:
	result = bytearray()
	for item_id in item_ids:
		appearance = b"\x08" + encode_varint(item_id) + b"\x1a\x00"
		result.extend(b"\x0a")
		result.extend(encode_varint(len(appearance)))
		result.extend(appearance)
	return bytes(result)
