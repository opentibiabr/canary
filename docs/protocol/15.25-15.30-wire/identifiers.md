# 15.30 wire-visible identifiers

This file lists numeric values that must agree with the 15.30 client. It does not define gameplay formulas.

## Creature task icons

Used in S2C `0x8B`, update type `0x0E`.

| Icon ID | Category | Client label | Record tail |
|---:|---:|---|---:|
| `8` | `1` | Weekly Task Monster | `reserved:u8 = 0` |
| `9` | `1` | Bounty Task Monster | `reserved:u8 = 0` |

The two-icon fixture passed client boundary validation. The visual labels come from the 15.30 static decoder; retain a screenshot/visual check in final QA.

## Vocation stance spell IDs

Used in S2C `0xC1`, `dataType 0x02`.

| Spell ID | Name |
|---:|---|
| `274` | Harmony |
| `275` | Justice |
| `276` | Sustain |

These are UI identifiers. Activation conditions and effects are outside this bytes-only package.

## Game Event selectors

Used in S2C `0x75`.

| ID | Name | Payload |
|---:|---|---|
| `0x04` | level | `level:u16` |
| `0x0B` | bounty task finished | `raceId:u16` |
| `0x0C` | weekly task specific creature finished | `raceId:u16` |
| `0x0D` | spell unlocked | `spellId:u32` |
| `0x0E` | leader monster killed | `raceId:u16, value:u32` |
| `0x0F` | subarea unlocked | `subareaId:u16` |
| `0x10` | area unlocked | `areaId:u16` |

Selectors `0x0B` and `0x0C` have live boundary coverage. The final three remain static-only.

## Magic effect IDs

Used as `effectId:u16` inside graphical-effects command `0x03`.

| ID | Name |
|---:|---|
| `318` | Bash |
| `319` | Divine Barrage |
| `320` | Ethereal Barrage |
| `321` | Death Echo |
| `324` | Forked Glacier |
| `325` | Forked Thorns |
| `326` | Thousand Fist Blows |

IDs `322` and `323` are intentionally not assigned by this package.

## Distance effect IDs

Used as `effectId:u16` inside graphical-effects command `0x04`.

| ID | Name |
|---:|---|
| `64` | Shatterstorm Arrow |
| `65` | Firestorm Arrow |
| `66` | Terrastorm Arrow |
| `67` | Froststorm Arrow |
| `68` | Thunderstorm Arrow |

## Resource IDs

| ID | Name | Known response width |
|---:|---|---|
| `0x49` | Lunar Ascension Orb | `unknown` |
| `0x50` | Unspent Skill Points | `u32` |
| `0x56` | Bounty Points | `u32` |
| `0x57` | Soulseals | `u32` |

The `0x49` identifier is confirmed in the 15.30 resource enum, but no official request/response capture proves whether `0xEE` carries it as `u32` or `u64`. Do not generate a non-zero `0x49` response from this specification. Capture `C2S 0xED 0x49` and the corresponding `S2C 0xEE` response first.

## Special status byte

The byte after the `u64` normal status mask in S2C `0xA2` accepts values `0..9` in the current client/reference. The reference names them `None` and special taint states `1..9`. They are not the Weekly/Bounty creature icons above.
