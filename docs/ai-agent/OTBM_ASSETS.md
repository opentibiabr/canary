# OTClient and RME asset indexing

`tools/ai-agent/otbm_asset_tool.py` validates the modern client asset layout used by OTClient and Canary Map Editor before sprite rendering is enabled.

## Supported input layouts

Pass any of these paths:

```text
client-root/
├── package.json
└── assets/
    ├── catalog-content.json
    ├── appearances-....dat
    ├── sprite-sheet-....lzma
    └── assets.json.sha256
```

```text
data/things/<version>/
├── catalog-content.json
├── appearances-....dat
├── sprite-sheet-....lzma
└── assets.json.sha256
```

You can also pass the `assets` directory or `catalog-content.json` directly.

## Create an index

```bash
python tools/ai-agent/otbm_asset_tool.py /path/to/client-root \
  --output artifacts/CLIENT_ASSETS_INDEX.json
```

The command verifies and records:

- the `catalog-content.json` structure and SHA-256;
- the single appearances entry and referenced file;
- every sprite sheet, file size, SHA-256, compression suffix, layout type, and declared sprite range;
- missing files, unsafe paths, reversed ranges, overlaps, and gaps;
- optional `package.json` metadata;
- optional `assets.json.sha256` content and file hash.

Errors return exit code 2. `--allow-errors` keeps the report but returns success for audit-only jobs.

Hashing large sprite packages can be intentionally skipped:

```bash
python tools/ai-agent/otbm_asset_tool.py /path/to/data/things/1524 \
  --skip-hashes \
  --output artifacts/CLIENT_ASSETS_INDEX.json
```

## Safety

- the command is read-only;
- catalog paths are constrained to the catalog directory;
- absolute paths and `..` traversal are rejected;
- no archive extraction or LZMA decompression occurs at this stage;
- no client executable, appearances file, sprite sheet, map, or server file is modified.

## Renderer boundary

A successful index proves that the asset package is structurally complete and range-consistent. Pixel rendering still requires the next stage: parsing appearances protobuf data, decoding the referenced sprite-sheet format, applying RME/OTClient draw order and offsets, and comparing deterministic screenshots.

The machine-readable contract is `docs/ai-agent/OTBM_ASSET_INDEX.schema.json`.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_assets.py -v
python -m json.tool docs/ai-agent/OTBM_ASSET_INDEX.schema.json > /dev/null
```
