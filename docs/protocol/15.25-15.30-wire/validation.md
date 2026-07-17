# Validation, rollout and support

## Completed validation

The following standalone payloads were sent to a Tibia 15.30 client in game. A normal text boundary packet was decoded immediately afterward, and movement/chat/container actions remained usable:

- `S2C 0xA7` compact tactics;
- `S2C 0xC1` empty active-stance list;
- `S2C 0xC1` Harmony active-stance list;
- `S2C 0x8B` primary creature task icons;
- `S2C 0x8B` primary creature icon clear;
- `S2C 0x75` bounty task event;
- `S2C 0x75` weekly task event;
- `S2C 0xDD` minimap marker reference packet.

The structured probe serializer also validated the expected byte counts for the supplied fixtures. No client EOF, unknown gameserver opcode or packet-overrun error was observed for the live-tested set.

An earlier apparent client freeze was traced to a server dispatcher stall during rapid probe execution, not to a confirmed client parser failure. Probes should still be sent one at a time.

## Required integration test order

Use a disposable test character and send only one candidate packet per session until its boundary is known.

1. Log in and perform movement, speech and container-open baselines.
2. Verify `0xA7` and a natural C2S `0xA0` tactics change.
3. Spawn or reveal a creature to validate the embedded icon counts in a full creature instance.
4. Send `0x8B` clear, one icon, then two task icons.
5. Send `0xC1` clear, Harmony, Justice and Sustain separately.
6. Open forge to validate a natural non-empty `0x86`.
7. Open proficiency with zero selected/shaped perks, then one selected and one shaped perk.
8. Trigger reshape and validate empty, one-offer and multiple-offer `0xBB` responses.
9. Open bestiary search with zero, one locked and one progressed race (`0xD6`).
10. Open race details at stages 0, 1, 2 and 3 (`0xD7`).
11. Test Task Board bounty and weekly views using natural data.
12. Test boss difficulty actions `0`, `1` and `2`.
13. Capture resource `0x49` before choosing a numeric width.

After each step:

- move one tile;
- say a short message;
- open or refresh a container;
- inspect client logs for EOF, overrun, unknown opcode or crash payload;
- retain the last valid packet and the first invalid packet.

## Safe fixtures

These fixtures contain no variable-length records and are suitable for initial boundary checks:

| Purpose | Plain application bytes |
|---|---|
| tactics | `A7 00 01 00` |
| clear primary creature icons | `8B 04 03 02 01 0E 00` |
| clear target candidate | `A3 00 00 00 00 00 00 00 00` |
| clear active stance spells | `C1 02 00` |
| empty proficiency | `C4 34 12 00 00 00 00 00 00` |
| empty reshape offers | `BB 34 12 00 00 00` |
| empty forge base data | `86 00 00 00 00 00` |
| empty bestiary result | `D6 00 00 00 00 00 00` |
| close boss difficulty | `2F 01` |

Replace fixture IDs with real IDs where the client window requires a known object. The table shows application payloads only.

## Known gaps

| Area | Current status | Required evidence |
|---|---|---|
| `0xA3` second creature ID | width/order static; semantic role incomplete | natural 15.30 target update capture |
| embedded secondary icon list | mandatory zero count known; record unknown | non-empty client/server capture or decoder branch |
| `0x8B` update type `0x0F` | empty prefix known; record unknown | non-empty capture |
| `0x49` resource value | resource ID known; width unknown | paired `0xED`/`0xEE` capture |
| non-empty `0xBB` | record shape static; economy/UI flow untested | natural reshape capture |
| Task Board non-empty views | 15.23+ reference layout | natural 15.30 bounty/weekly/shop captures |
| boss difficulty | static layout | live actions `0`, `1`, `2` |
| non-empty `0xD6` and staged `0xD7` | static/reference | natural bestiary captures at all stages |

Unknown sections are not placeholders for arbitrary zero-filled records. Only the explicitly documented empty count is safe.

## Debugging procedure

When the client reports an opcode error or crashes:

1. Decrypt/decompress the server block and isolate the plaintext application stream.
2. Locate the last fully decoded packet before the reported opcode.
3. Recalculate every conditional count and string length in that packet.
4. Compare the unread tail with the next expected opcode.
5. Reproduce with a single record, then zero records, before increasing the count.
6. Check signedness (`i16` in `0xD7`) and mandatory zero counts (`0xC4`, embedded icons).

The opcode named by the client is often a payload byte from the preceding malformed packet.

## Protocol support included with this hand-off

Protocol stabilization covers investigation and correction of the documented 15.25/15.30 wire contract when integration produces:

- invalid packet layouts or lengths;
- field-alignment errors;
- EOF/overrun parser errors;
- unknown gameserver messages caused by these packets;
- login/session protocol regressions attributable to the documented delta;
- client crashes caused by the documented packet writers.

If a private engine changes the surrounding packet order or owns a different custom payload, support includes identifying the divergence. Implementing unrelated private-engine systems or gameplay logic remains a separate task.
