# Named hunt-area catalogue tooling

`docs/systems/gameplay-analytics-context.md` already documents the
`huntAreas` table format and the fallback grid. This document covers the
tooling that generates and validates that table, and why the shipped
catalogue starts empty.

## Why the catalogue starts empty

Adding a named hunt area means committing a real in-game rectangle. This
repository was checked for an existing authoritative source of hunting-ground
boundaries before writing this tooling:

- `data-otservbr-global/world/otservbr-zones.xml` defines only one zone (a
  boss room reference) and carries no coordinate data.
- `data-otservbr-global/world/otservbr-house.xml` has house entry points,
  not hunting-ground boundaries.
- No monster spawn XML with area radii was found in this data pack.
- The `.otbm` map itself encodes zone/region boundaries only as binary map
  data, with no exported rectangle list to read them from safely, and this
  task does not touch map or OTBM files.

No authoritative rectangle source exists yet. Rather than invent
coordinates to populate the table, the shipped `huntAreas` stays `{}` (its
existing default) and fallback grid areas remain enabled
(`trackFallbackGridAreas = true`, also already the default), exactly as
`gameplay-analytics-context-rollout.md` already recommends for a first
rollout. The tooling below exists so that when an operator *does* confirm
real coordinates, adding them is validated and repeatable instead of manual
Lua editing.

## Files

- `tools/analytics/gameplay_analytics_hunt_areas_lib.py` — shared parsing/validation used by
  both tools below.
- `tools/analytics/validate_gameplay_analytics_hunt_areas.py` — validates the `huntAreas`
  table already in
  `data-otservbr-global/scripts/config/gameplay_analytics.lua`, and
  optionally a candidate file alongside it.
- `tools/analytics/generate_gameplay_analytics_hunt_areas.py` — assembles a candidate file into
  a ready-to-paste Lua snippet, after validating it together with the
  existing table.
- `tools/analytics/gameplay_analytics_hunt_area_candidates.example.json` — a template with
  placeholder coordinates; copy it, do not edit it in place.
- `tools/analytics/fixtures/hunt_areas/*.json` — synthetic fixtures (not
  real game locations) used by `test_gameplay_analytics_hunt_areas.py`.

## Process for adding a new hunt area

1. Confirm the real rectangle in-game or in the map editor yourself. This
   tool never generates or guesses coordinates; only the operator's
   first-hand confirmation is a valid source.
2. Copy `tools/analytics/gameplay_analytics_hunt_area_candidates.example.json` to a working
   file (for example `my_candidates.json`, outside version control) and
   replace the placeholder `name`/`from`/`to` values with the confirmed
   rectangle. Remove the `_comment` field.
3. Run the generator:

   ```bash
   python tools/analytics/generate_gameplay_analytics_hunt_areas.py my_candidates.json
   ```

   This validates your candidate together with every area already in the
   shipped config. It refuses to print anything if the result would contain
   a duplicate name or an overlapping rectangle.
4. Paste the printed `huntAreas = { ... }` table over the existing one in
   `data-otservbr-global/scripts/config/gameplay_analytics.lua`.
5. Run the validator as a final check:

   ```bash
   python tools/analytics/validate_gameplay_analytics_hunt_areas.py
   ```

6. Restart Canary (or wait for the next deploy). Compare named-area totals
   with fallback-grid totals for the same period before relying on the new
   name in a dashboard, as already recommended in the context rollout
   checklist.

## First-match ordering

`data-otservbr-global/scripts/lib/gameplay_analytics_context.lua` walks
`huntAreas` in table order and uses the **first** rectangle whose bounds
contain the sampled position. If two rectangles both contain a position,
the one earlier in the table wins and the later one is effectively
unreachable for that overlap region. This is exactly why the validator
treats any overlap as an error rather than a warning: an overlap either was
a coordinate mistake, or is a deliberate order dependency that must be
resolved (split the rectangles, or reorder and document why) before it is
silently order-dependent in production.

## What the validator checks

- **Malformed coordinates**: `from.x/y/z` must not exceed the matching
  `to.x/y/z`; every coordinate must be an integer within the range the
  engine can represent (`x`/`y` in `[0, 65535]`, `z` in `[0, 15]` per
  `MAP_MAX_LAYERS` in `src/map/map_const.hpp`).
- **Duplicate names**: case-insensitive, since dashboards group by the
  exact `hunt_area` string and two names differing only by case would be
  confusing, separate series for what a human would read as the same hunt.
- **Overlapping rectangles**: two areas overlap only if their `x`, `y` and
  `z` ranges *all* intersect — the same floor and the same footprint. The
  same footprint on two different floors (a common case: a hunting ground
  stacked over a basement) is correctly not an overlap.

## No player movement history

This tooling only ever handles static rectangle definitions (a name and two
corner coordinates) supplied by an operator ahead of time. It does not read,
generate, or store any player position, movement path, or session data.
Runtime sampling behavior (how a live session's position is matched against
these rectangles) is unchanged and already documented in
`gameplay-analytics-context.md`, including that no coordinate trail is ever
persisted.

## Testing

`tools/analytics/test_gameplay_analytics_hunt_areas.py` covers: parsing a candidate file,
parsing (and round-tripping) the Lua table format, rejecting a missing
`huntAreas` block, rejecting inverted or out-of-range coordinates, accepting
non-overlapping areas, rejecting overlapping and case-insensitive-duplicate
areas, and confirming that identical footprints on different floors are not
flagged as overlapping.
