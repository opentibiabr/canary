# Multiprotocol runtime profiles

Canary supports multiple Tibia client protocol contracts through runtime
profiles. The goal is to keep the current client behavior intact while allowing
older or extended clients to connect without compile-time `CLIENT_VERSION`
switches or scattered raw version checks.

The profile model separates three concerns:

- Transport framing: how the TCP stream is framed, checksummed, encrypted, and
  optionally compressed before the game payload can be parsed.
- Login layout: how the account login and game login packets are read and how
  the first server challenge is written.
- Protocol payload: how opcodes, message modes, player stats, skills, effects,
  item ids, and other game packets are encoded after the profile is known.

## Core types

`TransportProfile` describes the byte envelope owned by the network layer. It
contains the outer length encoding, encrypted payload layout, inbound/outbound
checksum method, compression layout, crypto header behavior, and whether the
sequence high bit signals compression.

`TransportCodec` applies a `TransportProfile`. `Connection` must use the active
codec for header/body size calculation before `ProtocolGame` receives a packet.
New protocol support must not reintroduce direct rules such as "if a game
protocol exists, multiply the length by 8".

`InitialConnectionBehavior` describes everything needed before the first real
game payload:

- transport profile
- handshake flow
- challenge layout
- expected protocol profile

Hint conflicts compare the complete initial behavior, not only the transport.
Two hints with the same transport but different challenge layout are ambiguous
and must not be guessed.

`ChallengeProfile` controls who speaks first and the exact challenge layout.
The current supported legacy clients still use a server challenge before the
login packet, but that must remain data-driven by profile and confirmed by
capture or fixture before adding new clients.

`ProtocolProfile` is the runtime identity of a client family. It contains the
client version, `ClientWireFamily`, `RSAKeyFamily`, support state, item mapper
policy, initial behavior, optional asset signatures, and protocol feature flags.

`AccountLoginLayout` and `GameLoginLayout` are intentionally separate. The
account login socket builds the character list and can register a session hint;
the game socket enters the world and validates the hint. Their packet layouts
do not always evolve together.

## Detection flow

There is one account login port. World login can use separate configured game
ports for the current profile, 11.00, and 8.60 because the first game-socket
transport cannot always be selected safely without the account-login hint.
When `legacy1100GameProtocolPort` or `legacy860GameProtocolPort` is `0`, Canary
auto-selects the next available ports after `gameProtocolPort` while avoiding
the login and status ports. Docker quickstart uses explicit legacy ports so the
host mappings stay stable:

- `CANARY_GAME_PORT=7172`
- `CANARY_STATUS_PORT=7173`
- `CANARY_LEGACY_1100_GAME_PORT=7174`
- `CANARY_LEGACY_860_GAME_PORT=7175`

1. The account login flow resolves an `AccountLoginLayout` from the client
   version and, when needed, client asset signatures.
2. After a successful account login, `ProtocolSessionHintStore` registers a
   hint using the remote IP, profile id, session key, and allowed character
   names.
3. The game socket starts without assuming the modern transport.
4. Before the first outbound challenge or body read, the game protocol claims a
   fresh hint by IP.
5. Claiming a hint does not consume it. The lease only selects an initial
   behavior if all fresh hints for that IP agree on transport, handshake flow,
   and challenge layout.
6. The game login payload validates the claimed hint against session key,
   character name, client version, TTL, and profile policy.
7. Only after validation is the profile finalized. Reusable legacy hints can be
   kept alive to support reconnect behavior; modern hints expire quickly.

If no safe hint exists, the connection uses the current modern behavior only
when the current profile is allowed by policy. Policy can reject a detected
profile, but it must not select legacy framing just because no hint exists.

## Active profiles

### Current

`ProtocolProfileId::Current` is the normal supported Canary client version.

- Transport: `CurrentModern`
- Outer length: modern block count
- Encrypted payload: modern padding byte
- Checksum: sequence checksum
- Compression: official sequence high-bit compression
- Challenge: current login challenge
- Features: current payload, login speed formula, modern login side systems,
  and resource balance packets

This profile is the default only when no safer legacy hint was found and the
current profile is allowed.

### Tibia1100

`ProtocolProfileId::Tibia1100` is the old protocol path used by compatible
11.00 clients.

- Transport: `LegacyRawWithLoginHeader`
- Outer length: raw body length
- Encrypted payload: legacy inner length
- Checksum: Adler32
- Compression: none
- Challenge: `Tibia1100LoginChallenge`
- Account login response transport: `LegacyClassic`
- Features: old protocol compatibility, legacy payload, and login speed formula

This profile is not a modern transport profile. It must not inherit the modern
block-count framing, sequence checksum, resource balance packet, or current
login side systems.

Known Tibia1100 payload rules:

- `0x17` login success uses the legacy bootstrap shape with the speed formula
  and classic tail fields.
- `0xA0` player stats uses the classic old-protocol layout.
- `0xA1` skills uses the 11.00 layout: seven basic skills as
  `uint16 level`, `uint16 base`, `uint8 percent`, then additional skills as
  `uint16 level`, `uint16 base`.
- `0xEE` resource balance is disabled unless the profile has
  `ResourceBalancePackets`.
- Weapon proficiency, item prices, prey, task hunting, and forging bootstrap
  packets require `ModernLoginSideSystems`.

### Cipsoft860Vanilla

`ProtocolProfileId::Cipsoft860Vanilla` is the classic 8.60 CipSoft wire layout
using OpenTibia RSA for direct server connections.

"CipSoft" here means packet and asset layout family. It does not mean an
unmodified official CipSoft client can connect to Canary, because Canary does
not have the official CipSoft private RSA key.

- Transport: `LegacyClassic`
- Challenge: `Cipsoft860LoginChallenge`
- Account login layout: legacy character list, no session key
- Game login authentication: account/password
- Item mapper policy: required before world enter
- Features: old protocol compatibility, legacy payload, item mapper required,
  inline bug-report flag

The legacy character list encodes the world address as a 32-bit IPv4 number.
Set `ip` or `CANARY_SERVER_IP` to a numeric IPv4 address reachable by the
client. Hostnames, `auto`, and IPv6 addresses cannot be represented in this
packet and are rejected before the character list is sent.

This profile is a classic wire-layout profile, not a promise that an
unmodified vanilla asset set can render the modern Canary world. The supported
8.60 deployment path uses an extended asset package whose item ids match the
current server item ids, so map, inventory, container, trade, and shop payloads
can keep using the same item ids as the current profile. A truly vanilla 8.60
asset set still requires an item mapper or an explicit world-entry block before
item-dependent packets are sent.

### Cipsoft860ExtendedAssets

`ProtocolProfileId::Cipsoft860ExtendedAssets` keeps the 8.60 CipSoft wire
layout but allows an extended asset package.

- Transport and challenge match `Cipsoft860Vanilla`.
- Extended assets keep item ids aligned with the current profile; a mapper is
  only required for deployments that intentionally use a different asset id
  table.
- Runtime metadata reflects that contract: the profile does not advertise
  `RequiresItemMapper` and does not require a mapper before world entry.
- Extended sprite files are enabled.

### Cipsoft860CanaryExtended

`ProtocolProfileId::Cipsoft860CanaryExtended` is the Canary-controlled extended
8.60 client contract.

- Transport and challenge match `Cipsoft860Vanilla`.
- Extended assets keep item ids aligned with the current profile; a mapper is
  only required for deployments that intentionally use a different asset id
  table.
- Runtime metadata reflects that contract: the profile does not advertise
  `RequiresItemMapper` and does not require a mapper before world entry.
- Extended sprite files and 16-bit magic effects are enabled.
- Asset signatures select this profile automatically when they match a known
  Canary extended package.

The corresponding 8.60 `.dat` must stay parseable by the classic client data
reader. Do not write modern attributes such as the modern `Clothes` attribute
into an 8.60 `.dat`; colorized outfits are handled by the classic outfit
layout and the outfit colors sent in protocol packets. Extended sprite ids are
a separate client extension and do not require modern `.dat` attributes.

### OTCv8Extended860

`ProtocolProfileId::OTCv8Extended860` is reserved for an OTCv8-specific 8.60
contract. It is blocked until the exact transport, challenge, and payload
fixtures are available.

OTC is useful as an implementation reference, but it is not the final
specification for CipSoft client behavior.

## Adding a new client profile

Add new clients by extending the profile model, not by adding compile-time
branches or broad raw version checks.

1. Capture the account login and game login bytes from the target client.
2. Confirm the transport envelope before parsing payload fields.
3. Add a new `TransportProfileId` only if the length, checksum, encryption, or
   compression contract differs from existing profiles.
4. Add a `ChallengeLayout` only if the first server challenge bytes differ from
   existing layouts.
5. Add a `ProtocolProfileId` and `ProtocolProfile` with the correct
   `ClientWireFamily`, `RSAKeyFamily`, support state, item mapper policy,
   initial behavior, features, and optional asset signatures.
6. Add or reuse `AccountLoginLayout` and `GameLoginLayout`.
7. Register account-login hints after successful account authentication.
8. Validate game-login hints before finalizing the profile.
9. Gate payload differences with `ProtocolFeature` or explicit profile helpers.
   Prefer translation at the protocol boundary for message modes, effects, ids,
   and legacy-only fields.
10. Add an item mapper or block world entry before sending map, inventory,
    containers, outfits, effects, or other item-dependent packets.

The expected failure mode for an unsupported or incomplete profile is a clear
disconnect before sending incompatible game payloads. Do not rely on the client
debug window as part of normal validation.

## Validation checklist

For every new profile or transport change:

- Cold account login returns the character list.
- Game login works from a fresh client process.
- Re-login to a character already online does not desynchronize the transport.
- Walking, turning, auto-walk, combat, death/loot, skill window, inventory,
  containers, text messages, magic effects, and resource updates do not emit
  unsupported packet types.
- A wrong or expired hint does not consume another character's hint.
- Multiple hints from the same IP only select an initial behavior when all
  candidates share the same transport, handshake flow, and challenge layout.
- The current profile still logs in and keeps byte-compatible modern framing.

For C++ validation on Windows, use the existing preset workflow from the
repository root:

```bat
cmake --preset windows-release
cmake --build --preset windows-release --target canary
```

If the preset is already configured, the build command alone is usually enough.

## Common crash clues

These symptoms usually mean a packet layout is still leaking from the wrong
profile:

- `unknown packet type during game` immediately after login: a bootstrap packet
  is unsupported by that client or a previous packet wrote too many bytes.
- `unknown packet type` after `0xA1`: the skill layout is misaligned.
- `0xEE` in a legacy client crash report: resource balance was sent without
  `ResourceBalancePackets`.
- `packet size does not fit to symmetric encryption`: the transport codec or
  account/game socket response transport does not match the client flow.
- `Cannot open Tibia.dat`: the asset export is not parseable by that client
  family. For 8.60-style clients, keep the classic `.dat` attribute table and
  use explicit client extensions only for supported limits such as sprite ids.
