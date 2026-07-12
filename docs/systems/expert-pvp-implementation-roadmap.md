# Expert PvP Implementation Roadmap

This roadmap turns the contracts from the
[Expert PvP porting plan](expert-pvp-porting-plan.md) into small implementation
steps. The goal is to keep each commit reviewable, atomic, and safe while
Expert PvP is selected explicitly through `worldType = "expert-pvp"`.

## Current Status

Phases 1 through 8 are implemented in the branch. The current review scope is
therefore stabilization and regression validation, not a Phase 1-only PR.

- Foundation, player state, combat, walkthrough, field context, collision,
  viewer visuals, situations, marks, and persistence are present.
- White/Yellow/Red relation matrices, pure combat validation, summon ownership,
  field pathfinding, and bounded mark refreshes have dedicated fixes.
- Tibia 11.00 carries the verified hand-mode byte. Current 15.25 has a verified
  three-byte Set Tactics packet, so it defaults to Dove and does not expose the
  hand selector.
- Frag sharing, `player_kills.weight`, debug commands, caster-only wild-growth
  cutting, and the top-stack product decision remain out of scope.

## Ground Rules

- Keep `worldType = "retro-pvp"` as the explicit default; keep `worldType = "pvp"`
  as a compatibility alias for Retro PvP.
- `worldType` is the source of truth for Retro PvP versus Expert PvP; do not add
  parallel boolean gates for either mode.
- With `worldType = "retro-pvp"` or legacy `"pvp"`, current Retro PvP behavior
  must not change.
- Keep existing functions as thin call sites; put Expert PvP decisions in
  `src/creatures/players/components/pvp/`.
- Do not apply old Shadowborn or TibiaDuality patches directly.
- Do not copy old code without adapting it to current Canary contracts.
- Do not mix frag-share, `player_kills.weight`, related kill-schema migrations,
  debug talkactions, or unrelated protocol work into the implementation chain.
- Separate protocol, player state, combat, walkthrough, field context, field
  visuals, and side effects into different commits or PRs.
- Update every maintained build entry point when adding C++ source files.

## Definition Of Done For Each Commit

Each commit should answer these points in its message or PR notes:

- What behavior changes when `worldType` is `retro-pvp` or legacy `pvp`?
- What behavior changes when `worldType` is `expert-pvp`?
- Which existing call site became thinner?
- Which helper now owns the decision?
- Which regression scenario from the porting plan is covered or prepared?

If the expected answer for the disabled feature is not "no behavior change",
split the commit or document why the exception is necessary.

## Phase 1: Foundation, No Behavior Change

### `feat(pvp): add expert pvp world type`

Add the explicit Expert PvP world type while preserving Retro PvP compatibility.

Expected files:

- `config.lua.dist`
- `src/config/config_enums.hpp`
- `src/config/configmanager.cpp`

Rules:

- Add `worldType = "expert-pvp"` as the Expert PvP gate.
- Keep `worldType = "pvp"` as a compatibility alias for `retro-pvp`.
- Do not add granular rollout flags yet.

Validation:

- Static diff review.
- Confirm the default `worldType` is `retro-pvp`.
- Confirm legacy `worldType = "pvp"` maps to Retro PvP.

### `feat(pvp): add expert pvp decision skeleton`

Create the component area and value types for future decisions.

Expected files:

- `src/creatures/players/components/pvp/expert_pvp_definitions.hpp`
- `src/creatures/players/components/pvp/expert_pvp.hpp`
- `src/creatures/players/components/pvp/expert_pvp.cpp`
- `src/creatures/players/components/pvp/player_pvp.hpp`
- `src/creatures/players/components/pvp/player_pvp.cpp`
- `src/creatures/CMakeLists.txt`
- `vcproj/canary.vcxproj`

Initial types:

- `ExpertPvpModeSource`
- `ExpertPvpRelation`
- `ExpertPvpActionKind`
- `ExpertPvpDecisionReason`
- `ExpertPvpModeResult`
- `ExpertPvpRelationContext`
- `ExpertPvpDecision`
- `ExpertPvpWalkthroughDecision`
- `ExpertFieldContext`
- `ExpertPvpFieldStepDecision`
- `ExpertPvpFieldDamageDecision`
- `ExpertPvpFieldVisualDecision`

Rules:

- Helpers should be pure and value-based where possible.
- Decision results should default to "not handled" when the feature is disabled.
- `PlayerPvp` should mirror the component shape used by `PlayerWheel`, but it
  should remain unintegrated until the player-state slice.
- No combat, movement, protocol, or Lua behavior should be wired in this commit.

Validation:

- Static diff review.
- Confirm the new `.cpp` is listed in CMake and Visual Studio project files.

### `test(pvp): cover expert pvp pure helpers`

Add focused unit tests for the first pure helpers.

Expected files:

- `tests/unit/players/components/expert_pvp_test.cpp`
- `tests/unit/players/components/CMakeLists.txt`

Suggested coverage:

- Valid hand modes are accepted.
- Unknown mode bytes normalize to Dove or fail closed.
- Default client mode is explicit.
- Basic relation classification preserves precedence.

Rules:

- Avoid full `Game` or map fixtures in this commit.
- Do not test call sites that are not wired yet.

## Phase 2: Player Mode State And Protocol

### `feat(player): store expert pvp mode state`

Add runtime PvP hand mode to `Player`.

Expected files:

- `src/creatures/players/player.hpp`
- `src/creatures/players/player.cpp`
- `src/creatures/players/components/pvp/expert_pvp.*`

Rules:

- Default to Dove.
- Clamp through `ExpertPvp::normalizeMode`.
- Do not persist yet.
- Do not change combat behavior.

### `feat(game): route pvp mode through fight mode updates`

Extend the game-layer fight mode path.

Expected files:

- `src/game/game.hpp`
- `src/game/game.cpp`

Rules:

- Keep `Game::playerSetFightModes()` as the only game-layer entry point.
- Preserve the old fight, chase, and secure-mode behavior.
- Feature disabled should ignore or normalize PvP mode without changing current
  behavior.

### `feat(protocol): parse expert pvp fight mode byte`

Read the PvP hand mode from `ProtocolGame::parseFightModes()`.

Expected files:

- `src/server/network/protocol/protocolgame.cpp`
- `src/server/network/protocol/protocolgame.hpp`, only if needed

Rules:

- Read the byte only for protocol profiles that send it.
- Do not use tail-length heuristics copied from old patches.
- Invalid values must not fall through to permissive combat.
- Keep secure mode parsing unchanged.

### `feat(protocol): send stored expert pvp fight mode`

Send the stored hand mode through `ProtocolGame::sendFightModes()`.

Rules:

- Preserve exact packet shape per protocol profile.
- Legacy/current-payload profiles must not desync.
- Feature disabled should keep current behavior.

### `feat(protocol): gate expert mode login flag`

Control the login Expert Mode UI flag.

Rules:

- Implement only after confirming client meaning for the hard-coded login byte.
- Keep this commit isolated because it can affect client UI state and login
  payload shape.

## Phase 3: Central Combat Decisions

### `feat(pvp): classify expert pvp combat relations`

Implement relation classification from current game state.

Relations to compute:

- self
- access player
- party ally
- guild ally
- war enemy
- direct attacker
- direct target
- skulled target
- neutral player
- monster
- player summon
- npc

Rules:

- Compute facts once per decision.
- Do not mutate attack state while classifying.

### `feat(pvp): evaluate expert pvp combat actions`

Implement structured combat decisions.

Decision fields:

- allowed
- starts battle
- applies protection-zone lock
- skull action
- unjustified kill risk
- side-effect owner
- reason

Rules:

- Unknown mode values must deny or normalize safely.
- Side effects are described, not applied, in this commit.

### `feat(combat): use expert pvp decisions for direct attacks`

Wire direct player attacks through the helper.

Expected files:

- `src/creatures/combat/combat.cpp`
- `src/creatures/combat/combat.hpp`, only if needed

Rules:

- Keep the call site thin.
- Apply side effects only after the decision is final.
- Feature disabled must use the current Canary path.

### `feat(combat): use expert pvp decisions for area and rune targets`

Wire area spells and rune targeting separately from direct attacks.

Rules:

- Preserve secure mode behavior.
- Do not reintroduce yellow frame flicker.
- Do not let Dove or White Hand hit unrelated players when the feature is
  enabled.

## Phase 4: Player Walkthrough

### Selected Contract

Implement player-player body blocking from the blocker hand mode and relation,
not from a blanket active-battle rule:

- Dove blocks only characters that have been aggressive towards the blocker.
- White Hand blocks only characters that attacked the blocker or the blocker's
  party/guild members.
- Yellow Hand blocks skulled non-allies.
- Red Fist generally blocks non-allies and can open PvP pressure when a neutral
  player tries to pass through.

### `feat(pvp): evaluate expert pvp walkthrough`

Implement the central walkthrough decision.

Rules:

- Preserve precedence for access players, ghost mode, protection zones,
  no-PvP zones, depot or house restrictions, and low-level walkthrough.
- Do not derive player-player body blocking only from active PvP situation
  membership.
- Pathfinding and actual movement must be able to share the same result.

### `feat(player): route walkthrough through expert pvp helper`

Make `Player::canWalkthrough()` and `Player::canWalkthroughEx()` delegate to the
helper when enabled.

Rules:

- Feature disabled keeps the current double-attempt walkthrough behavior.
- Expert neutral ghosting must not accidentally inherit the double-attempt
  requirement unless explicitly chosen.

### `feat(game): refresh walkthrough from expert pvp decisions`

Keep `Game::updateCreatureWalkthrough()` as orchestration and reuse the updated
player helper.

Rules:

- Do not duplicate relation logic in `Game`.

## Phase 5: Magic Wall And Wild Growth Field Context

### Selected Contract

Use cast-time field mode and stable owner identity:

- field owner mode is captured at cast time;
- owner cannot walk through their own MW/WG;
- neutral non-owners outside a PvP situation with the caster see/pass the safe
  field;
- players that are only targets of the caster's aggression and have not
  retaliated still see/pass the safe field, including when the aggressor cast the
  field in Red Fist;
- players that have attacked the owner, war enemies, and valid blocked targets
  for the cast-time hand mode see/collide with the blocking field;
- Red Fist field block may apply skull and pz-lock, but should not force fight
  ticks or a yellow square unless that block is later selected as a real attack.

### `feat(pvp): add expert pvp field context`

Model field ownership explicitly.

Expected fields:

- owner player GUID
- owner mode source
- owner mode value
- canonical item id
- safe visual item id
- blocking visual item id
- whether owner came from player or summon

Rules:

- Owner identity must be stable player GUID.
- Summon owners normalize to master player.
- Do not guess owners from nearby spectators.

### `feat(combat): capture expert field context on field creation`

Capture field context in C++ field creation.

Expected files:

- `src/creatures/combat/combat.cpp`

Rules:

- Do not change shared item identity for viewer-specific visuals.
- Do not change MW/WG cast aggression yet unless this commit explicitly owns
  that decision.

### `feat(lua): attach expert field owner context to mw wg runes`

Attach owner context in rune-created MW/WG.

Expected files:

- `data/scripts/runes/magic_wall.lua`
- `data/scripts/runes/wild_growth.lua`

Rules:

- Lua should provide canonical creation and owner context only.
- Lua must not decide final PvP legality.

### `feat(combat): evaluate expert pvp field damage`

Route harmful field conditions through the helper.

Expected files:

- `src/creatures/combat/combat.cpp`

Rules:

- Do not mix player GUID with runtime creature IDs.
- Dove and White Hand fields must not damage unrelated players when enabled.
- Optional PvP field behavior must remain unchanged when disabled.

## Phase 6: MW/WG Collision And Viewer-Specific Visuals

### `feat(pvp): evaluate expert pvp field stepping`

Implement pass/block decisions for MW/WG.

Rules:

- Compute side effects before mutating state.
- A failed movement attempt must not pollute `hasAttacked()` state.
- Evaluate MW/WG by field owner, cast-time owner mode, and caster/viewer PvP
  situation; do not reuse player-player body-blocking shortcuts here.
- Monsters should remain covered by the locked field contract.

### `feat(tile): route mw wg movement through expert pvp decisions`

Wire `Tile::queryAdd()` to the field-step helper.

Rules:

- Keep Optional PvP safe-field removal scoped to Optional PvP or no-PvP zones.
- Expert safe-looking MW/WG must not be removed merely because a player walks
  through it.
- Pathfinding and movement should agree.

### `feat(protocol): serialize mw wg visuals per viewer`

Add per-viewer item id selection for MW/WG.

Rules:

- Tile keeps stable Expert field context. If the physical backing item is safe
  so bystanders can pass, the canonical MW/WG id still lives in field metadata.
- Viewer sees safe or blocking visual according to helper result.
- Do not transform shared world item state for one viewer.

### `feat(pvp): apply expert pvp field side effects`

Apply final field side effects in one place.

Rules:

- Red Fist field blocking applies skull and pz-lock to the correct owner if
  selected.
- Do not force fight ticks or yellow square unless the product decision says a
  field block is a real attack.

## Phase 7: Runtime PvP Situations And Marks

This phase should happen only if the selected product contract needs dedicated
pairwise PvP situations instead of deriving involvement from existing attacked
sets.

### `feat(pvp): track runtime expert pvp situations`

Add a pairwise situation map keyed by player GUIDs.

Rules:

- Situation expiry should align with the selected pz-lock or battle duration.
- Situation data may affect fields, marks, and unjustified kill logic, but each
  use must be explicit.
- Player-player body blocking must continue to use the blocker hand mode and
  relation target set, not situation membership alone.

### `feat(protocol): send expert pvp situation marks`

Add persistent PvP mark serialization if selected.

Rules:

- Use explicit packet helpers or overloads.
- Do not change default `sendCreatureSquare()` packet shape globally.
- Suggested viewer contract: yellow for fighting viewer, orange for fighting
  viewer ally, brown for unrelated fights, unmarked otherwise.

## Phase 8: Persistence, If Selected

Persist PvP hand mode only after runtime mode behavior and protocol support are
stable.

### `feat(player): persist expert pvp mode`

Expected files, depending on final storage choice:

- `schema.sql`
- migration files, if this repository uses incremental migrations for the
  chosen schema
- `src/io/functions/iologindata_load_player.cpp`
- `src/io/functions/iologindata_save_player.cpp`

Rules:

- Keep this separate from combat behavior.
- Do not add frag-share or kill weighting migrations here.
- Define fallback behavior for missing stored values.

## Explicitly Out Of Scope For The Initial Chain

- Frag-share weighting.
- `player_kills.weight`.
- Debug talkactions such as PvP mark testing or reset commands.
- Wild growth caster-only cutting rule.
- Top-stack aggressive PvP rule, unless selected before Phase 3.
- New C++ world-type enum changes; map `expert-pvp` and `retro-pvp` onto the
  existing PvP enum unless a later PR proves a separate enum is required.
- Broad `WORLD_TYPE_PVP` behavior changes outside `worldType = "expert-pvp"`.

## Review And Revert Boundaries

Keep the existing commit groups separate when reviewing or reverting:

1. world type and component foundation;
2. player state, protocol profile gates, and persistence;
3. combat permission and delayed side effects;
4. player body blocking;
5. field ownership, damage, collision, and per-viewer visuals;
6. runtime situations and marks;
7. post-merge stabilization fixes.

The in-game matrix in the porting plan is required before release. A failure in
one group should be fixed or reverted without folding unrelated phases into the
same commit.
