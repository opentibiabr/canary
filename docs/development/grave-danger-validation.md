# Grave Danger corrections and validation

Validated locally on 2026-11-12. No live server was started or reloaded.

## Changes

- Count Vlarkorth includes vocation base ID 9 (Monk/Exalted Monk), Dark Merudri
  and Good Remains of a Merudri (50311). Remains retain world/session/vocation
  validation. Item 50311 exists in the local `data/items/appearances.dat`.
  Dark Merudri uses the existing male Monk appearance 1824; confirm its visual
  presentation in game. Its documented 6,500 HP and known attack ranges are used;
  undocumented attack intervals/chances use the existing dark-counterpart cadence.
- Lord Azaram removes Condensed Sins during the soul phase. Three fragments
  complete each round without requiring a healer. First-round direct healing
  remains supported; the last round requires fragments even if healed to full.
  Fragments are tied to world, encounter and phase, and cannot be reused.
  Soul health persists between transformations, and a soul already full on spawn
  requires fragments. Existing two-round encounter limit is retained.
- Earl Osam is visibly renamed Channeling Earl Osam while shielded, returns to
  Earl Osam afterwards and receives exactly 80,000 healing per arriving sphere.
  Channeling starts at 40 seconds, then every 60 seconds measured from the previous
  phase start. Damage no longer triggers the phase and there is no four-phase cap.
  Sphere travel remains one tile every four seconds, pending retail confirmation.
- Duke Krule checks opposite-element proximity every second during the active
  transformation, capped at one 2,000 nominal damage hit per player per pulse.
  Delayed callbacks do not replay missed pulses. Timing is explicit local tuning:
  4-second introduction, 8 seconds transformed, 12 seconds between phases. Public
  walkthroughs do not establish every timing precisely; this is not a claim of
  measured retail timing.
- Both Zelos cleanse map triggers use one world/session-owned vortex: a successful
  cleanse removes Greater Hex, heals Zelos for 10,000–15,000 and creates Unleashed
  Hex. Exhaustion lasts 60 seconds. Failed summoning leaves the condition and
  vortex unchanged. Replacement encounters invalidate old restore callbacks.
  Cleansing preserves current HP: 2,000/4,000 becomes 2,000/10,000;
  4,000/4,000 becomes 4,000/10,000. Only the native condition removal reverses
  the maximum-HP penalty; the vortex neither heals nor damages the player.
- The Red Knight room maintains three Risen Soldiers and two Vampiric Blood.
  Each dead creature has its own ten-second respawn deadline while the knight lives.
  Initial placement uses local anchors with bounded walkable/unoccupied fallback;
  unsuccessful placement retries after one second, without forced/extended spawning.
  Rewar's two separate soldiers are outside this room's cap.
- Zelos resistance is frozen when the ritual completes: received damage is multiplied
  by max(0, 1 - ritualSeconds / 720). Final-fight elapsed time does not change it.
  The twelve-minute horizon and linear curve are provisional calibration, not a
  recovered retail formula. See [video evidence](grave-danger-video-calibration.md).
- Duke Krule has 290,000 HP, receives neutral energy and 35% ice damage, and heals
  for 100% of death damage. Earth remains at 80% damage received. Loot quantities
  use up to 20 supreme health potions, 14 ultimate mana potions and 4 pieces of
  hell steel; violet gem is included. Existing probabilities remain unchanged;
  the wiki does not establish exact probabilities (the added violet gem uses the
  existing yellow-gem probability).
- Sir Nictros has 150,000 HP and heals for 300% of death damage. Other resistances
  are retained because the public sources disagree on several values.
- Lord Azaram retains 300,000 HP and heals for 260% of earth damage.
- The subsequent source-backed review adds Count immunity, Rewar's Fetter
  protection/cycles, the 30-second Mass retry, final-room Zelos soldiers,
  documented Osam/Baeloc/shard/Mass HP, elemental healing, soul health persistence,
  death reflection and Scarlett's explicit ten-minute limit.
- See [the fidelity review](grave-danger-fidelity.md) for sources, approximations
  and the 47.5/55 documentary checklist (approximately 86%). The Zelos resistance
  curve remains an explicit approximation, not a recovered official formula.

Native `monster.heals` registration is used together with immunity to the same
damage type, following existing server conventions. No C++ changes are needed.

## Sources

Retrieved on 2026-11-12. Wiki resistance/loot tables include uncertainty warnings.

- https://www.tibiawiki.com.br/wiki/Duke_Krule
- https://www.tibiawiki.com.br/wiki/Sir_Nictros
- https://www.tibiawiki.com.br/wiki/Lord_Azaram
- https://www.tibiawiki.com.br/wiki/Dark_Merudri
- https://www.tibiawiki.com.br/wiki/Good_Remains_of_a_Merudri
- https://tibia.fandom.com/wiki/Item_IDs
- https://tibia.fandom.com/wiki/Grave_Danger_Quest

## Local validation

From an initialized MSVC x64 environment, using the maintained LuaJIT library:

```powershell
python tools/canary_audit/test_grave_danger_flow.py tools/canary_audit/test_grave_danger.lua
python tools/canary_audit/test_grave_danger_flow.py tools/canary_audit/test_duke_krule.lua
```

Both passed. The harness loads the real monster definitions and healing adapter;
it tests both soul rounds using actual fragment healing rather than setting soul
HP to full. It also covers Monk action dispatch, channel naming, sphere healing,
Duke movement during transformation, world isolation, vortex failure/exhaustion
and stale encounter timers. Additional checks cover the Osam phase interval,
random support placement/count/failed-spawn retry, stopping support replenishment
on owner death, and unchanged current HP when cleansing the Hex.
XML parsing and scoped whitespace validation passed.
These are isolated Lua checks, not proof of live engine combat or client visuals.

## PR assessment and follow-up issues

Suggested title: `fix: correct Grave Danger mechanics and boss balance`.

Suitable for a draft PR after isolating the complete Grave Danger dependency set.
The current checkout is `main` with extensive pre-existing changes, including
untracked Grave Danger runtime files and removed older handlers. A PR containing
only the newly edited tracked files would be incomplete. Review the final diff
and include the library loader, mechanics registrations, monster files, actions,
movements, item definition and tests together. Do not include unrelated changes.
No commit, branch, remote PR or remote issue was created by this task.

Suggested separate issues:

1. **Live regression in worlds 0 and 1**: test Monk and promoted Monk remains,
   both Azaram soul rounds with and without healing, Osam channel display,
   moving into Duke's proximity after transformation and both Hex triggers.
   Confirm elemental healing in the native engine, loot, quest credit and cleanup.
2. **Zelos ritual scaling calibration**: compare the new approximate resistance
   curve against timestamped official-server combat recordings near 12 minutes.
   Exact timing and damage reduction remain unconfirmed.
3. **Scarlett arena regression**: verify the corrected ten-minute limit and actual
   mirror/explosion bounds in the native engine and client.
4. **Encounter participation across transitions**: audit Azaram's removed/recreated
   monster and credit for players who hit only the first brother. The current
   completion handler reads only the dying monster's damage map; reproduce with
   separate participants before deciding how encounter-wide credit is retained.

Merge readiness requires the live regression and review of the isolated PR diff.
