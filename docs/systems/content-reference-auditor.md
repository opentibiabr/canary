# Content reference auditor

## Purpose

The Canary content reference auditor creates a deterministic semantic index of
the repository and detects references that cannot be resolved within a real
server load profile. Its implementation lives in `tools/canary_audit` and its
CI integration lives in `.github/workflows/repository-audit.yml`.

This is a static repository check. It does not execute gameplay scripts, write
to a database, start the server, parse production credentials, compile C++, or
modify content files.

The design has three priorities:

1. model Canary runtime semantics instead of matching arbitrary numbers;
2. keep alternative datapacks isolated in their actual load profiles;
3. report unknown static values as unresolved rather than inventing certainty.

## Load-profile model

The server loads shared resources from `data` and one configured datapack. The
auditor defines the corresponding profiles in
`tools/canary_audit/config.json`:

| Profile | Loaded layers |
| --- | --- |
| `canary` | `data`, `data-canary` |
| `otservbr-global` | `data`, `data-otservbr-global` |

`--profile all` runs the semantic rules for both profiles independently. It
does not form a synthetic profile that loads both gameplay datapacks. A monster
or NPC intentionally present in both alternatives is therefore not a duplicate
unless it is duplicated inside one effective profile.

## Processing pipeline

The scanner performs one deterministic discovery pass. When Git is available,
it uses tracked files plus non-ignored untracked files. The fallback filesystem
walk prunes configured directories and does not follow symbolic links.

Each path is normalized as a repository-relative POSIX path. Configuration,
inputs, outputs, and symbolic-link components are checked to prevent workspace
escape. Output files are replaced atomically.

`scan --output-dir` is additionally restricted to the configured
`artifactRoot` or one of its descendants. The default configuration uses
`artifacts`; an output path outside that tree is rejected as a usage error.
Keeping generated output under an excluded discovery root prevents one scan
from indexing artifacts produced by an earlier scan.

Extractors convert source syntax into typed facts. Rules then operate only on
those facts:

```text
repository files
    -> profile-aware extractors
    -> typed, sorted facts
    -> semantic rules and baseline lookup
    -> JSON artifacts and Markdown summary
```

This separation keeps source parsing independent from conflict policy. A new
syntax should normally extend an extractor; a new invariant should normally
extend the rules layer.

## Typed fact model

Every fact contains:

- a semantic `domain`, such as `item.server_id` or `monster.name`;
- a `role`: `definition`, `reference`, `registration`, or `unresolved`;
- a scalar value and optional inclusive `endValue` for ranges;
- its layer and effective profiles;
- repository-relative path, line, and column;
- extractor identity and confidence;
- optional symbol, owner, and semantic attributes.

The roles are intentionally distinct:

- a definition establishes an authoritative value;
- a reference consumes an existing definition;
- a registration claims a runtime dispatch selector;
- an unresolved fact preserves a dynamic expression that could not be safely
  evaluated.

Repeated references are normal and do not create definition conflicts.

## Semantic domains

### Items

`data/items/appearances.dat` is the authoritative server item catalog. It is a
protobuf `Appearances` message described by `src/protobuf/appearances.proto`.
The scanner reads IDs from `Appearances.object` without treating outfit, effect,
or missile IDs as items. It mirrors `Items::loadFromProtobuf`: an object must
have both `id` and `flags`, and the ID must fit the server's `uint16` item-ID
domain. Invalid objects are reported and are not promoted to definitions.

`data/items/items.xml` is loaded after the protobuf catalog and supplies item
metadata overrides. Consequently, both `<item id="...">` and
`<item fromid="..." toid="...">` are modeled as references to authoritative
item IDs. An override outside the catalog is reported by
`item.override-missing-definition`.

The server reserves IDs `0` through `99` for XML fluid handling in
`Items::parseItemNode`; the auditor records that range explicitly.

Lua item references are extracted only from typed contexts, including:

- `Game.createItem(...)` and `ItemType(...)`;
- item add, remove, and count methods;
- `Action:id(...)`, `MoveEvent:id(...)`, and `Weapon:id(...)`.

`Spell:id(...)` belongs to `spell.id`, not to the item catalog. `Item(uid)` is
an instance lookup and is not interpreted as an item type reference. Generic
XML attributes such as `clientid` are not globally classified as item IDs.

### Monsters and NPCs

A Lua creature type becomes a definition only when its constructor result is
registered. Constant local names are resolved when possible:

```lua
local internalNpcName = "Adrenius"
local npcType = Game.createNpcType(internalNpcName)
npcType:register(npcConfig)
```

Definitions are normalized for case-insensitive lookup within a profile.
Literal or statically resolvable references are extracted from `Game` creation
calls and XML monster, single-spawn, and NPC elements.

Computed names remain unresolved. Monster and NPC coverage is therefore marked
`partial`, and unresolved expressions do not generate missing-definition
findings.

### Storages

Configured nested Lua tables are flattened into full symbols while preserving
their runtime domain. The default configuration includes:

- `Storage` as `storage.player`;
- `GlobalStorage` and `Global.Storage` as `storage.global`;
- `data/XML/storages.xml` as player-storage definitions.

For an XML storage, the effective value is `range.start + storage.key`. Invalid,
overlapping, or out-of-range XML declarations produce error diagnostics.

Player and global storage values are separate domains because they use
different runtime maps. A repeated numeric value across those domains is not by
itself a collision. Dynamic receiver expressions and string-keyed in-memory
creature state are not promoted to numeric player-storage definitions.

### Action and movement selectors

Lua constructor type determines selector meaning:

| Registration | Domain or reference |
| --- | --- |
| `Action:id(...)` | item reference plus `action.item_id` registration |
| `Action:aid(...)` | `action.action_id` registration |
| `Action:uid(...)` | `action.unique_id` registration |
| `MoveEvent:id(...)` | item reference plus `movement.item_id` registration |
| `MoveEvent:aid(...)` | `movement.action_id` registration |
| `MoveEvent:uid(...)` | `movement.unique_id` registration |
| `Weapon:id(...)` | item reference plus `weapon.item_id` registration |
| `Spell:id(...)` | `spell.id` registration |

Action registrations for the same selector conflict inside the Action dispatch
map. Action and MoveEvent selectors are separate, and a repeated action ID on
multiple map items is commonly intentional.

The auditor indexes MoveEvent registrations but does not currently assert all
event-type and slot-specific collision rules.

## OTBM boundary

Binary `.otbm` maps contain the item instances that produce action IDs and
unique IDs. The current auditor does not parse OTBM. A correct map extractor
must be version-aware, understand every loaded map fragment, and model which
fragments can be active together.

Until such an extractor exists:

- map coverage is reported as `unavailable`;
- action and movement selectors are reported as `registrations-only`;
- the tool does not claim that a Lua AID or UID registration has a matching map
  item;
- the tool does not claim that map UIDs are unique.

This limitation is a deliberate guard against false missing-reference and
duplicate-UID reports.

## Findings and diagnostics

Findings represent completed semantic checks and have a stable fingerprint.
Their severity comes from `severityByRule` in the configuration, with support
for exact `ruleId:domain`, `ruleId:*`, and global `*` fallbacks.

Operational `scan.*` diagnostics describe incomplete input or execution, such
as malformed Lua/XML, an unreadable protobuf stream, a missing configured
source, a fact limit, or an unsafe workspace path. Any such error marks the
report `incomplete` and cannot be waived. Content-level XML and protobuf
validation codes are instead converted into semantic findings; those follow
the configured gate and may receive a narrowly scoped baseline waiver.

Extraction, diagnostics, total facts, and findings have separate configured
limits. Limits are enforced while data is produced, not after an unbounded
collection has already been allocated. XML also has an explicit byte limit and
external entities must be disabled by the active SAX parser before parsing.

The default gate is `error`. `--fail-on` can make a local or CI invocation more
strict without changing repository configuration.

## Baseline contract

`tools/canary_audit/baseline.json` is a reviewed waiver list, not a snapshot of
expected counts. Each entry contains:

- a 64-character finding fingerprint;
- a concrete reason;
- an optional ISO expiration date.

Fingerprints include the rule, profile, domain, normalized value, and source
paths, but exclude line numbers. A line-only movement keeps the waiver stable;
a semantic or source-scope change does not. When the same semantic identity
occurs more than once in one file, the occurrence count also participates in
the fingerprint so a single-occurrence waiver cannot hide a duplicate.

Expired waivers are ignored. Active waivers that match no finding are reported
as stale so they can be removed. A waived finding remains in
`reference-report.json` with `baselineStatus: waived`, but does not count as a
new blocking finding.

Do not baseline operational `scan.*` diagnostics or broad classes of future
findings. Add the smallest specific semantic waiver and document why the
underlying content cannot yet be corrected.

## Artifact schemas

All schemas use JSON Schema Draft 2020-12, reject unknown object properties,
and live in `tools/canary_audit/schemas`.

| Schema | Contract |
| --- | --- |
| `config.schema.json` | Layers, profiles, inputs, limits, severities, and baseline path |
| `baseline.schema.json` | Reviewed finding waivers |
| `project-index.schema.json` | File inventory, counts, and revision metadata |
| `symbol-registry.schema.json` | Profiles, coverage, and sorted typed facts |
| `reference-report.schema.json` | Status, gate, diagnostics, findings, and summary counts |

`summary.md` is a presentation artifact and has no JSON Schema. The three JSON
outputs are validated before they are written, and the `validate` command can
check an existing artifact directory independently.

Artifact JSON is emitted with stable key and fact ordering. Revision metadata
contains the checked head SHA, optional base SHA, and working-tree state. If an
artifact contract changes incompatibly, update the associated schema, readers,
tests, and `schemaVersion` together.

## Exit-code contract

| Code | Contract |
| ---: | --- |
| `0` | Complete operation with no new gated finding |
| `1` | Complete scan with one or more new gated findings |
| `2` | Invalid CLI usage, configuration, input artifact/schema, SHA, or requested path |
| `3` | Incomplete scan or operational extraction, composition, validation, or write failure |

Automation must distinguish `1` from `3`: the former is a content result, while
the latter means the audit could not establish complete results for its declared
coverage.

## CI integration

`.github/workflows/repository-audit.yml` runs on relevant pull requests, pushes
to `main`, and manual dispatch. It installs the pinned Python requirements,
validates schemas, runs unit tests, scans both profiles, publishes the Markdown
job summary, and uploads artifacts even when the scan gate fails.

The workflow has read-only repository permissions, disables persisted checkout
credentials, uses a concurrency group with cancellation, and has a job timeout.
It does not run a Canary build.

## Extending the auditor

When adding coverage:

1. identify the runtime loader and authoritative source;
2. add a typed extractor that ignores comments and unrelated syntactic fields;
3. preserve dynamic expressions as unresolved facts;
4. scope facts to the correct layer and profiles;
5. add real-format fixtures for definitions, references, comments, ranges, and
   dynamic expressions;
6. add or update a semantic rule only after the extracted role is unambiguous;
7. update coverage text and schemas when their contract changes.

Avoid global regular expressions for names such as `id`, `uid`, `clientId`, or
`storage`. Their meaning depends on the Lua object, XML element, and runtime
subsystem.
