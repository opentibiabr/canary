# world-tool

`world-tool` reads World projects with the same C++ model and validators used by
Canary and RME. It does not start the server, load gameplay Lua, open a database or
write to the map. It supports schema versions 1 and 2.

```sh
world-tool validate data-otservbr-global/world/otservbr.world.json
world-tool inspect --map data-otservbr-global/world/otservbr.otbm --items data/items/items.xml --positions artifacts/world-migration/positions.json
world-tool normalize data-otservbr-global/world/otservbr.world.json
```

On Windows, use `world-tool.exe` and quote paths containing spaces. `--positions`
is a JSON array of `{ "x": 100, "y": 100, "z": 7 }` records. `--map` can override
the map path during validation of a review bundle without modifying the catalog.
`--items` overrides the item catalog for the same purpose. `normalize` prints the
parsed catalog/layers and the exact source bytes it read. Add `--convert-v2` to
explicitly convert the printed result; opening or normalizing without that flag
keeps the original version. Neither form writes configuration. Standard output
is JSON; errors from invalid projects include
file, object, field and message. Exit codes are 0 for success, 1 for invalid data
and 2 for command/input failures.

The item catalog uses `items.xml` and its sibling `appearances.dat`. Inspection
retains requested tiles and teleport tiles, plus the complete UID census. It
preserves original item identity, ground/item distinction, attributes and
container contents. Each inspected item includes a selector captured by the
shared validator, including occurrence preconditions when necessary. The tile's
`legacy` section identifies ground, top-down, top-top and first-by-item-ID targets
in the server's loading order. Python does not duplicate those selection rules.
Unknown reserved sprites in unrelated map content can be
inspected; an active World declaration still requires a known item type.

This validates the initial OTBM configuration. Persistence, other startup
producers, live behavior implementations and gameplay require runtime validation.

## Offline publication and recovery

The Python migrator validates its review bundle before invoking `publish`.
`publish` is the low-level file primitive: it enforces revisions, locking,
recoverable snapshots and publication ordering, without interpreting Lua patches
or treating arbitrary file content as a validated World project.

```sh
world-tool publish artifacts/world-migration/publication.json --root . --confirm-offline
world-tool recover data-otservbr-global/world/otservbr.world.json --root . --finish --confirm-offline
world-tool recover data-otservbr-global/world/otservbr.world.json --root . --rollback --confirm-offline
```

`--confirm-offline` confirms that the affected server and editing sessions are
stopped. Recovery requires exactly one of `--finish` and `--rollback`. Use the
same publication root for recovery as for the interrupted operation.

A publication manifest has `schemaVersion: 1`, `catalog`, `changes` and `guards`.
Each change contains `file`, `before` and `after`; each guard contains `file` and
`expected`. Target paths are relative to `--root`. Revision values are paths to
immutable snapshots relative to the manifest directory, or `null` for an absent
file. Empty snapshots represent empty files. Paths escaping those roots,
duplicate fields, stale revisions and unknown options are rejected. Changes are
ordered by dependency, with the active catalog last.

Migration ownership records may include a relative `receipt` path. That file
contains tool-owned recovery metadata and is never another runtime configuration.

## Maintained build targets

The Canary Linux and Windows CMake binary packages include `world-tool` alongside
the server. Extract the package, retaining its runtime libraries, and pass the
helper's path to the migrator. No server compilation or startup is required.
CI runs the binary fixture tests against that packaged executable before upload.

The standalone CMake target in this directory depends on `nlohmann-json` and
`pugixml`, using the repository's manifest dependencies. RME also maintains
`vcproj/Project/WorldTool.vcxproj` alongside its existing Visual Studio targets.
Use the configured compiler, dependency installation and build state for the
chosen repository; do not build the server just to obtain the helper.

Native binary fixture tests can use an existing compatible artifact:

The Python package and fixtures are maintained in the Canary repository. Run
these commands from that checkout, using a helper built from either project.

```sh
WORLD_TOOL_PATH=/path/to/world-tool python -m unittest tools.world_migrate.tests.test_world_tool -v
```

PowerShell:

```powershell
$env:WORLD_TOOL_PATH = 'path/to/world-tool.exe'
python -m unittest tools.world_migrate.tests.test_world_tool -v
```
