# Task Board module

The Task Board is implemented as a Lua module under `data/modules/scripts/taskboard/`. The module owns the official-client packet entry points, persistent state, task generation, rewards, preferences, shop purchases, progression callbacks, and the optional Soulpit adapter boundary.

The implementation intentionally derives behavior from the official packet contract without importing a server-specific catalog, generated monster pool, or source layout. Monster candidates are discovered from `Game.getMonsterTypes()` at runtime.

## Components

- `taskboard.lua` loads the components and exposes the small global integration surface used by event callbacks.
- `settings.lua` contains packet ids, action ids, limits, reward formulas, and local catalogs.
- `catalog.lua` builds a race-id catalog from the server's loaded monster types.
- `state.lua` reads and writes primitive values in the player's `task-board` KV scope. Arrays are represented by numbered KV scopes so the schema does not depend on table serialization.
- `rules.lua` implements bounty and weekly generation, kill progression, deliveries, rerolls, preferences, upgrades, shop purchases, and reward accounting.
- `wire.lua` is the only component that writes Task Board and resource-balance packets.
- `actions.lua` parses client actions and rejects incomplete or trailing payloads.
- `soulpit.lua` handles the 0xBA selection contract and calls an optional server-provided `SoulPit.startSoloFight` adapter.
- `lifecycle.lua` restores viewer-specific task icons when a player logs in.
- `on_login_complete_taskboard.lua` sends the Bounty and Weekly snapshots after the login packet sequence is complete, restoring client trackers without interleaving custom packets with the handshake.

The module registrations are in `data/modules/modules.xml`. Both 0x5F and 0xBA are routed to the Task Board entry point. Because the module loader evaluates that entry point once per registered opcode, its composition is idempotent and both callbacks retain the same Task Board instance.

Gameplay policy remains module-owned, but the implementation is not Lua-only. Narrow native bridges provide protocol-profile dispatch, direct resource requests, viewer-specific creature icon overlays, mutable combat life-leech data, filtered item counting and removal, and Wheel access to persisted extra points. Keep those bridges generic: they expose engine capabilities while task generation, prices, rewards, and feature decisions stay in the module.

## Packet contract

The parser treats the first byte after client packet 0x5F as an action:

| Action | Payload |
| --- | --- |
| 0x00, 0x01, 0x03, 0x04, 0x06, 0x0A, 0x0C | none |
| 0x02, 0x05, 0x07, 0x08, 0x09, 0x0D, 0x0E | one byte |
| 0x0B | one unsigned 16-bit value |
| 0x0F, 0x10 | two unsigned 16-bit values |

The parser consumes exactly the expected payload and ignores malformed packets without sending a response. This includes missing fields, unknown actions, and unexpected trailing bytes. The 0xBA selection packet contains exactly one unsigned 16-bit race id.

The outbound 0x5B layout is split into three windows:

- Bounty: task count and records, daily reroll counters, difficulty, four talisman upgrade lines, and five preference slots.
- Weekly: any-creature progress, kill records, item records, difficulty and experience values, completion counters, selection state, next reset, third-slot state, and the current weekly task-hunting reward.
- Shop: configured offers followed by the wheel-bonus offer. Item, mount, outfit, and decoration records use their official appearance shapes; the default catalog only enables a server-safe item offer and the wheel offer.

Every variable record list is capped before both its count and records are written. The shop reserves one byte-sized entry for the trailing Wheel offer, so hidden overflow entries cannot move the client-visible purchase index.

Resource balances use packet 0xEE. Bounty points and Soulseals are unsigned 32-bit values; legacy task-hunting points remain an unsigned 64-bit value. The module sends all three balances after a Task Board window or a Soulpit debit. When a current client requests resource 0x56 or 0x57 directly, the protocol transport reads the corresponding module-owned KV value and returns the same bounded balance.

Active Bounty and specific Weekly races are mirrored into viewer-owned creature icon overlays. The protocol merges those overlays only for that viewer when a matching monster enters the screen, while the module refreshes known visible creatures after login, task selection, rerolls, claims, weekly generation, and task completion. Icon ids 8 and 9 are serialized through the existing 15.25 Other Icons record layout and share its three-icon safety limit.

The weekly Soulseals tail is version-gated. It is emitted for numeric client versions 15.21 and newer, for the known `15.20.f23bc3` build prefix, and omitted for unknown 15.20 builds. No hash arithmetic or guessed build ordering is used. The current Lua client metadata exposes the numeric protocol version; a future binding that exposes the full version string can use the conservative 15.20 prefix branch.

The final byte of a bounty task record is the task marker. Generation checks the configured Gold chance first and the Silver chance second; the defaults are 5% Gold and 10% Silver. Normal, Silver, and Gold tasks multiply experience and bounty-point rewards by 1, 2, and 4 respectively, while preserving the same byte width and record position.

## Runtime behavior

The player kill callback calls `Taskboard.onMonsterKilled` for every credited player after an eligible, non-summoned monster dies. Progress is independent of corpse creation and loot generation, while reward bosses and Soulpit encounters remain excluded. This updates the selected bounty, the any-creature weekly task, matching weekly kill tasks, and the visible client windows. A newly completed bounty or creature-specific weekly task also emits its official client event so the 15.20+ completion feedback is preserved. Weekly item delivery counts only unequipped inventory containers and the stash; equipped items and the Store Inbox are excluded by the same filters used during removal. The stash portion is removed first, and if backpack removal fails it is restored without requiring free inventory capacity.

Persisted weekly assignments are normalized when loaded. Invalid creature or item entries are discarded, progress is bounded by each requirement, completed records are made internally consistent, and reward counters are derived from the surviving assignments. Stored aggregate values are never trusted independently when calculating the weekly payout.

The next weekly cycle starts on Monday at the configured global server-save hour and minute. If that runtime setting is absent or malformed, the module falls back to midnight without emitting an invalid timestamp.

Persisted bounty options follow the same boundary rules: unknown races, zero requirements, duplicate choices, and extra active assignments are rejected. Invalid unlocked preference races are cleared, locked preferences cannot retain hidden assignments, and the first preference remains available as the free base slot.

Preference probabilities apply only to Bounty generation. Each configured unwanted race has the configured chance to be skipped from that generation, while each available preferred race receives the configured priority roll before uniform selection. Weekly creature assignments always use the unweighted difficulty catalog.

Bounty points are stored by this module. Shop prices consume the existing task-hunting point API exposed by the server. Weekly completion points are awarded to that same task-hunting balance when the weekly cycle rolls over. Purchased Wheel points remain module-owned in `task-board/wheel/multiplier`; the Wheel reads that bounded value as zero to 50 extra points when calculating and serializing its available points. The next price is always derived from the multiplier instead of trusting an independent persisted value. The module never counts the store inbox as weekly delivery inventory.

Task Board item rewards are delivered to the Store Inbox after its free slots are checked. Decoration offers create one unwrap kit per configured decoration id, including paired decorations. If any insertion in a reward batch fails, already inserted items are removed before the task-point debit is refunded.

Shop offer prices must be finite, non-negative integers that fit the unsigned 32-bit wire field. Invalid prices are serialized as zero for packet stability, remain unavailable, and are never passed to the task-point debit or refund paths.

Configured outfit offers validate their looktypes and addon before becoming purchasable. A successful purchase grants both configured sex variants and persists base/addon ownership by looktype pair, so changing sex or temporarily failing an outfit eligibility check cannot expose the same offer for a second charge.

All four talisman levels are persisted and exposed in the official four-line bounty record. The `moreLoot` effect is applied by `Player:calculateLootFactor`; damage activation is applied before combat damage is resolved; life leech is added to the native combat leech amount and therefore settles from the engine's final real damage; the double-bestiary upgrade uses `Player:addBestiaryKill` when its active-task and chance checks pass. Its extra kill amount mirrors the active base, event, and concoction multipliers, and it stops once the Bestiary entry is unlocked. These effects require the bounty talisman in the ammo slot, are gated by the selected bounty race, and do not affect unrelated creatures.

The bounty talisman is available from the regular jewellery NPC shops for 5,000 gold. It remains an ordinary tradable datapack item; only its equipped state and the module-owned upgrade levels control the Task Board bonuses.

The Soulpit packet window is deliberately adapter-driven. A server that has a Soulpit engine can configure race ids in `settings.lua` and provide `SoulPit.startSoloFight(player, monsterName)`. Configured races are validated against the runtime monster catalog, deduplicated, and sorted before serialization. An adapter may also expose `SoulPit.canOpenWindow(player)` to enforce its own map, distance, or encounter-state rules both when opening and when selecting, plus `SoulPit.abortSoloFight(player)` to roll back a failed start or an encounter whose Soulseal debit cannot be persisted. A map or NPC script can then call `Taskboard.openSoulpitWindow(player)`. The window is limited to supported clients and grants one short-lived, single-use selection authorization bound to the player's current login session. Its six valid Bestiary difficulties cost 10–60 Soulseals; malformed difficulty metadata is rejected. Without an adapter or a non-empty catalog, no packet is sent and no Soulseals are deducted.

## State outline

The persistent root is `player:kv():scoped("task-board")`:

- `general`: bounty points, Soulseals, third-slot state, and Task Board outfit ownership;
- `bounty`: difficulty, reroll counters, task records, and preference records;
- `weekly`: difficulty, reset state, any-creature progress, kill/item records, reward totals, and experience values;
- `upgrades`: damage, life-leech, loot, and double-bestiary levels;
- `wheel`: multiplier and next price;
- `meta`: schema version and next weekly reset timestamp.

Each write clamps wire-facing counters to the width required by the protocol. Non-finite semantic values are replaced with safe defaults before persistence or probability calculations; saturating wire clamps map positive and negative overflow to the field limits and map `NaN` to the lower limit. Unknown or stale records are normalized during load and never cause a packet to read past its own boundary.

## Validation

From the repository root:

```text
lua tests/lua/test_taskboard_module.lua
stylua --check data/modules/scripts/taskboard data/scripts/eventcallbacks/creature/on_combat_taskboard.lua data/scripts/eventcallbacks/player/on_kill_taskboard.lua data/scripts/eventcallbacks/player/on_login_complete_taskboard.lua data/scripts/talkactions/god/manage_task_board.lua tests/lua/test_taskboard_module.lua
```

Also run `luac -p` for every changed Lua file. The standalone suite covers parser boundaries, packet widths and version gates, KV normalization, task generation and progression, reward rollback, resource requests, creature icons, combat bonuses, Wheel progression, shop ownership, Soulpit authorization, and invalid numeric inputs.

Changes limited to module policy can use the Lua checks above. Changes to any native bridge must also regenerate the Lua API artifacts when bindings change and build the `canary` target with the repository's existing configured CMake preset:

```text
cmake --build --preset <configured-preset> --target canary
```

Do not create a separate build tree solely for Task Board validation. Reuse the maintained preset and follow the platform build guidance in `docs/development.md` if configuration is required.
