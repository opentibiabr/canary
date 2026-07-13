# Canary content reference auditor

`tools/canary_audit` builds a deterministic, profile-aware index of Canary
content and validates references against authoritative definitions. It is
intended for local development and CI; it does not start or compile the server.

The auditor deliberately prefers an unresolved fact over guessing the meaning
of a dynamic Lua expression. See
[`docs/systems/content-reference-auditor.md`](../../docs/systems/content-reference-auditor.md)
for the data model and semantic rules.

## Requirements

- Python 3.12
- `pip`
- Git, recommended for deterministic tracked and non-ignored file discovery

Run all commands below from the repository root.

```sh
python -m pip install -r tools/canary_audit/requirements.txt
```

## Quick start

Validate the bundled JSON Schemas and run the unit tests before scanning:

```sh
python -m tools.canary_audit validate-schemas
python -m unittest discover -s tools/canary_audit/tests -t . -p "test_*.py" -v
```

Scan both supported profiles and validate the generated artifacts:

```sh
python -m tools.canary_audit scan --profile all --output-dir artifacts/canary-audit
python -m tools.canary_audit validate --input-dir artifacts/canary-audit
```

The output directory is created inside the repository workspace. Each artifact
file is replaced atomically and the directory contains:

- `project-index.json`: deterministic file inventory and revision metadata;
- `symbol-registry.json`: typed definitions, references, registrations,
  unresolved expressions, and coverage declarations;
- `reference-report.json`: diagnostics, semantic findings, fingerprints,
  baseline status, and gate counts;
- `summary.md`: concise human-readable status and coverage summary.

## Load profiles

Canary loads the shared `data` layer with exactly one gameplay datapack. The
auditor mirrors that behavior instead of treating alternative datapacks as if
they were loaded together.

| Profile | Layers |
| --- | --- |
| `canary` | `data` + `data-canary` |
| `otservbr-global` | `data` + `data-otservbr-global` |
| `all` | Evaluates both profiles independently |

For example:

```sh
python -m tools.canary_audit scan --profile canary
python -m tools.canary_audit scan --profile otservbr-global
```

Definitions shared by alternative datapacks are therefore not reported as
cross-datapack conflicts.

## Commands

### `scan`

```sh
python -m tools.canary_audit scan \
  --profile all \
  --output-dir artifacts/canary-audit \
  --fail-on error
```

Options:

- `--profile`: `canary`, `otservbr-global`, or `all`;
- `--output-dir`: repository-relative output directory equal to the configured
  `artifactRoot` or one of its descendants. The default root is `artifacts`, so
  a path outside `artifacts` is rejected with exit code `2`;
- `--fail-on`: override the configured `info`, `warning`, or `error` gate;
- `--base-sha` and `--head-sha`: optional lowercase 40-character commit SHAs
  recorded in the artifacts;
- `--github-annotations`: emit annotations for errors and new gated findings.

The default configuration is `tools/canary_audit/config.json`. To use another
validated, repository-relative configuration, place the global option before
the command:

```sh
python -m tools.canary_audit --config tools/canary_audit/config.json scan --profile all
```

### `validate`

`validate` checks all bundled schemas and validates the three JSON artifacts in
an existing output directory:

```sh
python -m tools.canary_audit validate --input-dir artifacts/canary-audit
```

### `validate-schemas`

`validate-schemas` validates every `*.schema.json` file in
`tools/canary_audit/schemas` against the JSON Schema Draft 2020-12
meta-schema:

```sh
python -m tools.canary_audit validate-schemas
```

## Exit codes

| Code | Meaning |
| ---: | --- |
| `0` | Scan or validation completed with no new finding at or above the gate severity |
| `1` | Scan completed, but at least one new finding reached the gate severity |
| `2` | Invalid CLI usage, configuration, input artifact/schema, SHA, or requested path |
| `3` | Incomplete scan or operational failure during extraction, artifact composition, validation, or writing |

Incomplete input takes precedence over the finding gate. A report with status
`incomplete` must not be treated as a clean audit.

## Baseline waivers

`tools/canary_audit/baseline.json` contains reviewed finding fingerprints. A
waiver requires a reason and may include an ISO `expiresOn` date:

```json
{
  "schemaVersion": 1,
  "waivers": [
    {
      "fingerprint": "<64 lowercase hexadecimal characters>",
      "reason": "Document why this known finding is currently accepted.",
      "expiresOn": "2099-12-31"
    }
  ]
}
```

Copy fingerprints from `reference-report.json`. Fingerprints exclude line
numbers but include the rule, profile, domain, normalized value, and source
paths. This keeps a waiver stable when nearby lines move while invalidating it
when its semantic scope changes. Expired waivers are ignored; unused active
waivers are counted as stale.

Waivers suppress only semantic findings. Operational `scan.*` diagnostics,
including parse, input, limit, and workspace failures, cannot be waived.

## Coverage boundaries

- `data/items/appearances.dat` is authoritative for server item IDs. Entries
  must contain protobuf `id` and `flags` fields, and IDs must fit `uint16`, as
  required by the runtime item loader.
- `data/items/items.xml` is an override layer. Its `id` and `fromid`/`toid`
  entries are references that must resolve to the protobuf catalog; they do not
  create authoritative item definitions.
- IDs `0` through `99` follow the fluid handling implemented by
  `Items::parseItemNode` and are represented explicitly by the auditor.
- Registered Lua monster and NPC types, statically resolvable Lua calls, world
  spawn XML, raid spawns, configured storage tables, and `storages.xml` are
  covered.
- Player and global storage domains are separate.
- Action, movement, weapon, and spell selectors are typed according to their
  constructor. Repeated references are not treated as duplicate definitions.
- Binary `.otbm` maps are not parsed. Action-ID and unique-ID selectors are
  indexed as Lua registrations only, so the auditor does not claim that a map
  selector exists or is missing.
- Dynamic expressions are recorded with `unresolved` role and dynamic
  confidence. They are coverage information, not fabricated missing-reference
  findings.

## Configuration and schemas

`tools/canary_audit/config.json` declares layers, profiles, source files,
storage roots, safety limits, severities, the baseline path, and the
`artifactRoot` output boundary. Its shape is validated by
`schemas/config.schema.json` before a scan begins.

All schemas are strict: unknown object properties are rejected. When changing
an artifact shape, update its schema, tests, readers, and `schemaVersion`
together.
