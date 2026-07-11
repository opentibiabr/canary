# OTBM map tool

`tools/ai-agent/otbm_map_tool.py` provides deterministic, standard-library-only OTBM inspection, bounded region export, diff generation, dry-run patch validation, and opt-in map writing.

## Safety model

- Dry-run is the default.
- Source maps are never modified in place.
- A write requires both `--write` and a separate `--output` path.
- Existing output files require `--overwrite` and are backed up first.
- Patch bounds are limited with `--max-tiles`.
- Existing-tile edits require `expectedTileHash` unless `--unsafe-no-precondition` is explicitly used.
- The source SHA-256 is rechecked immediately before writing.
- The generated map is parsed again and changed tiles are checked before the temporary file is atomically moved to the output path.
- Repository policy still forbids committing generated `.otbm` files.

## Inspect and verify

```bash
python tools/ai-agent/otbm_map_tool.py inspect data-otservbr/world/otservbr.otbm --output artifacts/map-info.json
python tools/ai-agent/otbm_map_tool.py verify data-otservbr/world/otservbr.otbm --count-tiles --output artifacts/map-verify.json
```

`inspect --fast` reads metadata without enumerating every tile.

## Export a readable region

```bash
python tools/ai-agent/otbm_map_tool.py export data-otservbr/world/otservbr.otbm \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --output artifacts/region.json \
  --preview artifacts/region.svg
```

The JSON contains tile coordinates, normalized tile hashes, flags, house IDs, inline item IDs, child item nodes, supported item attributes, and the original node bytes encoded as Base64. The SVG is an occupancy preview, not a sprite renderer.

## Create a reusable patch from two maps

```bash
python tools/ai-agent/otbm_map_tool.py diff old.otbm edited.otbm \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --output patches/quest-room.json
```

Only changed tiles in the bounded region are included. Existing tiles carry `expectedTileHash`, so applying the patch to a newer map reports a conflict when that same tile was changed independently.

## Validate a patch without writing

```bash
python tools/ai-agent/otbm_map_tool.py apply current.otbm patches/quest-room.json \
  --output artifacts/current-with-quest.otbm \
  --report artifacts/quest-room-report.json
```

Without `--write`, no OTBM output is created. The report lists planned operations, warnings, conflicts, expected output dimensions, and changed positions.

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

## Tests

```bash
python -m unittest discover -s tools/ai-agent -p "test_*.py" -v
```
