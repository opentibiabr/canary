# Lua API

This file is auto-generated from Canary's C++ Lua bindings. Do not edit it manually.

## Generated Files

- `docs/lua-api/lua_api.d.lua`: Lua Language Server definition file for IntelliSense.
- `docs/lua-api/lua_api.md`: human-readable API reference.
- `docs/lua-api/lua_api.json`: structured API metadata for tooling.

## Type Aliases

- `CombatType`: `integer`
- `DistanceEffect`: `integer`
- `MagicEffect`: `integer`
- `ReturnValue`: `integer`
- `SoundEffect`: `integer`
- `TileState`: `integer`

## VSCode IntelliSense

Install the Lua extension for VSCode. The repository `.luarc.json` already adds `docs/lua-api` to the Lua workspace library and sets `workspace.preloadFileSize` high enough for `docs/lua-api/lua_api.d.lua`.

On Windows, run `tools/setup_vscode_lua_api.ps1` from the repository root to also update local `.vscode/settings.json` workspace settings. The helper keeps `.luarc.json` aligned and ignores generated build, cache, Visual Studio, and vcpkg directories through `workspace.ignoreDir`.

For manual setup, add `docs/lua-api` or `docs/lua-api/lua_api.d.lua` to the Lua Language Server workspace library. Canary updates these files during startup when `generateLuaApiDocs` is enabled in `config.lua`.

Some signatures are inferred from C++ bindings and may use `any`, `argN`, or `...` until explicit Lua API annotations are added.

## Manual Signature Hints

C++ Lua binding handlers and registration lines can override inferred signatures with a `/*** */` block immediately before the handler or `Lua::register*` call. Supported tags are `@class`, `@field`, `@function`, `@overload`, `@param`, and `@return`; functions without docblocks continue to use automatic inference.

## Classes

### Action

#### `Action:aid(aids: number)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:allowFarUse(value: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:blockWalls(value: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:checkFloor(value: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:id(ids: number)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:onUse(callback: fun(player: Player, item: Item, fromPosition: Position, target: Creature|Item, toPosition: Position, isHotkey: boolean): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:position(positions: Position, itemIdOrName: number|string)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:register()`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

#### `Action:uid(uids: number)`

- Returns: `boolean`
- Source: `src/lua/functions/events/action_functions.cpp`

### Bank

#### `Bank.balance(playerOrGuild: any, amount?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.credit(playerOrGuild: any, amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.debit(playerOrGuild: any, amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.deposit(player: Player, amount: number, destination?: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.hasBalance(playerOrGuild: any, amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.transfer(fromPlayerOrGuild: any, toPlayerOrGuild: any, amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.transferToGuild(fromPlayerOrGuild: any, toGuild: any, amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

#### `Bank.withdraw(player: Player, amount: number, source?: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/bank_functions.cpp`

### BatchUpdate

#### `BatchUpdate:add(container: Container)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/batch_update_functions.cpp`

#### `BatchUpdate.delete()`

- Returns: `nil`
- Source: `src/lua/functions/core/game/batch_update_functions.cpp`

### Charm

#### `Charm:castSound(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:category(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:chance(arg2?: table)`

- Returns: `boolean|table`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:damageType(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:description(arg2?: string)`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:effect(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:impactSound(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:messageCancel(arg2?: string)`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:messageServerLog(arg2?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:name(arg2?: string)`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:percentage(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:points(arg2?: table)`

- Returns: `boolean|table`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

#### `Charm:type(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/charm_functions.cpp`

### Combat

#### `Combat:addCondition(condition: Condition)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:execute(creature: Creature, variant: Variant)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:setArea(area: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:setCallback(key: any, callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:setFormula(type: any, mina: number, minb: number, maxa: number, maxb: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:setOrigin(origin: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

#### `Combat:setParameter(key: any, value: boolean|number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/combat_functions.cpp`

### Condition

#### `Condition:addDamage(rounds: number, time: number, value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:clone()`

- Returns: `nil|Condition`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition.delete()`

- Returns: `nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getEndTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getIcons()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getSubId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getTicks()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:getType()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:setFormula(mina: number, minb: number, maxa: number, maxb: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:setOutfit(outfit: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:setParameter(key: any, value: boolean|number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

#### `Condition:setTicks(ticks: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/condition_functions.cpp`

### Container

- Extends: `Item`

#### `Container:addItem(itemId: number|string, countOrSubType?: number, index?: number, flags?: number)`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:addItemEx(item: Item, index?: number, flags?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getCapacity()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getContentDescription(oldProtocol?: boolean)`

- Returns: `string|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getCorpseOwner()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getEmptySlots(recursive?: boolean)`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getItem(index: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getItemCountById(itemId: number|string, subType?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getItemHoldingCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getItems(recursive?: boolean)`

- Returns: `table|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getMaxCapacity()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:getSize()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:hasItem(item: Item)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:registerReward()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:removeAllItems(actor: Player, recursive: boolean)`

- Returns: `number|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

#### `Container:removeItemById(itemId: number|string, count: number, subType?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/container_functions.cpp`

### Creature

#### `Creature:addCondition(condition: Condition)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:addHealth(healthChange: number, combatType: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:attachEffectById(effectId: number, temporary?: boolean)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:canSee(position: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:canSeeCreature(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:changeSpeed(delta: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:clearIcons()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:detachEffectById(effectId: number)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getAttachedEffects()`

- Returns: `table`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getBaseSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getCondition(conditionType: any, conditionId?: any, subId?: number)`

- Returns: `nil|Condition`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getDamageMap()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getDescription(distance: number)`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getDirection()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getEvents(type: any)`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getFollowCreature()`

- Returns: `nil|Creature`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getHealth()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getIcon(key: string)`

- Returns: `boolean|table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getIcons()`

- Returns: `boolean|table`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getLight()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getMaster()`

- Returns: `nil|Creature`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getMaxHealth()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getOutfit()`

- Returns: `nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getParent()`

- Returns: `nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getPathTo(pos: Position, minTargetDist?: number, maxTargetDist?: number, fullPathSearch?: boolean, clearSight?: boolean, maxSearchDist?: number)`

- Returns: `boolean|table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getShader()`

- Returns: `string`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getSkull()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getSummons()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getTarget()`

- Returns: `nil|Creature`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getTile()`

- Returns: `nil|Tile`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getTypeName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getZoneType()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:getZones()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:hasBeenSummoned()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:hasCondition(conditionType: any, subId?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isCreature()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isDirectionLocked()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isHealthHidden()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isImmune(conditionOrConditionType: Condition)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isInGhostMode()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isMoveLocked()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:isRemoved()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:move(direction: Tile)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:registerEvent(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:reload()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:remove(forced?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:removeCondition(conditionType: any, conditionId?: any, subId?: number, force?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:removeIcon(key: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:say(text: string, type?: any, ghost?: boolean, target?: Creature, position?: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setDirection(direction: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setDirectionLocked(directionLocked: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setDropLoot(doDrop: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setFollowCreature(followedCreature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setHealth(health: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setHiddenHealth(hide: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setIcon(key: string, category: any, icon: any, value?: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setLight(color: number, level: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setMaster(master: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setMaxHealth(maxHealth: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setMoveLocked(moveLocked: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setOutfit(outfit: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setShader(shaderName: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setSkillLoss(skillLoss: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setSkull(skull: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setSpeed(speed: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:setTarget(target: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:teleportTo(position: Position, pushMovement?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

#### `Creature:unregisterEvent(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/creature_functions.cpp`

### CreatureEvent

#### `CreatureEvent:onAdvance(callback: fun(player: Player, skill: integer, oldLevel: integer, newLevel: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onDeath(callback: fun(creature: Creature, corpse: Item, lastHitKiller: Creature|nil, mostDamageKiller: Creature|nil, lastHitUnjustified: boolean, mostDamageUnjustified: boolean): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onExtendedOpcode(callback: fun(player: Player, opcode: integer, buffer: string))`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onHealthChange(callback: fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onKill(callback: fun(creature: Creature, target: Creature, lastHit: boolean))`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onLogin(callback: fun(player: Player): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onLogout(callback: fun(player: Player): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onManaChange(callback: fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onModalWindow(callback: fun(player: Player, modalWindowId: integer, buttonId: integer, choiceId: integer))`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onPrepareDeath(callback: fun(creature: Creature, killer: Creature|nil, realDamage: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onTextEdit(callback: fun(player: Player, item: Item, text: string): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:onThink(callback: fun(creature: Creature, interval: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:register()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

#### `CreatureEvent:type(callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/creature_event_functions.cpp`

### EventCallback

#### `EventCallback.register(...: any)`

- Returns: `boolean`
- Source: `src/lua/functions/events/event_callback_functions.cpp`

#### `EventCallback.type(...: any)`

- Returns: `boolean`
- Source: `src/lua/functions/events/event_callback_functions.cpp`

### EventsScheduler

#### `EventsScheduler.getEventSBossLoot(...: any)`

- Returns: `number`
- Source: `src/lua/functions/events/events_scheduler_functions.cpp`

#### `EventsScheduler.getEventSExp(...: any)`

- Returns: `number`
- Source: `src/lua/functions/events/events_scheduler_functions.cpp`

#### `EventsScheduler.getEventSLoot(...: any)`

- Returns: `number`
- Source: `src/lua/functions/events/events_scheduler_functions.cpp`

#### `EventsScheduler.getEventSSkill(...: any)`

- Returns: `number`
- Source: `src/lua/functions/events/events_scheduler_functions.cpp`

#### `EventsScheduler.getSpawnMonsterSchedule(...: any)`

- Returns: `number`
- Source: `src/lua/functions/events/events_scheduler_functions.cpp`

### Game

#### `Game.addInfluencedMonster(monster: Monster, stack?: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createBestiaryCharm(id: number)`

- Returns: `nil|Charm`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createContainer(itemIdOrName: number|string, size: number, position?: Position)`

- Returns: `Container|nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createItem(itemIdOrName: number|string, count?: number, position?: Position)`

- Returns: `Item|Item[]|nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createItemClassification(id: number)`

- Returns: `nil|ItemClassification`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createMonster(monsterName: string, position: Position, extended?: boolean, force?: boolean, master?: Creature)`

- Returns: `nil|Monster`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createMonsterType(name: string, variant?: string, alternateName?: string)`

- Returns: `nil|MonsterType`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createNpc(npcName: string, position: Position, extended?: boolean, force?: boolean)`

- Returns: `nil|Npc`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createNpcType(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createSoulPitMonster(monsterName: string, position: Position, stack?: number, extended?: boolean, force?: boolean, master?: Creature)`

- Returns: `nil|Monster`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.createTile(x: integer, y: integer, z: integer, isDynamic?: boolean)`

- Overloads:
  - `fun(position: Position, isDynamic?: boolean): Tile`
- Returns: `Tile`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.generateNpc(npcName: string)`

- Returns: `nil|Npc`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getAchievementInfoById(id: number)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getAchievementInfoByName(name: string)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getAchievements(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getBestiaryCharm(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getBestiaryList(arg1?: any)`

- Returns: `number|string|table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getBoostedBoss(...: any)`

- Returns: `string`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getBoostedCreature(...: any)`

- Returns: `string`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getClientVersion(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getDummies(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getEventCallbacks(...: any)`

- Returns: `string|table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getExperienceForLevel(level: number)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getFiendishMonsters(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getGameState(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getHouses(...: any)`

- Returns: `House[]`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getInfluencedMonsters(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getLadderIds(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getMonsterCount(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getMonsterTypeByName(name: string)`

- Returns: `boolean|MonsterType`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getMonsterTypes(...: any)`

- Returns: `table<string, MonsterType>`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getMonstersByBestiaryStars(stars: number)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getMonstersByRace(race: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getNormalizedGuildName(name: string)`

- Returns: `string|nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getNormalizedPlayerName(name: string, isNewName?: boolean)`

- Returns: `string|nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getNpcCount(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getOfflinePlayer(nameOrId: number|string)`

- Returns: `nil|Player`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getPlayerCount(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getPlayers(...: any)`

- Returns: `Player[]`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getPublicAchievements(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getReturnMessage(value: any)`

- Returns: `string`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getSecretAchievements(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getSoulCoreItems(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getSpectators(position: Position, multifloor?: boolean, onlyPlayer?: boolean, minRangeX?: integer, maxRangeX?: integer, minRangeY?: integer, maxRangeY?: integer)`

- Returns: `Creature[]`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getTalkActions(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getTowns(...: any)`

- Returns: `Town[]`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.getWorldType(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.hasDistanceEffect(effectId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.hasEffect(effectId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.loadMap(path: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.loadMapChunk(path: string, position: Position, remove: any)`

- Returns: `nil`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.makeFiendishMonster(monsterId: number)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.registerAchievement(id: number, name: string, description: string, secret: boolean, grade: number, points: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.reload(reloadType: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.removeFiendishMonster(monsterId: number)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.removeInfluencedMonster(monsterId: number)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.setGameState(state: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.setWorldType(type: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/game_functions.cpp`

#### `Game.startRaid(raidName: string)`

- Returns: `number`
- Source: `src/lua/functions/core/game/game_functions.cpp`

### GlobalEvent

#### `GlobalEvent:interval(interval: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onPeriodChange(callback: fun(lightState: integer, lightLevel: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onRecord(callback: fun(current: integer, old: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onSave(callback: fun(): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onShutdown(callback: fun(): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onStartup(callback: fun(): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onThink(callback: fun(interval: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:onTime(callback: fun(interval: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:register()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:time(time: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/global_event_functions.cpp`

#### `GlobalEvent:type(callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/global_event_functions.cpp`

### Group

#### `Group:getAccess()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:getFlags()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:getMaxDepotItems()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:getMaxVipEntries()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

#### `Group:hasFlag(flag: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/group_functions.cpp`

### Guild

#### `Guild:addRank(id: number, name: string, level: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getBankBalance()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getMembersOnline()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getMotd()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getRankById(id: number)`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:getRankByLevel(level: number)`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:setBankBalance(bankBalance: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

#### `Guild:setMotd(motd: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/guild_functions.cpp`

### House

#### `House:canEditAccessList(listId: number, player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getAccessList(listId: number)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getBedCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getBeds()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getDoorCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getDoorIdByPosition(position: Position)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getDoors()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getExitPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getItems()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getOwnerGuid()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getPrice()`

- Returns: `number`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getRent()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getTileCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getTiles()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:getTown()`

- Returns: `nil|Town`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:hasItemOnTile()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:hasNewOwnership(guid: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:isInvited(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:kickPlayer(player: Player, targetPlayer: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:setAccessList(listId: number, list: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:setHouseOwner(guid: number, updateDatabase?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:setNewOwnerGuid(guid: number, updateDatabase?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

#### `House:startTrade(player: Player, tradePartner: Player)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/house_functions.cpp`

### Imbuement

#### `Imbuement:getBase()`

- Returns: `table|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getCategory()`

- Returns: `table|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getCombatType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getElementDamage()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getItems()`

- Returns: `table|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

#### `Imbuement:isPremium()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/imbuement_functions.cpp`

### Item

#### `Item:actor(arg2?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:canBeMoved()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:canReceiveAutoCarpet()`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:clone()`

- Returns: `nil|Item`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:decay(decayId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getActionId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getArticle()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getAttribute(key: string)`

- Returns: `number|string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getCharges()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getClassification()`

- Returns: `boolean|number`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getContainer()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getCustomAttribute(key: number|string)`

- Returns: `nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getDescription(distance: number)`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getFluidType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getImbuement()`

- Returns: `boolean|table|Imbuement`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getImbuementSlot()`

- Returns: `boolean|number`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getOwnerId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getOwnerName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getParent()`

- Returns: `nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getPluralName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getShader()`

- Returns: `boolean|string`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getSubType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getTier()`

- Returns: `boolean|number`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getTile()`

- Returns: `nil|Tile`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getTopParent()`

- Returns: `nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getUniqueId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:getWeight()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:hasAttribute(key: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:hasOwner()`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:hasProperty(property: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:hasShader()`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:isContainer()`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:isInsideDepot(includeInbox?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:isItem()`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:isOwner(creatureOrCreatureId: number|Creature)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:moveTo(positionOrCylinder: Container|Player|Tile|Position, flags?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:moveToSlot(player: Player, slot: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:remove(count?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:removeAttribute(key: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:removeCustomAttribute(key: number|string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:serializeAttributes()`

- Returns: `nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setActionId(actionId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setAttribute(key: string, value: string|number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setCustomAttribute(key: number|string, value: number|string|boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setDuration(minDuration?: number, maxDuration?: number, decayTo?: number, showDuration?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setOwner(creatureOrCreatureId: number|Creature)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setShader(shaderName: string)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:setTier(tier: number)`

- Returns: `boolean`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:split(count?: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/items/item_functions.cpp`

#### `Item:transform(itemId: number|string, countOrSubType?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_functions.cpp`

### ItemClassification

#### `ItemClassification:addTier(id: number, core: number, regularPrice: number, convergenceFusionPrice: number, convergenceTransferPrice: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_classification_functions.cpp`

### ItemType

#### `ItemType:getAmmoType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getArmor()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getArticle()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getAttack()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getBaseSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getCapacity()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getCharges()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getDecayId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getDecayTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getDefense()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getDescription(count?: number)`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getDestroyId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getElementDamage()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getElementType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getElementalBond()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getExtraDefense()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getFluidSource()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getHitChance()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getImbuementSlot()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getPluralName()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getRequiredLevel()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getShootRange()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getShowDuration()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getSlotPosition()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getStackSize()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getTransformDeEquipId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getTransformEquipId()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getVocationString()`

- Returns: `string|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getWeaponType()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getWeight(count?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:getWrapableTo()`

- Returns: `number|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:hasSubType()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isBlocking()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isContainer()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isCorpse()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isDoor()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isFluidContainer()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isGroundTile()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isKey()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isMagicField()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isMovable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isMultiUse()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isPickupable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isPodium()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isQuiver()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isReadable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isRune()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isStackable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isStowable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isWeapon()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

#### `ItemType:isWritable()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/item_type_functions.cpp`

### KV

#### `KV.get(key: string|KV|boolean, forceLoad?: boolean)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `KV.keys(prefix?: KV|string)`

- Returns: `table`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `KV.remove(key: string|KV)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `KV.scoped(key: string|KV)`

- Returns: `KV`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `KV.set(key: string|KV, value: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

### Loot

#### `Loot:addChildLoot(loot: Loot)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setActionId(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setArmor(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setArticle(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setAttack(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setChance(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setDefense(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setExtraDefense(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setHitChance(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setId(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot:setIdFromName(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setMaxCount(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setMinCount(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setNameItem(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setShootRange(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setSubType(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot.setText(...: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

#### `Loot:setUnique(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/loot_functions.cpp`

### ModalWindow

#### `ModalWindow:addButton(id: number, text: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:addChoice(id: number, text: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getButtonCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getChoiceCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getDefaultEnterButton()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getDefaultEscapeButton()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getMessage()`

- Returns: `string|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:getTitle()`

- Returns: `string|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:hasPriority()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:sendToPlayer(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:setDefaultEnterButton(buttonId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:setDefaultEscapeButton(buttonId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:setMessage(text: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:setPriority(priority: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

#### `ModalWindow:setTitle(text: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/game/modal_window_functions.cpp`

### Monster

- Extends: `Creature`

#### `Monster:addAttackSpell(monsterspell: MonsterSpell)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:addDefense(defense: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:addDefenseSpell(monsterspell: MonsterSpell)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:addFriend(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:addReflectElement(type: any, percent: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:addTarget(creature: Creature, pushFront?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:changeTargetDistance(distance: number, duration?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:clearFiendishStatus()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:configureForgeSystem(stack?: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:criticalChance(critical?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:criticalDamage(damage?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getDefense(defense: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getForgeStack()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getFriendCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getFriendList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getMonsterForgeClassification()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getName()`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getRespawnType()`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getSpawnPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getTargetCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getTargetList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getTimeToChangeFiendish()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:getType()`

- Returns: `nil|MonsterType`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:hazard(hazard?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:hazardCrit(hazardCrit?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:hazardDamageBoost(hazardDamageBoost?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:hazardDefenseBoost(hazardDefenseBoost?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:hazardDodge(hazardDodge?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:immune(arg2?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isChallenged()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isDead()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isForgeable()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isFriend(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isIdle()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isInSpawnRange(position?: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isMonster()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isOpponent(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:isTarget(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:removeFriend(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:removeTarget(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:runHealth(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:searchTarget(searchType?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:selectTarget(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setForgeStack(stack: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setIdle(idle: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setMonsterForgeClassification(classication: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setName(name: string, nameDescription?: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setSpawnPosition(interval: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setTimeToChangeFiendish(endTime: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:setType(nameOrRaceId: number|string, restoreHealth: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

#### `Monster:soulPit(soulPit?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_functions.cpp`

### MonsterSpell

#### `MonsterSpell:castSound(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:impactSound(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setAttackValue(attack: number, skill: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setChance(chance: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatEffect(effect: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatLength(length: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatRadius(radius: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatShootEffect(effect: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatSpread(spread: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatType(arg1: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setCombatValue(min: number, max: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setConditionDamage(min: number, max: number, start: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setConditionDuration(duration: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setConditionSpeedChange(speed: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setConditionTickInterval(interval: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setConditionType(type: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setInterval(interval: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setNeedTarget(value: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setOutfitItem(effect: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setOutfitMonster(effect: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setRange(range: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setScriptName(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

#### `MonsterSpell:setType(type: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_spell_functions.cpp`

### MonsterType

#### `MonsterType:BestiaryCharmsPoints(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiaryFirstUnlock(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiaryLocations(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiaryOccurrence(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiarySecondUnlock(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiaryStars(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:Bestiaryclass(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:Bestiaryrace(race?: any)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:BestiarytoKill(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addAttack(monsterspell: MonsterSpell)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addDefense(monsterspell: MonsterSpell)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addElement(type: any, percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addHealing(type: any, percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addLoot(loot: Loot)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addReflect(type: any, percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addSound(soundId: SoundEffect)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addSummon(name: string, interval: number, chance: number, count?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:addVoice(sentence: string, interval: number, chance: number, yell: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:armor(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:baseSpeed(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:bossRace(raceId?: number, class?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:bossRaceId(raceId?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canPushCreatures(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canPushItems(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canSpawn(pos: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canWalkOnEnergy(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canWalkOnFire(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:canWalkOnPoison(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:changeTargetChance(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:changeTargetSpeed(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:combatImmunities(immunity?: string)`

- Returns: `boolean|table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:conditionImmunities(immunity?: string)`

- Returns: `boolean|table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:corpseId(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:critChance(arg2: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:deathSound(arg2?: any)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:defense(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:enemyFactions(faction?: any)`

- Returns: `boolean|table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:eventType(event: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:experience(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:faction(arg2?: any)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:familiar(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getAttackList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getCorpseId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getCreatureEvents()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getDefenseList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getElementList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getLoot()`

- Returns: `nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getMonstersByBestiaryStars(stars: any)`

- Returns: `table`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getMonstersByRace(race: any)`

- Returns: `table`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getSounds()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getSummonList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getTypeName()`

- Returns: `string`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:getVoices()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:health(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isAttackable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isBlockable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isConvinceable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isForgeCreature(arg2?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isHealthHidden(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isHostile(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isIllusionable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isPreyExclusive(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isPreyable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isPushable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isRewardBoss(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:isSummonable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:light(arg2?: number, arg3?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:manaCost(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:maxHealth(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:maxSummons(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:mitigation(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:name(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:nameDescription(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onAppear(callback: fun(monster: Monster, creature: Creature): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onDisappear(callback: fun(monster: Monster, creature: Creature): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onMove(callback: fun(monster: Monster, creature: Creature, oldPosition: Position, newPosition: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onPlayerAttack(callback: fun(monster: Monster, attacker: Player): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onSay(callback: fun(monster: Monster, creature: Creature, type: integer, message: string): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onSpawn(callback: fun(monster: Monster, position: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:onThink(callback: fun(monster: Monster, interval: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:outfit(outfit?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:race(race?: string)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:raceId(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:registerEvent(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:respawnTypeIsUnderground(arg2?: any)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:runHealth(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:soundChance(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:soundSpeedTicks(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:staticAttackChance(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:strategiesTargetDamage(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:strategiesTargetHealth(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:strategiesTargetNearest(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:strategiesTargetRandom(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:targetDistance(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:targetPreferMaster(arg2?: boolean)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:targetPreferPlayer(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:variant(arg2?: string)`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:yellChance(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

#### `MonsterType:yellSpeedTicks(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/monster/monster_type_functions.cpp`

### Mount

#### `Mount:getClientId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/mount_functions.cpp`

#### `Mount:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/mount_functions.cpp`

#### `Mount:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/mount_functions.cpp`

#### `Mount:getSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/mount_functions.cpp`

### MoveEvent

- Overloads:
  - `fun(): MoveEvent`

#### `MoveEvent:aid(ids: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:id(ids: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:level(lvl: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:magicLevel(lvl: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onAddItem(callback: fun(moveItem: Item, tileItemOrPosition: Item|Position, position?: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onDeEquip(callback: fun(player: Player, item: Item, slot: integer, isCheck: boolean): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onEquip(callback: fun(player: Player, item: Item, slot: integer, isCheck: boolean): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onRemoveItem(callback: fun(moveItem: Item, tileItemOrPosition: Item|Position, position?: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onStepIn(callback: fun(creature: Creature, item: Item|nil, position: Position, fromPosition: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:onStepOut(callback: fun(creature: Creature, item: Item|nil, position: Position, fromPosition: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:position(positions: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:premium(value: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:register()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:slot(slot: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:type(callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:uid(ids: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

#### `MoveEvent:vocation(vocName: string, showInDescription?: boolean, lastVoc?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/events/move_event_functions.cpp`

### NetworkMessage

#### `NetworkMessage:add16(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:add32(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:add64(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:add8(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addByte(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addDouble(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addItem(item: Item, player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addPosition(position: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addString(value: string, callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addU16(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addU32(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:addU64(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage.delete()`

- Returns: `nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getByte()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getString()`

- Returns: `string|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getU16()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getU32()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getU64()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:getUnreadBytes()`

- Returns: `number|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:reset()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:sendToPlayer(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

#### `NetworkMessage:skipBytes(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/core/network/network_message_functions.cpp`

### Npc

- Extends: `Creature`

#### `Npc:closeShopWindow(player: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:follow(player: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getCurrency()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getDistanceTo(uid: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getShopItem(itemId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:getSpeechBubble()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:isInTalkRange(position: Position, range?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:isInteractingWithPlayer(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:isMerchant(playerGUID: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:isNpc()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:isPlayerInteractingOnTopic(creature: Creature, topicId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:move(direction: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:openShopWindow(player: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:openShopWindowTable(player: Player, items: table)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:place(position: Position, extended?: boolean, force?: boolean)`

- Returns: `nil|Npc`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:removePlayerInteraction(creature: Creature)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:say(text: string, type?: any, ghost?: boolean, target?: Creature, position?: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:sellItem(player: Player, itemId: number, amount: number, subtype?: number, actionId?: number, ignoreCap?: boolean, inBackpacks?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:setCurrency(arg2: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:setMasterPos(pos: Position)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:setName(name: string)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:setPlayerInteraction(creature: Creature, topic: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:setSpeechBubble(speechBubble: number)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:turn(direction: any)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

#### `Npc:turnToCreature(creature: Creature, arg2: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_functions.cpp`

### NpcType

- Overloads:
  - `fun(name: string): NpcType`

#### `NpcType:addShopItem(shop: Shop)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:addSound(soundId: SoundEffect)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:addVoice(sentence: string, interval: number, chance: number, yell: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:baseSpeed(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:canPushCreatures(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:canPushItems(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:canSpawn(pos: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:currency(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:eventType(event: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:floorChange(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:getCreatureEvents()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:getSounds()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:getVoices()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:health(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:isPushable(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:light(arg2?: number, arg3?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:maxHealth(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:name(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:nameDescription(arg2?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onAppear(callback: fun(npc: Npc, creature: Creature): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onBuyItem(callback: fun(npc: Npc, player: Player, itemId: integer, subType: integer, amount: integer, ignore: boolean, inBackpacks: boolean, totalCost: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onCheckItem(callback: fun(npc: Npc, player: Player, itemId: integer, subType: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onCloseChannel(callback: fun(npc: Npc, player: Player): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onDisappear(callback: fun(npc: Npc, creature: Creature): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onMove(callback: fun(npc: Npc, creature: Creature, oldPosition: Position, newPosition: Position): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onSay(callback: fun(npc: Npc, creature: Creature, type: integer, message: string): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onSellItem(callback: fun(npc: Npc, player: Player, itemId: integer, subType: integer, amount: integer, ignore: boolean, itemName: string, totalCost: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:onThink(callback: fun(npc: Npc, interval: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:outfit(outfit?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:registerEvent(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:respawnTypeIsUnderground(arg2?: any)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType.respawnTypePeriod(arg2?: any)`

- Overloads:
  - `fun(name: string): NpcType`
- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:soundChance(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:soundSpeedTicks(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:speechBubble(arg2?: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:walkInterval(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:walkRadius(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:yellChance(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

#### `NpcType:yellSpeedTicks(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/npc/npc_type_functions.cpp`

### Party

#### `Party:addInvite(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:addMember(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:disband()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getInviteeCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getInvitees()`

- Returns: `Player[]|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getLeader()`

- Returns: `nil|Player`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getMemberCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getMembers()`

- Returns: `Player[]|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:getUniqueVocationsCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:isSharedExperienceActive()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:isSharedExperienceEnabled()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:removeInvite(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:removeMember(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:setLeader(player: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:setSharedExperience(active: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

#### `Party:shareExperience(experience: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/party_functions.cpp`

### Player

- Extends: `Creature`

- Overloads:
  - `fun(idOrGuid: integer): Player?`
  - `fun(name: string): Player?, integer?`
  - `fun(player: Player): Player?`

#### `Player:addAchievement(idOrName: number|string, sendMessage?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addAchievementPoints(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addAnimusMastery(monsterType: string)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addBadge(id: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addBestiaryKill(name: string, amount?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addBlessing(blessing: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addBosstiaryKill(name: string, amount?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addCharmPoints(charms: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addCustomOutfit(type: string, idOrName: number|string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addExperience(experience: number, sendText?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addFamiliar(lookType: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addForgeDustLevel(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addForgeDusts(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addItem(itemId: number|string, count?: number, canDropOnMap?: boolean, subType?: number, slot?: number, tier?: number)`

- Returns: `Item|Item[]|nil|false`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addItemBatchToPaginedContainer(container: Container, itemId: number, count: number, tier: number, flags: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addItemEx(item: Item, canDropOnMap?: boolean, indexOrSlot?: integer, flags?: integer)`

- Overloads:
  - `fun(item: Item, canDropOnMap?: false, index?: integer, flags?: integer): integer|false|nil`
  - `fun(item: Item, canDropOnMap: true, slot?: integer): integer|false|nil`
- Returns: `integer|false|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addItemStash(itemId: number, count: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addMana(manaChange: number, animationOnLoss?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addManaSpent(amount: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addMapMark(position: Position, type: number, description: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addMinorCharmEchoes(charms: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addMoney(money: number, flags?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addMount(mountIdOrMountName: number|string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addOfflineTrainingTime(time: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addOfflineTrainingTries(skillType: any, tries: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addOutfit(lookTypeOrName: number|string, addon: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addOutfitAddon(lookType: number, addon: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addPremiumDays(days: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addPreyCards(amount: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addSkillTries(skillType: any, tries: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addSoul(soulChange: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addTaskHuntingPoints(amount: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addTibiaCoins(coins: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addTitle(id: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addTransferableCoins(coins: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:addWeaponExperience(experience: number, itemId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:applyImbuementScroll(item: Item, scrollItem: Item)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:avatarTimer(value?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:calculateFlatDamageHealing()`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:canCast(spell: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:canLearnSpell(spellName: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:canReceiveLoot()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:changeName(newName: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:channelSay(speaker: Creature, type: any, text: string, channelId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:charmExpansion(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:clearAllImbuements(item: Item)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:clearSpellCooldowns(spenders: boolean, builder: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:closeForge()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:closeImbuementWindow()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:createTransactionSummary(type: number, amount: number, id?: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:fillHarmony()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:forgetSpell(spellName: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getAccountId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getAccountType()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getAchievementPoints()`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBackpack()`

- Returns: `nil|Container`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBankBalance()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBaseMagicLevel()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBaseMaxHealth()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBaseMaxMana()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBaseXpGain()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBlessingCount(index: number, storeCount?: boolean)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBossBonus(slotId: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBosstiaryKills(name: string)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getBosstiaryLevel(name: string)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getCapacity()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getCharmChance(charmId: any)`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getCharmMonsterType(arg1: any)`

- Returns: `nil|MonsterType`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getCharmTier(charmId: any)`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getClient()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getContainerById(id: number)`

- Returns: `nil|Container`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getContainerId(container: Container)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getContainerIndex(id: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getDeathPenalty()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getDepotChest(depotId: number, autoCreate?: boolean)`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getDepotLocker(depotId: number)`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getEffectiveSkillLevel(skillType: any)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getExperience()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getFaction()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getFamiliarLooktype()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getFightMode()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getForgeCores()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getForgeDustLevel()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getForgeDusts()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getForgeSlivers()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getFreeBackpackSlots()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getFreeCapacity()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGrindingXpBoost()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGroup()`

- Returns: `nil|Group`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGuid()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGuild()`

- Returns: `nil|Guild`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGuildLevel()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getGuildNick()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getHarmony()`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getHarmonyDamage(baseMin: integer, baseMax: integer)`

- Returns: `integer min, integer max`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getHazardSystemPoints()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getHouse()`

- Returns: `nil|House`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getIdleTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getInbox()`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getInstantSpells()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getIp()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getItemById(itemId: number|string, deepSearch: boolean, subType?: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getItemCount(itemId: number|string, subType?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getKills()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLastLoginSaved()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLastLogout()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLevel()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLivestreamViewers()`

- Returns: `string|table|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLivestreamViewersCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLootPouch()`

- Returns: `nil|Container`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLoyaltyBonus()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLoyaltyPoints()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getLoyaltyTitle()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMagicLevel()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMagicShieldCapacityFlat(useCharges: boolean)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMagicShieldCapacityPercent(useCharges: boolean)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMana()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getManaSpent()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMapShader()`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMaxMana()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMaxSoul()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getMoney()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getName()`

- Returns: `boolean|string`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getOfflineTrainingSkill()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getOfflineTrainingTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getParty()`

- Returns: `nil|Party`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getPremiumDays()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getPreyCards()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getPreyExperiencePercentage(raceId: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getPreyLootPercentage(raceId: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getPronoun()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getReward(rewardId: number, autoCreate?: boolean)`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getRewardList()`

- Returns: `table|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSex()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSkillLevel(skillType: any)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSkillPercent(skillType: any)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSkillTries(skillType: any)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSkullTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSlotBossId(slotId: number)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSlotItem(slot: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getSoul()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStamina()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStaminaXpBoost()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStashCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStashItemCount(itemId: number|string)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStorageValue(key: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getStoreInbox()`

- Returns: `boolean|nil|Item`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getTaskHuntingPoints()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getTibiaCoins()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getTitles()`

- Returns: `table`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getTown()`

- Returns: `nil|Town`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getTransferableCoins()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getVipDays()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getVipTime()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getVirtue()`

- Returns: `number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getVocation()`

- Returns: `nil|Vocation`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getVoucherXpBoost()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getWheelSpellAdditionalArea(spellname: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getWheelSpellAdditionalDuration(spellname: string)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getWheelSpellAdditionalTarget(spellname: string)`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getXpBoostPercent()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:getXpBoostTime()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasAchievement(idOrName: number|string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasAnimusMastery(monsterType: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasBlessing(blessing: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasChaseMode()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasFamiliar(lookType: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasGroupFlag(flag: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasLearnedSpell(spellName: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasMount(mountIdOrMountName: number|string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasOutfit(lookType: number, addon?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:hasSecureMode()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:instantSkillWOD(name: string, value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isLivestreamViewer()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isMonsterBestiaryUnlocked(raceId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isMonsterPrey(raceId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isOffline()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isPlayer()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isPromoted()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isPzLocked()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isTraining()`

- Returns: `boolean|number`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isUIExhausted(time: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:isVip()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:kv()`

- Returns: `boolean|KV`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:learnSpell(spellName: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:onThinkWheelOfDestiny(force?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:openChannel(channelId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:openForge()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:openImbuementWindow(action?: any, item?: Item)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:openMarket()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:openStash(isNpc: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:popupFYI(message: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:preyThirdSlot(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:reloadData()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeAchievement(idOrName: number|string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeAchievementPoints(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeAnimusMastery(monsterType: string)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeBlessing(blessing: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeCustomOutfit(type: string, idOrName: number|string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeExperience(experience: number, sendText?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeFamiliar(lookType: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeForgeDustLevel(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeForgeDusts(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeGroupFlag(flag: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeIconBakragore(iconType?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeItem(itemId: number|string, count: number, subType?: number, ignoreEquipped?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeMoney(money: number, flags?: number, useBank?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeMount(mountIdOrMountName: number|string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeOfflineTrainingTime(time: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeOutfit(lookType: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeOutfitAddon(lookType: number, addon: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removePremiumDays(days: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removePreyStamina(amount: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeReward(rewardId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeStashItem(itemId: number|string, count: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeTaskHuntingPoints(amount: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeTibiaCoins(coins: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeTransferableAndTibiaCoins(coins: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:removeTransferableCoins(coins: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:resetCharmsBestiary()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:resetOldCharms()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:revelationStageWOD(name?: string, set?: boolean|number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:save()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendAmbientSoundEffect(id: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendBlessStatus()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendBosstiaryCooldownTimer()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendChannelMessage(author: string, text: string, type: any, channelId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendContainer(container: Container)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendCreatureAppear(isLogin: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendDoubleSoundEffect(mainSoundId: SoundEffect, secondarySoundId: SoundEffect, actor?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendHouseWindow(house: House, listId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendIconBakragore(iconType: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendInventory()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendLootStats(item: Item, count: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendMusicSoundEffect(id: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendOutfitWindow()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendPrivateMessage(speaker: Player, text: string, type?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendSingleSoundEffect(soundId: SoundEffect, actor?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendSpellCooldown(spellId: number, time: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendSpellGroupCooldown(groupId: any, time: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendTextMessage(type: any, text: string, position?: number|Position, primaryValue?: number, primaryColor?: any, secondaryValue?: number, secondaryColor?: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendTutorial(tutorialId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:sendUpdateContainer(container: Container)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setAccountType(accountType: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setBankBalance(bankBalance: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setBaseXpGain(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setBossPoints(arg2: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setCapacity(capacity: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setCurrentTitle(id: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setDailyReward(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setEditHouse(house: House, listId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setFaction(factionId: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setFamiliarLooktype(lookType: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setForgeDusts(arg2: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGhostMode(enabled: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGrindingXpBoost(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGroup(group: Group)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGroupFlag(flag: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGuild(guild: Guild)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGuildLevel(level: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setGuildNick(nick: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setHazardSystemPoints(amount: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setKills(kills: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setLevel(level: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setLivestreamViewers(data: table)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setLoyaltyBonus(amount: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setLoyaltyTitle(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setMagicLevel(level: number, manaSpent?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setMapShader(shaderName: string, temporary?: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setMaxMana(maxMana: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setOfflineTrainingSkill(skillId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setPronoun(newPronoun: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setRemoveBossTime(arg2: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSerene(value: boolean, ticks: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSex(newSex: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSkillLevel(skillType: any, level: number, tries?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSkullTime(skullTime: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSpecialContainersAvailable(stashMenu: boolean, marketMenu: boolean, depotSearchMenu: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setSpeed(speed: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setStamina(stamina: number)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setStaminaXpBoost(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setStorageValue(key: number, value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setTown(town: Town)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setTraining(value: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setVirtue(virtue: any)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setVocation(idOrNameOrUserdata: number|string|Vocation)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setVoucherXpBoost(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setXpBoostPercent(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:setXpBoostTime(timeLeft: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:showTextDialog(idOrNameOrUserdata: number|string|Item, text?: string, canWrite?: boolean, length?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:takeScreenshot(screenshotType: any, skillId?: number, skillLevel?: number, achievementName?: string, raceId?: number, bestiaryStep?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:taskHuntingThirdSlot(arg2?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:unlockAllCharmRunes()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:updateConcoction(itemId: number, timeLeft: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:updateFood(itemId: number, timeLeft: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:updateKillTracker(creature: Creature, corpse: Container)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:updateSupplyTracker(item: Item)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:updateUIExhausted(exhaustionTime: number)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:upgradeSpellsWOD(name?: string, add?: boolean)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

#### `Player:wheelUnlockScroll(scrollName: string)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/player/player_functions.cpp`

### Position

- Fields:
  - `x integer`
  - `y integer`
  - `z integer`
  - `stackpos integer`

- Overloads:
  - `fun(): Position`
  - `fun(x?: integer, y?: integer, z?: integer, stackpos?: integer): Position`
  - `fun(position: Position): Position`

#### `Position:getDistance(positionEx: Position)`

- Returns: `number`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:getPathTo(pos: Position, minTargetDist?: number, maxTargetDist?: number, fullPathSearch?: boolean, clearSight?: boolean, maxSearchDist?: number)`

- Returns: `boolean|table`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:getTile()`

- Returns: `nil|Tile`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:getZones()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:isSightClear(positionEx: Position, sameFloor?: boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:removeMagicEffect(magicEffect: MagicEffect, player?: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:sendDistanceEffect(positionEx: Position, distanceEffect: DistanceEffect, player?: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:sendDoubleSoundEffect(mainSoundId: SoundEffect, secondarySoundId: SoundEffect, actor?: Creature)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:sendMagicEffect(magicEffect: MagicEffect, player?: Player)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:sendSingleSoundEffect(soundId: SoundEffect, actor?: Creature)`

- Returns: `boolean`
- Source: `src/lua/functions/map/position_functions.cpp`

#### `Position:toString()`

- Returns: `string`
- Source: `src/lua/functions/map/position_functions.cpp`

### Result

#### `Result.free(resultId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/result_functions.cpp`

#### `Result.getNumber(resultId: number, column: string)`

- Returns: `number|false`
- Source: `src/lua/functions/core/libs/result_functions.cpp`

#### `Result.getStream(resultId: number, column: string)`

- Returns: `string|false stream, number? length`
- Source: `src/lua/functions/core/libs/result_functions.cpp`

#### `Result.getString(resultId: number, column: string)`

- Returns: `string|false`
- Source: `src/lua/functions/core/libs/result_functions.cpp`

#### `Result.next(resultId: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/result_functions.cpp`

### Shop

#### `Shop:addChildShop(shop: Shop)`

- Returns: `nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setBuyPrice(price: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setCount(count: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setId(id: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setIdFromName(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setNameItem(name: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setSellPrice(chance: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setStorageKey(storage: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

#### `Shop:setStorageValue(value: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/npc/shop_functions.cpp`

### Spdlog

#### `Spdlog.debug(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `Spdlog.error(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `Spdlog.info(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `Spdlog.warn(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

### Spell

#### `Spell:allowFarUse(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:allowOnSelf(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:blockWalls(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:castSound(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:charges(charges?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:checkFloor(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:cooldown(cooldown?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:group(primaryGroup?: string, secondaryGroup?: string)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:groupCooldown(primaryGroupCd?: number, secondaryGroupCd?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:hasParams(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:hasPlayerNameParam(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:id(id?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:impactSound(arg2?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isAggressive(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isBlocking(blockingSolid?: boolean, blockingCreature?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isBlockingWalls(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isEnabled(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isPremium(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:isSelfTarget(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:level(lvl?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:magicLevel(lvl?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:mana(mana?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:manaPercent(percent?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:monkSpellType(type?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:name(name?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:needCasterTargetOrDirection(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:needDirection(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:needLearn(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:needTarget(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:needWeapon(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:onCastSpell(callback: fun(creature: Creature, variant: Variant, isHotkey?: boolean): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:range(range?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:register()`

- Returns: `boolean`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:runeId(id?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:setPzLocked(value?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:soul(soul?: number)`

- Returns: `boolean|number|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:vocation(vocation: any)`

- Returns: `boolean|table|nil|Spell`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

#### `Spell:words(words?: string, separator?: string)`

- Returns: `boolean|string|nil`
- Source: `src/lua/functions/creatures/combat/spell_functions.cpp`

### TalkAction

#### `TalkAction:getDescription()`

- Returns: `boolean|string`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:getGroupType()`

- Returns: `boolean|number`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:getName()`

- Returns: `boolean|string`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:groupType(groupType: string|number)`

- Returns: `boolean`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:onSay(callback: fun(player: Player, words: string, param: string, type: integer): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:register()`

- Returns: `boolean`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:separator(sep: string)`

- Returns: `boolean`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

#### `TalkAction:setDescription(arg2: string)`

- Returns: `boolean`
- Source: `src/lua/functions/events/talk_action_functions.cpp`

### Teleport

- Extends: `Item`

#### `Teleport:getDestination()`

- Returns: `nil|Position`
- Source: `src/lua/functions/map/teleport_functions.cpp`

#### `Teleport:setDestination(position: Position)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/teleport_functions.cpp`

### Tile

#### `Tile:addItem(itemId: number|string, countOrSubType?: number, flags?: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:addItemEx(item: Item, flags?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getBottomCreature()`

- Returns: `nil|Creature`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getBottomVisibleCreature(creature: Creature)`

- Returns: `nil|Creature`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getCreatureCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getCreatures()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getDownItemCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getFieldItem()`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getGround()`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getHouse()`

- Returns: `nil|House`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItemById(itemId: number|string, subType?: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItemByTopOrder(topOrder: number)`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItemByType(itemType: any)`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItemCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItemCountById(itemId: number|string, subType?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getItems()`

- Returns: `table|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getPosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getThing(index: number)`

- Returns: `nil|Creature|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getThingCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getThingIndex(thing: any)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopCreature()`

- Returns: `nil|Creature`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopDownItem()`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopItemCount()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopTopItem()`

- Returns: `nil|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopVisibleCreature(creature: Creature)`

- Returns: `nil|Creature`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:getTopVisibleThing(creature: Creature)`

- Returns: `nil|Creature|Item`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:hasFlag(flag: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:hasProperty(property: any, item?: Item)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:queryAdd(thing: any, flags?: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

#### `Tile:sweep(actor: Player)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/map/tile_functions.cpp`

### Town

#### `Town:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/map/town_functions.cpp`

#### `Town:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/map/town_functions.cpp`

#### `Town:getTemplePosition()`

- Returns: `nil|Position`
- Source: `src/lua/functions/map/town_functions.cpp`

### Variant

#### `Variant:getNumber()`

- Returns: `number`
- Source: `src/lua/functions/creatures/combat/variant_functions.cpp`

#### `Variant:getPosition()`

- Returns: `Position`
- Source: `src/lua/functions/creatures/combat/variant_functions.cpp`

#### `Variant:getString()`

- Returns: `string`
- Source: `src/lua/functions/creatures/combat/variant_functions.cpp`

### Vocation

#### `Vocation:getAttackSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getBaseAttackSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getBaseId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getBaseSpeed()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getCapacityGain()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getClientId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getDemotion()`

- Returns: `nil|Vocation`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getDescription()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getHealthGain()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getHealthGainAmount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getHealthGainTicks()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getId()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getManaGain()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getManaGainAmount()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getManaGainTicks()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getMaxSoul()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getName()`

- Returns: `string|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getPromotion()`

- Returns: `nil|Vocation`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getRequiredManaSpent(magicLevel: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getRequiredSkillTries(skillType: any, skillLevel: number)`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

#### `Vocation:getSoulGainTicks()`

- Returns: `number|nil`
- Source: `src/lua/functions/creatures/player/vocation_functions.cpp`

### Weapon

#### `Weapon:action(callback: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:ammoType(type: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:attack(atk: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:breakChance(percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:charges(charges?: number, showCharges?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:damage(damage?: number, max?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:decayTo(arg2?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:defense(defense?: number, extraDefense?: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:duration(duration?: number, showDuration?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:element(combatType: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:extraElement(atk: number, combatType: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:health(health: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:healthPercent(percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:hitChance(chance: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:id(id: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:level(lvl: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:magicLevel(lvl: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:mana(mana: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:manaPercent(percent: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:maxHitChance(max: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:onUseWeapon(callback: fun(player: Player, variant: Variant): boolean)`

- Returns: `boolean`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:premium(value: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:range(range: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:register()`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:shootType(type: any)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:slotType(slot: string)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:soul(soul: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:transformDeEquipTo(itemId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:transformEquipTo(itemId: number)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:vocation(vocName: string, showInDescription?: boolean, lastVoc?: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

#### `Weapon:wieldUnproperly(value: boolean)`

- Returns: `boolean|nil`
- Source: `src/lua/functions/items/weapon_functions.cpp`

### Webhook

#### `Webhook.sendMessage(title: string, message: string, color: number, url: any)`

- Returns: `nil`
- Source: `src/lua/functions/core/network/webhook_functions.cpp`

### Zone

#### `Zone:addArea(fromPos: Position, toPos: Position)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone.getAll(...: any)`

- Returns: `table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone.getByName(name: string)`

- Returns: `nil|Zone`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone.getByPosition(pos: Position)`

- Returns: `table|nil`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getCreatures()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getItems()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getMonsters()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getName()`

- Returns: `boolean|string`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getNpcs()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getPlayers()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getPositions()`

- Returns: `boolean|table`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:getRemoveDestination()`

- Returns: `Position`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:refresh()`

- Returns: `nil`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:removeMonsters()`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:removeNpcs()`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:removePlayers()`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:setMonsterVariant(variant: string)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:setRemoveDestination(pos: Position)`

- Returns: `nil`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

#### `Zone:subtractArea(fromPos: Position, toPos: Position)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/zone_functions.cpp`

### configManager

#### `configManager.getBoolean(key: any)`

- Returns: `boolean`
- Source: `src/lua/functions/core/game/config_functions.cpp`

#### `configManager.getFloat(key: any, shouldRound: boolean)`

- Returns: `number`
- Source: `src/lua/functions/core/game/config_functions.cpp`

#### `configManager.getNumber(key: any)`

- Returns: `number`
- Source: `src/lua/functions/core/game/config_functions.cpp`

#### `configManager.getString(key: any)`

- Returns: `string`
- Source: `src/lua/functions/core/game/config_functions.cpp`

### db

#### `db.asyncQuery(query: string, callback?: fun(success: boolean))`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.asyncStoreQuery(query: string, callback?: fun(resultId: number|false))`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.escapeBlob(value: string, length: number)`

- Returns: `string`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.escapeString(value: string)`

- Returns: `string`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.lastInsertId(...: any)`

- Returns: `number`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.query(query: string)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.storeQuery(query: string)`

- Returns: `boolean|number`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

#### `db.tableExists(tableName: string)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/db_functions.cpp`

### kv

#### `kv.get(key: string|KV|boolean, forceLoad?: boolean)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `kv.keys(prefix?: KV|string)`

- Returns: `table`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `kv.remove(key: string|KV)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `kv.scoped(key: string|KV)`

- Returns: `KV`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

#### `kv.set(key: string|KV, value: number)`

- Returns: `boolean`
- Source: `src/lua/functions/core/libs/kv_functions.cpp`

### logger

#### `logger.debug(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `logger.error(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `logger.info(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `logger.trace(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

#### `logger.warn(text: string)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/logger_functions.cpp`

### metrics

#### `metrics.addCounter(name: string, value: number, attributes: any)`

- Returns: `nil`
- Source: `src/lua/functions/core/libs/metrics_functions.cpp`
