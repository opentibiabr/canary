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
| 1 | Reproducible inventory, consumer coverage and legacy characterization | In progress |
| 2 | Shared v2 model, schemas, selectors, descriptors and native world-tool | Pending |
| 3 | Runtime, ownership, compatibility, lifecycle and persistence | Pending |
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
