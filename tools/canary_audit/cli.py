"""Command-line interface with stable exit codes for local use and CI."""

from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import date
from pathlib import Path, PurePosixPath
from typing import Any, Sequence

from .config import AuditConfig, ConfigError, load_config
from .models import SEVERITY_RANK, is_sha
from .runner import AuditArtifacts, run_audit
from .schema_tools import (
	SchemaError,
	load_and_validate_json,
	stable_json,
	validate_all_schemas,
	validate_instance,
)
from .workspace import (
	WorkspaceError,
	atomic_write_text,
	relative_outputs,
	resolve_workspace_path,
	safe_relative_path,
)


EXIT_SUCCESS = 0
EXIT_FINDINGS = 1
EXIT_USAGE = 2
EXIT_INCOMPLETE = 3

DEFAULT_CONFIG = "tools/canary_audit/config.json"
DEFAULT_OUTPUT = "artifacts/canary-audit"

ARTIFACT_SCHEMAS = {
	"project-index.json": "project-index.schema.json",
	"symbol-registry.json": "symbol-registry.schema.json",
	"reference-report.json": "reference-report.schema.json",
}


def _parser() -> argparse.ArgumentParser:
	parser = argparse.ArgumentParser(
		prog="python -m tools.canary_audit",
		description="Build and validate deterministic Canary content audit artifacts.",
	)
	parser.add_argument("--config", default=DEFAULT_CONFIG, help="repository-relative configuration path")
	subcommands = parser.add_subparsers(dest="command", required=True)

	scan = subcommands.add_parser("scan", help="scan the repository, write artifacts, and apply the finding gate")
	scan.add_argument(
		"--output-dir",
		default=DEFAULT_OUTPUT,
		help="repository-relative artifact directory under the configured artifactRoot",
	)
	scan.add_argument("--profile", default="all", help="load profile name or 'all'")
	scan.add_argument("--fail-on", choices=["info", "warning", "error"], help="override configured gate severity")
	scan.add_argument("--base-sha", help="optional 40-character PR base commit SHA")
	scan.add_argument("--head-sha", help="optional 40-character checked commit SHA")
	scan.add_argument("--github-annotations", action="store_true", help="emit GitHub workflow annotations")

	validate = subcommands.add_parser("validate", help="validate schemas and an existing artifact directory")
	validate.add_argument("--input-dir", default=DEFAULT_OUTPUT, help="repository-relative artifact directory")

	subcommands.add_parser("validate-schemas", help="validate every bundled schema against its meta-schema")
	return parser


def _load_config_and_baseline(root: Path, config_relative: str) -> tuple[AuditConfig, frozenset[str]]:
	config_name = safe_relative_path(config_relative, "config path")
	config_path = resolve_workspace_path(root, config_name, must_exist=True)
	load_and_validate_json(config_path, "config.schema.json")
	config = load_config(config_path)
	baseline_path = resolve_workspace_path(root, config.baseline_path, must_exist=True)
	baseline = load_and_validate_json(baseline_path, "baseline.schema.json")
	today = date.today()
	waivers = set()
	for waiver in baseline["waivers"]:
		expires = waiver.get("expiresOn")
		if expires and date.fromisoformat(expires) < today:
			continue
		waivers.add(waiver["fingerprint"])
	return config, frozenset(waivers)


def _selected_profiles(config: AuditConfig, requested: str) -> tuple[str, ...]:
	if requested == "all":
		return tuple(sorted(config.profile_by_name))
	if requested not in config.profile_by_name:
		raise ConfigError(f"unknown profile {requested!r}; expected one of {sorted(config.profile_by_name)}")
	return (requested,)


def _validate_sha(label: str, value: str | None) -> None:
	if not is_sha(value):
		raise ConfigError(f"{label} must be a lowercase 40-character commit SHA")


def _validate_artifacts(artifacts: AuditArtifacts) -> None:
	validate_instance("project-index.schema.json", artifacts.project_index)
	validate_instance("symbol-registry.schema.json", artifacts.symbol_registry)
	validate_instance("reference-report.schema.json", artifacts.reference_report)


def _artifact_output_directory(config: AuditConfig, requested: str) -> str:
	directory = safe_relative_path(requested, "output directory").rstrip("/")
	root_parts = PurePosixPath(config.artifact_root).parts
	if PurePosixPath(directory).parts[: len(root_parts)] != root_parts:
		raise ConfigError(f"output directory must be {config.artifact_root!r} or one of its descendants")
	return directory


def _write_artifacts(root: Path, output_directory: str, artifacts: AuditArtifacts) -> None:
	paths = relative_outputs(
		output_directory,
		("project-index.json", "symbol-registry.json", "reference-report.json", "summary.md"),
	)
	payloads = (
		stable_json(artifacts.project_index),
		stable_json(artifacts.symbol_registry),
		stable_json(artifacts.reference_report),
		artifacts.summary_markdown,
	)
	for path, payload in zip(paths, payloads, strict=True):
		atomic_write_text(root, path, payload)


def _annotation_escape_data(value: str) -> str:
	return value.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def _annotation_escape_property(value: str) -> str:
	return _annotation_escape_data(value).replace(":", "%3A").replace(",", "%2C")


def _emit_annotations(artifacts: AuditArtifacts, gate_severity: str) -> None:
	for diagnostic in artifacts.diagnostics:
		if diagnostic.severity != "error":
			continue
		location = diagnostic.location
		metadata = ""
		if location is not None:
			metadata = f" file={_annotation_escape_property(location.path)},line={location.line},col={location.column}"
		print(f"::error{metadata}::{_annotation_escape_data(diagnostic.message)}")
	for finding in artifacts.findings:
		if (
			finding.baseline_status != "new"
			or SEVERITY_RANK[finding.severity] < SEVERITY_RANK[gate_severity]
		):
			continue
		location = finding.locations[0]
		annotation_level = "notice" if finding.severity == "info" else finding.severity
		print(
			f"::{annotation_level} file={_annotation_escape_property(location.path)},line={location.line},col={location.column},"
			f"title={_annotation_escape_property(finding.rule_id)}::{_annotation_escape_data(finding.message)}"
		)


def _scan(root: Path, args: argparse.Namespace, config: AuditConfig, waivers: frozenset[str]) -> int:
	_validate_sha("base SHA", args.base_sha)
	_validate_sha("head SHA", args.head_sha)
	profiles = _selected_profiles(config, args.profile)
	gate_severity = args.fail_on or config.gate_severity
	output_directory = _artifact_output_directory(config, args.output_dir)
	artifacts = run_audit(
		root,
		config,
		selected_profiles=profiles,
		waived_fingerprints=waivers,
		base_sha=args.base_sha,
		head_sha=args.head_sha,
		gate_severity=gate_severity,
	)
	_validate_artifacts(artifacts)
	_write_artifacts(root, output_directory, artifacts)
	print(artifacts.summary_markdown.rstrip())
	if args.github_annotations or os.environ.get("GITHUB_ACTIONS") == "true":
		_emit_annotations(artifacts, gate_severity)
	if artifacts.incomplete:
		return EXIT_INCOMPLETE
	if artifacts.blocking_count:
		return EXIT_FINDINGS
	return EXIT_SUCCESS


def _validate_existing(root: Path, input_directory: str) -> int:
	validate_all_schemas()
	directory = safe_relative_path(input_directory, "input directory").rstrip("/")
	for file_name, schema_name in ARTIFACT_SCHEMAS.items():
		relative = f"{directory}/{file_name}"
		path = resolve_workspace_path(root, relative, must_exist=True)
		load_and_validate_json(path, schema_name)
	print(f"Validated {len(ARTIFACT_SCHEMAS)} audit artifacts in {directory}")
	return EXIT_SUCCESS


def main(argv: Sequence[str] | None = None, *, repository_root: Path | None = None) -> int:
	parser = _parser()
	args = parser.parse_args(argv)
	try:
		root = (repository_root or Path(__file__).resolve().parents[2]).resolve(strict=True)
	except (OSError, RuntimeError) as error:
		print(f"canary-audit: internal workspace failure: {error}", file=sys.stderr)
		return EXIT_INCOMPLETE

	if args.command == "validate-schemas":
		try:
			validate_all_schemas()
			print("All Canary audit schemas are valid")
			return EXIT_SUCCESS
		except Exception as error:
			print(f"canary-audit: internal schema failure: {error}", file=sys.stderr)
			return EXIT_INCOMPLETE

	try:
		config, waivers = _load_config_and_baseline(root, args.config)
	except (ConfigError, SchemaError, WorkspaceError, ValueError) as error:
		print(f"canary-audit: {error}", file=sys.stderr)
		return EXIT_USAGE

	if args.command == "validate":
		try:
			return _validate_existing(root, args.input_dir)
		except (ConfigError, SchemaError, WorkspaceError, ValueError) as error:
			print(f"canary-audit: {error}", file=sys.stderr)
			return EXIT_USAGE

	if args.command != "scan":
		print(f"canary-audit: unsupported command: {args.command}", file=sys.stderr)
		return EXIT_USAGE
	try:
		_validate_sha("base SHA", args.base_sha)
		_validate_sha("head SHA", args.head_sha)
		_selected_profiles(config, args.profile)
		_artifact_output_directory(config, args.output_dir)
	except (ConfigError, WorkspaceError, ValueError) as error:
		print(f"canary-audit: {error}", file=sys.stderr)
		return EXIT_USAGE
	try:
		return _scan(root, args, config, waivers)
	except Exception as error:  # Scanning, schema composition, and writes are operational failures.
		print(f"canary-audit: internal scan failure: {error}", file=sys.stderr)
		return EXIT_INCOMPLETE


if __name__ == "__main__":
	raise SystemExit(main())
