# Weapon Proficiency (Protocol 15.11) - Server Guide

This document explains the Weapon Proficiency system introduced in [PR #3845](https://github.com/opentibiabr/canary/pull/3845), including:

- how it works
- where to edit data
- how `config.lua` changes behavior
- how weapon proficiency source precedence works (protobuf vs `items.xml`)
- common troubleshooting steps

This guide is focused on Canary server behavior.

## 1. Scope of PR #3845 (high level)

Main additions in this PR:

- Weapon Proficiency system (experience, perk selection, mastery, combat effects, persistence)
- New proficiency data file: `data/items/proficiencies.json`
- New proficiency metadata in assets protobuf (`proficiency_id` in appearances)
- Optional weapon proficiency override in `items.xml` using `<attribute key="proficiency" value="..."/>`
- New catalyst items and helper scripts for adding weapon proficiency XP
- New imbuement-related content (including imbuement scroll flow)

## 2. Core files

Main implementation files:

- `src/creatures/players/components/weapon_proficiency.hpp`
- `src/creatures/players/components/weapon_proficiency.cpp`
- `src/enums/weapon_proficiency.hpp`
- `data/items/proficiencies.json`
- `src/items/items.cpp` (protobuf proficiency load)
- `src/items/functions/item/item_parse.cpp` (XML proficiency override)
- `src/server/network/protocol/protocolgame.cpp` (window/update packets)
- `src/io/functions/iologindata_load_player.cpp` and `src/io/iologindata.cpp` (load/save persistence)
- `config.lua.dist` + `src/config/configmanager.cpp` (config options)

Related Lua API/scripts:

- `src/lua/functions/creatures/player/player_functions.cpp` (`Player:addWeaponExperience`)
- `src/lua/functions/items/item_type_functions.cpp` (`ItemType:isWeapon`)
- `data/scripts/lib/proficiency_helper.lua`
- `data/scripts/talkactions/god/weapon_proficiency.lua`
- `data-otservbr-global/scripts/actions/object/proficiency_catalyst.lua`
- `data-otservbr-global/scripts/actions/object/greater_proficiency_catalyst.lua`

## 3. Data source precedence for weapon proficiency IDs

Weapon proficiency ID on each item is resolved in this order:

1. Baseline/default from protobuf appearances (`appearances.dat` -> `proficiency_id`)
2. Optional override from `items.xml` (`<attribute key="proficiency" value="..."/>`)

Important:

- protobuf is the default source
- XML has higher precedence when that attribute is present and valid
- if XML attribute is missing, protobuf value remains active

Validation:

- unknown/invalid proficiency IDs are ignored and logged
- item keeps previous valid value (or zero if none is valid)

## 4. Startup and runtime flow

### Startup

1. Server loads `data/items/proficiencies.json`
2. Server loads `appearances.dat` and assigns protobuf `proficiency_id` to item types
3. Server loads `items.xml`, optionally overriding per item with `key="proficiency"`

### Player load/save

- On login init: weapon proficiency state is loaded from KV scope `weapon-proficiency`
- On save/logout: full state is persisted back to KV

### Gameplay flow

- Equipping left-hand weapon:
  - clears current proficiency-derived cached stats
  - applies selected perks for equipped weapon
  - sends current proficiency status to client
- Unequipping:
  - clears applied proficiency cached stats
  - sends proficiency update

### Combat/xp

- XP is awarded on monster kill, based on:
  - bosstiary rarity
  - bestiary stars
- Perk effects are applied in combat pipeline (crit, elemental crit, bestiary bonus, powerful foe bonus, life/mana gains, skill percentage bonuses, etc.)

## 5. Editing `data/items/proficiencies.json`

Each entry represents one proficiency profile:

- `ProficiencyId`
- `Name`
- `Levels` (array)
- `Levels[].Perks` (array of selectable perks at that level)

Basic example:

```json
{
  "ProficiencyId": 999,
  "Name": "Custom Test Profile",
  "Version": 1,
  "Levels": [
    {
      "Perks": [
        { "Type": 0, "Value": 1.0 }
      ]
    }
  ]
}
```

Common perk fields:

- `Type` (required)
- `Value` (required)
- optional by perk type:
  - `SkillId`
  - `SpellId`
  - `AugmentType`
  - `ElementId` or `DamageType` (in source json, converted internally)
  - `BestiaryId`
  - `BestiaryName`
  - `Range`

If you reference a proficiency ID in protobuf/XML that does not exist in this file, that item proficiency will be ignored.

## 6. Proficiency bonus type IDs (`Type`)

Defined in `src/enums/weapon_proficiency.hpp`:

- `0` attack damage
- `1` defense bonus
- `2` shield modifier
- `3` skill bonus
- `4` specialized magic level
- `5` spell augment
- `6` bestiary damage bonus
- `7` powerful foe bonus
- `8` critical hit chance
- `9` elemental hit chance
- `10` rune critical hit chance
- `11` auto-attack critical hit chance
- `12` critical extra damage
- `13` elemental critical extra damage
- `14` rune critical extra damage
- `15` auto-attack critical extra damage
- `16` mana leech
- `17` life leech
- `18` mana gain on hit
- `19` life gain on hit
- `20` mana gain on kill
- `21` life gain on kill
- `22` perfect shot damage
- `23` ranged hit chance
- `24` attack range
- `25` skill percentage auto-attack
- `26` skill percentage spell damage
- `27` skill percentage spell healing

## 7. Config options (`config.lua`)

Current options:

- `weaponProficiencyMaxLevels`
- `weaponProficiencyMaxPerksPerLevel`
- `weaponProficiencyGainMultiplier`

Behavior:

- `weaponProficiencyMaxLevels`:
  - hard cap while loading levels from `proficiencies.json`
  - extra levels in JSON are ignored
- `weaponProficiencyMaxPerksPerLevel`:
  - hard cap while loading perks in each level
  - extra perks are ignored
- `weaponProficiencyGainMultiplier`:
  - multiplier applied to gained proficiency XP
  - values `< 0` are clamped to `0`
  - final value is rounded (`llround`)

Practical note about rounding:

- very small base gains can become `0` after multiplier
- example: `1 * 0.33` rounds to `0`

## 8. XP tables and mastery

Current proficiency XP thresholds by weapon category:

- Crossbow table:
  - `600, 8000, 30000, 150000, 650000, 2500000, 10000000, 20000000, 30000000`
- Knight table:
  - `1250, 20000, 80000, 300000, 1500000, 6000000, 20000000, 40000000, 60000000`
- Standard table:
  - `1750, 25000, 100000, 400000, 2000000, 8000000, 30000000, 60000000, 90000000`

Mastery progression logic:

- perk unlock levels use `maxLevel`
- mastery XP tiers use `maxLevel + 2` (bounded by table size)
- max experience uses this mastery tier count

This means proficiency can continue past the last perk-unlock level until mastery cap.

### Base XP gain from monsters

From current code:

- Bestiary stars:
  - `0 -> 1`
  - `1 -> 30`
  - `2 -> 70`
  - `3 -> 100`
  - `4 -> 165`
  - `5 -> 241`
- Bosstiary rarity:
  - `BANE -> 500`
  - `ARCHFOE -> 5000`
  - `NEMESIS -> 15000`

## 9. Client-side vs server-side edits

This system is split between server and client.

Server side controls:

- progression logic
- perk effects
- persistence
- item-to-proficiency assignment

Client side controls:

- UI data/display of proficiencies (client assets)

If you only edit server files, client visuals may not change.
If you only edit client assets, server logic will not change.

For full changes, update both sides and restart/redeploy both.

## 10. Catalysts and scripts

Shared helper:

- `data/scripts/lib/proficiency_helper.lua`
- validates target is a weapon (`ItemType:isWeapon()`)
- applies XP via `Player:addWeaponExperience(experience, weaponId)`

Registered catalyst actions in `data-otservbr-global`:

- `51588` -> `25000` XP
- `51589` -> `100000` XP

If catalyst items exist but do nothing, confirm these action scripts are present and loaded.

## 11. Optional XML override example

Example for forcing a specific proficiency ID on one item:

```xml
<item id="12345" name="my custom weapon">
  <attribute key="proficiency" value="6"/>
</item>
```

Requirements:

- `value` must be a valid `ProficiencyId` in `data/items/proficiencies.json`
- server restart/reload needed

## 12. Testing checklist

Use this quick validation flow after changes:

1. Restart server after editing proficiency data/config/item mappings
2. Equip the target weapon and confirm proficiency packet/UI updates
3. Kill monsters and confirm XP gain
4. Select/clear perks from client and confirm persistence
5. Relog and confirm saved state remains
6. If using catalysts, test on a weapon item (not non-weapon)
7. Optional GM test: `/proficiency <xp>` (requires god group)

## 13. Troubleshooting

### "I changed both JSON files and nothing changed."

Check all of the following:

- weapon actually has a non-zero resolved `proficiencyId`
- ID exists in server `data/items/proficiencies.json`
- client assets were also updated/deployed
- server and client were restarted (and client cache refreshed if applicable)
- you are testing with protocol 15.11 path (old protocol path does not process these packets)

### "Catalyst is not adding XP."

Check:

- target item is recognized as weapon (`ItemType:isWeapon()`)
- catalyst action scripts are registered in your datapack
- item ID matches registered catalyst IDs

### "Perks do not apply after selecting."

Check:

- selected level is unlocked by XP
- only one perk per level is allowed
- weapon is equipped so effects are applied to current combat stats

## 14. Notes for maintainers

- `items.xml` override is intentionally optional; protobuf remains default mapping source
- invalid KV proficiency keys are sanitized during load/save
- proficiency state is persisted in KV scope `weapon-proficiency`
- changing `weaponProficiencyMaxLevels` or `weaponProficiencyMaxPerksPerLevel` can truncate loaded definitions from JSON
