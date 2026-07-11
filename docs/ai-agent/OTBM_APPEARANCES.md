# Appearances protobuf indexing

`tools/ai-agent/otbm_appearances_tool.py` reads the modern `appearances.dat` protobuf format used by Canary, OTClient, and Canary Map Editor without requiring generated protobuf bindings.

## Create an object appearance index

```bash
python tools/ai-agent/otbm_appearances_tool.py /path/to/appearances.dat \
  --output artifacts/APPEARANCES_INDEX.json
```

The default output indexes object appearances because map items reference the object category directly by appearance ID. It records:

- appearance ID, name, and description;
- fixed frame groups;
- pattern width, height, depth, layers, and sprite IDs;
- animation loop settings and phase durations;
- render-relevant flags such as bottom, top, clip, lying object, shift, height, light, automap color, translucency, and opacity;
- source file size and SHA-256;
- duplicate IDs, missing flags, missing frame groups, malformed protobuf fields, invalid UTF-8, and sprite statistics.

Include outfit, effect, and missile appearances when auditing a complete client package:

```bash
python tools/ai-agent/otbm_appearances_tool.py /path/to/appearances.dat \
  --include-non-objects \
  --output artifacts/APPEARANCES_ALL_INDEX.json
```

## Verify sprite-sheet coverage

First create the asset package index:

```bash
python tools/ai-agent/otbm_asset_tool.py /path/to/client-root \
  --output artifacts/CLIENT_ASSETS_INDEX.json
```

Then cross-check every non-zero sprite ID referenced by appearances:

```bash
python tools/ai-agent/otbm_appearances_tool.py /path/to/appearances.dat \
  --asset-index artifacts/CLIENT_ASSETS_INDEX.json \
  --output artifacts/APPEARANCES_INDEX.json
```

A sprite ID outside every declared sprite-sheet range is an error. Sprite ID 0 is retained and reported as a warning because some client data uses it as an empty or sentinel reference.

## Parser safety

- source files are read-only;
- message size is bounded;
- varints are limited to ten bytes;
- nested messages are depth-limited;
- only protobuf wire types 0, 1, 2, and 5 are accepted;
- unknown fields are skipped according to their wire type, allowing forward-compatible additions;
- no generated Python module, external protobuf package, executable, map, or client asset is modified.

The parser extracts only fields relevant to map rendering and validation. Unknown appearance flags remain preserved in the source file but are not included in the JSON index.

The machine-readable contract is `docs/ai-agent/OTBM_APPEARANCES_INDEX.schema.json`.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_appearances.py -v
python -m json.tool docs/ai-agent/OTBM_APPEARANCES_INDEX.schema.json > /dev/null
```
