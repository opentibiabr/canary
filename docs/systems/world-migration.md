# World configuration and migration

World JSON under the datapack's `world/` directory is authoritative. Canary and
RME consume the same catalog and layers. RME is the normal visual editor; direct
JSON edits are supported. There is no export step and no Lua/JSON synchronization.

The distributed global datapack includes the complete conversion of its startup
configuration: item attributes, creation, signs, books, container contents,
teleports, mechanisms and reward parameters. The legacy Lua files remain frozen
for compatibility. See the [implementation record](world-implementation.md) for
validation evidence and the remaining integrated acceptance checks.

## Startup modes

| `worldConfiguration` | Behavior |
| --- | --- |
| `legacy` | Load and apply compatibility tables; no World catalog required. |
| `world` | Load JSON and skip legacy configuration tables and map assignments. |
| `mixed` | Load both and permit only legacy responsibilities not owned by World. |

`config.lua.dist` selects `world`. An older config without the option selects
`legacy` and emits a migration notice. Legacy and mixed mode warn that legacy
world configuration will be discontinued in a future release; no removal release
has been selected. Invalid values fail initialization.

`worldProject = "auto"` resolves `<datapack>/world/<mapName>.world.json`.
An explicit catalog path is also supported. World and mixed mode fail startup if
the project is absent, invalid or undergoing an incomplete publication. They never
fall back automatically. Restart to apply JSON changes; Lua reload does not reload
the world. Player storage-key migrations and quest-state resets run in all modes.

## Complete or selective migration

Run from the repository root using Python 3.12 and a compatible distributed
`world-tool` executable. Python performs static analysis without executing Lua;
the native helper performs map inspection, selection, validation and publication.
See [the tool guide](../../tools/world_migrate/README.md) for its contract.

These examples are single-line commands usable from PowerShell or POSIX shells.
On Windows use `world-tool.exe`, or set `WORLD_TOOL_PATH` to its location.

```text
python -m tools.world_migrate analyze --datapack data-otservbr-global --all
python -m tools.world_migrate analyze --datapack data-otservbr-global --file startup/tables/teleport.lua --table TeleportUnique --entry 38012 --entry 38013 --report artifacts/world-migration/analysis.json
python -m tools.world_migrate generate --report artifacts/world-migration/analysis.json --output artifacts/world-migration/bundle --world-tool world-tool
python -m tools.world_migrate validate --bundle artifacts/world-migration/bundle --world-tool world-tool
python -m tools.world_migrate apply --bundle artifacts/world-migration/bundle --world-tool world-tool --confirm-offline
python -m tools.world_migrate revert --receipt data-otservbr-global/world/migrations/migration-id.json --world-tool world-tool --confirm-offline
```

Analysis prints results; only `--report` writes a report. Generation produces an
inactive review bundle. Review its `analysis.json`, `bundle.json` and `after/`
files. Unknown expressions, repeated keys, ambiguous selectors, customized
consumers and conflicting assignments require explicit treatment. Do not edit the
bundle snapshots: their hashes are publication preconditions. Regenerate after
reviewing source changes instead.

Stop the server and editing sessions before apply or revert. Both operations
compare revisions, use the shared file lock and journal, preserve displaced
versions and refuse to overwrite later changes. The map is read and hashed but
never written. Repeating an unchanged applied bundle is a no-op. Keep the local
receipt and `world/migrations/.recovery/` snapshots while reversal is needed;
these installation-specific files are not active catalog content or repository
configuration.

The repository conversion used the explicit evidence in
`tools/world_migrate/resolutions/data-otservbr-global.json`, selected with
`generate --resolutions`. Its map hash and declaration/consumer fingerprints must
match. It does not apply automatically to custom maps. It records shadowed Lua
keys, inactive placeholders, LuaJIT-characterized assignment order and five UID
collisions. The three pre-existing reward consumers keep their rewards through
independent World bindings. No shadowed reward is reactivated as a side effect.

A checkout already contains the migrated baseline and needs no migration command
to use World mode. Its baseline ownership record is versioned; local receipts and
backup snapshots are created only by migration operations on that installation.

## Ownership and compatibility

The catalog lists migration records conforming to
[`world-migration-v2.schema.json`](../../schemas/world-migration-v2.schema.json).
Claims name a source file, table, key, declaration occurrence, fingerprint, object
identity and responsibilities such as `attributes.aid`, `creation` or `onUse`.
They contain no duplicate positions, rewards or behavior parameters.

Ownership is per declaration, item occurrence and responsibility. A shared AID
never disables another object. Disabled layers retain their ownership; turning
a layer off does not quietly reactivate its old loader. Existing scripts keep
their dispatch except for the exact World events explicitly substituted.

Mixed mode verifies normalized source hashes before loading scripts. UTF-8 Lua
text normalizes CRLF to LF for portable provenance; publication guards still
compare exact bytes. Changed sources require analysis and reconciliation. An
unclaimed overlapping legacy write aborts startup instead of applying partially.

To return the entire installation to compatibility configuration, explicitly set
`worldConfiguration = "legacy"` and restart. That uses the frozen Lua settings;
JSON edits are not copied back. For selected ownership restoration use a reviewed
migration reversal whose revisions still match. Reverting after later edits
requires resolving those changes first, and never rewinds player storages or
other gameplay/database state.

## Invalid edits and interrupted writes

RME keeps the last valid scene and unsaved local work when disk JSON is invalid.
It reports file/field diagnostics, offers comparison or a recoverable draft for
conflicts, and requires confirmation before discarding local edits. Normal save
is blocked while configuration is invalid. Drafts remain outside the active
catalog.

A `.world.json.pending` marker denotes an incomplete publication. Do not delete
it to bypass validation. Recover through RME or the native helper's `recover`
command, with the original catalog and publication root. See
[file publication and recovery](world-file-publication.md).
