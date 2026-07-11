"""Single-pass audit orchestration and deterministic artifact composition."""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass, replace
from pathlib import Path, PurePosixPath
from typing import Any, Iterable

from .config import AuditConfig
from .extractors import extract_file
from .models import (
	Diagnostic,
	Fact,
	Finding,
	Location,
	SCHEMA_VERSION,
	SEVERITY_RANK,
	TOOL_VERSION,
	finding_fingerprint,
)
from .rules import evaluate_rules
from .workspace import DiscoveredFile, discover_files, git_dirty, git_revision


@dataclass(frozen=True)
class AuditArtifacts:
	project_index: dict[str, Any]
	symbol_registry: dict[str, Any]
	reference_report: dict[str, Any]
	summary_markdown: str
	findings: tuple[Finding, ...]
	diagnostics: tuple[Diagnostic, ...]
	blocking_count: int
	incomplete: bool


MAX_SEMANTIC_FINDING_LOCATIONS = 20


def _revision(root: Path, base_sha: str | None = None, head_sha: str | None = None) -> dict[str, Any]:
	return {
		"headSha": head_sha or git_revision(root),
		"baseSha": base_sha,
		"workingTreeDirty": git_dirty(root),
	}


def _required_input_diagnostics(files: Iterable[DiscoveredFile], config: AuditConfig) -> list[Diagnostic]:
	discovered = {file.path for file in files}
	required = {
		*config.item_catalog_files,
		*config.item_override_files,
		*(table.path for table in config.storage_tables),
		*config.storage_xml_files,
	}
	return [
		Diagnostic(
			"scan.missing-input",
			f"configured audit input is missing: {path}",
			"error",
		)
		for path in sorted(required - discovered)
	]


def _filter_fact_profiles(fact: Fact, selected_profiles: frozenset[str]) -> Fact | None:
	profiles = tuple(profile for profile in fact.profiles if profile in selected_profiles)
	return replace(fact, profiles=profiles) if profiles else None


def _semantic_diagnostic_findings(
	diagnostics: Iterable[Diagnostic],
	config: AuditConfig,
	selected_profiles: frozenset[str],
	waived_fingerprints: frozenset[str],
) -> tuple[Finding, ...]:
	groups: dict[
		tuple[str, str, str, str, str],
		list[tuple[Diagnostic, Location]],
	] = {}
	for diagnostic in diagnostics:
		if diagnostic.code.startswith("scan."):
			continue
		location = diagnostic.location or Location("tools/canary_audit/config.json")
		layer = config.layer_for_path(location.path)
		profiles = (
			set(config.profiles_for_layer(layer)).intersection(selected_profiles)
			if layer is not None
			else set(selected_profiles)
		)
		for profile in sorted(profiles):
			identity = diagnostic.identity or diagnostic.message
			domain = "xml" if diagnostic.code.startswith("xml.") else "audit"
			groups.setdefault(
				(profile, diagnostic.code, domain, identity, location.path),
				[],
			).append((diagnostic, location))

	findings: list[Finding] = []
	for (profile, code, domain, identity, path), matches in sorted(groups.items()):
		if len(findings) >= config.max_findings:
			raise RuntimeError(
				f"semantic diagnostic output exceeded configured maxFindings={config.max_findings}"
			)
		ordered = sorted(matches, key=lambda item: item[0].sort_key())
		occurrence_count = len(ordered)
		unique_locations = {
			(location.path, location.line, location.column): location
			for _, location in ordered
		}
		location_keys = sorted(unique_locations)[:MAX_SEMANTIC_FINDING_LOCATIONS]
		locations = tuple(unique_locations[key] for key in location_keys)
		extra = code if occurrence_count == 1 else f"{code}:occurrences={occurrence_count}"
		fingerprint = finding_fingerprint(
			code,
			profile,
			domain,
			identity,
			[path],
			extra=extra,
		)
		message = ordered[0][0].message
		if occurrence_count > 1:
			message = f"{message} ({occurrence_count} occurrences with the same identity)"
		findings.append(
			Finding(
				rule_id=code,
				severity=config.severity_for(code, domain),
				confidence="exact",
				profile=profile,
				domain=domain,
				value=identity,
				message=message,
				locations=locations,
				fingerprint=fingerprint,
				baseline_status="waived" if fingerprint in waived_fingerprints else "new",
			)
		)
	return tuple(findings)


def _project_index(
	files: tuple[DiscoveredFile, ...],
	config: AuditConfig,
	revision: dict[str, Any],
) -> dict[str, Any]:
	extension_counts = Counter(file.extension or "<none>" for file in files)
	top_level_counts = Counter(PurePosixPath(file.path).parts[0] for file in files)
	layer_counts = Counter(
		layer
		for file in files
		if (layer := config.layer_for_path(file.path)) is not None
	)
	entries = []
	for file in files:
		layer = config.layer_for_path(file.path)
		entry: dict[str, Any] = {
			"path": file.path,
			"sizeBytes": file.size_bytes,
			"extension": file.extension,
		}
		if layer is not None:
			entry["layer"] = layer
			entry["profiles"] = list(config.profiles_for_layer(layer))
		entries.append(entry)
	return {
		"schemaVersion": SCHEMA_VERSION,
		"toolVersion": TOOL_VERSION,
		"revision": revision,
		"summary": {
			"fileCount": len(files),
			"totalBytes": sum(file.size_bytes for file in files),
			"extensionCounts": dict(sorted(extension_counts.items())),
			"topLevelCounts": dict(sorted(top_level_counts.items())),
			"layerCounts": dict(sorted(layer_counts.items())),
		},
		"files": entries,
	}


def _coverage(facts: tuple[Fact, ...]) -> list[dict[str, str]]:
	return [
		{
			"domain": "item.server_id",
			"status": "authoritative",
			"details": "definitions come from Appearances.object; items.xml and resolvable Lua selectors are references",
		},
		{
			"domain": "item.name",
			"status": "registrations-only",
			"details": "string item overloads are indexed but item-name definitions are not exported from protobuf yet",
		},
		{
			"domain": "monster.name",
			"status": "partial",
			"details": "registered Lua monster types and literal/static Game or XML references are covered",
		},
		{
			"domain": "npc.name",
			"status": "partial",
			"details": "registered Lua NPC types and literal/static Game or XML references are covered",
		},
		{
			"domain": "storage.player/storage.global",
			"status": "partial",
			"details": "configured Lua tables, storages.xml, and statically resolvable get/set calls are covered",
		},
		{
			"domain": "action/movement selectors",
			"status": "registrations-only",
			"details": "Lua registrations are indexed; OTBM selector definitions are not parsed",
		},
		{
			"domain": "map.otbm",
			"status": "unavailable",
			"details": "binary map validation requires a separate version-aware OTBM extractor",
		},
	]


def _symbol_registry(
	facts: tuple[Fact, ...],
	profiles: tuple[str, ...],
	revision: dict[str, Any],
) -> dict[str, Any]:
	by_domain = Counter(fact.domain for fact in facts)
	by_role = Counter(fact.role for fact in facts)
	return {
		"schemaVersion": SCHEMA_VERSION,
		"toolVersion": TOOL_VERSION,
		"revision": revision,
		"profiles": list(profiles),
		"summary": {
			"factCount": len(facts),
			"countsByDomain": dict(sorted(by_domain.items())),
			"countsByRole": dict(sorted(by_role.items())),
			"unresolvedCount": by_role.get("unresolved", 0),
		},
		"coverage": _coverage(facts),
		"facts": [fact.as_dict() for fact in facts],
	}


def _diagnostic_dict(diagnostic: Diagnostic) -> dict[str, Any]:
	result: dict[str, Any] = {
		"code": diagnostic.code,
		"severity": diagnostic.severity,
		"message": diagnostic.message,
	}
	if diagnostic.location is not None:
		result["location"] = diagnostic.location.as_dict()
	return result


def _reference_report(
	findings: tuple[Finding, ...],
	diagnostics: tuple[Diagnostic, ...],
	profiles: tuple[str, ...],
	revision: dict[str, Any],
	gate_severity: str,
	waived_fingerprints: frozenset[str],
) -> tuple[dict[str, Any], int, bool]:
	incomplete = any(diagnostic.severity == "error" for diagnostic in diagnostics)
	blocking = tuple(
		finding
		for finding in findings
		if finding.baseline_status == "new"
		and SEVERITY_RANK[finding.severity] >= SEVERITY_RANK[gate_severity]
	)
	by_severity = Counter(finding.severity for finding in findings)
	by_rule = Counter(finding.rule_id for finding in findings)
	used_waivers = {finding.fingerprint for finding in findings if finding.baseline_status == "waived"}
	report = {
		"schemaVersion": SCHEMA_VERSION,
		"toolVersion": TOOL_VERSION,
		"revision": revision,
		"profiles": list(profiles),
		"status": "incomplete" if incomplete else "complete",
		"gateSeverity": gate_severity,
		"summary": {
			"findingCount": len(findings),
			"newFindingCount": sum(finding.baseline_status == "new" for finding in findings),
			"waivedFindingCount": sum(finding.baseline_status == "waived" for finding in findings),
			"blockingFindingCount": len(blocking),
			"diagnosticCount": len(diagnostics),
			"staleWaiverCount": len(waived_fingerprints - used_waivers),
			"countsBySeverity": dict(sorted(by_severity.items())),
			"countsByRule": dict(sorted(by_rule.items())),
		},
		"diagnostics": [_diagnostic_dict(item) for item in diagnostics],
		"findings": [finding.as_dict() for finding in findings],
	}
	return report, len(blocking), incomplete


def _summary_markdown(project: dict[str, Any], registry: dict[str, Any], report: dict[str, Any]) -> str:
	lines = [
		"# Canary repository audit",
		"",
		f"- Status: **{report['status']}**",
		f"- Profiles: {', '.join(report['profiles'])}",
		f"- Files indexed: {project['summary']['fileCount']}",
		f"- Facts extracted: {registry['summary']['factCount']}",
		f"- Unresolved static expressions: {registry['summary']['unresolvedCount']}",
		f"- Findings: {report['summary']['findingCount']}",
		f"- New blocking findings: {report['summary']['blockingFindingCount']}",
		f"- Diagnostics: {report['summary']['diagnosticCount']}",
		"",
		"## Findings by severity",
		"",
	]
	counts = report["summary"]["countsBySeverity"]
	for severity in ("error", "warning", "info"):
		lines.append(f"- {severity}: {counts.get(severity, 0)}")
	lines.extend(["", "## Coverage", ""])
	for entry in registry["coverage"]:
		lines.append(f"- `{entry['domain']}`: **{entry['status']}** — {entry['details']}")
	return "\n".join(lines) + "\n"


def run_audit(
	root: Path,
	config: AuditConfig,
	*,
	selected_profiles: Iterable[str] | None = None,
	waived_fingerprints: frozenset[str] = frozenset(),
	base_sha: str | None = None,
	head_sha: str | None = None,
	gate_severity: str | None = None,
	prefer_git: bool = True,
) -> AuditArtifacts:
	profile_names = set(config.profile_by_name)
	selected = profile_names if selected_profiles is None else set(selected_profiles)
	unknown = selected - profile_names
	if not selected or unknown:
		raise ValueError(f"unknown or empty audit profile selection: {sorted(unknown)}")
	profiles = tuple(sorted(selected))
	selected_set = frozenset(profiles)
	files = discover_files(root, config.excluded_directories, prefer_git=prefer_git)
	diagnostics = _required_input_diagnostics(files, config)
	stop_scan = False
	if len(diagnostics) >= config.max_total_diagnostics:
		diagnostics = diagnostics[: max(0, config.max_total_diagnostics - 1)]
		diagnostics.append(
			Diagnostic(
				"scan.diagnostic-limit",
				f"scan diagnostics reached configured maxTotalDiagnostics={config.max_total_diagnostics}",
				"error",
			)
		)
		stop_scan = True
	facts: list[Fact] = []
	for file in files:
		if stop_scan:
			break
		layer = config.layer_for_path(file.path)
		if layer is None or not selected_set.intersection(config.profiles_for_layer(layer)):
			continue
		extraction = extract_file(file, config)
		for diagnostic in extraction.diagnostics:
			if len(diagnostics) >= config.max_total_diagnostics - 1:
				diagnostics.append(
					Diagnostic(
						"scan.diagnostic-limit",
						f"scan diagnostics reached configured maxTotalDiagnostics={config.max_total_diagnostics}",
						"error",
						Location(file.path),
					)
				)
				stop_scan = True
				break
			diagnostics.append(diagnostic)
		if stop_scan:
			break
		for fact in extraction.facts:
			filtered = _filter_fact_profiles(fact, selected_set)
			if filtered is not None:
				if len(facts) >= config.max_total_facts:
					limit_diagnostic = Diagnostic(
						"scan.fact-limit",
						f"scan facts reached configured maxTotalFacts={config.max_total_facts}",
						"error",
						Location(file.path),
					)
					if len(diagnostics) < config.max_total_diagnostics:
						diagnostics.append(limit_diagnostic)
					else:
						diagnostics[-1] = limit_diagnostic
					stop_scan = True
					break
				facts.append(filtered)
	fact_tuple = tuple(sorted(facts, key=lambda fact: fact.sort_key()))
	semantic_findings = _semantic_diagnostic_findings(diagnostics, config, selected_set, waived_fingerprints)
	diagnostic_tuple = tuple(
		sorted((item for item in diagnostics if item.code.startswith("scan.")), key=lambda item: item.sort_key())
	)
	rule_config = replace(config, max_findings=config.max_findings - len(semantic_findings))
	findings = tuple(
		sorted(
			(*evaluate_rules(fact_tuple, rule_config, profiles, waived_fingerprints), *semantic_findings),
			key=lambda finding: finding.sort_key(),
		)
	)
	revision = _revision(root, base_sha=base_sha, head_sha=head_sha)
	project = _project_index(files, config, revision)
	registry = _symbol_registry(fact_tuple, profiles, revision)
	effective_gate = gate_severity or config.gate_severity
	report, blocking_count, incomplete = _reference_report(
		findings,
		diagnostic_tuple,
		profiles,
		revision,
		effective_gate,
		waived_fingerprints,
	)
	return AuditArtifacts(
		project_index=project,
		symbol_registry=registry,
		reference_report=report,
		summary_markdown=_summary_markdown(project, registry, report),
		findings=findings,
		diagnostics=diagnostic_tuple,
		blocking_count=blocking_count,
		incomplete=incomplete,
	)
