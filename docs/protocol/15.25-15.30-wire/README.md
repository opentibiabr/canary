# Tibia 15.25 to 15.30 wire migration package

Private technical hand-off for migrating a Tibia 15.25 protocol implementation to Tibia 15.30. This package describes application-level packet bytes only. It is intentionally engine-independent so the layouts can be mapped to a custom TFS fork, Canary, XML/Lua systems, or another server architecture.

## Scope

Included:

- client-to-server and server-to-client packet deltas introduced or changed for 15.30;
- relevant 15.25 packet families that 15.30 continues to use;
- exact field order, integer width, conditional sections and repeated records;
- safe example payloads in hexadecimal;
- new wire-visible identifiers used by vocation balance features;
- confidence and validation status for every non-trivial layout;
- a machine-readable companion manifest in `wire-manifest.json`.

Not included:

- vocation formulas, spell damage, cooldowns or gameplay rules;
- monster scripts, maps, quests or NPC content;
- item/proficiency balance data such as `proficiencies.json`;
- client assets or a complete engine backport;
- unchanged legacy packets that are byte-identical to 15.25.

The absence of gameplay data is deliberate. This delivery is the protocol-bytes milestone only.

## Transport boundary

There is no identified 15.30 transport-envelope change relative to 15.25. Both use the same modern official transport characteristics:

- modern outer block-length encoding;
- sequence checksum in both directions;
- XTEA crypto header and modern padding byte;
- checksum included in the encoded length;
- official compression, signalled by the high sequence bit.

Every layout and hex example in this package starts at the application opcode. Outer length, sequence/checksum, compression, XTEA encryption and padding are not included. A 15.25 implementation should keep its existing transport wrapper and replace only the affected application payloads.

## Encoding conventions

| Notation | Encoding |
|---|---|
| `u8`, `i8` | one byte |
| `u16`, `i16` | two-byte little-endian integer |
| `u32`, `i32` | four-byte little-endian integer |
| `u64`, `i64` | eight-byte little-endian integer |
| `double` | IEEE-754 binary64, little-endian |
| `bool` | `u8`, normally `0x00` or `0x01` |
| `string` | `length:u16` followed by exactly `length` bytes |
| `position` | `x:u16, y:u16, z:u8` |
| `count + records[]` | count first, followed immediately by that many records |

Hex examples use spaces between bytes. Multi-byte values are already shown in wire order. For example, `0x0112` is encoded as `12 01`.

## Evidence levels

| Level | Meaning |
|---|---|
| `live` | Sent to the 15.30 client and followed by a valid packet boundary during in-game testing. |
| `static` | Recovered from the 15.30 client decoder or a matching TibiaAPI decoder. |
| `reference` | Implemented by the Canary writer or an older private official-protocol reference. |
| `candidate` | The byte boundary is strongly supported, but the semantic meaning or a live capture is incomplete. |
| `unknown` | Do not emit non-empty data without additional capture or decoder evidence. |

Static evidence can prove width and order without proving the correct gameplay value. A parser should still validate counts and remaining bytes.

## 15.30 delta index

| Direction | Opcode/location | Change from 15.25 | Evidence |
|---|---:|---|---|
| C2S | `0xA0` | fight mode removed; payload is now chase, secure and PvP | `static/reference` |
| C2S | `0xB3` | shaped-proficiency commands `0x04` through `0x09` | `static/reference` |
| S2C | `0x75` | new bounty, weekly-task and spell event selectors | `live/static` |
| S2C | `0x86` | 13-field forge configuration tail replaced by one byte | `static/reference` |
| S2C | creature instance | primary icon records gain a trailing byte; second icon-list count added | `static/reference` |
| S2C | `0x8B` | icon record gains a trailing byte; task icon IDs added | `live/static/reference` |
| S2C | `0xA3` | second creature ID added | `candidate/static/reference` |
| S2C | `0xA7` | fight mode removed; payload is now chase, secure and PvP | `live/static/reference` |
| S2C | `0xBB` | shaped-perk reshape offers | `static/reference` |
| S2C | `0xC1` | active vocation stance spell list used by the rebalance UI | `live/static/reference` |
| S2C | `0xC4` | mandatory shaped-perk list follows selected perks | `static/reference` |
| S2C | `0xD6` | reworked monster list record | `static/reference` |
| S2C | `0xD7` | reordered Animus/bestiary data and signed element values | `static/reference` |
| Identifier | resource `0x49` | Lunar Ascension Orb identifier discovered; value width not captured | `candidate` |

## Recommended migration order

1. Keep the 15.25 transport and login framing.
2. Change tactics in both directions (`C2S 0xA0`, `S2C 0xA7`) before logging in.
3. Update embedded creature icons before sending map or creature data.
4. Update `0x86`, `0xC4`, `0xD6` and `0xD7` before opening their corresponding windows.
5. Add the new standalone packets and event selectors.
6. Replay the safe fixtures and boundary tests in `validation.md`.

An old-length packet in a concatenated server message can make the client interpret the next payload byte as an opcode. Symptoms include `Unknown Gameserver Message`, EOF/overrun errors, a frozen UI or a client crash. Debug from the first mismatched packet, not from the final opcode reported by the client.

## Package map

- `client-to-server.md`: packets sent by the 15.30 client.
- `server-to-client.md`: packets written to the 15.30 client.
- `15.25-foundation.md`: carried packet families needed by the new UI.
- `identifiers.md`: icons, events, effects, missiles and resources.
- `validation.md`: safe test order, expected results, known gaps and support boundary.
- `task-board-reference.md`: provenance, integration requirements and limitations of the separately packaged Task Board reference module.
- `wire-manifest.json`: structured representation for Python, AI-assisted mapping or code generation.
