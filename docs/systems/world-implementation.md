# World implementation work record

World configuration is authored in JSON under the datapack's `world/` directory.
Canary and RME consume those same files. RME integrates authoring into the normal
map canvas, palette, properties and undo history; external changes never become
OTBM attributes. Stable object identities are independent of AID and UID. AID may
repeat; a nonzero UID must be unique in the effective world, including containers.

This work extends the existing v1 implementation. The stages below are acceptance
gates, not a claim that the implementation is already complete.

| Stage | Deliverable | Status |
| --- | --- | --- |
| 1 | Reproducible inventory, consumer coverage and legacy characterization | Inventory implemented; explicit exceptional-case characterization remains |
| 2 | Shared v2 model, schemas, selectors, descriptors and native world-tool | Contract and read-only helper implemented; application adapters follow in stages 3–5 |
| 3 | Runtime, ownership, compatibility, lifecycle and persistence | General adapter and mode/ownership integration in progress; native runtime validation outstanding |
| 4 | Lua API, per-instance dispatch, descriptors and consumer adapters | Pending |
| 5 | Full native RME authoring, container editing and unified history | Pending |
| 6 | External changes, conflicts, recoverable concurrent publication | Pending |
| 7 | Static migration analysis, generation, validation, apply and revert | Pending |
| 8 | Complete repository migration, default switch and integrated acceptance | Pending |

## Compatibility gates

- Retain v1 reading and require explicit conversion; opening alone never rewrites a project.
- Add `worldConfiguration` modes `legacy`, `world` and `mixed`. A missing option
  preserves legacy behavior and warns. Invalid values fail initialization.
- An explicitly active World project must exist and validate; never silently
  fall back after a World error.
- Mixed ownership is per source declaration, occurrence and responsibility,
  never merely per AID. Disabling a layer does not restore legacy ownership.
- Keep legacy tables and APIs as frozen compatibility configuration. Announce
  future discontinuation without inventing a removal release.
- Switch the distributed configuration to World only after every inventoried
  configuration and consumer has a destination and validated migration.
- Keep storage migrations and quest startup resets in their execution paths.

## Validation gates

Contract coverage includes strict JSON, duplicate keys, typed parameters,
selectors, AID/UID rules, references, rollback, script reload, lifecycle,
persistence, authoring, concurrent files, compatibility and migration reversal.
The native helper and both applications must share the validator; Python does
not implement a second interpretation of the world model.

External-only edits must preserve OTBM bytes. Invalid external data must preserve
the last valid scene and unsaved work. A denied World event must not fall through
to a permissive legacy handler. Migration must never activate a shadowed Lua
declaration as an accidental gameplay correction.

Native tests, UI scenarios and in-game scenarios are separate evidence. Record
only checks actually performed. Canary compilation is not part of local
validation for this work; a compatible existing or CI artifact is required.
RME validation uses its maintained build and test entry points.

## Recorded checks

- Static inventory: 16 loader files, 25 tables, 1,661 declarations and 29 direct
  table-consumer usages. Thirty declarations require explicit treatment, including
  duplicates and unresolved example positions. Empty tables are included.
- Python 3.12: 15 parser, inventory and native-helper fixture tests passed.
- RME's maintained headless Visual Studio target: v1 regressions and v2 authoring
  contract passed. Coverage includes inherited/cleared UIDs, repeated AIDs, base
  container selection, occurrence fingerprints, descriptor capabilities, unknown
  fields, relation cycles, teleport cycles and depth/number bounds.
- Additional shared contract checks passed for separate base selection/live UID
  state, persisted children, migration revisions/claims, disabled-layer ownership,
  duplicate ownership and consumed container originals. Loader Lua syntax checks
  passed; these checks do not validate server runtime execution.
- JSON Schema 2020-12 validation with jsonschema 4.26.0 accepted the complete
  example catalog, layer and descriptor used by the native tests.
- Read-only inspection of the global map scanned 17,972,761 tiles and 23,359,453
  items in approximately 16 seconds, retained 2,934 requested positions and found
  587 UID occurrences with no duplicates. This is a local observation, not a
  portable performance guarantee or a gameplay test.
- No Canary build, server launch, migration application or new GUI walkthrough
  has been performed during these stages.
