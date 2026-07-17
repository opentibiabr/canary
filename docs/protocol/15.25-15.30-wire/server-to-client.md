# Server-to-client bytes

This document contains the S2C application payloads changed or newly used by Tibia 15.30.

## `0x75` Game Event additions

The selector-based `0x75` family predates 15.30, but the rebalance/task UI consumes new event values.

| Selector | Event | Fields after selector | Evidence |
|---:|---|---|---|
| `0x0B` | bounty task finished | `raceId:u16` | `live/static` |
| `0x0C` | weekly task for specific creature finished | `raceId:u16` | `live/static` |
| `0x0D` | spell unlocked | `spellId:u32` | `static` |
| `0x0E` | leader monster killed | `raceId:u16, value:u32` | `static` |
| `0x0F` | subarea unlocked | `subareaId:u16` | `static`, not live-tested |
| `0x10` | area unlocked | `areaId:u16` | `static`, not live-tested |

Examples for race `22` and spell `274`:

```text
75 0B 16 00
75 0C 16 00
75 0D 12 01 00 00
```

Selectors `0x0B` and `0x0C` passed the live client boundary test. Treat `0x0E`-`0x10` as static until captured or tested in their actual UI flow.

## `0x86` Exaltation Base Data

The classification and tier tables remain. The legacy 13-field forge configuration tail is replaced by one currently unknown byte in 15.30.

### 15.30 layout

```text
86
classificationCount:u8
  repeat classificationCount:
    classificationId:u8
    tierCount:u8
      repeat tierCount:
        targetTier:u8
        regularPrice:u64
exaltedCoreTierCount:u8
  repeat exaltedCoreTierCount:
    tier:u8
    coreCount:u8
convergenceFusionTierCount:u8
  repeat convergenceFusionTierCount:
    tier:u8
    price:u64
convergenceTransferTierCount:u8
  repeat convergenceTransferTierCount:
    tier:u8
    price:u64
reserved:u8
```

Safe empty fixture:

```text
86 00 00 00 00 00
```

For 15.30, do not append the old dust/conversion values after `reserved`. Doing so moves the next opcode into the old tail and desynchronizes the client.

Evidence: `static/reference`.

## Creature icon record changes

### Standalone update `0x8B`, update type `0x0E`

```text
8B
creatureId:u32
updateType:u8 = 0x0E
iconCount:u8
  repeat iconCount, maximum 3:
    iconId:u8
    category:u8
    count:u16
    reserved:u8
```

The `reserved:u8` after every icon record is new/required for 15.30. Current captures/reference writers use `0x00`.

Clear icons for creature `0x01020304`:

```text
8B 04 03 02 01 0E 00
```

Weekly Task and Bounty Task icons for the same creature:

```text
8B 04 03 02 01 0E 02 08 01 00 00 00 09 01 00 00 00
```

Both forms passed the 15.30 client boundary test. The client supports at most three primary icons; sending more can crash it.

### Embedded full-creature instance

The icon portion inside a full creature instance changes from:

```text
stepSpeed:u16
primaryIconCount:u8
primaryIconRecords[]
skull:u8
...
```

to:

```text
stepSpeed:u16
primaryIconCount:u8
primaryIconRecords15_30[]
secondaryIconCount:u8
secondaryIconRecords[]
skull:u8
...
```

Every primary embedded record uses the same five-byte record as `0x8B`: `iconId:u8, category:u8, count:u16, reserved:u8`.

`secondaryIconCount` is mandatory even when zero. The non-empty secondary record shape is not confirmed, so emit `0x00` until captured. Omitting this count shifts the creature skull and all following creature fields.

### Standalone update type `0x0F`

The client contains a second `0x8B` update branch beginning with `creatureId:u32, updateType:u8=0x0F, count:u8`. An empty list is boundary-safe in static analysis, but non-empty record semantics remain `unknown`. Do not generate non-empty records from this specification.

## `0xA2` Player State / special status icon

This packet is retained because the 15.30 UI has a second status-icon byte after the normal bit mask.

```text
A2 normalIcons:u64 specialIcon:u8
```

Clear fixture:

```text
A2 00 00 00 00 00 00 00 00 00
```

The `specialIcon` range currently observed is `0..9`. This packet is not a newly discovered structural change from 15.25; it is listed to prevent implementations from sending only the `u64` mask.

Evidence: `static/reference`.

## `0xA3` Update / clear target

15.30 reads two creature identifiers:

```text
A3 primaryCreatureId:u32 secondaryCreatureId:u32
```

Clear both targets:

```text
A3 00 00 00 00 00 00 00 00
```

The second field is present in the static 15.30 decoder and the reference sender. Its exact UI semantics have no live official capture. Both IDs should be zero when cancelling a target.

Evidence: `candidate/static/reference`. The clear fixture requires a guarded, explicitly enabled test and has not yet passed live boundary validation; preserve the candidate label until a natural target update is captured.

## `0xA7` Set Tactics

15.30 removes `fightMode`:

```text
A7 chaseMode:u8 secureMode:u8 pvpMode:u8
```

Example, stand + secure + dove:

```text
A7 00 01 00
```

This packet passed the live client boundary test. A legacy TibiaAPI `SetTactics` model may still expose four logical fields; that class must not be used as the 15.30 byte authority.

Evidence: `live/static/reference`.

## `0xBB` Shaped Perk Reshape Offers

```text
BB
weaponId:u16
level:u8
index:u8
offerCount:u8
  repeat offerCount:
    perkId:u16
    rank:u8
```

Empty offers for weapon `0x1234`, tree position `(2,1)`:

```text
BB 34 12 02 01 00
```

Two example offers, `(perkId=0x0042,rank=1)` and `(perkId=0x0043,rank=2)`:

```text
BB 34 12 02 01 02 42 00 01 43 00 02
```

The empty writer is implemented in the reference server. The non-empty record shape is confirmed by the static/TibiaAPI decoder, but its economy and selection rules are gameplay scope.

Evidence: `static/reference`; non-empty UI flow not live-tested.

## `0xC1` Vocation-specific active spells

For the active-stance list used by the vocation rebalance UI:

```text
C1
dataType:u8 = 0x02
spellCount:u8
  repeat spellCount:
    spellId:u16
```

Clear active stance spells:

```text
C1 02 00
```

Activate Harmony (`274`):

```text
C1 02 01 12 01
```

Known stance spell IDs are listed in `identifiers.md`. Clear and one-spell fixtures both passed the live 15.30 boundary test.

Evidence: `live/static/reference`.

## `0xC4` Weapon Proficiency Window

15.30 requires a shaped-perk list after the selected-perk list. Its count byte is mandatory even when zero.

```text
C4
weaponId:u16
experience:u32
selectedCount:u8
  repeat selectedCount:
    level:u8
    index:u8
shapedCount:u8
  repeat shapedCount:
    level:u8
    index:u8
    perkId:u16
    rank:u8
```

Empty state for weapon `0x1234`:

```text
C4 34 12 00 00 00 00 00 00
```

One selected perk `(2,1)` and one shaped perk `(2,1,perkId=0x0042,rank=1)`:

```text
C4 34 12 78 56 34 12 01 02 01 01 02 01 42 00 01
```

Unlike some 15.25 builds, the trailing count must not be build-string gated in 15.30.

Evidence: `static/reference`. The empty fixture is safe for isolated testing; the natural proficiency window still needs live UI coverage.

## `0xD6` Monster Cyclopedia Monsters

15.30 adds `isNew`, duplicates an occurrence-class byte for progressed records and retains the Animus bonus/points fields.

```text
D6
search:string
raceCount:u16
  repeat raceCount:
    raceId:u16
    isNew:u8
    progress:u8
    if progress > 0:
      occurrence:u8
      occurrenceAgain:u8
    animusBonus:u16
animusPoints:u16
```

Safe empty result:

```text
D6 00 00 00 00 00 00
```

One progressed race `22`, with progress `2`, occurrence values `1`, no Animus bonus or points:

```text
D6 00 00 01 00 16 00 00 02 01 01 00 00 00 00
```

The two occurrence bytes are currently written with the same value. Do not omit either one for `progress > 0`.

An older TibiaAPI `MonsterCyclopediaMonsters` class may still read the pre-15.30 record. Use the layout above for 15.30.

Evidence: `static/reference`. The empty fixture has static boundary coverage; a non-empty natural bestiary response remains recommended.

## `0xD7` Monster Cyclopedia Race

### Header and Animus section

```text
D7
raceId:u16
raceClass:string
currentStage:u8
firstUnlock:u16
secondUnlock:u16
killCounter:u32
thirdUnlock:u16
animusBonus:u16
animusPoints:u16
reservedBool:u8
```

For `currentStage == 0`, the 15.30 packet ends here. Do not append stars, occurrence or a zero loot count.

### Stage `>= 1`: overview and loot

```text
stars:u8
occurrence:u8
lootCount:u8
  repeat lootCount:
    objectId:u16
    rarity:u8
    specialEvent:u8
    if objectId > 0:
      name:string
      cumulative:u8
```

### Stage `>= 2`: combat statistics

```text
charmPoints:u16
attackMode:u8
reserved:u8 = 0x00
hitpoints:u32
experience:u32
speed:u16
armor:u16
mitigation:double
```

The byte after `attackMode` changed from the legacy `0x02` value to `0x00`.

### Stage `>= 3`: elements and locations

```text
elementCount:u8
  repeat elementCount:
    elementId:u8
    modifier:i16
locationCount:u16
  repeat locationCount:
    location:string
```

Element modifiers are signed in 15.30. A negative modifier must be serialized as two's-complement `i16`, not clamped or cast through an unsigned gameplay percentage.

The 15.30 order differs substantially from older TibiaAPI models. In particular, the first/second unlock values now precede the kill counter, stage zero is shorter, and the current reference writer ends after locations.

Evidence: `static/reference`. This is high-risk for alignment and should be tested at stages 0, 1, 2 and 3 separately.
