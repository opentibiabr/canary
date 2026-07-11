"""Shared immutable models used by extractors, rules, and reporters."""

from __future__ import annotations

import hashlib
import json
import re
import unicodedata
from dataclasses import dataclass, field
from typing import Any, Literal


SCHEMA_VERSION = 1
TOOL_VERSION = "1.0.0"

Role = Literal["definition", "reference", "registration", "unresolved"]
Confidence = Literal["exact", "derived", "dynamic"]
Severity = Literal["info", "warning", "error"]

SEVERITY_RANK: dict[str, int] = {"info": 0, "warning": 1, "error": 2}


def normalize_value(domain: str, value: int | str) -> int | str:
	"""Return the lookup representation used by semantic rules."""
	if isinstance(value, int):
		return value
	text = unicodedata.normalize("NFC", value).strip()
	if domain in {"monster.name", "npc.name"}:
		return text.casefold()
	return text


def value_sort_key(value: int | str) -> tuple[int, str]:
	return (0, f"{value:020d}") if isinstance(value, int) else (1, value)


@dataclass(frozen=True)
class Location:
	path: str
	line: int = 1
	column: int = 1

	def __post_init__(self) -> None:
		if not self.path or "\\" in self.path or self.path.startswith("/"):
			raise ValueError(f"location path must be repository-relative POSIX: {self.path!r}")
		if any(part in {"", ".", ".."} for part in self.path.split("/")):
			raise ValueError(f"location path is not normalized: {self.path!r}")
		if self.line < 1 or self.column < 1:
			raise ValueError("line and column must be positive")

	def as_dict(self) -> dict[str, Any]:
		return {"path": self.path, "line": self.line, "column": self.column}


@dataclass(frozen=True)
class Fact:
	domain: str
	role: Role
	value: int | str
	layer: str
	profiles: tuple[str, ...]
	location: Location
	extractor: str
	confidence: Confidence = "exact"
	end_value: int | None = None
	symbol: str | None = None
	owner: str | None = None
	attributes: tuple[tuple[str, str], ...] = field(default_factory=tuple)

	def __post_init__(self) -> None:
		if self.end_value is not None:
			if not isinstance(self.value, int) or self.end_value < self.value:
				raise ValueError("fact ranges require an integer end_value >= value")
		if not self.profiles:
			raise ValueError("facts must belong to at least one load profile")

	def as_dict(self) -> dict[str, Any]:
		result: dict[str, Any] = {
			"domain": self.domain,
			"role": self.role,
			"value": self.value,
			"layer": self.layer,
			"profiles": list(self.profiles),
			"location": self.location.as_dict(),
			"extractor": self.extractor,
			"confidence": self.confidence,
		}
		if self.end_value is not None:
			result["endValue"] = self.end_value
		if self.symbol is not None:
			result["symbol"] = self.symbol
		if self.owner is not None:
			result["owner"] = self.owner
		if self.attributes:
			result["attributes"] = dict(self.attributes)
		return result

	def sort_key(self) -> tuple[Any, ...]:
		return (
			self.domain,
			self.role,
			value_sort_key(self.value),
			self.end_value if self.end_value is not None else -1,
			self.layer,
			self.location.path,
			self.location.line,
			self.location.column,
			self.extractor,
		)


@dataclass(frozen=True)
class Diagnostic:
	code: str
	message: str
	severity: Severity
	location: Location | None = None
	identity: str = ""

	def sort_key(self) -> tuple[Any, ...]:
		location = self.location or Location("tools/canary_audit/config.json")
		return (self.severity, self.code, self.identity, location.path, location.line, self.message)


@dataclass(frozen=True)
class Finding:
	rule_id: str
	severity: Severity
	confidence: Confidence
	profile: str
	domain: str
	value: int | str
	message: str
	locations: tuple[Location, ...]
	fingerprint: str
	baseline_status: Literal["new", "waived"] = "new"

	def as_dict(self) -> dict[str, Any]:
		return {
			"ruleId": self.rule_id,
			"severity": self.severity,
			"confidence": self.confidence,
			"profile": self.profile,
			"domain": self.domain,
			"value": self.value,
			"message": self.message,
			"locations": [location.as_dict() for location in self.locations],
			"fingerprint": self.fingerprint,
			"baselineStatus": self.baseline_status,
		}

	def sort_key(self) -> tuple[Any, ...]:
		return (
			-SEVERITY_RANK[self.severity],
			self.rule_id,
			self.profile,
			self.domain,
			value_sort_key(self.value),
			self.fingerprint,
		)


def finding_fingerprint(
	rule_id: str,
	profile: str,
	domain: str,
	value: int | str,
	paths: list[str] | tuple[str, ...],
	extra: str = "",
) -> str:
	"""Build a stable fingerprint that deliberately excludes line numbers."""
	payload = {
		"ruleId": rule_id,
		"profile": profile,
		"domain": domain,
		"value": normalize_value(domain, value),
		"paths": sorted(set(paths)),
		"extra": extra,
	}
	canonical = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
	return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def is_sha(value: str | None) -> bool:
	return value is None or bool(re.fullmatch(r"[0-9a-f]{40}", value))
