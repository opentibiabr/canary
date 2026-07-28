"""Semantic rules over typed facts, isolated from extraction details."""

from __future__ import annotations

from bisect import bisect_right
from collections import defaultdict
from dataclasses import dataclass, replace
import heapq
from typing import Iterable, Iterator

from .config import AuditConfig
from .models import Fact, Finding, Location, finding_fingerprint, normalize_value, value_sort_key


AUTHORITATIVE_DOMAINS = {
	"item.server_id",
	"monster.name",
	"npc.name",
	"storage.player",
	"storage.global",
}

MAX_FINDING_LOCATIONS = 20


@dataclass(frozen=True)
class _NumericDefinitionIndex:
	intervals: tuple[tuple[int, int], ...]
	starts: tuple[int, ...]


_EMPTY_NUMERIC_DEFINITION_INDEX = _NumericDefinitionIndex((), ())


def _locations(facts: Iterable[Fact]) -> tuple[Location, ...]:
	unique = {(fact.location.path, fact.location.line, fact.location.column): fact.location for fact in facts}
	keys = heapq.nsmallest(MAX_FINDING_LOCATIONS, unique)
	return tuple(unique[key] for key in keys)


def _definition_aliases(fact: Fact) -> tuple[int | str, ...]:
	aliases = [normalize_value(fact.domain, fact.value)]
	if fact.symbol:
		aliases.append(normalize_value(fact.domain, fact.symbol))
	return tuple(aliases)


def _numeric_intervals(definitions: Iterable[Fact]) -> list[tuple[int, int, Fact]]:
	result = []
	for fact in definitions:
		if isinstance(fact.value, int):
			result.append((fact.value, fact.end_value if fact.end_value is not None else fact.value, fact))
	return sorted(result, key=lambda item: (item[0], item[1], item[2].sort_key()))


def _merged_numeric_intervals(definitions: Iterable[Fact]) -> tuple[tuple[int, int], ...]:
	merged: list[list[int]] = []
	for start, end, _ in _numeric_intervals(definitions):
		if not merged or start > merged[-1][1] + 1:
			merged.append([start, end])
		else:
			merged[-1][1] = max(merged[-1][1], end)
	return tuple((start, end) for start, end in merged)


def _numeric_definition_index(definitions: Iterable[Fact]) -> _NumericDefinitionIndex:
	intervals = _merged_numeric_intervals(definitions)
	return _NumericDefinitionIndex(
		intervals=intervals,
		starts=tuple(start for start, _ in intervals),
	)


def _missing_numeric_ranges(
	reference: Fact,
	definitions: _NumericDefinitionIndex,
) -> list[tuple[int, int]]:
	if not isinstance(reference.value, int):
		return []
	start = reference.value
	end = reference.end_value if reference.end_value is not None else start
	cursor = start
	missing: list[tuple[int, int]] = []
	index = max(0, bisect_right(definitions.starts, cursor) - 1) if definitions.starts else 0
	while index < len(definitions.intervals):
		definition_start, definition_end = definitions.intervals[index]
		if definition_end < cursor:
			index += 1
			continue
		if definition_start > end:
			break
		if definition_start > cursor:
			missing.append((cursor, min(end, definition_start - 1)))
		cursor = max(cursor, definition_end + 1)
		if cursor > end:
			break
		index += 1
	if cursor <= end:
		missing.append((cursor, end))
	return missing


def _reference_is_defined(
	reference: Fact,
	definitions: _NumericDefinitionIndex,
	definition_aliases: frozenset[int | str],
) -> bool:
	if isinstance(reference.value, int):
		return not _missing_numeric_ranges(reference, definitions)
	target = normalize_value(reference.domain, reference.value)
	return target in definition_aliases


def _missing_reference_findings(
	facts: tuple[Fact, ...],
	config: AuditConfig,
	profiles: tuple[str, ...],
) -> Iterator[Finding]:
	for profile in profiles:
		definitions_by_domain: dict[str, list[Fact]] = defaultdict(list)
		for fact in facts:
			if profile in fact.profiles and fact.role == "definition":
				definitions_by_domain[fact.domain].append(fact)
		numeric_indexes_by_domain = {
			domain: _numeric_definition_index(definitions)
			for domain, definitions in definitions_by_domain.items()
		}
		aliases_by_domain = {
			domain: frozenset(alias for definition in definitions for alias in _definition_aliases(definition))
			for domain, definitions in definitions_by_domain.items()
		}

		for reference in facts:
			if (
				profile not in reference.profiles
				or reference.role != "reference"
				or reference.domain not in AUTHORITATIVE_DOMAINS
			):
				continue
			numeric_index = numeric_indexes_by_domain.get(
				reference.domain,
				_EMPTY_NUMERIC_DEFINITION_INDEX,
			)
			definition_aliases = aliases_by_domain.get(reference.domain, frozenset())
			if isinstance(reference.value, int):
				missing_ranges = _missing_numeric_ranges(reference, numeric_index)
				for start, end in missing_ranges:
					value: int | str = start if start == end else f"{start}-{end}"
					rule_id = (
						"item.override-missing-definition"
						if reference.extractor == "xml.item-override"
						else "reference.missing-definition"
					)
					yield _build_finding(
						rule_id=rule_id,
						config=config,
						profile=profile,
						domain=reference.domain,
						value=value,
						message=f"{reference.owner or 'reference'} uses {value!r} without an authoritative definition",
						facts=(reference,),
					)
			elif not _reference_is_defined(reference, numeric_index, definition_aliases):
				yield _build_finding(
					rule_id="reference.missing-definition",
					config=config,
					profile=profile,
					domain=reference.domain,
					value=reference.value,
					message=f"{reference.owner or 'reference'} uses {reference.value!r} without an authoritative definition",
					facts=(reference,),
				)


def _duplicate_definition_findings(
	facts: tuple[Fact, ...],
	config: AuditConfig,
	profiles: tuple[str, ...],
) -> Iterator[Finding]:
	for profile in profiles:
		by_domain: dict[str, list[Fact]] = defaultdict(list)
		for fact in facts:
			if profile in fact.profiles and fact.role == "definition":
				by_domain[fact.domain].append(fact)

		for domain, definitions in by_domain.items():
			if domain in {"monster.name", "npc.name"}:
				by_value: dict[int | str, list[Fact]] = defaultdict(list)
				for fact in definitions:
					by_value[normalize_value(domain, fact.value)].append(fact)
				for value, matches in by_value.items():
					if len(_locations(matches)) > 1:
						yield _build_finding(
							rule_id="definition.duplicate-value",
							config=config,
							profile=profile,
							domain=domain,
							value=value,
							message=f"{domain} {value!r} is defined more than once in profile {profile}",
							facts=tuple(matches),
						)
			else:
				for start, end, overlapping, overlap_count in _overlapping_numeric_segments(definitions):
					yield _overlap_finding(
						start,
						end,
						overlapping,
						overlap_count,
						config,
						profile,
						domain,
					)

			by_symbol: dict[str, list[Fact]] = defaultdict(list)
			for fact in definitions:
				if fact.symbol:
					by_symbol[fact.symbol].append(fact)
			for symbol, matches in by_symbol.items():
				values = {normalize_value(domain, match.value) for match in matches}
				if len(values) > 1:
					yield _build_finding(
						rule_id="definition.symbol-conflict",
						config=config,
						profile=profile,
						domain=domain,
						value=symbol,
						message=f"symbol {symbol!r} resolves to multiple {domain} values",
						facts=tuple(matches),
					)


def _overlapping_numeric_segments(
	definitions: Iterable[Fact],
) -> Iterator[tuple[int, int, tuple[Fact, ...], int]]:
	"""Yield exact inclusive segments covered by more than one definition."""
	events: dict[int, tuple[list[int], list[int]]] = defaultdict(lambda: ([], []))
	entries: dict[int, Fact] = {}
	for serial, (start, end, fact) in enumerate(_numeric_intervals(definitions)):
		entries[serial] = fact
		events[start][0].append(serial)
		events[end + 1][1].append(serial)

	positions = sorted(events)
	active: set[int] = set()
	representative_heap: list[tuple[tuple[object, ...], int]] = []
	for index, position in enumerate(positions[:-1]):
		additions, removals = events[position]
		for serial in removals:
			active.discard(serial)
		for serial in additions:
			active.add(serial)
			heapq.heappush(representative_heap, (entries[serial].sort_key(), serial))
		segment_end = positions[index + 1] - 1
		if len(active) > 1 and position <= segment_end:
			selected: list[tuple[tuple[object, ...], int]] = []
			while representative_heap and len(selected) < MAX_FINDING_LOCATIONS:
				candidate = heapq.heappop(representative_heap)
				if candidate[1] in active:
					selected.append(candidate)
			for candidate in selected:
				heapq.heappush(representative_heap, candidate)
			yield (
				position,
				segment_end,
				tuple(entries[serial] for _, serial in selected),
				len(active),
			)


def _overlap_finding(
	start: int,
	end: int,
	overlapping: tuple[Fact, ...],
	overlap_count: int,
	config: AuditConfig,
	profile: str,
	domain: str,
) -> Finding:
	value: int | str = start if start == end else f"{start}-{end}"
	return _build_finding(
		rule_id="definition.duplicate-value",
		config=config,
		profile=profile,
		domain=domain,
		value=value,
		message=f"{domain} contains {overlap_count} overlapping definitions in {value}",
		facts=overlapping,
	)


def _duplicate_action_registrations(
	facts: tuple[Fact, ...],
	config: AuditConfig,
	profiles: tuple[str, ...],
) -> Iterator[Finding]:
	for profile in profiles:
		groups: dict[tuple[str, int | str], list[Fact]] = defaultdict(list)
		for fact in facts:
			if profile in fact.profiles and fact.role == "registration" and fact.domain.startswith("action."):
				groups[(fact.domain, normalize_value(fact.domain, fact.value))].append(fact)
		for (domain, value), matches in groups.items():
			if len(_locations(matches)) < 2:
				continue
			yield _build_finding(
				rule_id="action.duplicate-registration",
				config=config,
				profile=profile,
				domain=domain,
				value=value,
				message=f"multiple Action handlers register {domain} {value!r} in profile {profile}",
				facts=tuple(matches),
			)


def _build_finding(
	*,
	rule_id: str,
	config: AuditConfig,
	profile: str,
	domain: str,
	value: int | str,
	message: str,
	facts: tuple[Fact, ...],
) -> Finding:
	locations = _locations(facts)
	return Finding(
		rule_id=rule_id,
		severity=config.severity_for(rule_id, domain),
		confidence="exact" if all(fact.confidence == "exact" for fact in facts) else "derived",
		profile=profile,
		domain=domain,
		value=value,
		message=message,
		locations=locations,
		fingerprint=finding_fingerprint(
			rule_id,
			profile,
			domain,
			value,
			[location.path for location in locations],
		),
	)


def evaluate_rules(
	facts: Iterable[Fact],
	config: AuditConfig,
	profiles: Iterable[str],
	waived_fingerprints: frozenset[str] = frozenset(),
) -> tuple[Finding, ...]:
	fact_tuple = tuple(sorted(facts, key=lambda fact: fact.sort_key()))
	profile_tuple = tuple(sorted(set(profiles)))
	findings: list[Finding] = []
	producers = (
		_missing_reference_findings(fact_tuple, config, profile_tuple),
		_duplicate_definition_findings(fact_tuple, config, profile_tuple),
		_duplicate_action_registrations(fact_tuple, config, profile_tuple),
	)
	for producer in producers:
		for finding in producer:
			if len(findings) >= config.max_findings:
				raise RuntimeError(
					f"semantic rule output exceeded configured maxFindings={config.max_findings}"
				)
			findings.append(
				replace(finding, baseline_status="waived")
				if finding.fingerprint in waived_fingerprints
				else finding
			)
	return tuple(sorted(findings, key=lambda finding: finding.sort_key()))
