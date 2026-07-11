# OTBM sprite region rendering

`tools/ai-agent/otbm_render_tool.py` combines a bounded OTBM region with a modern OTClient or Canary Map Editor asset package and writes a deterministic transparent PNG.

## Render a region

```bash
python tools/ai-agent/otbm_render_tool.py \
  /maps/otservbr.otbm \
  /clients/Tibia \
  --from 32000,32000,7 \
  --to 32031,32031,7 \
  --output artifacts/region.png \
  --report artifacts/region-render.json
```

The assets argument may point to:

- a client root containing `package.json` and `assets/`;
- an OTClient `data/things/<version>` directory;
- an `assets` directory containing `catalog-content.json`.

The renderer validates every file and sprite range declared by the supplied catalog before drawing. The catalog may represent a complete client or a reduced render package. Appearances are parsed independently, while sprite availability is required only for IDs actually referenced by items in the requested map region.

## Rendering pipeline

For every tile in the selected floor, the tool:

1. reads the OTBM tile and preserves its visible item stack;
2. maps each placed item ID directly to its modern object appearance;
3. selects a renderable fixed frame group;
4. calculates deterministic position, stack-count, fluid, and depth patterns;
5. resolves sprite IDs in OTClient order: animation phase, Z pattern, Y pattern, X pattern, then layer;
6. extracts the sprite from its catalog sheet;
7. applies appearance displacement and cumulative elevation;
8. composites RGBA pixels with source-over alpha blending;
9. writes a deterministic PNG and a provenance report.

## Draw order

The tile order mirrors the OTClient map pipeline:

1. ground;
2. ground borders;
3. bottom items;
4. common items in reverse stack order;
5. top items with elevation reset.

Container contents are not rendered because they are not visible on the map. Top-level OTBM item nodes and an inline ground/item ID are rendered.

## Deterministic patterns

The renderer currently uses animation phase `0`. This makes CI output reproducible and avoids time-dependent screenshots.

Position patterns use tile coordinates modulo the appearance pattern dimensions. Stackable appearances with the standard 4×2 layout follow OTClient count buckets:

- 1–4;
- 5–9;
- 10–24;
- 25–49;
- 50 or more.

Liquid patterns use the stored item count/subtype. Hangable items require neighboring wall-hook context for exact orientation. Until that context is implemented, pattern `0` is used and the report contains `hangable_default_pattern`.

## Output and diagnostics

The PNG has a transparent background and configurable padding:

```bash
python tools/ai-agent/otbm_render_tool.py map.otbm /client \
  --from 100,100,7 --to 109,109,7 \
  --padding-tiles 6 \
  --output region.png
```

The JSON report records:

- map, catalog, and appearances SHA-256 values;
- requested coordinates and output dimensions;
- rendered item and sprite counts;
- decoded sprite-sheet paths;
- missing appearance IDs and sprite IDs;
- explicit warnings and errors.

A PNG is still written when individual placed items are missing from the client data. The command returns exit code `2` unless `--allow-errors` is supplied.

## Safety limits

- all map and asset inputs are read-only;
- rendering is limited to one floor per invocation;
- the requested position count is bounded by `--max-tiles`;
- padding is bounded;
- total canvas pixels are bounded;
- asset paths must pass the catalog index safety checks;
- appearances and every sprite sheet used by the selected region must pass their independent parsers before rendering;
- no OTBM, companion XML, client asset, or server file is modified.

## Current boundary

This stage renders static map items. It does not render creatures, projectiles, effects, dynamic lighting, text, selection overlays, or animation timing. Exact hangable orientation is reported as a known warning rather than guessed silently.

The machine-readable contract is `docs/ai-agent/OTBM_RENDER_REPORT.schema.json`.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_renderer.py -v
```

The end-to-end test creates a synthetic OTBM, appearances protobuf, CIP-wrapped raw-LZMA sprite sheet, and catalog, then verifies the resulting PNG pixels and report.