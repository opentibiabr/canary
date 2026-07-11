# OTBM map tool

`tools/ai-agent/otbm_map_tool.py` provides deterministic, standard-library-only OTBM inspection, item-catalog enrichment, world-package indexing, companion XML authoring, bounded region export, diff generation, patch validation, dry-run conflict detection, and opt-in writes.

## Safety model

- Dry-run is the default.
- Source maps and companion XML files are never modified in place.
- OTBM writes require `--write` and a separate `--output` path.
- Companion XML writes require `--write` and a separate `--output-dir` package.
- Existing outputs require `--overwrite` and are backed up first.
- Patch bounds are limited with `--max-tiles`.
- Existing-tile edits require `expectedTileHash` unless `--unsafe-no-precondition` is explicitly used.
- Companion edits require the expected map SHA-256, every source XML SHA-256, and per-entry hashes for replacements or removals.
- Generated maps and companion packages are parsed and cross-validated before publication.
- Repository policy still forbids committing generated `.otbm` files.

The map-tile patch contract is `docs/ai-agent/OTBM_PATCH.schema.json`. The companion XML patch contract is `docs/ai-agent/OTBM_WORLD_PATCH.schema.json`. Runtime validation uses the Python standard library and does not require a third-party JSON Schema package.

## Inspect and verify

```bash
python tools/ai-agent/otbm_map_tool.py inspect data-otservbr/world/otservbr.otbm --output artifacts/map-info.json
python tools/ai-agent/otbm_map_tool.py verify data-otservbr/world/otservbr.otbm --count-tiles --output artifacts/map-verify.json
```

`inspect --fast` reads metadata without enumerating every tile.

## Index the complete world package

Place the OTBM and its referenced companion files in the same directory, then run:

```bash
python tools/ai-agent/otbm_map_tool.py world-index data-otservbr/world/otservbr.otbm \
  --output artifacts/OTBM_WORLD_INDEX.json
```

The command reads the whole map and produces an AI-readable inventory of towns, temple positions, waypoints, house and zone IDs, monster and NPC spawns, house metadata, zone definitions, SHA-256 provenance, and cross-file errors. Use `--summary-only` to omit potentially large entry arrays. By default, validation errors produce exit code 2; `--allow-errors` retains the report but returns success for audit-only pipelines.

When an OTBM attribute does not name a companion file, the tool follows Canary conventions and looks for `<map>-monster.xml`, `<map>-npc.xml`, `<map>-house.xml`, and `<map>-zones.xml` next to the map.

## Author companion XML safely

Create a hash-pinned template from the current map package:

```bash
python tools/ai-agent/otbm_map_tool.py world-patch-template data-otservbr/world/otservbr.otbm \
  --output patches/world-change.json
```

The template contains:

- the map SHA-256;
- the filename and SHA-256 of each monster, NPC, house, and zones XML file;
- house, zone, and spawn-group entry hashes for safe selectors;
- an initially empty `operations` array.

Supported operations are:

- `upsert_house` and `remove_house`;
- `upsert_zone` and `remove_zone`;
- `add_spawn_group`, `replace_spawn_group`, and `remove_spawn_group` for monster or NPC files.

Validate the JSON structure without reading the map:

```bash
python tools/ai-agent/otbm_map_tool.py validate-world-patch patches/world-change.json \
  --output artifacts/world-change-schema-report.json
```

Perform a complete dry-run against the current map and source XML files:

```bash
python tools/ai-agent/otbm_map_tool.py apply-world-patch data-otservbr/world/otservbr.otbm \
  patches/world-change.json \
  --report artifacts/world-change-report.json
```

A dry-run creates only temporary files. It validates XML parsing, map and source hashes, entry hashes, house-to-town links, map house IDs, map zone IDs, spawn coordinates, respawn values, duplicates, and final package consistency.

Publish a complete companion XML package to a separate directory:

```bash
python tools/ai-agent/otbm_map_tool.py apply-world-patch data-otservbr/world/otservbr.otbm \
  patches/world-change.json \
  --output-dir artifacts/world-package \
  --report artifacts/world-change-report.json \
  --write
```

The output directory contains all four companion files, including unchanged ones, so it is a complete reviewable package. The source directory is never accepted as the output. With `--overwrite`, the previous output directory is atomically renamed to a timestamped backup before the validated staged package is published.

## Build the Canary item catalog

```bash
python tools/ai-agent/otbm_map_tool.py catalog data/items/items.xml \
  --output artifacts/ITEM_CATALOG.json
```

The catalog streams `items.xml`, supports individual IDs and `fromid`/`toid` ranges, and records names, articles, plurals, declared types, XML attributes, conservative logical categories, source SHA-256, and diagnostics. Reversed ranges are skipped to mirror Canary's loader behavior, and repeated definitions are reported while the later XML entry wins. It does not modify `items.xml` or `items.otb`.

## Export an AI-readable region

```bash
python tools/ai-agent/otbm_map_tool.py export data-otservbr/world/otservbr.otbm \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --items-xml data/items/items.xml \
  --require-catalog \
  --output artifacts/region.json \
  --preview artifacts/region.svg
```

The JSON contains coordinates, normalized tile hashes, flags, house IDs, inline item IDs, child nodes, supported attributes, raw node bytes, and optional item names and categories. The SVG is a logical renderer with coordinates and item-name tooltips; it is not yet a Tibia sprite renderer.

## Create and apply reusable map patches

```bash
python tools/ai-agent/otbm_map_tool.py diff old.otbm edited.otbm \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --output patches/quest-room.json

python tools/ai-agent/otbm_map_tool.py validate-patch patches/quest-room.json

python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json
```

Without `--write`, `apply` is a dry-run. Existing tiles carry `expectedTileHash`, so a newer map produces a conflict when the same tile was independently changed. `--strict-base` additionally requires the exact whole-map hash.

Write a new map only after a successful dry-run:

```bash
python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json \
  --write
```

Supported semantic map operations:

- `replace_item_id`
- `remove_item`
- `add_simple_item`
- `set_item_attribute`
- `set_tile_flags`
- `set_house_id`
- `create_tile`
- `add_tile`
- `replace_tile`
- `delete_tile`

Raw tile operations preserve unsupported item attributes and child nodes byte-for-byte. Semantic editing refuses a tile or item when its property stream contains an unsupported attribute that cannot be safely reconstructed.

## Current boundary

The tool can understand and safely patch map tiles, item definitions, houses, zones, monster spawns, and NPC spawns. Towns and waypoints are currently readable and validated but not yet writable. Pixel-accurate rendering still requires compatible client or RME sprite assets.

## Tests

```bash
python -m unittest discover -s tools/ai-agent -p "test_*.py" -v
python -m json.tool docs/ai-agent/OTBM_PATCH.schema.json > /dev/null
python -m json.tool docs/ai-agent/OTBM_WORLD_PATCH.schema.json > /dev/null
```
