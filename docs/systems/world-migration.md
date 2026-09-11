# World configuration and compatibility

World catalogs and layers in the datapack's `world/` directory are the authority
for migrated configuration. The editor and server read the same files. Legacy
tables remain available for compatibility; new World values are not copied back
into those tables.

The complete migration tool and repository migration are being delivered through
the stages tracked in [the implementation record](world-implementation.md).
Currently, `analyze` is available; do not treat an analysis report as an applied
migration or assume that the entire datapack has already moved to World.

## Startup modes

Set `worldConfiguration` in `config.lua` to one of:

| Value | Behavior |
| --- | --- |
| `legacy` | Apply the compatibility loader. No World catalog is required. |
| `world` | Apply the configured World catalog. Skip legacy map configuration. |
| `mixed` | Apply World and permit only legacy responsibilities not taken over by migration records. |

An older configuration without this option uses `legacy`. Legacy and mixed
startup warn that legacy world configuration will be discontinued in a future
release; a removal release has not been selected. Invalid mode values fail
configuration loading.

`worldProject = "auto"` resolves `<datapack>/world/<mapName>.world.json`.
An explicit path is also supported. In `world` or `mixed` mode an absent, empty
or invalid project fails startup. There is no automatic fallback to legacy.
Changes require a restart; reloading Lua does not reread the project.

The distributed default remains `legacy` until the complete content and consumer
migration is validated. Selecting `world` with only a partial project intentionally
omits configuration that is still present only in legacy tables.

Storage-key migrations and quest-state resets are execution logic. They continue
running in all modes and are not replaced by JSON declarations.

## Migration ownership records

The catalog explicitly lists migration records. Their version 2 schema is
[`world-migration-v2.schema.json`](../../schemas/world-migration-v2.schema.json).
Paths resolve relative to the record that declares them. Each claim identifies:

- Source file, table, entry key, declaration occurrence and source fingerprint.
- Occurrence within that entry, such as `1.item`, `1.ground`, `1.topDown` or
  `1.topTop`; a single-position entry uses `item`.
- Stable World identity and the exact responsibilities it takes over.

These records contain no second copy of positions, rewards or behavior parameters.
Repeated AIDs do not determine ownership. A migrated responsibility stays owned
when its layer is disabled; restoring legacy execution requires explicit reversal.

Mixed mode verifies the recorded SHA-256 source revisions before loading scripts.
Source text uses UTF-8 with CRLF normalized to LF so the same frozen compatibility
files can be checked on Windows and Linux. Bundle application/reversal also needs
exact on-disk revision checks; normalized hashes do not authorize overwrites.
Modified sources must be analyzed and reconciled, even when the modification
appears unrelated to the migrated entry. This conservative check prevents silent
suppression of a customized declaration.

An unclaimed legacy write that overlaps a World-owned item responsibility aborts
startup. Position-based Lua creation also checks for objects already created by
World. Gameplay handlers remain attached unless their specific event is replaced.

## Read-only analysis

Run from the repository root with Python 3.12. This command is valid in both
PowerShell and POSIX shells:

```text
python -m tools.world_migrate analyze --datapack data-otservbr-global --all
```

Writing a report requires an explicit output option:

```text
python -m tools.world_migrate analyze --datapack data-otservbr-global --file startup/tables/teleport.lua --table TeleportUnique --entry 38012 --entry 38013 --report artifacts/world-migration/analysis.json
```

Analysis does not execute Lua or modify sources. Duplicate keys and unresolved
expressions remain visible for review. Shadowed declarations must not be
reactivated as an incidental migration correction.
