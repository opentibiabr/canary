# Task Board reference module

The ZIP includes a separate Task Board reference extracted from the private Canary-based implementation. It is provided to clarify the packet readers/writers and give a practical migration example. It is not presented as a drop-in module for a custom 2014 TFS fork.

## Version status

- The module is a 15.23/15.25-era official-style reference carried into the current private codebase.
- Its non-empty Bounty, Weekly and Shop payloads have not yet been confirmed by a natural 15.30 wire capture.
- The layouts therefore retain `reference` status in `wire-manifest.json`.
- The 15.30-specific packet deltas remain authoritative in the protocol documentation; the module must not override them.

## Included files

### Core module

| File | Purpose |
|---|---|
| `constants.lua` | opcodes/actions, difficulty tables, reward/shop data and shared helpers |
| `wiki_monster_pools.lua` | generated creature pools used when building task choices |
| `state.lua` | KV-backed state, generation, progress and reward calculations |
| `windows.lua` | S2C `0x5B`, resource balance and Soulpit window writers |
| `handlers.lua` | C2S `0x5F` and `0xBA` readers/actions |
| `task_board.lua` | module entry point and file-loading order |

### Optional integration hooks

| File | Purpose |
|---|---|
| `task_board_kill.lua` | forwards monster kills into bounty/weekly progress |
| `on_send_add_creature.lua` | refreshes task windows when the player is fully attached to the client |
| `manage_task_board.lua` | god-only development commands for balances, rerolls and state testing |

The administrative talkaction is not required in production.

## Module registration

The Canary module loader uses decimal recvbyte values:

```xml
<!-- Task Board -->
<module type="recvbyte" byte="95" script="task_board/task_board.lua" />

<!-- Soul Seals / Soulpit -->
<module type="recvbyte" byte="186" script="task_board/task_board.lua" />
```

These are `C2S 0x5F` and `C2S 0xBA` respectively. A custom engine can route the same opcodes directly to equivalent C++ or Lua handlers instead of using Canary's module loader.

## Load order

The entry point loads files in this order:

1. `constants.lua`
2. `wiki_monster_pools.lua`
3. `state.lua`
4. `windows.lua`
5. `handlers.lua`

Preserve that order if converting the module to a different script system.

## Required engine capabilities

The reference assumes the following APIs or equivalent adapters:

- raw recvbyte dispatch for `0x5F` and `0xBA`;
- `NetworkMessage` readers/writers for byte, `u16`, `u32`, string and raw send-to-player;
- access to client protocol/build information for conditional tails;
- player-scoped persistent KV storage;
- monster race IDs and monster-type lookup;
- inventory item counting/removal and reward item/outfit/mount delivery;
- player level, experience, task-hunting points and resource-balance sending;
- creature-kill and post-login/player-attach callbacks;
- optional wheel-bonus getter/setter if the shop's wheel offer is retained.

The Lua method names are implementation details. During a TFS backport, map capabilities rather than copying the names blindly.

## Configuration used by the reference

The module reads these settings:

- `taskBoardLuaModuleEnabled`
- `taskBoardFreeThirdSlot`
- `taskBoardBountyTaskGoldTypeChance`
- `taskBoardBountyTaskSilverTypeChance`
- `taskBoardBountyPreferredChance`
- `taskBoardBountyUnwantedChance`
- `taskBoardBountyRerollCooldown`
- `taskBoardBountyTalismanBaseCost`
- `taskBoardBountyTalismanUpgradeCostIncrement`
- `taskBoardBountyTalismanDamageActivationChance`
- `taskBoardBountyTalismanLifeLeechActivationChance`

If the target engine has no config-key registry, these values can be moved into a Lua table or its existing configuration layer.

## Using the module only as a byte reference

For a protocol-only backport, start with:

- `handlers.lua` for the `0x5F`/`0xBA` C2S action boundaries;
- `windows.lua` for `0x5B` S2C field order;
- `constants.lua` for selector and resource IDs.

The state, reward, shop and progression logic can be replaced by the target server's own systems. Do not let unavailable gameplay APIs block the initial packet migration.

## Important 15.30 cautions

- Treat non-empty Task Board views as reference layouts until captured/tested with 15.30.
- Apply the 15.30 creature-icon record extension independently; the reference module predates that delta.
- Keep the 15.30 compact tactics, proficiency shaping and bestiary changes from the main documentation.
- Do not infer the `0x49` resource width from the module; that resource remains unresolved.
