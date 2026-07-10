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

## Current limitations

The scanner is intentionally conservative and regex-based. It detects numeric identifiers present directly in source files. It does not yet resolve:

- Lua constants and arithmetic expressions,
- imported storage tables,
- dynamically constructed identifiers,
- binary OTBM action and unique IDs,
- item IDs stored only in binary asset files.

A later indexer stage will add Lua-aware parsing and OTBM inspection. Multi-file reuse is reported as a warning rather than an automatic error because shared identifiers may be intentional.

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
