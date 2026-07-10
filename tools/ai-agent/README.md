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
