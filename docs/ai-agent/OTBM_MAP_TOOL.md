# OTBM map tool

`tools/ai-agent/otbm_map_tool.py` provides deterministic, standard-library-only OTBM inspection, item-catalog enrichment, world-package indexing, bounded region export, diff generation, patch validation, dry-run conflict detection, and opt-in map writing.

## Safety model

- Dry-run is the default.
- Source maps are never modified in place.
- A write requires both `--write` and a separate `--output` path.
- Existing output files require `--overwrite` and are backed up first.
- Patch bounds are limited with `--max-tiles`.
- Existing-tile edits require `expectedTileHash` unless `--unsafe-no-precondition` is explicitly used.
- Patch structure, item IDs, coordinates, hashes, operation-specific fields, and raw Base64 tile nodes are validated before map access.
- The source SHA-256 is rechecked immediately before writing.
- The generated map is parsed again and changed tiles are checked before the temporary file is atomically moved to the output path.
- Repository policy still forbids committing generated `.otbm` files.

The machine-readable patch contract is defined by `docs/ai-agent/OTBM_PATCH.schema.json`. Runtime validation does not require a third-party JSON Schema package.

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

The command reads the whole map and produces an AI-readable inventory of:

- towns and temple positions stored inside OTBM;
- waypoints stored inside OTBM;
- house IDs used by house tiles;
- zone IDs used by tile-zone nodes;
- referenced or conventionally named monster, NPC, house, and zones XML files;
- monster and NPC spawn groups, absolute positions, directions, respawn times, and names;
- house metadata, entry positions, rents, sizes, town references, client IDs, guildhall flags, and bed limits;
- zone names and IDs;
- SHA-256 values for the map and every companion file;
- cross-file errors such as missing house definitions, unknown house towns, missing zone definitions, duplicate IDs, invalid spawn positions, malformed XML, and missing companion files.

Use `--summary-only` to retain counts, name summaries, diagnostics, and cross-file validation while omitting the potentially large entity arrays. By default, validation errors produce exit code 2. `--allow-errors` preserves the same report but returns success for audit-only pipelines.

When an OTBM attribute does not name a companion file, the indexer follows Canary conventions and looks for `<map>-monster.xml`, `<map>-npc.xml`, `<map>-house.xml`, and `<map>-zones.xml` next to the map.

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

When `--items-xml` is omitted, the command looks for `data/items/items.xml` from the working directory and the map's parent directories. Without `--require-catalog`, it can still export raw IDs if no catalog is available.

The JSON contains tile coordinates, normalized tile hashes, flags, house IDs, inline item IDs, child item nodes, supported item attributes, original node bytes encoded as Base64, and—when a catalog is available—item names, categories, XML properties, reference counts, and missing item IDs.

The SVG is a logical renderer. It uses categories such as ground, door, teleport, field, container, floor change, writable, and pickupable; each tile has a tooltip with coordinates and item names. It is not yet a Tibia sprite renderer.

## Create a reusable patch from two maps

```bash
python tools/ai-agent/otbm_map_tool.py diff old.otbm edited.otbm \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --output patches/quest-room.json
```

Only changed tiles in the bounded region are included. Existing tiles carry `expectedTileHash`, so applying the patch to a newer map reports a conflict when that same tile was changed independently. Generated patches are validated before being written.

## Validate a patch without a map

```bash
python tools/ai-agent/otbm_map_tool.py validate-patch patches/quest-room.json \
  --output artifacts/quest-room-schema-report.json
```

Validation checks:

- document format and bounds;
- operation names and required fields;
- coordinate and item-ID ranges;
- whole-map and tile SHA-256 values;
- per-tile preconditions;
- operation-specific values;
- Base64 decoding and complete OTBM tile-node structure.

`--allow-missing-preconditions` exists only for intentionally unsafe migration work.

## Validate against a map without writing

```bash
python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json
```

Without `--write`, no OTBM output is created. The report lists schema validation, planned operations, warnings, conflicts, expected output dimensions, and changed positions.

Use `--strict-base` when the patch must only apply to the exact whole-map SHA-256. Without it, a different whole-map hash is a warning while per-tile preconditions remain authoritative.

## Write a new map

```bash
python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json \
  --write
```

To replace an existing output file while retaining a timestamped backup:

```bash
python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json \
  --write \
  --overwrite
```

## Supported semantic operations

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

The tool can now understand map tiles, item definitions, towns, waypoints, houses, zones, monster spawns, and NPC spawns as structured data and can validate their cross-file references. Pixel-accurate rendering still requires compatible client or RME sprite assets. Editing companion XML and OTBM towns or waypoints remains a later authoring stage; the current world index is read-only.

## Tests

```bash
python -m unittest discover -s tools/ai-agent -p "test_*.py" -v
python -m json.tool docs/ai-agent/OTBM_PATCH.schema.json > /dev/null
```
