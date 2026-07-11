# OTBM item and map-mechanics audit

`tools/ai-agent/otbm_item_audit_tool.py` audits every item placed in an OTBM map against a modern object-appearance index and Canary `items.xml`.

The audit is read-only. It does not edit the map, client data, XML, or Lua scripts.

## Build the native scanner

Linux and macOS:

```bash
c++ -O3 -std=c++20 \
  tools/ai-agent/otbm_item_audit_scan.cpp \
  -o artifacts/otbm_item_audit_scan
```

Windows with MinGW:

```powershell
g++ -O3 -std=c++20 `
  tools/ai-agent/otbm_item_audit_scan.cpp `
  -o artifacts/otbm_item_audit_scan.exe
```

The scanner walks the OTBM node stream directly and records:

- inline tile items;
- top-level and nested item nodes;
- placement counts per item ID;
- item-attribute counts;
- `actionId`, `uniqueId`, teleport destinations, and house-door IDs with coordinates and container depth;
- unknown attribute tails that could make the scan incomplete.

It uses fixed-size item counters and emits only aggregate usage plus map-mechanics placements, so large maps do not require materializing every tile or item as Python objects.

## Prepare an appearances index

```bash
python tools/ai-agent/otbm_appearances_tool.py \
  /client/assets/appearances.dat \
  --output artifacts/APPEARANCES_INDEX.json
```

The item audit expects object appearances. Outfit, effect, and missile entries are ignored.

## Run the audit

```bash
python tools/ai-agent/otbm_item_audit_tool.py \
  /maps/otservbr.otbm \
  --scanner artifacts/otbm_item_audit_scan \
  --appearances-index artifacts/APPEARANCES_INDEX.json \
  --items-xml data/items/items.xml \
  --scan-output artifacts/OTBM_ITEM_SCAN.json \
  --output artifacts/OTBM_ITEM_AUDIT.json
```

`OTBM_ITEM_AUDIT_SCANNER` may be set instead of passing `--scanner`.

Use `--skip-map-hash` for repeated local iterations on a very large map. The default records the OTBM SHA-256.

## Interpretation

### Missing appearance

A placed item ID that has no modern object appearance is an error. The client cannot render that ID from the supplied appearance data.

### No explicit `items.xml` entry

This is **not automatically an error**. Canary first creates base `ItemType` records from `appearances.dat` and then applies explicit `items.xml` definitions and overrides.

The report divides IDs without an XML entry into:

- `appearanceOnlyDecorations` — no interactive appearance flag and no map-mechanics attribute was detected;
- `interactiveWithoutItemsXml` — the appearance is interactive or at least one placed instance has `actionId`, `uniqueId`, teleport destination, or house-door ID.

The second group requires gameplay review before copying or replacing a region.

### Map mechanics

`mechanicPlacements` preserves every detected map-level mechanic with:

- item ID;
- world position;
- nesting depth (`0` for a top-level item, `1+` inside containers);
- action ID;
- unique ID;
- house-door ID;
- teleport destination.

This stage inventories definitions. A later script-resolution audit determines whether each identifier has a matching Lua/XML handler and whether generic ranges such as quest chest action ID `2000` are intentionally supported.

## Report status

`ok` is false when:

- at least one used item ID is missing from the supplied appearances index; or
- an unknown item-attribute tail prevents complete parsing.

Missing explicit XML definitions and unresolved script handlers remain review findings rather than parser errors.

The report contract is `docs/ai-agent/OTBM_ITEM_AUDIT_REPORT.schema.json`.

## Real-map validation

On the current uploaded OTBM and client 15.25 data, the scanner processed:

- 17,972,761 tiles;
- 23,359,571 placed items;
- 23,852 unique item IDs;
- 9,339 placements containing action, unique, teleport, or house-door mechanics;
- zero unknown attribute tails.

These values document one validation run and are not hard-coded expectations.

## Tests

```bash
python -m unittest tools/ai-agent/test_otbm_item_audit.py -v
```

The test compiles the C++ scanner, creates a synthetic OTBM with inline, nested, action, unique, teleport, and house-door items, then verifies classification against synthetic appearances and `items.xml`.
