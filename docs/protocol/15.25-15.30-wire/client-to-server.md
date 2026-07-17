# Client-to-server bytes

This document contains the C2S application payloads that change for 15.30. The opcode is included in every layout and example.

## `0xA0` Set Tactics

15.30 removes `fightMode` from this packet. The server should treat the character as using the single remaining attack stance supported by the client.

### 15.30 layout

| Field | Type | Notes |
|---|---|---|
| opcode | `u8` | `0xA0` |
| chaseMode | `u8` | `0` stand, `1` chase |
| secureMode | `u8` | client secure-mode boolean |
| pvpMode | `u8` | PvP mode; consume even if the engine ignores it |

Example, stand + secure + dove:

```text
A0 00 01 00
```

### Difference from 15.25

```text
15.25: A0 fightMode:u8 chaseMode:u8 secureMode:u8
15.30: A0              chaseMode:u8 secureMode:u8 pvpMode:u8
```

The length remains three payload bytes after the opcode, which can hide a wrong parser: a legacy implementation may remain byte-aligned while assigning every value to the wrong field.

Evidence: `static/reference`. A natural C2S capture is still recommended even though the matching S2C tactics packet passed live boundary validation.

## `0xB3` Weapon Proficiency Command

15.30 completes the shaped-perk command family. `command 0x01` is the only command without a weapon ID.

### Common prefix

| Field | Type | Condition |
|---|---|---|
| opcode | `u8` | always `0xB3` |
| command | `u8` | always |
| weaponId | `u16` | commands `0x00`, `0x02` through `0x09` |

### Commands

| Command | Name | Fields after common prefix |
|---:|---|---|
| `0x00` | get proficiency | none |
| `0x01` | get all proficiencies | no `weaponId`; no additional fields |
| `0x02` | reset proficiency | none |
| `0x03` | pick perks | `count:u8`, then `count` records `{level:u8, index:u8}` |
| `0x04` | shape perk | `{level:u8, index:u8}` |
| `0x05` | refine shaped perk | `{level:u8, index:u8}` |
| `0x06` | maximize shaped perk | `{level:u8, index:u8}` |
| `0x07` | reshape shaped perk | `{level:u8, index:u8}` |
| `0x08` | select reshape option | `{level:u8, index:u8}`, then `selectedOffer:u8` |
| `0x09` | clear shaped perk | `{level:u8, index:u8}` |

`level` and `index` identify a position in the proficiency tree. They are not a `perkId`.

### Examples

Get all:

```text
B3 01
```

Get weapon `0x1234`:

```text
B3 00 34 12
```

Pick two perks for weapon `0x1234`: `(level=1,index=0)` and `(level=2,index=1)`:

```text
B3 03 34 12 02 01 00 02 01
```

Shape `(level=1,index=0)`:

```text
B3 04 34 12 01 00
```

Select reshape offer `2` for `(level=1,index=0)`:

```text
B3 08 34 12 01 00 02
```

### Parser requirements

- Reject unknown commands instead of leaving unread bytes in the message.
- Require `weaponId` before reading command-specific fields, except for `0x01`.
- Check `count * 2` bytes before reading perk selections.
- Require two target bytes for `0x04`-`0x07` and `0x09`.
- Require three target/offer bytes for `0x08`.
- Wire parsing and gameplay validation are separate concerns. Parsing the packet does not authorize a reshape outside a protection zone or without the required currency.

Evidence: `static/reference`. The field layout matches the 15.30 decoder and TibiaAPI command model.

## Carried C2S packets

The following are not structural 15.30 deltas, but they are required by the same UI families:

- `0x5F` Task Board actions;
- `0x96` Talk optional spell target tail;
- `0xBA` Soul Seals monster selection;
- `0xC2` Boss difficulty selection;
- `0xED` resource balance request.

Their layouts are documented in `15.25-foundation.md` so they are not confused with newly changed 15.30 packets.
