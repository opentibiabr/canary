# Canary AI Agent Tools

## Identifier scanner

`scan_ids.py` recursively scans text-based project files and creates a machine-readable registry of:

- storage keys,
- action IDs,
- unique IDs,
- item IDs.

Run from the repository root:

```bash
python tools/ai-agent/scan_ids.py
```

Custom root and output:

```bash
python tools/ai-agent/scan_ids.py --root . --output docs/ai-agent/ID_REGISTRY.json
```

The generated document follows `docs/ai-agent/ID_REGISTRY.schema.json`.

### Scanner limitations

The identifier scanner is intentionally conservative and regex-based. It detects numeric identifiers present directly in source files. It does not yet merge binary OTBM action and unique IDs into `ID_REGISTRY.json`, resolve Lua constants and arithmetic expressions, imported storage tables, dynamically constructed identifiers, or item IDs stored only in binary asset files.

The separate OTBM tool described below can inspect and export binary map regions. A future registry-integration stage can feed those results into the identifier allocator. Multi-file reuse is reported as a warning rather than an automatic error because shared identifiers may be intentional.

## OTBM map intelligence

`otbm_map_tool.py` safely inspects Canary OTBM files, exports bounded regions, enriches item IDs from `data/items/items.xml`, renders logical SVG previews, validates patch documents, generates diffs, detects conflicts on newer maps, and writes only to separate output files when explicitly enabled.

Main entry points:

```bash
python tools/ai-agent/otbm_map_tool.py verify map.otbm --count-tiles
python tools/ai-agent/otbm_map_tool.py catalog data/items/items.xml --output artifacts/ITEM_CATALOG.json
python tools/ai-agent/otbm_map_tool.py export map.otbm --from 32000,32000,7 --to 32031,32031,7 --items-xml data/items/items.xml --output artifacts/region.json --preview artifacts/region.svg
python tools/ai-agent/otbm_map_tool.py validate-patch patches/change.json
python tools/ai-agent/otbm_map_tool.py apply map.otbm patches/change.json --output artifacts/map-edited.otbm --report artifacts/change-report.json
```

The last command is a dry-run unless `--write` is present. See `docs/ai-agent/OTBM_MAP_TOOL.md` and `docs/ai-agent/OTBM_PATCH.schema.json` for the complete safety and format contracts.

## Content authoring pipeline

The dry-run content authoring pipeline adds these entry points:

- `validate_task_spec.py` validates task JSON without third-party dependencies.
- `allocate_ids.py` suggests, reserves, releases, or commits identifier reservations.
- `plan_content.py` creates `CONTENT_PLAN.json`.
- `render_content.py` writes preview-only files under `artifacts/generated-content/<taskId>/`.
- `validate_content_plan.py` checks identifier, path, rollback, and manual-step safety.
- `run_content_pipeline.py` orchestrates the end-to-end flow.

Example:

```bash
python tools/ai-agent/run_content_pipeline.py \
  --task docs/ai-agent/examples/forgotten_forge.quest.json \
  --registry artifacts/ID_REGISTRY.json \
  --content-index artifacts/CONTENT_INDEX.json \
  --reservations docs/ai-agent/ID_RESERVATIONS.json \
  --output artifacts/content-pipeline
```

The lifecycle is validation, temporary CI reservation, planning, preview rendering, plan validation, risk review, and human approval. To add a renderer, implement preview output only and call the shared path policy before writes. To add a content type, extend the task schema, validator rules, planner output, renderer, plan validator tests, and example coverage.

Current limitations: schema validation is a focused built-in validator rather than full JSON Schema evaluation; generated Lua/XML is preview scaffolding, not active datapack content.
