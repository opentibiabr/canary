"""Validated repository-specific configuration and load-profile handling."""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Any

from .models import Severity


class ConfigError(ValueError):
	pass


def _relative_path(value: str, field_name: str) -> str:
	if not value or "\\" in value:
		raise ConfigError(f"{field_name} must use a non-empty POSIX path")
	if any(part in {"", ".", ".."} for part in value.split("/")):
		raise ConfigError(f"{field_name} must be normalized and stay inside the repository: {value!r}")
	path = PurePosixPath(value)
	if path.is_absolute() or any(part in {"", ".", ".."} for part in path.parts):
		raise ConfigError(f"{field_name} must stay inside the repository: {value!r}")
	return path.as_posix()


@dataclass(frozen=True)
class Layer:
	name: str
	root: str


@dataclass(frozen=True)
class Profile:
	name: str
	layers: tuple[str, ...]


@dataclass(frozen=True)
class StorageTable:
	path: str
	root: str
	domain: str


@dataclass(frozen=True)
class AuditConfig:
	schema_version: int
	layers: tuple[Layer, ...]
	profiles: tuple[Profile, ...]
	excluded_directories: frozenset[str]
	max_text_file_bytes: int
	max_lua_tokens: int
	max_xml_file_bytes: int
	max_facts_per_file: int
	max_diagnostics_per_file: int
	max_total_facts: int
	max_total_diagnostics: int
	max_findings: int
	artifact_root: str
	item_catalog_files: tuple[str, ...]
	item_override_files: tuple[str, ...]
	storage_tables: tuple[StorageTable, ...]
	storage_xml_files: tuple[str, ...]
	severity_by_rule: dict[str, Severity]
	gate_severity: Severity
	baseline_path: str

	@property
	def layer_by_name(self) -> dict[str, Layer]:
		return {layer.name: layer for layer in self.layers}

	@property
	def profile_by_name(self) -> dict[str, Profile]:
		return {profile.name: profile for profile in self.profiles}

	def layer_for_path(self, path: str) -> str | None:
		matches = [
			layer
			for layer in self.layers
			if path == layer.root or path.startswith(f"{layer.root}/")
		]
		if not matches:
			return None
		return max(matches, key=lambda layer: len(layer.root)).name

	def profiles_for_layer(self, layer: str) -> tuple[str, ...]:
		return tuple(profile.name for profile in self.profiles if layer in profile.layers)

	def severity_for(self, rule_id: str, domain: str) -> Severity:
		return self.severity_by_rule.get(
			f"{rule_id}:{domain}",
			self.severity_by_rule.get(f"{rule_id}:*", self.severity_by_rule.get("*", "warning")),
		)


def load_config(path: Path) -> AuditConfig:
	try:
		data = json.loads(path.read_text(encoding="utf-8"))
	except (OSError, UnicodeError, json.JSONDecodeError) as error:
		raise ConfigError(f"cannot load audit config {path}: {error}") from error

	if data.get("schemaVersion") != 1:
		raise ConfigError("unsupported config schemaVersion")

	layers = tuple(
		Layer(name=str(item["name"]), root=_relative_path(str(item["root"]), "layers.root"))
		for item in data.get("layers", [])
	)
	if not layers or len({item.name for item in layers}) != len(layers):
		raise ConfigError("layers must have unique names")
	if len({item.root for item in layers}) != len(layers):
		raise ConfigError("layer roots must be unique")

	layer_names = {item.name for item in layers}
	profiles = tuple(
		Profile(name=str(item["name"]), layers=tuple(str(name) for name in item["layers"]))
		for item in data.get("profiles", [])
	)
	if not profiles or len({item.name for item in profiles}) != len(profiles):
		raise ConfigError("profiles must have unique names")
	for profile in profiles:
		if not profile.layers or not set(profile.layers) <= layer_names:
			raise ConfigError(f"profile {profile.name!r} references an unknown layer")

	storage_tables = tuple(
		StorageTable(
			path=_relative_path(str(item["path"]), "storageTables.path"),
			root=str(item["root"]),
			domain=str(item["domain"]),
		)
		for item in data.get("storageTables", [])
	)

	severity_data = data.get("severityByRule", {})
	valid_severities = {"info", "warning", "error"}
	if any(value not in valid_severities for value in severity_data.values()):
		raise ConfigError("severityByRule contains an invalid severity")
	gate_severity = str(data.get("gateSeverity", "error"))
	if gate_severity not in valid_severities:
		raise ConfigError("gateSeverity must be info, warning, or error")

	max_bytes = int(data.get("maxTextFileBytes", 4_000_000))
	max_lua_tokens = int(data.get("maxLuaTokens", 250_000))
	max_xml_bytes = int(data.get("maxXmlFileBytes", 32_000_000))
	max_facts = int(data.get("maxFactsPerFile", 100_000))
	max_diagnostics = int(data.get("maxDiagnosticsPerFile", 1_000))
	max_total_facts = int(data.get("maxTotalFacts", 1_000_000))
	max_total_diagnostics = int(data.get("maxTotalDiagnostics", 50_000))
	max_findings = int(data.get("maxFindings", 50_000))
	if any(
		limit < 1
		for limit in (
			max_bytes,
			max_lua_tokens,
			max_xml_bytes,
			max_facts,
			max_diagnostics,
			max_total_facts,
			max_total_diagnostics,
			max_findings,
		)
	):
		raise ConfigError("scan limits must be positive")
	excluded_directories = frozenset(str(value) for value in data.get("excludedDirectories", []))
	artifact_root = _relative_path(str(data.get("artifactRoot", "artifacts")), "artifactRoot")
	if PurePosixPath(artifact_root).parts[0] not in excluded_directories:
		raise ConfigError("artifactRoot must be nested under an excluded top-level directory")

	return AuditConfig(
		schema_version=1,
		layers=layers,
		profiles=profiles,
		excluded_directories=excluded_directories,
		max_text_file_bytes=max_bytes,
		max_lua_tokens=max_lua_tokens,
		max_xml_file_bytes=max_xml_bytes,
		max_facts_per_file=max_facts,
		max_diagnostics_per_file=max_diagnostics,
		max_total_facts=max_total_facts,
		max_total_diagnostics=max_total_diagnostics,
		max_findings=max_findings,
		artifact_root=artifact_root,
		item_catalog_files=tuple(_relative_path(str(value), "itemCatalogFiles") for value in data.get("itemCatalogFiles", [])),
		item_override_files=tuple(_relative_path(str(value), "itemOverrideFiles") for value in data.get("itemOverrideFiles", [])),
		storage_tables=storage_tables,
		storage_xml_files=tuple(_relative_path(str(value), "storageXmlFiles") for value in data.get("storageXmlFiles", [])),
		severity_by_rule={str(key): value for key, value in severity_data.items()},
		gate_severity=gate_severity,
		baseline_path=_relative_path(str(data.get("baselinePath", "tools/canary_audit/baseline.json")), "baselinePath"),
	)


def config_to_schema_instance(config: AuditConfig) -> dict[str, Any]:
	"""Return a small normalized view useful in tests and diagnostics."""
	return {
		"layers": [layer.name for layer in config.layers],
		"profiles": [profile.name for profile in config.profiles],
		"gateSeverity": config.gate_severity,
	}
