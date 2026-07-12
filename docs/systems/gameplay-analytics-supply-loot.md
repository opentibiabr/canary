# Gameplay Analytics supply and loot telemetry

`GameplayAnalytics.recordSupply(player, itemId, amount, unitValue)` and
`GameplayAnalytics.recordLoot(player, itemId, amount, npcValue, marketValue)`
store per-item aggregates in `analytics_session_supplies` and
`analytics_session_loot`. Both remain disabled until `trackSupplies` /
`trackLoot` are set to `true` in
`data-otservbr-global/scripts/config/gameplay_analytics.lua` (both default to
`false`). This document covers what is wired up, why, and the value-source
precedence used for pricing.

## Value-source precedence

Every price used by this integration comes from
`data/scripts/lib/gameplay_analytics_prices.lua`, a small table copied
directly from real NPC shop scripts. For a given item:

1. If the table has a verified entry for the relevant side (`buy` for
   supplies, `sell` for loot), that exact number is used.
2. Otherwise the value is `0`.

Prices are **never guessed, estimated, or derived** from unrelated data.
Every table entry carries a comment naming the NPC script it was copied from,
so it can be re-verified against that source at any time. `marketValue` is
always `0` for every call in this integration: this engine does not expose a
Lua-accessible market price API (only `Shop:setBuyPrice`/`setSellPrice`,
configured per NPC, exist), so there is no trustworthy source to read from —
per the documented contract in `docs/systems/gameplay-analytics.md`, a
missing value stays at zero rather than being invented.

## Runtime access and script load order

Shared action, rune and event-callback scripts use the live
`GameplayAnalytics` global at the moment an event occurs. They do not
`dofile` the Analytics core themselves. Re-executing the core after context,
batching and reliability wrappers have been installed could replace wrapped
functions while leaving their installation flags set, so the validators
explicitly reject that pattern. When the current data pack does not provide
Analytics, the global is `nil` and the integrations remain no-ops.

## Supply telemetry

### Potions

`data/scripts/actions/items/potions.lua` calls `recordSupply` at the existing
`player:updateSupplyTracker(item)` call site, right before the potion is
actually removed from the player's inventory. This is the same established,
single hook the client-facing supply tracker UI already uses, so there is
exactly one recording point per potion consumed — no separate code path was
added that could double-count it.

11 of the potions in that file have a verified NPC buy price (sourced from
`data-otservbr-global/npc/chuckles.lua`); the rest (buff potions, the antidote
potion, the transform-on-use "vial of blood") report `unitValue = 0` because
no verified price was found, not because they were skipped by mistake.

### Runes

`data/scripts/runes/fireball.lua` and
`data/scripts/runes/intense_healing_rune.lua` (already wired for spell
telemetry — see `docs/systems/gameplay-analytics-spells.md`) additionally call
`recordSupply` once per successful cast, using the same rune item ID already
configured via `rune:runeId(...)` and a verified buy price
(`data-otservbr-global/npc/alexander.lua` for the fireball rune,
`data-otservbr-global/npc/asima.lua` for the intense healing rune). This is a
separate aggregate table from the spell-cast data `recordSpell` stores; the
two calls do not interact.

### Ammunition (not yet integrated)

The task covers "runes and ammunition where reliable." Ammunition is not
wired up in this change: `Weapon:onUseWeapon(player, variant)` does not
expose which specific item ID was consumed when a single weapon script
registers more than one ammo ID (as `data/scripts/weapons/scripts/diamond_arrow.lua`
does, for IDs `25757` and `35901`). Recording supply usage under one of those
IDs without knowing which was actually used would be a guess, which this
integration does not do. Extending this to ammunition needs either a
single-ID-per-script convention or an engine change exposing the consumed
item to the callback.

## Loot telemetry

`data/scripts/eventcallbacks/monster/postdroploot_gameplay_analytics.lua`
registers on the existing `monsterPostDropLoot` event (see
`data/scripts/eventcallbacks/README.md`), which fires once per corpse, after
`data/scripts/eventcallbacks/monster/ondroploot__base.lua` has already
generated and added the monster's loot to it. The callback reads the corpse's
final contents with `Container:getItems(true)`. The recursive flag is
important: items inside backpacks, bags or other nested containers are
physical loot too and would otherwise be omitted. The callback calls
`recordLoot` once for each returned item, including the container itself.

Loot is attributed **only to the corpse owner**
(`Container:getCorpseOwner()`), never to every shared-experience party
member the way `postdroploot_analyzer.lua`'s kill tracker update is. A
corpse holds exactly one set of physical items; if this integration credited
that same loot to every party member it would multiply the reported loot
value by party size in aggregate dashboards. This is a deliberate difference
from the kill-tracker pattern it otherwise resembles, and the static
validator (`tools/analytics/validate_gameplay_analytics_supply_loot_integration.py`)
asserts the callback never iterates party members and always includes nested
containers.

The logic itself lives in `data/scripts/lib/gameplay_analytics_loot.lua`
(`GameplayAnalyticsLoot.recordCorpseLoot`) so it can be unit tested without a
running game engine.

## No duplicate counting

- Potions: one call site, immediately before the one existing `item:remove(1)`.
- Runes: one call per successful cast, gated on the same success result the
  spell-cast wrapper already returns.
- Loot: one call per physical item per corpse, including items in nested
  containers, from a callback that itself only fires once per monster death
  and is attributed to a single player.

## Disabled by default

`trackSupplies` and `trackLoot` both default to `false`. Every call site in
this integration goes through `recordSupply` / `recordLoot`, which already
no-op when their respective tracking flag is off or Analytics itself is
disabled — this change does not alter those defaults or add a new bypass
around them.

## Aggregated, not per-event, writes

Both functions accumulate into the in-memory session (`session.supplies`,
`session.loot`) exactly like every other Gameplay Analytics aggregate. No SQL
is issued per potion drunk or per looted item; persistence still only happens
in batched, idempotent upserts when a completed session is flushed (see
`docs/systems/gameplay-analytics-persistence.md`).
