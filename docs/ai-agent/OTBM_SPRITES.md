# Modern sprite-sheet decoding

`tools/ai-agent/otbm_sprite_tool.py` decodes the modern CIP-wrapped LZMA sprite sheets referenced by OTClient and Canary Map Editor catalogs.

## Inspect a sheet

```bash
python tools/ai-agent/otbm_sprite_tool.py inspect \
  /path/to/sprite-sheet.lzma \
  --output artifacts/SPRITE_SHEET_REPORT.json
```

The decoder follows the OTClient format:

1. validate the fixed 32-byte CIP header;
2. validate the CIP signature and 7-bit LZMA file size;
3. read the LZMA1 properties byte, dictionary size, and declared output size;
4. decompress the raw LZMA stream with bounded output;
5. validate the 384×384, 32-bit BMP;
6. convert BGRA to RGBA;
7. make RGB magenta (`255,0,255`) fully transparent;
8. normalize bottom-up BMP rows to top-down RGBA.

## Extract one sprite

Use the `firstspriteid`, `lastspriteid`, and `spritetype` values from `catalog-content.json` or `CLIENT_ASSETS_INDEX.json`:

```bash
python tools/ai-agent/otbm_sprite_tool.py extract \
  /path/to/sprite-sheet.lzma \
  --first-id 1 \
  --last-id 144 \
  --layout 0 \
  --sprite-id 42 \
  --output artifacts/sprite-42.png \
  --report artifacts/sprite-42.json
```

All 36 OTClient layouts are supported, from 32×32 through 384×384. Sprite placement is calculated as:

```text
offset  = spriteId - firstSpriteId
columns = 384 / spriteWidth
column  = offset % columns
row     = offset / columns
```

The PNG writer uses the Python standard library and writes deterministic RGBA PNG files.

## Safety and validation

- source sheets are read-only;
- the CIP size must exactly match the physical LZMA payload;
- LZMA properties, dictionary size, stream termination, output size, and trailing data are checked;
- decompressed output is bounded;
- BMP dimensions, pixel offset, bit depth, compression, and data bounds are checked;
- sprite range and layout capacity are checked before extraction;
- no archive, client executable, appearances file, sprite sheet, map, or datapack is modified.

## Renderer boundary

This stage can produce individual item sprites. The next stage composes them into map tiles using the appearance frame groups, layers, pattern dimensions, offsets, elevation, and RME/OTClient draw order.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_sprites.py -v
```
