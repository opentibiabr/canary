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
`normalize` prints the parsed catalog and layers; it neither saves nor upgrades
their version. Standard output is JSON; errors from invalid projects include
file, object, field and message. Exit codes are 0 for success, 1 for invalid data
and 2 for command/input failures.

The item catalog uses `items.xml` and its sibling `appearances.dat`. Inspection
retains requested tiles and teleport tiles, plus the complete UID census. It
preserves original item identity, ground/item distinction, attributes and
container contents. Unknown reserved sprites in unrelated map content can be
inspected; an active World declaration still requires a known item type.

This validates the initial OTBM configuration. Persistence, other startup
producers, live behavior implementations and gameplay require runtime validation.

## Maintained build targets

The standalone CMake target in this directory depends on `nlohmann-json` and
`pugixml`, using the repository's manifest dependencies. RME also maintains
`vcproj/Project/WorldTool.vcxproj` alongside its existing Visual Studio targets.
Use the configured compiler, dependency installation and build state for the
chosen repository; do not build the server just to obtain the helper.

Native binary fixture tests can use an existing compatible artifact:

```sh
WORLD_TOOL_PATH=/path/to/world-tool python -m unittest tools.world_migrate.tests.test_world_tool -v
```

PowerShell:

```powershell
$env:WORLD_TOOL_PATH = 'path/to/world-tool.exe'
python -m unittest tools.world_migrate.tests.test_world_tool -v
```
