# OTBM comparison with TibiaMaps

`tools/ai-agent/otbm_reference_tool.py` compares tile occupancy from an OTBM map with the map and pathfinding PNG floors published by [TibiaMaps map data](https://github.com/tibiamaps/tibia-map-data).

The comparison is read-only. It does not convert minimap colors into OTBM items and does not modify the source map.

## Build the native scanner

A small standard-library-only C++ helper scans large OTBM files into compact occupancy bitsets. It avoids materializing item stacks and can scan multi-gigabyte maps much faster than a Python node walker.

Linux and macOS:

```bash
c++ -O3 -std=c++20 \
  tools/ai-agent/otbm_reference_scan.cpp \
  -o artifacts/otbm_reference_scan
```

Windows with MinGW:

```powershell
g++ -O3 -std=c++20 `
  tools/ai-agent/otbm_reference_scan.cpp `
  -o artifacts/otbm_reference_scan.exe
```

The scanner accepts a dynamic world origin and reference dimensions and writes one bitset per floor plus `occupancy.json`.

## Prepare reference floors

The reference directory must contain matching map and path PNGs:

```text
floor-00-map.png
floor-00-path.png
...
floor-15-map.png
floor-15-path.png
```

The latest generated files are published by TibiaMaps. Their standard canvas is 2560×2048 pixels with default world origin `31744,30976`, so one PNG pixel corresponds to one Tibia position.

## Run a full comparison

```bash
python tools/ai-agent/otbm_reference_tool.py \
  /maps/otservbr.otbm \
  /references/tibiamaps/data \
  --scanner artifacts/otbm_reference_scan \
  --output-dir artifacts/tibiamaps-comparison
```

Compare selected floors only:

```bash
python tools/ai-agent/otbm_reference_tool.py map.otbm reference-data \
  --scanner artifacts/otbm_reference_scan \
  --floors 7-10,15 \
  --minimum-component-area 16 \
  --output-dir artifacts/comparison
```

`OTBM_REFERENCE_SCANNER` may be set instead of passing `--scanner`.

## Output

The output directory contains:

- `comparison.json` — totals, per-floor coverage, connected missing regions, provenance, and a color legend;
- `floor-XX-diff.png` — deterministic transparent difference images;
- `occupancy/occupancy.json` — native scanner metadata;
- `occupancy/floor-XX.bits` — compact OTBM occupancy bitsets.

Difference colors:

- green — the tile exists in both OTBM and the reference;
- red — the tile exists only in the reference;
- blue — the tile exists only in OTBM;
- transparent — neither source contains terrain at the position.

Missing reference tiles are grouped with four-neighbor connected components. Each component records total area, walkable area, bounds, centroid, width, and height. Reports contain rankings by both total area and walkable area.

## Terrain and pathfinding semantics

TibiaMaps map PNGs use the standard minimap colors. The ground-floor empty background is RGB `51,102,153`; other floors use black as the unexplored background.

Path PNGs use:

- grayscale values for walkable path data;
- yellow `255,255,0` for non-walkable positions;
- magenta `255,0,255` for unexplored positions.

The tool counts a missing reference position as walkable only when its path pixel is grayscale.

## Safety and limitations

- OTBM and reference PNG inputs are opened read-only.
- The native scanner validates node boundaries, escape bytes, floor ranges, reference dimensions, duplicate positions, and output sizes.
- PNG CRCs, dimensions, palette indexes, filters, and supported color modes are validated with the Python standard library.
- Source OTBM SHA-256 is recorded unless `--skip-map-hash` is used.
- No client asset, minimap, OTBM, companion XML, or server file is modified.

TibiaMaps is a structural reference, not a complete map source. Its colors and path data do not identify exact item stacks, action IDs, unique IDs, teleport destinations, houses, spawns, or quest scripts. A red region is therefore a reconstruction candidate, not an automatically applicable patch.

Blue OTBM-only regions may be valid custom content, hidden geometry, sea/void fillers, or areas removed from current Tibia. They must not be deleted automatically.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_reference.py -v
```

The test suite validates indexed and RGBA PNG decoding, OTBM escape handling, occupancy bitsets, connected regions, pathfinding classification, deterministic diff PNGs, native scanner compilation, and an end-to-end synthetic comparison.
