# World implementation work record

World configuration is authored in JSON under the datapack's `world/` directory.
Canary and RME consume those same files. RME integrates authoring into the normal
map canvas, palette, properties and undo history; external changes never become
OTBM attributes. Stable object identities are independent of AID and UID. AID may
repeat; a nonzero UID must be unique in the effective world, including containers.

This work extends the existing v1 implementation. The table records delivered
implementation separately from final manual acceptance. Remaining checks are
listed explicitly instead of leaving completed stages marked as pending.

| Stage | Deliverable | Status |
| --- | --- | --- |
| 1 | Reproducible inventory, consumer coverage and legacy characterization | Implemented; every declaration has an explicit converted, preserved or excluded destination, including exceptional cases |
| 2 | Shared v2 model, schemas, selectors, descriptors and native world-tool | Implemented in Canary and RME with parity checks and shared fixtures |
| 3 | Runtime, ownership, compatibility, lifecycle and persistence | Implemented with transactional application, rollback, effective UID validation and persistence projection |
| 4 | Lua API, per-instance dispatch, descriptors and consumer adapters | Implemented; repository consumers are adapted and dispatch/behavior tests cover migrated and preserved paths |
| 5 | Full native RME authoring, container editing and unified history | Implemented and compiled; final post-optimization interactive walkthrough remains an acceptance check |
| 6 | External changes, conflicts, recoverable concurrent publication | Implemented with revision guards, watchers, journals, coordinated map saves and recovery tests |
| 7 | Static migration analysis, generation, validation, apply and revert | Implemented; the Python suite and compatible native helper exercise the complete lifecycle |
| 8 | Complete repository migration, default switch and integrated acceptance | Repository migration and World default implemented; final interactive RME and in-game scenarios remain |

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
- Python 3.12: all 49 migration tests passed with a compatible native `world-tool`;
  no native-helper tests were skipped. Coverage includes static analysis, dispatch,
  repository completeness, bundle generation, guarded publication, idempotence,
  reversal, UID census and stale/conflicting revisions.
- RME's maintained Release x64 solution, `WorldTool` and `WorldLayersTests` targets
  built locally. The native tests passed v1 regressions and the v2 authoring
  contract. CI also compiled the final formatting head on Linux, macOS, Windows
  CMake, Windows Solution Debug/Release and Docker.
- Additional shared contract checks passed for separate base selection/live UID
  state, persisted children, migration revisions/claims, disabled-layer ownership,
  duplicate ownership and consumed container originals. Loader Lua syntax checks
  passed; these checks do not validate server runtime execution.
- Shared nested parameter defaults and copy isolation passed in RME's native
  contract target. Lua characterization passed for behavior allow/deny paths,
  missing related items and failed transformations, and for legacy routing with
  repeated AIDs. Canary CI executes the native World Lua binding, dispatcher,
  runtime and contract tests. The door descriptor passed JSON Schema validation.
- The runtime acceptance probe generated valid Lua for all 3,940 enabled Global
  declarations and is part of the maintained legacy, World and mixed startup
  smoke. It verifies published identities, items, positions, initial item IDs,
  attributes, reverse bindings, tokens, containers and teleport destinations.
- JSON Schema 2020-12 validation with jsonschema 4.26.0 accepted the complete
  example catalog, layer and descriptor used by the native tests.
- Read-only inspection of the global map scanned 17,972,761 tiles and 23,359,453
  items in approximately 16 seconds, retained 2,934 requested positions and found
  587 UID occurrences with no duplicates. This is a local observation, not a
  portable performance guarantee or a gameplay test.
- No full local Canary build or local server launch was performed. Final acceptance
  still requires a post-optimization RME walkthrough and in-game interaction tests
  for representative actions, movement, rewards and equipment behavior.
