# Canary AI Agent Tools

## Identifier scanner

`scan_ids.py` recursively scans text-based project files and creates a machine-readable registry of storage keys, action IDs, unique IDs, and item IDs.

```bash
python tools/ai-agent/scan_ids.py
```

Include one or more OTBM maps so action and unique IDs stored inside map items are merged into the same registry:

```bash
python tools/ai-agent/scan_ids.py \
  --map /maps/otservbr.otbm \
  --output artifacts/ID_REGISTRY.json
```

`--map` may be repeated. Maps are read without modification, hashed with SHA-256, and scanned tile-by-tile, including item nodes nested inside containers. Duplicate `uniqueId` definitions are errors; reused `actionId` definitions are review warnings. The generated document follows `docs/ai-agent/ID_REGISTRY.schema.json`.

The text scanner remains intentionally conservative and regex-based. It does not resolve Lua constants, arithmetic expressions, imported storage tables, dynamically constructed identifiers, or item IDs stored only in binary asset files. The OTBM scanner contributes action and unique IDs but deliberately avoids adding every placed item ID.

## OTBM map intelligence and authoring

`otbm_map_tool.py` safely inspects Canary OTBM files, indexes world metadata, exports bounded regions, enriches item IDs from `data/items/items.xml`, renders logical SVG previews, validates patches, detects conflicts on newer maps, writes new OTBM copies, and publishes separately validated companion XML packages.

Main entry points:

```bash
python tools/ai-agent/otbm_map_tool.py verify map.otbm --count-tiles
python tools/ai-agent/otbm_map_tool.py world-index map.otbm --output artifacts/OTBM_WORLD_INDEX.json
python tools/ai-agent/otbm_map_tool.py catalog data/items/items.xml --output artifacts/ITEM_CATALOG.json
python tools/ai-agent/otbm_map_tool.py export map.otbm --from 32000,32000,7 --to 32031,32031,7 --items-xml data/items/items.xml --output artifacts/region.json --preview artifacts/region.svg
python tools/ai-agent/otbm_map_tool.py validate-patch patches/change.json
python tools/ai-agent/otbm_map_tool.py apply map.otbm patches/change.json --output artifacts/map-edited.otbm --report artifacts/change-report.json
```

Companion XML workflow:

```bash
python tools/ai-agent/otbm_map_tool.py world-patch-template map.otbm --output patches/world-change.json
python tools/ai-agent/otbm_map_tool.py validate-world-patch patches/world-change.json
python tools/ai-agent/otbm_map_tool.py apply-world-patch map.otbm patches/world-change.json --report artifacts/world-change-report.json
python tools/ai-agent/otbm_map_tool.py apply-world-patch map.otbm patches/world-change.json --output-dir artifacts/world-package --report artifacts/world-change-report.json --write
```

The companion patcher supports houses, zones, monster spawn groups, and NPC spawn groups. It requires map, file, and entry hashes; dry-run is the default; source files are never overwritten; and an existing output package is replaced only with `--overwrite`, after a timestamped directory backup. See `docs/ai-agent/OTBM_MAP_TOOL.md`, `docs/ai-agent/OTBM_PATCH.schema.json`, and `docs/ai-agent/OTBM_WORLD_PATCH.schema.json`.

## Content authoring pipeline

The dry-run content authoring pipeline adds these entry points:

- `validate_task_spec.py` validates task JSON without third-party dependencies.
- `allocate_ids.py` suggests, reserves, releases, or commits identifier reservations.
- `plan_content.py` creates `CONTENT_PLAN.json`.
- `render_content.py` writes preview-only files under `artifacts/generated-content/<taskId>/`.
- `validate_content_plan.py` checks identifier, path, rollback, and manual-step safety.
- `run_content_pipeline.py` orchestrates the end-to-end flow.

```bash
python tools/ai-agent/run_content_pipeline.py \
  --task docs/ai-agent/examples/forgotten_forge.quest.json \
  --registry artifacts/ID_REGISTRY.json \
  --content-index artifacts/CONTENT_INDEX.json \
  --reservations docs/ai-agent/ID_RESERVATIONS.json \
  --output artifacts/content-pipeline
```

The lifecycle is validation, temporary CI reservation, planning, preview rendering, plan validation, risk review, and human approval. Current limitations: schema validation is a focused built-in validator rather than full JSON Schema evaluation; generated Lua/XML from the generic content pipeline is preview scaffolding, while the dedicated OTBM companion patcher publishes only hash-pinned, cross-validated world packages.
