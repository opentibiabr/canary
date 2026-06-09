# Livestream System Contract

This document describes the expected behavior and maintenance contract for the
Canary livestream system. Treat this as protocol documentation: small looking
changes can break the Cip client, duplicate packets, or let a viewer mutate the
real caster state.

## Goals

- Let a real online player broadcast their current gameplay to read-only
  viewers.
- Let viewers log in through the normal game protocol by using the
  `@livestream` account descriptor.
- Keep viewers protocol-correct for client 15 while preventing them from
  walking, fighting, opening new game actions, or mutating the caster.
- Keep the implementation centered on `ProtocolGame` and `LivestreamManager`
  without a proxy class that duplicates the whole `ProtocolGame` send API.

## Main Entry Points

- `src/creatures/players/livestream/livestream.hpp`
- `src/creatures/players/livestream/livestream.cpp`
- `src/server/network/protocol/protocolgame.hpp`
- `src/server/network/protocol/protocolgame.cpp`
- `src/server/network/protocol/protocollogin.cpp`
- `data/scripts/talkactions/player/livestream_system.lua`
- `src/lua/functions/creatures/player/player_functions.cpp`
- `config.lua.dist`
- `data-otservbr-global/migrations/58.lua`
- `data-otservbr-global/schema.sql`

## External Contract

### Login

Livestream character list requests use the special account descriptor
`@livestream`. The login response must keep the session key in this format:

```text
@livestream
<password>
```

The web login endpoint used by client 15 must generate the same session key.
Changing the string format breaks the game server side `ProtocolLogin` and
`ProtocolGame` flow.

### Caster Commands

The `!livestream` talkaction is the player-facing control plane. It must keep
support for:

- `!livestream on`
- `!livestream off`
- `!livestream desc, ...`
- `!livestream password, ...`
- `!livestream kick, ...`
- `!livestream ban, ...`
- `!livestream unban, ...`
- `!livestream bans`
- `!livestream mute, ...`
- `!livestream unmute, ...`
- `!livestream mutes`
- `!livestream show`
- `!livestream status`

The Lua-facing contract is also part of the feature:

- `player:getLivestreamViewersCount()`
- `player:getLivestreamViewers()`
- `player:setLivestreamViewers(data)`
- `player:isLivestreamViewer()`

### Persistence

Persistent state is split intentionally:

- Player KV under `livestream-system` stores stream password, description,
  record, and experience bonus state.
- `active_livestream_casters` stores the active login-list state for external
  login services.
- Runtime sessions in `LivestreamManager` store viewers, bans, mutes, viewer
  names, IPs, and active broadcast metadata.

The database table must be provided by migrations and schema. Runtime code may
check whether the table exists to avoid noisy failures, but the normal fix for a
missing table is to run migrations or update the schema, not to hide the missing
database contract.

## Internal Contract

### Player::client Must Remain ProtocolGame

Do not replace `Player::client` with a livestream proxy type. The player owns a
real `ProtocolGame_ptr`. A proxy that imitates `ProtocolGame` duplicates a large
send surface and makes every future protocol method a livestream maintenance
hazard.

The current design keeps:

- One real `ProtocolGame` for the caster.
- One real `ProtocolGame` for each viewer.
- `LivestreamManager` as the session and fanout coordinator.

### Viewer Login Must Use Full Login Bootstrap

The viewer is not a normal player, but the Cip client still expects the normal
login bootstrap packet family. A partial or hand-rolled bootstrap can leave the
client missing creature/protobuf/stat state and produce symptoms such as:

- the viewer entering with health `0`;
- client debug logs like `updateOrCreateCreatureFromProtobuf: no creature`;
- disconnects shortly after entering the game.

The expected implementation is:

1. `ProtocolGame::castViewerLogin` finds the real caster.
2. `m_isLivestreamViewer` is set on the viewer protocol.
3. The viewer protocol temporarily uses the caster as `ProtocolGame::player`.
4. `sendLivestreamViewerAppear` temporarily assigns `foundPlayer->client` to the
   viewer protocol only while calling `sendAddCreature(..., isLogin = true)`.
5. `foundPlayer->client` is restored immediately after the bootstrap call.
6. The viewer is added to `LivestreamManager`.

The temporary client swap looks risky, but it is deliberate. Many existing login
packet builders write through `player->client`; the swap lets those builders
emit the full login bootstrap to the viewer without permanently stealing the
caster client.

Never leave `foundPlayer->client` pointing at a viewer after bootstrap. Never
replace this with a minimal custom bootstrap unless the replacement is proven to
be protocol-equivalent on client 15.

### Viewers Are Read-Only

Viewer input must stay behind an explicit allowlist. The current viewer flow
allows:

- logout;
- ping and ping-back;
- livestream channel chat;
- safe resend of already-open containers;
- harmless store/window packets needed by the client.

Everything else must be ignored or answered with cancel feedback. Viewer input
must not call handlers that mutate the caster, such as movement, combat, item
actions, market actions, spell actions, or generic game actions.

`parseUpdateContainer` must not run for viewers. The client uses opcode `0xCA`
for container refresh requests, but that path can mutate real container state.
Viewers may only call `resendLivestreamViewerContainer`, which re-sends a
container that is already open on the caster.

### Rooted Is Required

Do not remove `PlayerIcon::Rooted` from viewer setup. It prevents client 15 from
attempting auto-walk on the viewer session. The icon must be sent:

- after the initial viewer bootstrap;
- after full map refresh packets, because a refresh can reset the client-side
  state.

If a future client changes this behavior, keep the old-client and client-15
paths explicit instead of deleting Rooted globally.

### Fanout Lives At Output Buffer Boundary

Packet forwarding belongs near `ProtocolGame::writeToOutputBuffer`. The owner
protocol should broadcast only when:

- `m_isLivestreamBroadcaster` is true;
- `player` exists;
- `m_isLivestreamViewer` is false.

This flag is a correctness and cost guard. Do not replace it with repeated
session lookups on every packet unless there is a measured reason and equivalent
behavior.

`LivestreamManager::broadcastPacket` must keep an explicit packet allowlist.
Forwarding every packet leaks private data and can desync the viewer. Full map
packets need special handling: refresh the viewer map, then re-send Rooted.

### Chat Must Not Be Duplicated

Livestream chat uses `CHANNEL_LIVESTREAM` and is delivered by
`LivestreamManager::sendChannelMessage`.

Do not forward `CHANNEL_LIVESTREAM` again through generic speak-packet fanout.
Doing both sends the same message twice to viewers.

Private messages must not be forwarded to viewers. Channel and text-message
forwarding must keep the existing filters for privacy and client stability.

### Do Not Leak Private Resources

Viewers watch the caster's world state, but they are not entitled to every
private account/player resource. Keep guards around packets such as resource
balance, store/account state, and private text.

If a packet is needed for protocol correctness during login, it belongs in the
full bootstrap. If it is private runtime state, it should not be forwarded by
generic fanout.

### Viewer Identity And Limits

Viewer sessions are tracked by their viewer protocol and by the viewer IP from
that protocol, not by the caster IP. IP limits, bans, mutes, kick, and viewer
names must operate on the viewer connection.

`livestreamMaximumViewers = 0` means no global viewer limit. Premium limits and
positive global limits are separate config paths and must remain documented in
`config.lua.dist`.

## Maintenance Rules

- Do not introduce a `Livestream` class that pretends to be `ProtocolGame`.
- Do not replace the full viewer bootstrap with a smaller custom packet set
  without proving client 15 compatibility.
- Do not remove Rooted from viewers.
- Do not allow viewer input to reach mutating player action handlers.
- Do not forward livestream channel messages through both explicit channel send
  and generic packet fanout.
- Do not count the caster IP when enforcing viewer IP limits.
- Do not silently change `@livestream` session key formatting.
- Do not move livestream database state into runtime-only memory; external
  login services need `active_livestream_casters`.
- Do not add runtime DDL as the primary schema path. Migrations and
  `schema.sql` are the source of truth.

## Validation Checklist

Run the narrow checks that match the files changed:

```powershell
git diff --check
clang-format --dry-run --Werror <changed C++ files>
stylua --check data/scripts/talkactions/player/livestream_system.lua
cmake --build --preset windows-release --target canary
```

For Linux or CI-only changes, also validate the relevant Linux preset or the
failing GitHub Actions job:

```bash
git diff --check
clang-format --dry-run --Werror <changed C++ files>
stylua --check data/scripts/talkactions/player/livestream_system.lua
cmake --build --preset linux-release --target canary
```

Runtime validation should cover:

- a real caster logs in and runs `!livestream on`;
- the login list exposes the caster through `@livestream`;
- a viewer can enter with client 15 without health `0` and without
  `updateOrCreateCreatureFromProtobuf` debug logs;
- the viewer cannot walk, auto-walk, fight, use items, or mutate the caster;
- the viewer receives map updates, creature updates, combat text, and container
  refreshes;
- livestream channel messages appear once, not twice;
- private messages and private account resources are not forwarded;
- caster logout or `!livestream off` disconnects viewers cleanly;
- passwords, bans, mutes, kicks, viewer names, IP limits, and max viewer limits
  still work.

## Review Guidance

Some changes look like cleanup but are protocol regressions. In reviews, ask for
runtime proof before accepting suggestions that:

- remove the temporary `foundPlayer->client` swap during viewer bootstrap;
- replace `sendAddCreature(..., true)` with a manual packet sequence;
- remove `PlayerIcon::Rooted`;
- pass viewer packets through normal `ProtocolGame` handlers;
- remove the `CHANNEL_LIVESTREAM` exception from speak packet fanout;
- move persistence away from `active_livestream_casters` without updating the
  external login contract.

When in doubt, prioritize client 15 runtime behavior over local code neatness.
