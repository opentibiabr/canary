# Expert PvP Porting Plan

This document describes how to port an Expert PvP system into current Canary
without copying an older implementation verbatim. The goal is to define the
behavioral contracts first, then implement the feature in small, testable steps.

## Scope

Expert PvP covers the Tibia hand modes:

- `PVP_MODE_DOVE`
- `PVP_MODE_WHITE_HAND`
- `PVP_MODE_YELLOW_HAND`
- `PVP_MODE_RED_FIST`

The feature affects combat permission, player walkthrough, field behavior,
skulls, protection zone lock, per-viewer field visuals, and protocol payloads.
It must not regress Optional PvP, PvP Enforced, old protocol clients, or the
existing secure mode behavior.

Do not treat the older Shadowborn work as source code to copy. Use it only as
evidence of failure modes and missing contracts.

## Implementation Status

This branch implements the roadmap through persistence: world-type selection,
the `ExpertPvp` and `PlayerPvp` components, hand-mode state, combat permission,
secure-mode defense, body blocking, field context, MW/WG collision and visual
selection, field damage, situation marks, and database persistence.

The stabilization pass also enforces these boundaries:

- combat validation is pure; skull, PZ lock, and situation changes happen only
  on the execution path;
- White Hand includes aggressors against the player's party or guild allies;
- walkthrough uses the blocker's mode;
- MW/WG path probes do not bypass later movement restrictions;
- player summons use their master player's relation;
- global mark refreshes are limited to visible players and reuse one relation
  snapshot.

Protocol support remains profile-specific. Tibia 11.00 has a verified four-byte
fight-mode layout in this branch and can select all hands. The current 15.25
parser has a verified three-byte Set Tactics layout with no separate hand-mode
byte; it therefore keeps Expert controls disabled and normalizes the server mode
to Dove. Do not append a speculative byte to 15.25.

## Public Behavior References

The current behavior contract should prefer public Tibia references over old
porting attempts when they disagree:

- [Tibia combat guide](https://www.tibia.com/gameguides/?section=combat&subtopic=manual)
  and [Tibia interface guide](https://www.tibia.com/gameguides/?section=interface&subtopic=manual)
  describe Expert PvP hand-mode attack and block rules.
- [Magic Wall Rune](https://www.tibia.com/library/?spell=magicwallrune&subtopic=spells)
  documents that Open PvP magic walls can appear yellow to characters that are
  not in a PvP situation with the caster.
- [TibiaWiki Combat Controls](https://tibia.fandom.com/wiki/Combat_Controls),
  [Magic Wall Object](https://tibia.fandom.com/wiki/Magic_Wall_%28Object%29),
  [TibiaWiki BR PvP Mode](https://www.tibiawiki.com.br/wiki/PvP_Mode),
  [TibiaGoals hand-mode guide](https://www.tibiagoals.com/2020/10/the-use-of-pvp-hand-modes-hand-mode-and.html),
  [TibiaDuality Open PvP](https://tibiaduality.com/pvp-openpvp), and
  [TibiaQA PvP rules discussion](https://www.tibiaqa.com/34100/how-to-know-the-exact-frag-%25-ill-get-from-killing-a-player)
  are secondary evidence for hand modes, PvP situations, and MW/WG behavior.

## Baseline At The Start Of The Port

The Canary baseline used when this work started had partial building blocks:

- `src/creatures/creatures_definitions.hpp` defines `PvpMode_t`.
- `src/server/network/protocol/protocolgame.cpp` sends a default Dove byte in
  `sendFightModes()` for profiles without `ProtocolFeature::CurrentPayload`.
- `src/server/network/protocol/protocolgame.cpp` currently ignores the client
  PvP mode byte in `parseFightModes()`.
- `src/server/network/protocol/protocolgame.cpp` currently writes a hard-coded
  `0x00` expert-mode login byte for newer clients. Confirm the client-side
  meaning before changing it; recovered comments disagreed on enabled versus
  disabled wording.
- `src/items/tile.cpp` currently removes `ITEM_MAGICWALL_SAFE` and
  `ITEM_WILDGROWTH_SAFE` when a player walks through them.
- `src/creatures/combat/combat.cpp` maps magic wall and wild growth to safe
  variants only for Optional PvP or no-PvP zones.
- `src/creatures/combat/combat.cpp` currently calls `addInFightTicks()` when a
  player casts MW/WG outside no-PvP contexts. That conflicts with the delayed
  aggression contract if MW/WG cast alone should not create fight state.
- `data/scripts/runes/magic_wall.lua` and
  `data/scripts/runes/wild_growth.lua` create fields but do not record a stable
  player GUID owner.
- `src/creatures/players/player.cpp` has `canWalkthroughEx()`, but its current
  contract is Optional PvP, protection-zone, and low-level walkthrough only.
- `Game::playerSetFightModes()` currently receives fight, chase, and secure
  modes only. It does not receive or store a PvP hand mode.
- No current player persistence path for PvP hand mode was found. A commented
  Lua helper in `data/modules/lib/modules.lua` mentions `getPvpMode()`, but the
  server-side API is not implemented.

These pieces are not a complete Expert PvP system.

Implementation gaps to close deliberately:

- Define the feature gate and world-type policy before any broad behavior change.
- Add a real `Player` PvP mode state, default, setter clamp, and optional
  persistence contract.
- Extend the fight-mode packet path without breaking packet length for every
  supported client profile.
- Replace runtime owner-id assumptions for field ownership with a stable player
  GUID field context.
- Split MW/WG cast, collision, damage, visual, and side-effect decisions so one
  fix cannot accidentally change all of them.
- Make `Player::canWalkthrough()`, `Player::canWalkthroughEx()`, pathfinding,
  and tile movement agree on the same Expert PvP relation result.
- Keep Optional PvP safe-field removal working, but prevent Expert PvP
  safe-looking MW/WG from being removed on pass-through.

## Recovered Shadowborn Context

The old Shadowborn repository was not recovered as a usable Git checkout. The
available evidence came from editor and chat history snapshots. Treat this
section as historical context, not as authoritative code.

Recovered Shadowborn work touched these areas:

- `config.lua.dist` for world-type or feature-gate decisions.
- `src/creatures/combat/combat.cpp` for field creation, pz-lock, and combat
  side effects.
- `src/items/tile.cpp` for player and MW/WG pass-or-block decisions.
- `src/server/network/protocol/protocolgame.cpp` and
  `src/server/network/protocol/protocolgame.hpp` for fight modes, Expert Mode
  UI flags, field visuals, and creature square packets.
- `src/creatures/players/player.hpp` and `src/creatures/players/player.cpp`
  for PvP mode state, skull visibility, and walkthrough decisions.
- `src/game/game.hpp` and `src/game/game.cpp` for spectator updates.
- `src/io/functions/iologindata_load_player.cpp` and
  `src/io/functions/iologindata_save_player.cpp` for persistence attempts.
- `data/scripts/runes/magic_wall.lua` and
  `data/scripts/runes/wild_growth.lua` for field owner metadata.

Recovered Shadowborn notes and observed failures:

- The desired world naming was Open PvP as Expert Mode, Retro Open PvP as
  current/simple PvP, Optional PvP as no-PvP, and Hardcore PvP as forced
  aggressive mode. Current Canary does not have the same enum names.
- Older code used names such as `WORLDTYPE_OPEN` and `WORLDTYPE_OPEN_RETRO`;
  current Canary uses `WORLD_TYPE_PVP`, `WORLD_TYPE_NO_PVP`, and
  `WORLD_TYPE_PVP_ENFORCED`.
- A Magic Wall cast in Dove mode incorrectly appeared blue to both players and
  blocked both. Correct behavior is viewer-relative: the caster sees a blocking
  wall, neutral non-owners see a safe/yellow wall, and active PvP opponents see
  a blocking wall.
- `item:setOwner(creature)` caused owner confusion because the runtime creature
  id is not the same contract as a stable player GUID. The recovered fix stored
  the caster player's GUID and normalized summons to their master player.
- Several old attempts put large blocks of Expert PvP logic directly inside
  `Tile::queryAdd()`, `Combat::doCombat()`, and `ProtocolGame` methods. This
  made behavior hard to reason about and produced regressions.
- Some versions called `onAttackedCreature()` before checking existing
  `hasAttacked()` relationships. That can pollute attack state during a failed
  movement attempt and then make later decisions look justified.
- Red Fist behavior oscillated between "owner Red Fist blocks everyone" and
  "only direct attack blocks". Public references support Red Fist as the
  aggressive mode for non-allied body blocking and field pressure, while Dove,
  White Hand, and Yellow Hand narrow blocking to their documented target sets.
- There was an attempt to change creature square packets globally for permanent
  PvP frames. Avoid changing the default `sendCreatureSquare()` packet shape for
  every caller. Add an explicit overload or helper only where Expert PvP needs
  a different square type.
- Old debug logs were very noisy and included state-changing movement paths.
  Any new implementation should keep logs behind useful, low-noise points.

Additional Antigravity history confirmed the same deleted workspace and added
more detailed fix notes:

- Antigravity had implementation walkthroughs for Expert PvP bug fixes,
  especially yellow frame flicker, MW/WG Red Fist blocking, rune aggression on
  cast, and pathfinding regressions.
- One code snapshot stored the caster's PvP mode on created field items through
  a `pvpMode` custom attribute. That is useful evidence for a cast-time field
  contract, but it should be implemented as explicit field context, not as an
  ad-hoc attribute read in multiple places.
- Field damage was changed to consult the stored owner mode before applying the
  field condition. That matters for Dove and White Hand: a field owned by a
  non-aggressive player must not damage unrelated players just because the item
  exists on the tile.
- A later Red Fist fix intentionally removed `addInFightTicks()` from MW/WG
  blocking. The block applied white skull and protection-zone lock to the field
  owner, but did not force an in-fight condition or yellow frame unless there
  was a real attack.
- Owner self-blocking was treated separately: the owner should not walk through
  their own MW/WG, and the movement failure should not trigger unrelated square
  resend behavior.
- Pathfinding had a regression where `TILESTATE_BLOCKPATH` blocked player
  pass-through even when `canWalkthrough()` allowed it. The old fix separated
  real blocking items from creature-derived block-path state.
- The Antigravity history also contained unrelated fixes, such as a gold-pouch
  equipment swap change. Keep those out of this port.

Additional Codex, VS Code, and Copilot recovery added these source facts:

- A Codex CLI session from the old workspace recorded the historical remote as
  `https://github.com/shadowborn-servers/shadow-global.git`, branch
  `shadow-main`, at commit `d5482d9c568b388d52144b0fe00f137477342be4`.
  Treat this as provenance only; do not assume the remote is available or that
  its old code is fit to copy.
- A Codex VS Code session opened the same deleted `canary-ashadow-global`
  workspace, confirming that relevant Codex work happened outside the current
  desktop thread.
- Codex Desktop/App history did not add a separate older Expert PvP server
  implementation beyond the current planning work. The useful old Codex
  evidence came from CLI and VS Code sessions.
- Commit `adaacdb2b9899693272187bd2816a057d897ecd4` was recovered from another
  local repo, but it is a task board, SoulPit, and NPC commit. It is not an
  Expert PvP source.
- VS Code and Copilot editing history recovered granular flags named
  `TOGGLE_EXPERT_PVP`, `EXPERT_PVP_CANWALKTHROUGHOTHERPLAYERS`,
  `EXPERT_PVP_CANWALKTHROUGHMAGICWALLS`, and
  `EXPERT_PVP_DEFAULT_HAND_WHEN_CLIENT_NO_BYTE`. These are useful hints for
  rollout and protocol compatibility, not proof that every flag should survive.
- Old `canAttackPlayerInExpertPvP` code lived on `Player` and mixed hand-mode
  rules, guild/party checks, war checks, skull checks, noisy logs, and fallback
  behavior. One recovered version allowed unknown modes by default; current
  Canary should normalize invalid modes or fail closed before combat is allowed.
- Old Lua rune scripts selected safe or blocking MW/WG item IDs at cast time
  based on owner PvP mode and in-fight state. Use that only as behavioral
  evidence. The current port should not couple shared world item identity to a
  viewer-specific visual decision.
- A debug `reset_pvp.lua` talkaction used `Game.updateCreatureSkull()` to repair
  skull state while testing. If a similar tool is kept, it should be dev-only or
  admin-gated, and any Lua binding should stay narrow.
- A client-side backup showed OTC parsing and storing an Expert PvP mode byte.
  That is useful protocol/UI context only; server behavior still belongs in the
  Canary helper layer.

## Recovered Evidence Summary

The historical evidence came from Codex sessions, editor history, Antigravity
notes, a client-side backup, and an old TibiaDuality-oriented patch. Those
machine-local artifacts are intentionally not indexed in repository
documentation. The behavior conclusions extracted from them are retained in
this plan.

Useful conclusions:

- Keep runtime PvP situations pairwise and keyed by stable player GUID.
- Serialize situation marks per viewer: yellow for a direct participant, orange
  for a party/guild ally's opponent, brown for an unrelated fight, and unmarked
  otherwise.
- Separate player-owned field bystanders from players involved with the owner.
- Capture field owner mode and relation snapshots at cast time.
- Keep player body blocking based on the blocker's hand mode, not merely on
  active situation membership.
- Treat top-stack restrictions, caster-only wild-growth cutting, debug commands,
  and unfair-frag weighting as separate product decisions.

Rejected implementation shapes:

- Do not apply the old patch directly or use its stale world-type names.
- Do not make shared item identity viewer-specific.
- Do not scatter field custom-attribute interpretation across combat, tile, and
  protocol code.
- Do not mix `player_kills.weight`, debug talkactions, or frag sharing into this
  implementation.
- Do not infer packet tails from buffer length or old client code. The official
  15.25 parser confirms a three-byte Set Tactics payload; profiles without a
  verified hand-mode byte must default safely to Dove.

## Using Old Sources Safely

The recovered material is not a single final patch. It is a timeline of attempts,
bugs, and fixes. A future implementation chat must separate old implementation
shape from intended final behavior.

Use this precedence order:

- Current Canary code is the baseline. Do not overwrite current behavior with an
  old Shadowborn patch.
- Local downloaded patches are evidence, not authority. If a patch does not
  apply cleanly or uses stale world-type names, extract the contract and
  reimplement it against current Canary.
- Newer recovered bug-fix notes outrank older implementation dumps when they
  describe the same behavior.
- February 16 Codex work in the current `canary` workspace outranks February 5-6
  initial patches for secure mode byte handling, area spells, and yellow frame
  flicker.
- February 10-11 Antigravity notes outrank the first implementation plan for
  MW/WG visual/collision, Red Fist field side effects, owner self-blocking, and
  pathfinding.
- Old code snapshots are evidence for edge cases and file locations, not code to
  paste. Extract the behavior contract, then reimplement through the new helper
  layer described in this document.

Known stale or risky old choices:

- `WORLD_TYPE_EXPERT` was later superseded by the product decision that Open PvP
  should be Expert Mode, Retro Open PvP should preserve normal Canary PvP, and
  Optional PvP should stay Optional PvP.
- The old toggle/config flag set is useful as rollout evidence, but should not be
  copied wholesale without a product decision.
- Old `Player::canAttackPlayerInExpertPvP` code mixed decision logic into
  `Player`, logged too much, and let unknown modes fall through permissively.
- Old Lua runes selected safe/blocking MW/WG item IDs at cast time. That is
  stale for the desired viewer-relative visual contract.
- Old `Tile::queryAdd()` patches mixed movement, skull, pz-lock, owner fallback,
  spectator guessing, and attack-state mutation in one place.
- Old Red Fist and MW/WG patches changed over time. Prefer the later contract:
  apply skull/pz-lock only to the correct player, avoid forced in-fight/yellow
  frame unless the final product decision says the block is a real attack, and
  do not pollute `hasAttacked()` before the movement decision is final.
- Commit `adaacdb2b9899693272187bd2816a057d897ecd4` is unrelated to Expert PvP.
- The TibiaDuality 2014 patch is especially useful for runtime PvP situations,
  creature marks, bystander field logic, and stack rules, but it is not a final
  implementation shape for current Canary.

When mining an old chat or snapshot, record these facts in the implementation
notes before porting anything:

- Source path, session id, or History folder.
- Timestamp or ordering evidence from `entries.json`.
- The current file or function it appears to affect.
- Whether the source is an initial implementation, a bug report, or a later fix.
- The behavior contract extracted from it.
- The old implementation shape that should be avoided.
- The current Canary code path that must remain unchanged when the feature gate
  is disabled.

Use the Shadowborn evidence to understand edge cases and regressions. Do not
copy its structure.

## Preferred Architecture

Keep the port structured like a player component, similar in spirit to
`src/creatures/players/components/wheel/`. Prefer new code that exposes small
helpers, then call those helpers from existing functions.

Recommended new area:

- `src/creatures/players/components/pvp/expert_pvp.hpp`
- `src/creatures/players/components/pvp/expert_pvp.cpp`
- `src/creatures/players/components/pvp/expert_pvp_definitions.hpp`

Recommended responsibilities:

- `ExpertPvp::isEnabled()` decides whether the feature gate applies.
- `ExpertPvp::modeFromClientByte(player, byte)` parses client input and rejects
  or normalizes unknown values before any behavior decision.
- `ExpertPvp::defaultModeForClient(player, protocolProfile)` returns the
  explicit default hand for clients that do not send the PvP byte.
- `ExpertPvp::normalizeMode(player, requestedMode)` clamps impossible modes such
  as Red Fist for black skull players, if that rule is enabled.
- `ExpertPvp::classifyRelation(viewer, subject)` describes self, party, guild,
  war, direct attacker, direct target, skulled, neutral, and monster/summon
  relation.
- `ExpertPvp::evaluateCombatAction(attacker, target, actionKind)` returns a
  structured result: allowed, starts battle, pz-lock owner, skull owner,
  unjustified risk, and visual relation.
- `ExpertPvp::canWalkThrough(walker, blocker)` returns the player walkthrough
  decision and explains whether it is neutral ghosting or battle blocking.
- `ExpertPvp::evaluateFieldStep(walker, fieldItem)` returns pass/block and side
  effects for MW/WG without mutating attack state first.
- `ExpertPvp::captureFieldContext(caster, fieldItem)` records the stable owner
  GUID, normalizes summons to the master player, and records cast-time PvP mode
  only if that product contract is chosen.
- `ExpertPvp::evaluateFieldDamage(fieldContext, victim)` decides whether field
  damage or conditions can apply to a player target.
- `ExpertPvp::getFieldClientId(viewer, fieldItem)` returns the viewer-specific
  item id for MW/WG serialization.
- `ExpertPvp::isInSituation(player, other)` checks runtime pairwise PvP
  involvement if the product contract adopts a dedicated situation map.
- `ExpertPvp::getSituationMark(subject, viewer)` returns yellow, orange, brown,
  or unmarked creature-mark state for persistent PvP boxes.
- `ExpertPvp::canInitiateFromStack(player, actionKind)` applies the "top player
  in stack" rule for aggressive direct and area actions if that rule is adopted.
- `ExpertPvp::applyBattleSideEffects(result)` is the only place that mutates
  skull, pz-lock, fight ticks, and attacked sets after a result is final.

Recommended internal types:

- `ExpertPvpModeSource`: `ClientByte`, `DefaultForClient`, `StoredPlayerState`,
  `CastTimeFieldContext`, or `LiveOwnerState`.
- `ExpertPvpRelation`: self, party ally, guild ally, war enemy, direct attacker,
  direct target, skulled target, neutral player, monster, player summon, npc, and
  access player.
- `ExpertPvpActionKind`: direct attack, area spell, rune target, field damage,
  field step, player walkthrough, pathfinding probe, and visual serialization.
- `ExpertPvpSituation`: owner GUID, other GUID, expiry time, reason, and whether
  it should affect fields, walkthrough, marks, or unjustified kill logic.
- `ExpertPvpDecision`: allowed, denied return value, relation, side-effect owner,
  skull action, pz-lock action, starts fight, sends square, counts unjustified,
  and a short reason enum for tests/logs.
- `ExpertFieldContext`: owner player GUID, owner mode source, owner mode value,
  canonical item id, safe visual id, blocking visual id, and whether the context
  came from a player or summon.

Keep these types small and value-based where possible. The decision helpers
should be cheap to test without a full game state. When a helper must inspect a
`Player`, do that at the boundary and return a plain result before mutating
anything.

Minimal integration points should look like:

- `Player::canWalkthroughEx()` delegates to `ExpertPvp::canWalkThrough()` when
  enabled, otherwise keeps current behavior.
- `Game::updateCreatureWalkthrough()` keeps its loop but uses the updated
  player helper.
- `ProtocolGame::parseFightModes()` reads the PvP mode byte only for profiles
  that send it, then delegates mode validation to the new helper.
- `ProtocolGame::sendFightModes()` sends the stored mode through the existing
  protocol feature gates.
- Tile serialization delegates MW/WG client id selection to
  `ExpertPvp::getFieldClientId()` rather than transforming the shared item.
- `Tile::queryAdd()` calls `ExpertPvp::evaluateFieldStep()` before the current
  safe-field removal path.
- Combat targeting calls `ExpertPvp::evaluateCombatAction()` before applying
  damage or area effects to players.
- Optional debug tooling, if kept, calls a narrow helper to refresh skull and
  square state instead of exposing broad combat internals to Lua.

This keeps existing functions as orchestration points. Avoid adding large
decision trees to existing method bodies.

Current call-site map:

- `ProtocolGame::parseFightModes()` has the PvP byte read commented out. The port
  should read it only when the active protocol profile sends it, then call a
  `Game::playerSetFightModes()` overload that includes the normalized PvP mode.
- `ProtocolGame::sendFightModes()` currently sends `PVP_MODE_DOVE` instead of
  player state. The port should send the stored normalized mode while preserving
  the exact packet shape per profile.
- `ProtocolGame::sendAddCreature()` writes the login expert-mode byte around the
  login packet setup. Change this only after confirming the client meaning of
  the hard-coded value.
- `Game::playerSetFightModes()` currently has no PvP mode parameter. Extending it
  is safer than mutating `Player` state directly from protocol code.
- `Player::canWalkthrough()` currently handles actual movement and includes the
  existing double-attempt walkthrough mechanic. Expert neutral ghosting should
  not accidentally require the legacy double-attempt flow unless that is chosen
  explicitly.
- `Player::canWalkthroughEx()` currently drives spectator/client walkthrough
  updates through `Game::updateCreatureWalkthrough()`. Its result must match the
  movement helper for Expert PvP.
- `Tile::queryAdd()` currently checks creature blocking, pathfinding
  `TILESTATE_BLOCKPATH`, and safe-field removal in separate branches. Insert
  Expert PvP decisions so pathfinding, movement, and safe-field removal cannot
  disagree.
- `Combat::combatTileEffects()` currently changes MW/WG ids for no-PvP contexts,
  adds fight ticks for PvP fields, creates the item, and calls `item->setOwner`.
  Field context capture should happen here, but delayed aggression rules should
  decide whether cast-time fight ticks stay.
- `MagicField::onStepInField()` currently mixes `getPlayerByGUID(ownerId)`,
  `getCreatureByID(ownerId)`, and `getPlayerByID(ownerId)`. The port should
  route all player-owned field checks through one owner GUID resolver.
- `data/scripts/runes/magic_wall.lua` and
  `data/scripts/runes/wild_growth.lua` should only provide canonical field
  creation and owner context. They should not decide final PvP legality.

## Selected And Remaining Product Decisions

Use these selected contracts unless a later capture proves a different current
Tibia behavior:

- Expert PvP is selected by `worldType = "expert-pvp"`.
- Retro Open PvP is selected by `worldType = "retro-pvp"`.
- `worldType = "pvp"` remains as a compatibility alias for `retro-pvp`.
- The C++ `WORLD_TYPE_PVP` enum remains the shared Open PvP baseline for both
  Retro and Expert modes unless a later PR proves a separate enum is required.
- Player PvP mode is server-side state and may be persisted.
- Field owner mode is captured at cast time.
- MW/WG runes are non-aggressive at cast time; aggression is handled only when
  the field actually blocks or damages a player.

Remaining decisions:

- Which old granular flags represent real contracts. Prefer `worldType` as the
  mode gate and avoid config sprawl unless a separate flag is required for
  rollout or compatibility.
- Which default hand applies when a client does not send a PvP byte. This must
  be explicit and should not be hidden behind an `oldProtocol` check.
- How invalid or unknown PvP mode bytes are handled. Older code allowed unknown
  modes by default; current code should normalize to a safe mode or fail closed.
- Whether war relations are explicit exceptions for Dove, White Hand, and Yellow
  Hand. If they are, keep war classification inside the shared helper.
- Whether a viewer's own Red Fist mode, without a PvP situation with the field
  owner, should make a neutral field block that viewer. Public sources emphasize
  the caster/viewer PvP situation for MW visual/pass-through, so avoid treating
  viewer mode alone as sufficient without a capture-backed product decision.
- Whether Red Fist field blocking creates only white skull and pz-lock, or also
  creates fight ticks and a yellow square. The recovered Antigravity fix favored
  no forced in-fight/yellow frame unless there was a real attack.
- Whether pathfinding should ignore creature-derived `TILESTATE_BLOCKPATH` after
  the player walkthrough helper has allowed pass-through, while still respecting
  real blocking items.
- Whether the runtime pairwise PvP situation should be a dedicated map or derived
  from existing attacked sets. This affects MW/WG visuals, damage, marks, and
  unjustified-kill attribution.
- Whether a rune-cast wild growth can be cut only by its caster.
- Whether the "top player in stack" rule belongs in this port: a player below
  another player cannot initiate aggressive PvP or aggressive area spells.
- Whether Open PvP 2014 unfair-frag share and `player_kills.weight` are in scope.
  Recommended answer for the first port: keep it out of scope.

Recommended default for upstream-safe work: keep `retro-pvp` and legacy `pvp`
behavior unchanged while Expert behavior is limited to `worldType =
"expert-pvp"`.

Recommended default for this port: add the `expert-pvp` world type first, then
implement the component/helper layer while `retro-pvp` remains the default. That
lets the first code PR be mostly additive.

Suggested decision record for the implementation PR:

```markdown
### Decision: <short name>

- Chosen contract:
- Current Canary behavior when feature disabled:
- Old source evidence used:
- Old source evidence rejected:
- Files touched:
- Regression scenarios added:
```

Keep this record in the PR description or in a short implementation note while
coding. It prevents a later chat from reintroducing an older behavior that was
already superseded.

## Behavioral Contracts

### Hand Modes

Dove:

- Can defend against direct aggressors.
- Can attack or body-block only characters that have been aggressive towards the
  player.
- Must not attack or body-block unrelated players.
- Area spells and runes must not hit unrelated players.
- Should not cause protection zone lock for neutral-only actions.

White Hand:

- Can defend self, party, and guild members against aggressors.
- Can attack or body-block only characters that have attacked the player or a
  party/guild member.
- Can show yellow skull to targets where appropriate.
- Deaths caused only by valid defense should not count as unjustified.

Yellow Hand:

- Can attack and body-block skulled players, except protected party/guild
  allies.
- Applies battle state and protection zone lock when it starts PvP.
- Uses yellow skull rules where the viewer contract requires it.

Red Fist:

- Can attack and body-block non-allied players.
- Must be unavailable or forced away for black skull players if the chosen
  product contract follows Tibia rules.
- Starts battle state and protection zone lock when it creates PvP pressure.
- A Red Fist magic wall or wild growth that blocks another player can create
  white skull and protection zone lock for the field owner when the target is
  not already a justified PvP target.

Hardcore PvP:

- If supported, should force Red Fist semantics and hide mode switching.
- Must not use normal skull logic.

### Walkthrough

Expert PvP player-player walkthrough must use the blocking player's hand mode,
not a blanket "same battle blocks each other" rule:

- Dove blocks only characters that have been aggressive towards the blocker.
- White Hand blocks only characters that have attacked the blocker or the
  blocker's party/guild members.
- Yellow Hand blocks skulled non-allies.
- Red Fist generally blocks non-allies and can open PvP pressure, skull, and
  protection-zone lock when a neutral player tries to pass through.
- Party/guild allies remain protected according to the selected hand mode.
- Protection zones, no-PvP zones, depot/house restrictions, access players, and
  ghost mode must keep their existing precedence.
- Pathfinding and actual movement checks must use the same decision helper.

Implement this through a central helper instead of duplicating rules inside
`Player::canWalkthrough()`, `Player::canWalkthroughEx()`, and `Tile::queryAdd()`.

### Combat Permission

Combat permission should be evaluated by one C++ helper that returns a structured
result, not by scattered boolean checks. The helper should answer:

- Can this action affect the target?
- Does it start battle state?
- Does it apply protection zone lock?
- Does it create a skull?
- Is the resulting death unjustified?
- Should party or guild relation override the result?

Use this helper from direct attacks, area spells, rune targeting, field damage,
and magic wall or wild growth blocking. Do not let Lua scripts decide final PvP
legality independently from C++ combat.

Secure mode remains a client combat-control input, but it must not override a
valid Expert PvP defense decision. In Dove mode, a player should be able to
retaliate against a direct aggressor without disabling secure mode. Secure mode
also cannot promise safety when the selected hand mode, field, area spell, or
body-blocking action legitimately opens PvP pressure.

War, guild, party, skull, direct-attacker, and direct-target relations should be
computed once per decision. Unknown or invalid PvP modes should not silently
fall through to "allowed".

If the top-stack rule is adopted, run it before applying side effects: a hidden
player under another player should not be able to start aggressive direct PvP or
area-spell PvP, but existing self-defense or already-active PvP situations should
remain valid.

### Magic Wall And Wild Growth

Magic wall and wild growth need two independent concepts:

- Server collision contract: whether a specific moving player is blocked.
- Client visual contract: which item ID a specific viewer sees.

Do not transform the world item just to change the color for one viewer. That
creates shared-state bugs. Prefer a protocol serialization hook that can choose
the displayed item ID per viewer while the tile keeps stable Expert field
context. If the physical backing item must be the safe variant so bystanders can
pass through, keep the canonical MW/WG id in explicit field metadata instead of
using the backing item id as the behavior contract.

Recovered Lua scripts chose safe or blocking MW/WG item IDs when the rune was
cast. That reproduced some visuals, but it made one shared item carry a
viewer-relative state. The cleaner port should attach owner context and let
protocol serialization pick the visual for each viewer.

Recommended field rules:

- The field owner is stored as the player's GUID, not a runtime creature ID.
- Summon-cast fields should use the master player's GUID.
- The field stores the owner's PvP mode at creation time. Public hand-mode
  guides describe fields, bombs, and summons as carrying the mode used when the
  action was created; do not switch field behavior to the owner's live mode.
- Owner sees the normal blocking field visual.
- Neutral non-owners that are not in a PvP situation with the caster see the
  safe/yellow field visual and can pass through the field.
- A player that is only the target of the caster's aggression, and has not
  retaliated or become blocked for another relation such as war, still sees the
  safe/yellow field visual and can pass through the field. This remains true for
  a Red Fist field cast by the aggressor.
- Players that have attacked the owner, war enemies, and valid blocked targets
  for the cast-time hand mode see the blocking field visual and can be blocked
  by MW/WG.
- Monsters should remain blocked by magic wall and wild growth.
- The owner cannot walk through their own MW/WG.
- Harmful field conditions must use the same Expert PvP decision helper as
  direct attacks, so non-aggressive owners do not damage unrelated players.
- A Red Fist field can open PvP pressure when another player tries to cross it.
  It may apply skull and pz-lock to the owner without forcing fight ticks or a
  yellow frame unless the product decision says the block is a real attack.
- Optional PvP safe-field behavior must remain scoped to Optional PvP and
  no-PvP zones.
- Expert PvP safe-looking fields must not be removed merely because a player
  walks through them.

Current `Tile::queryAdd()` and `MagicField::onStepInField()` remove safe fields.
That behavior must be preserved only for the existing Optional PvP contract, not
reused for Expert Open PvP.

### Owner And Identity

Field owner checks must use stable player GUIDs:

- Lua runes should set owner to the player GUID when creating MW/WG.
- C++ field creation should normalize summon owners to the master player.
- Protocol visual code should compare viewer GUID to field owner GUID.
- Fallbacks that guess the owner from nearby spectators are not acceptable.

The older work had owner ID confusion between creature runtime IDs and player
GUIDs. Treat that as a hard regression test.

### Skulls, Frames, And Battle State

Avoid mutating attack state inside movement checks unless the movement result is
already decided to be a PvP action. In particular:

- Do not call `onAttackedCreature()` before checking `hasAttacked()` conditions.
- Do not let a blocked movement attempt accidentally register the target as an
  attacker before the skull and block decision is made.
- Do not use field blocking as an implicit attack-state mutation unless the
  final side-effect contract explicitly says so.
- If `Player::addInFightTicks()` or square updates are touched, only send square
  changes on real state transitions. Re-sending the same yellow frame on every
  tick was a recovered regression.
- Keep transient square frames separate from permanent PvP framing. If a
  permanent square type is needed, add an overload or explicit packet type
  parameter instead of changing all existing `sendCreatureSquare()` callers.
- Refresh skulls and squares for all relevant spectators after battle state
  changes.

## Implementation Order

1. Add failing tests or debug-only assertions for the desired contract.
2. Add `src/creatures/players/components/pvp/` with pure decision helpers and
   no side effects except where explicitly named.
3. Add the `expert-pvp` world-type mapping and keep `pvp` as a `retro-pvp`
   compatibility alias.
4. Add `Player` PvP mode state with clamped setter and explicit default.
5. Parse and send PvP mode through `ProtocolGame::parseFightModes()` and
   `ProtocolGame::sendFightModes()` using protocol feature gates.
6. Enable the expert-mode login UI flag only when the server supports the mode.
7. Add a central Expert PvP relation helper for attacks, blocking, skulls, and
   pz-lock decisions.
8. Port `canWalkthroughEx()` and `Game::updateCreatureWalkthrough()` to use the
   helper.
9. Define field context for owner GUID and, if chosen, owner PvP mode at cast
   time.
10. Normalize MW/WG owner GUID assignment in Lua and C++ field creation.
11. Route damaging field conditions through the same Expert PvP helper.
12. Add per-viewer field visual serialization in the protocol layer.
13. Replace `Tile::queryAdd()` safe-field removal with Expert-aware
    pass-or-block decisions.
14. Apply skull, pz-lock, and frame updates only after the pass-or-block decision
    is stable.
15. Recheck pathfinding against actual movement so player pass-through and
    blocking-item behavior agree.
16. Remove noisy migration logs and keep only actionable diagnostics.

Suggested PR slices:

- PR 1: Add the `expert-pvp` world type, `ExpertPvp` definitions, value result
  types, and no-op helpers. `retro-pvp` and legacy `pvp` mean no behavior
  change.
- PR 2: Add player PvP mode state, defaulting, clamping, protocol parse/send, and
  optional persistence. Do not wire combat behavior yet.
- PR 3: Wire direct attacks, area spells, and rune target permission through the
  shared combat decision helper.
- PR 4: Wire player walkthrough and pathfinding through the shared relation
  helper while preserving existing Optional PvP, protection-zone, and low-level
  behavior.
- PR 5: Add field context for MW/WG, owner GUID resolution, and field damage
  permission. Keep per-viewer visual changes separate from the shared item id.
- PR 6: Add MW/WG per-viewer serialization and Red Fist field side effects, then
  remove temporary logs and debug-only tools.

Each slice should be reviewable with the feature disabled. If a slice must
change existing behavior before the feature is enabled, document why and add a
regression test for the old behavior.

## Regression Matrix

Minimum scenarios to cover:

- Legacy client logs in and does not desync when fight modes are sent.
- Client with Expert PvP support can switch each hand mode and the server stores
  the selected mode.
- `worldType = "retro-pvp"` and legacy `"pvp"` behavior remains unchanged.
- `worldType = "expert-pvp"` enables Expert Open PvP behavior.
- Dove area spell does not damage unrelated players.
- White Hand protects self, party, and guild, but does not open unrelated PvP.
- Yellow Hand can target skulled players and applies pz lock.
- Red Fist cannot be selected by black skull players if that contract is chosen.
- Neutral players can ghost through each other in Expert Open PvP.
- Player-player body blocking follows the blocker's hand mode, not a blanket
  active-battle rule.
- Dove, White Hand, Yellow Hand, and Red Fist body-block only the target sets
  documented for those hand modes.
- Optional PvP safe magic wall and wild growth behavior remains unchanged.
- Expert safe-looking MW/WG is not removed when a player passes through.
- Field owner always resolves by player GUID after logout/login or summon cast.
- Field owner mode uses cast-time metadata consistently.
- Owner sees a blocking MW/WG visual; neutral viewers see safe/yellow visual.
- Active PvP opponents see a blocking MW/WG visual.
- Red Fist field blocking applies pz lock and skull only to the correct player.
- Red Fist field blocking without a direct attack does not force fight ticks or
  a yellow frame if that contract is selected.
- MW/WG casting alone does not place the caster in fight or send a yellow frame
  if field aggression is delayed until block or damage.
- Dove or White Hand field damage does not apply conditions to unrelated
  players.
- The owner cannot walk through their own MW/WG.
- A failed movement attempt does not pollute `hasAttacked()` state before the
  final decision.
- Pathfinding agrees with actual movement for MW/WG and player walkthrough, but
  still respects real blocking items.
- Clients that do not send a PvP mode byte receive the documented default hand
  and do not desync when fight modes are sent.
- Invalid PvP mode bytes are normalized or rejected before they can allow combat.
- War relations are covered for Dove, White Hand, and Yellow Hand if the product
  contract keeps the recovered war exceptions.
- If a debug reset talkaction is retained, it refreshes skull and square state
  through a narrow API and is not available to normal players.
- Feature gate disabled while a client sends a PvP byte: server parses safely or
  ignores it without changing current PvP behavior.
- Player logs out and back in after selecting each hand mode, according to the
  chosen persistence contract.
- Expert mode login byte enables or disables the client button exactly as
  expected for the target client.
- Current payload and non-current payload protocol profiles keep the correct
  `sendFightModes()` packet length.
- Expert neutral ghosting works on the first movement attempt if that is the
  chosen contract, and does not inherit the legacy two-attempt walkthrough
  behavior by accident.
- `Combat::combatTileEffects()` does not put the caster in fight merely for
  casting MW/WG if delayed aggression is selected.
- `MagicField::onStepInField()` resolves owner GUID consistently and does not
  mix player GUID with runtime creature IDs.
- Safe MW/WG removal remains scoped to Optional PvP or no-PvP contexts.
- Replaying the February 16 secure-mode/frame regression does not reintroduce
  yellow frame flicker.
- Runtime PvP situations expire and clear viewer marks without leaving stale
  yellow, orange, or brown boxes.
- A player fighting the viewer sees yellow, a player fighting the viewer's party
  or guild ally sees orange, and unrelated fights show brown if that mark
  contract is selected.
- A hidden player below another player cannot initiate aggressive direct PvP or
  area-spell PvP if the top-stack rule is selected.
- A bystander can pass through or avoid damage from player-owned fields according
  to the caster/viewer PvP situation, while active PvP opponents and monsters
  still get the blocking/damaging behavior.
- Rune-cast wild growth can only be cut by its caster if that contract is
  selected.
- Frag-share `player_kills.weight` remains unchanged and out of scope unless a
  separate PR explicitly implements Open PvP 2014 unfair-frag rules.

## How To Test In Game

Use this section as the manual test script for people helping with in-game QA.
Run every scenario on a normal PvP tile, not inside protection zones, no-PvP
zones, arenas, party-protection exceptions, or war-only areas unless the test
explicitly says otherwise.

Before testing:

- Set `worldType = "expert-pvp"` in `config.lua` and restart the server.
- Use the Tibia 11.00 profile for full hand-mode selection. The current 15.25
  profile has no verified hand-mode byte and is intentionally limited to Dove.
- Prepare at least three normal characters:
  - `Attacker`: starts aggression, commonly a druid/sorcerer for runes and MW.
  - `Defender`: gets attacked first and tries to defend with secure mode on.
  - `Spectator`: neutral bystander for MW/WG visual and pass-through checks.
- Keep test characters out of the same party and guild unless the scenario says
  to test party/guild behavior.
- Start each scenario from a clean state: no skull, no PZ lock, no pending field
  owner state, and no previous attack relation. Relog or wait for fight state to
  clear if needed.
- For every failure report, record: world type, each character hand mode, secure
  mode state, who attacked first, visible skulls/frames/icons, whether the
  character can enter protection zone, and screenshots from each viewer when
  testing MW/WG.

### Smoke Test

1. Start the server and confirm the startup log reports Expert PvP as the world
   type.
2. Log in with `Attacker`, `Defender`, and `Spectator`.
3. On Tibia 11.00, confirm the Expert PvP hand control is enabled and each hand
   mode can be selected: Dove, White Hand, Yellow Hand, and Red Fist.
4. Toggle secure mode on and off, then select Dove again.
5. Separately log in with 15.25 and confirm the client stays synchronized, the
   unavailable Expert control remains disabled, and the server uses Dove.

Expected result: the client does not desync, the hand mode button remains
usable, and Dove is safe as the default/neutral mode.

### Dove And Secure Mode Defense

1. `Defender`: Dove mode, secure mode on.
2. `Attacker`: Red Fist mode, secure mode can be on or off.
3. `Attacker` attacks `Defender` first with a direct attack.
4. Without changing secure mode, `Defender` attacks `Attacker` back with a
   direct attack.
5. Repeat the retaliation with an offensive rune or targeted spell if available.

Expected result: `Defender` can retaliate without disabling secure mode. The
client must not show "You may not attack this player" for valid self-defense.
`Defender` must not receive PZ lock for valid defense and must be able to enter
protection zone if no other aggressive action was performed. `Attacker` is the
aggressor and receives the relevant skull/PZ pressure.

### Dove Neutral Safety

1. `Defender`: Dove mode, secure mode on.
2. `Spectator`: neutral, no previous combat with `Defender`.
3. `Defender` tries to attack `Spectator`.

Expected result: the attack is blocked. Dove must not allow unrelated neutral
PvP, and the failed attempt must not create skull, PZ lock, or a stale battle
relation.

### Red Fist Aggression

1. `Attacker`: Red Fist mode.
2. `Defender`: Dove mode, secure mode on.
3. `Attacker` attacks `Defender` with direct damage.
4. `Defender` retaliates once.

Expected result: Red Fist opens aggression against a neutral player. `Attacker`
receives the expected aggressive PvP pressure, including PZ lock/skull where
the current contract requires it. `Defender` can defend but does not become PZ
locked merely for defending.

### White Hand Ally Defense

1. Put `Defender` and `Party Ally` in the same party; repeat later with only the
   same guild.
2. `Defender`: White Hand and secure mode on.
3. `Attacker` attacks `Party Ally`, but does not attack `Defender`.
4. `Defender` attacks `Attacker` directly and with a targeted rune.
5. Repeat with `Defender` in Dove.

Expected result: White Hand allows defense of the party/guild ally without an
unjustified PZ lock. Dove does not allow that relation. Party and guild allies
must never be treated as hostile because of stale attack state.

### Yellow Hand Skulled Target

1. Give `Attacker` a visible non-green skull by opening aggression elsewhere.
2. `Defender`: Yellow Hand and secure mode on.
3. `Defender` attacks and tries to body-block `Attacker`.
4. Repeat against a neutral, unskulled `Spectator`.

Expected result: Yellow Hand permits and blocks the skulled non-ally, but does
not open aggression against the neutral spectator.

### Magic Wall And Wild Growth Visuals

Run the same steps for both Magic Wall and Wild Growth.

1. `Attacker` attacks `Defender` first.
2. Before `Defender` retaliates, `Attacker` casts MW/WG between or next to the
   players.
3. Observe the wall from `Attacker`, `Defender`, and `Spectator`.
4. Try to walk through the wall with each character.
5. Now let `Defender` retaliate.
6. Try to walk through the same existing wall again.
7. Cast a new MW/WG after `Defender` has already retaliated and repeat the
   visual/pass-through checks.
8. Use map click or auto-walk to cross every wall that is safe for that viewer.

Expected result: the caster sees the blocking visual and cannot walk through
their own MW/WG. A neutral spectator sees the safe/yellow visual and can pass.
If the wall was cast before `Defender` retaliated, `Defender` keeps seeing the
safe/yellow visual and can pass through that existing wall even after
retaliating. A new wall cast after both players are already in direct combat can
block active PvP opponents according to the current Expert PvP relation.
Auto-walk and manual movement must agree, and PZ/no-logout restrictions must
still reject movement after a safe-field path probe.

### Field Damage

1. `Attacker`: Dove mode.
2. Cast damaging fields/bombs where `Spectator` can step on them.
3. Repeat with White Hand, Yellow Hand, and Red Fist.
4. Repeat with a player summon owned by `Spectator` stepping into the field.

Expected result: Dove/White should not damage unrelated neutral players through
player-owned fields. Red Fist can create aggression through damaging fields when
the current contract allows it, and side effects must be applied to the field
owner, not to bystanders or the defender.

### Player Walkthrough And Body Blocking

1. Place two neutral players on adjacent tiles in Dove mode.
2. Try to walk through each other.
3. Repeat after one player has attacked the other.
4. Repeat with the blocker in White Hand, Yellow Hand, and Red Fist.

Expected result: Dove blocks only an aggressor against the blocker; White Hand
also blocks aggressors against the blocker's party/guild allies; Yellow Hand
blocks skulled non-allies; Red Fist blocks non-allies. Neutral players pass Dove,
White, and Yellow blockers. Party/guild allies pass every mode.

### Situation Marks

1. Start direct combat between `Attacker` and `Defender`.
2. Observe `Attacker` from `Defender`, from a party/guild ally of `Defender`, and
   from unrelated `Spectator`.
3. End the battle state, leave/join the party, and relog one participant.

Expected result: a direct participant sees yellow, an ally sees orange, an
unrelated viewer sees brown, and all marks clear when the relation ends. Joining
or leaving party/guild updates visible marks without reconnecting. Run this on
the current profile whose persistent mark packet is verified; legacy profiles
must remain synchronized and unmarked rather than showing a stale mark.

### Regression Checks For Other World Types

Repeat a short smoke test with:

- `worldType = "retro-pvp"`
- legacy `worldType = "pvp"`
- `worldType = "no-pvp"`
- `worldType = "pvp-enforced"`

Expected result: Expert PvP rules must not leak into other world types. Legacy
`"pvp"` remains a compatibility alias for Retro PvP behavior, and `expert-pvp`
is the only world type that enables the Expert PvP hand-mode rules.

## Files Likely To Change

Expected C++ touch points:

- `src/creatures/creatures_definitions.hpp`
- `src/creatures/players/components/pvp/expert_pvp_definitions.hpp`
- `src/creatures/players/components/pvp/expert_pvp.hpp`
- `src/creatures/players/components/pvp/expert_pvp.cpp`
- `src/creatures/players/player.hpp`
- `src/creatures/players/player.cpp`
- `src/creatures/combat/combat.cpp`
- `src/creatures/combat/combat.hpp`
- `src/creatures/combat/spells.cpp`
- `src/game/game.hpp`
- `src/game/game.cpp`
- `src/items/tile.cpp`
- `src/server/network/protocol/protocolgame.hpp`
- `src/server/network/protocol/protocolgame.cpp`
- `src/lua/functions/core/game/lua_enums.cpp`
- `src/lua/functions/core/game/game_functions.hpp`
- `src/lua/functions/core/game/game_functions.cpp`
- `src/lua/functions/creatures/player/player_functions.cpp`
- maintained build manifests for new `expert_pvp.cpp`

Expected persistence touch points, only if PvP mode is persisted:

- `schema.sql`
- `src/io/functions/iologindata_load_player.cpp`
- `src/io/functions/iologindata_save_player.cpp`
- repository migration files, if this repo keeps incremental migrations

Expected Lua touch points:

- `data/scripts/runes/magic_wall.lua`
- `data/scripts/runes/wild_growth.lua`
- `data-global/scripts/lib/register_actions.lua`, only if the wild-growth
  caster-only cut rule is in scope and that path exists in current Canary.

Optional debug or QA-only Lua touch points, if retained:

- `data/scripts/talkactions/player/reset_pvp.lua`
- `data/scripts/talkactions/god/pvp_mark_test.lua`

Expected config touch points, only if the feature is configurable:

- `config.lua.dist`
- `src/config/config_enums.hpp`
- `src/config/configmanager.cpp`

When adding the new `.cpp`, update every maintained build entry point required
by this repo, including CMake and the Visual Studio project if both are tracked.

Out-of-scope touch points from the TibiaDuality patch unless explicitly chosen:

- `schema.sql`
- `data/migrations/65.lua`
- `src/io/functions/iologindata_load_player.cpp`
- `src/io/functions/iologindata_save_player.cpp`
- kill-frag weighting in `src/creatures/players/player.cpp`

## Anti-Patterns To Avoid

- Do not copy old Shadowborn code without adapting it to current protocol
  profiles and world-type names.
- Do not add a broad `WORLD_TYPE_PVP` behavior change that affects `retro-pvp`
  or legacy `pvp`.
- Do not store field owner as a runtime creature ID.
- Do not derive player-player body blocking only from active PvP situation
  membership; use the blocker hand mode and relation target set.
- Do not use the MW/WG viewer-specific visual rule as a shortcut for
  player-player body blocking. These are separate contracts.
- Do not mutate the tile item only to change one viewer's field color.
- Do not let Lua rune scripts choose the shared safe/blocking item ID as a
  replacement for viewer-specific protocol serialization.
- Do not remove Expert MW/WG fields on player pass-through.
- Do not put skull, pz-lock, and `hasAttacked()` mutations in different branches
  that can disagree.
- Do not allow unknown PvP mode values to fall through to permissive combat.
- Do not let MW/WG cast itself create yellow frames if the chosen contract says
  field aggression happens only on block or damage.
- Do not treat every `TILESTATE_BLOCKPATH` as a blocking item after player
  walkthrough has already allowed creature pass-through.
- Do not change the default `sendCreatureSquare()` packet shape for every caller
  if only Expert PvP needs permanent square frames.
- Do not rely on nearby spectator guessing when owner metadata is missing.
- Do not hide protocol decisions behind `oldProtocol` alone; use the current
  protocol feature profile where possible.
- Do not treat commit `adaacdb2b9899693272187bd2816a057d897ecd4` as Expert PvP
  source material; it is unrelated feature work.
- Do not apply the TibiaDuality 2014 patch directly. It is stale against current
  Canary and mixes multiple scopes.
- Do not copy `tailRemaining` packet parsing heuristics without replacing them
  with protocol-profile based parsing.
- Do not mix unfair-frag share, `player_kills` schema changes, or kill weighting
  into the Expert PvP behavior port.
- Do not scatter `pveWall` custom-attribute reads across Lua, combat, tile, and
  protocol. If selected, model it as explicit field context.
- Do not expose debug reset commands or new Lua combat bindings to normal
  gameplay without an explicit gate.
- Do not mix unrelated Antigravity fixes into the Expert PvP port.

## Handoff For The Implementation Chat

Start from this document, not from the old Shadowborn code. The implementation
goal is to reproduce the behavior in current Canary with a cleaner shape:

- Use new helper/component files wherever practical.
- Keep existing functions as thin call sites.
- Use `worldType = "expert-pvp"` as the gate so Retro PvP behavior can remain
  unchanged while the port is incomplete.
- Make PvP decisions deterministic before applying side effects.
- Separate server collision from per-viewer client visuals.
- Store field ownership by player GUID.
- Store field owner mode at cast time before wiring MW/WG and damaging fields.
- Prefer one relation/combat decision helper over repeated local conditions.
- Add tests around the regression matrix before expanding behavior.

Useful first patch target:

1. Create `src/creatures/players/components/pvp/` with definitions and pure
   decision result structs.
2. Add no-op integration behind `worldType = "expert-pvp"`.
3. Add tests for the helper with simple player relation fixtures if the test
   harness supports it.
4. Only then wire protocol state, walkthrough, MW/WG visuals, and side effects.

## Review Checklist

Before merging an Expert PvP port:

- The feature can be disabled without changing existing PvP behavior.
- Protocol payload length is correct for every supported client profile.
- All player-mode state transitions are clamped and logged only when useful.
- Combat and movement use the same PvP relation helper.
- MW/WG visual state is viewer-specific and does not mutate shared tile state.
- Optional PvP and no-PvP zone behavior are still covered by tests.
- Red Fist skull and pz-lock effects are deterministic and happen once per
  relevant action.
- There are tests for both pathfinding and actual movement.
- Debug logs from exploratory work have been removed or downgraded.
