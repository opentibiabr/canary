# Lua API

## Action
### aid(...)
Source: src/lua/functions/events/action_functions.cpp

### allowFarUse(arg2: boolean)
Source: src/lua/functions/events/action_functions.cpp

### blockWalls(arg2: boolean)
Source: src/lua/functions/events/action_functions.cpp

### checkFloor(arg2: boolean)
Source: src/lua/functions/events/action_functions.cpp

### id(...)
Source: src/lua/functions/events/action_functions.cpp

### onUse(...)
Source: src/lua/functions/events/action_functions.cpp

### position(...)
Source: src/lua/functions/events/action_functions.cpp

### register(...)
Source: src/lua/functions/events/action_functions.cpp

### uid(...)
Source: src/lua/functions/events/action_functions.cpp

## Bank
### balance(bank: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### credit(bank: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### debit(bank: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### deposit(player: Player)
Source: src/lua/functions/core/game/bank_functions.cpp

### hasBalance(bank: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### transfer(source: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### transferToGuild(source: Bank)
Source: src/lua/functions/core/game/bank_functions.cpp

### withdraw(player: Player)
Source: src/lua/functions/core/game/bank_functions.cpp

## Charm
### __eq()
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### castSound(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### category(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### chance(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### damageType(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### description(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### effect(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### impactSound(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### messageCancel(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### messageServerLog(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### name(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### percentage(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### points(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

### type(...)
Source: src/lua/functions/creatures/monster/charm_functions.cpp

## Combat
### __eq()
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### addCondition(combat: Combat)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### execute(...)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### setArea(...)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### setCallback(...)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### setFormula(...)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### setOrigin(arg2: CombatOrigin)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

### setParameter(...)
Source: src/lua/functions/creatures/combat/combat_functions.cpp

## Condition
### __eq()
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### __gc(conditionPtr: std::shared_ptr<Condition>)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### addDamage(rounds: number, time: number, value: number)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### clone(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### delete(conditionPtr: std::shared_ptr<Condition>)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getEndTime(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getIcons(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getSubId(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getTicks(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### getType(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### setFormula(mina: number, minb: number, maxa: number, maxb: number)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### setOutfit(arg2: Outfit)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### setParameter(...)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

### setTicks(ticks: number)
Source: src/lua/functions/creatures/combat/condition_functions.cpp

## Container
### __eq()
Source: src/lua/functions/items/container_functions.cpp

### addItem(...)
Source: src/lua/functions/items/container_functions.cpp

### addItemEx(...)
Source: src/lua/functions/items/container_functions.cpp

### getCapacity(...)
Source: src/lua/functions/items/container_functions.cpp

### getContentDescription(...)
Source: src/lua/functions/items/container_functions.cpp

### getCorpseOwner(...)
Source: src/lua/functions/items/container_functions.cpp

### getEmptySlots(...)
Source: src/lua/functions/items/container_functions.cpp

### getItem(...)
Source: src/lua/functions/items/container_functions.cpp

### getItemCountById(...)
Source: src/lua/functions/items/container_functions.cpp

### getItemHoldingCount(...)
Source: src/lua/functions/items/container_functions.cpp

### getItems(...)
Source: src/lua/functions/items/container_functions.cpp

### getMaxCapacity(...)
Source: src/lua/functions/items/container_functions.cpp

### getSize(...)
Source: src/lua/functions/items/container_functions.cpp

### hasItem(...)
Source: src/lua/functions/items/container_functions.cpp

### registerReward(...)
Source: src/lua/functions/items/container_functions.cpp

## Creature
### __eq()
Source: src/lua/functions/creatures/creature_functions.cpp

### addCondition(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### addHealth(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### attachEffectById(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### canSee(arg2: Position)
Source: src/lua/functions/creatures/creature_functions.cpp

### canSeeCreature(otherCreature: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### changeSpeed(creature: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### clearIcons(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### detachEffectById(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getAttachedEffects(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getBaseSpeed(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getCondition(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getDamageMap(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getDescription(distance: number)
Source: src/lua/functions/creatures/creature_functions.cpp

### getDirection(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getEvents(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getFollowCreature(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getHealth(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getIcon(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getIcons(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getLight(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getMaster(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getMaxHealth(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getOutfit(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getParent(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getPathTo(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getPosition(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getShader(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getSkull(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getSpeed(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getSummons(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getTarget(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getTile(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getTypeName(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getZoneType(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### getZones(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### hasBeenSummoned(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### hasCondition(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isCreature(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isDirectionLocked(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isHealthHidden(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isImmune(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isInGhostMode(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isMoveLocked(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### isRemoved(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### move(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### registerEvent(arg2: string)
Source: src/lua/functions/creatures/creature_functions.cpp

### reload(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### remove(creaturePtr: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### removeCondition(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### removeIcon(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### say(arg6: Position)
Source: src/lua/functions/creatures/creature_functions.cpp

### setDirection(arg2: Direction)
Source: src/lua/functions/creatures/creature_functions.cpp

### setDirectionLocked(arg2: boolean)
Source: src/lua/functions/creatures/creature_functions.cpp

### setDropLoot(arg2: boolean)
Source: src/lua/functions/creatures/creature_functions.cpp

### setFollowCreature(followCreature: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### setHealth(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setHiddenHealth(arg2: boolean)
Source: src/lua/functions/creatures/creature_functions.cpp

### setIcon(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setLight(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setMaster(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setMaxHealth(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setMoveLocked(arg2: boolean)
Source: src/lua/functions/creatures/creature_functions.cpp

### setOutfit(outfit: Outfit_t)
Source: src/lua/functions/creatures/creature_functions.cpp

### setShader(...)
Source: src/lua/functions/creatures/creature_functions.cpp

### setSkillLoss(arg2: boolean)
Source: src/lua/functions/creatures/creature_functions.cpp

### setSkull(arg2: Skulls_t)
Source: src/lua/functions/creatures/creature_functions.cpp

### setSpeed(creature: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### setTarget(target: Creature)
Source: src/lua/functions/creatures/creature_functions.cpp

### teleportTo(arg2: Position)
Source: src/lua/functions/creatures/creature_functions.cpp

### unregisterEvent(arg2: string)
Source: src/lua/functions/creatures/creature_functions.cpp

## CreatureEvent
### onAdvance(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onDeath(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onExtendedOpcode(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onHealthChange(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onKill(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onLogin(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onLogout(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onManaChange(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onModalWindow(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onPrepareDeath(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onTextEdit(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### onThink(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### register(...)
Source: src/lua/functions/events/creature_event_functions.cpp

### type(typeName: string)
Source: src/lua/functions/events/creature_event_functions.cpp

## EventCallback
### register(...)
Source: src/lua/functions/events/event_callback_functions.cpp

### type(...)
Source: src/lua/functions/events/event_callback_functions.cpp

## EventsScheduler
### getEventSBossLoot(...)
Source: src/lua/functions/events/events_scheduler_functions.cpp

### getEventSExp(...)
Source: src/lua/functions/events/events_scheduler_functions.cpp

### getEventSLoot(...)
Source: src/lua/functions/events/events_scheduler_functions.cpp

### getEventSSkill(...)
Source: src/lua/functions/events/events_scheduler_functions.cpp

### getSpawnMonsterSchedule(...)
Source: src/lua/functions/events/events_scheduler_functions.cpp

## Game
### addInfluencedMonster(...)
Source: src/lua/functions/core/game/game_functions.cpp

### createBestiaryCharm(...)
Source: src/lua/functions/core/game/game_functions.cpp

### createContainer(arg1: number, size: number)
Source: src/lua/functions/core/game/game_functions.cpp

### createItem(arg1: number)
Source: src/lua/functions/core/game/game_functions.cpp

### createItemClassification(arg1: number)
Source: src/lua/functions/core/game/game_functions.cpp

### createMonster(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

### createMonsterType(name: string)
Source: src/lua/functions/core/game/game_functions.cpp

### createNpc(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

### createNpcType(...)
Source: src/lua/functions/core/game/game_functions.cpp

### createSoulPitMonster(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

### createTile(arg1: Position)
Source: src/lua/functions/core/game/game_functions.cpp

### generateNpc(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

### getAchievementInfoById(id: number)
Source: src/lua/functions/core/game/game_functions.cpp

### getAchievementInfoByName(name: string)
Source: src/lua/functions/core/game/game_functions.cpp

### getAchievements(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getBestiaryCharm(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getBestiaryList(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getBoostedBoss(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getBoostedCreature(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getClientVersion(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getDummies(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getEventCallbacks(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getExperienceForLevel(level: number)
Source: src/lua/functions/core/game/game_functions.cpp

### getFiendishMonsters(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getGameState(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getHouses(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getInfluencedMonsters(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getLadderIds(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getMonsterCount(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getMonsterTypeByName(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getMonsterTypes(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getMonstersByBestiaryStars(stars: number)
Source: src/lua/functions/core/game/game_functions.cpp

### getMonstersByRace(race: BestiaryType_t)
Source: src/lua/functions/core/game/game_functions.cpp

### getNormalizedGuildName(name: string)
Source: src/lua/functions/core/game/game_functions.cpp

### getNormalizedPlayerName(name: string)
Source: src/lua/functions/core/game/game_functions.cpp

### getNpcCount(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getOfflinePlayer(id: number)
Source: src/lua/functions/core/game/game_functions.cpp

### getPlayerCount(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getPlayers(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getPublicAchievements(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getReturnMessage(value: ReturnValue)
Source: src/lua/functions/core/game/game_functions.cpp

### getSecretAchievements(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getSoulCoreItems(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getSpectators(arg1: Position)
Source: src/lua/functions/core/game/game_functions.cpp

### getTalkActions(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getTowns(...)
Source: src/lua/functions/core/game/game_functions.cpp

### getWorldType(...)
Source: src/lua/functions/core/game/game_functions.cpp

### hasDistanceEffect(effectId: number)
Source: src/lua/functions/core/game/game_functions.cpp

### hasEffect(effectId: number)
Source: src/lua/functions/core/game/game_functions.cpp

### loadMap(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

### loadMapChunk(arg1: string, arg2: Position)
Source: src/lua/functions/core/game/game_functions.cpp

### makeFiendishMonster(...)
Source: src/lua/functions/core/game/game_functions.cpp

### registerAchievement(...)
Source: src/lua/functions/core/game/game_functions.cpp

### reload(reloadType: Reload_t)
Source: src/lua/functions/core/game/game_functions.cpp

### removeFiendishMonster(monsterId: number)
Source: src/lua/functions/core/game/game_functions.cpp

### removeInfluencedMonster(monsterId: number)
Source: src/lua/functions/core/game/game_functions.cpp

### setGameState(state: GameState_t)
Source: src/lua/functions/core/game/game_functions.cpp

### setWorldType(type: WorldType_t)
Source: src/lua/functions/core/game/game_functions.cpp

### startRaid(arg1: string)
Source: src/lua/functions/core/game/game_functions.cpp

## GlobalEvent
### interval(arg2: number)
Source: src/lua/functions/events/global_event_functions.cpp

### onPeriodChange(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onRecord(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onSave(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onShutdown(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onStartup(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onThink(...)
Source: src/lua/functions/events/global_event_functions.cpp

### onTime(...)
Source: src/lua/functions/events/global_event_functions.cpp

### register(...)
Source: src/lua/functions/events/global_event_functions.cpp

### time(timer: string)
Source: src/lua/functions/events/global_event_functions.cpp

### type(typeName: string)
Source: src/lua/functions/events/global_event_functions.cpp

## Group
### __eq()
Source: src/lua/functions/creatures/player/group_functions.cpp

### getAccess(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### getFlags(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### getMaxDepotItems(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### getMaxVipEntries(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/player/group_functions.cpp

### hasFlag(arg2: number)
Source: src/lua/functions/creatures/player/group_functions.cpp

## Guild
### __eq()
Source: src/lua/functions/creatures/player/guild_functions.cpp

### addRank(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getBankBalance(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getMembersOnline(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getMotd(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getRankById(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### getRankByLevel(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### setBankBalance(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

### setMotd(...)
Source: src/lua/functions/creatures/player/guild_functions.cpp

## House
### __eq()
Source: src/lua/functions/map/house_functions.cpp

### canEditAccessList(...)
Source: src/lua/functions/map/house_functions.cpp

### getAccessList(...)
Source: src/lua/functions/map/house_functions.cpp

### getBedCount(...)
Source: src/lua/functions/map/house_functions.cpp

### getBeds(...)
Source: src/lua/functions/map/house_functions.cpp

### getDoorCount(...)
Source: src/lua/functions/map/house_functions.cpp

### getDoorIdByPosition(...)
Source: src/lua/functions/map/house_functions.cpp

### getDoors(...)
Source: src/lua/functions/map/house_functions.cpp

### getExitPosition(...)
Source: src/lua/functions/map/house_functions.cpp

### getId(...)
Source: src/lua/functions/map/house_functions.cpp

### getItems(...)
Source: src/lua/functions/map/house_functions.cpp

### getName(...)
Source: src/lua/functions/map/house_functions.cpp

### getOwnerGuid(...)
Source: src/lua/functions/map/house_functions.cpp

### getPrice(...)
Source: src/lua/functions/map/house_functions.cpp

### getRent(...)
Source: src/lua/functions/map/house_functions.cpp

### getTileCount(...)
Source: src/lua/functions/map/house_functions.cpp

### getTiles(...)
Source: src/lua/functions/map/house_functions.cpp

### getTown(...)
Source: src/lua/functions/map/house_functions.cpp

### hasItemOnTile(...)
Source: src/lua/functions/map/house_functions.cpp

### hasNewOwnership(...)
Source: src/lua/functions/map/house_functions.cpp

### isInvited(...)
Source: src/lua/functions/map/house_functions.cpp

### kickPlayer(...)
Source: src/lua/functions/map/house_functions.cpp

### setAccessList(...)
Source: src/lua/functions/map/house_functions.cpp

### setHouseOwner(...)
Source: src/lua/functions/map/house_functions.cpp

### setNewOwnerGuid(...)
Source: src/lua/functions/map/house_functions.cpp

### startTrade(...)
Source: src/lua/functions/map/house_functions.cpp

## Imbuement
### __eq()
Source: src/lua/functions/items/imbuement_functions.cpp

### getBase(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getCategory(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getCombatType(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getElementDamage(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getId(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getItems(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### getName(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

### isPremium(imbuement: Imbuement)
Source: src/lua/functions/items/imbuement_functions.cpp

## Item
### __eq()
Source: src/lua/functions/items/item_functions.cpp

### actor(...)
Source: src/lua/functions/items/item_functions.cpp

### canBeMoved(...)
Source: src/lua/functions/items/item_functions.cpp

### canReceiveAutoCarpet(...)
Source: src/lua/functions/items/item_functions.cpp

### clone(...)
Source: src/lua/functions/items/item_functions.cpp

### decay(arg2: number)
Source: src/lua/functions/items/item_functions.cpp

### getActionId(...)
Source: src/lua/functions/items/item_functions.cpp

### getArticle(...)
Source: src/lua/functions/items/item_functions.cpp

### getAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### getCharges(...)
Source: src/lua/functions/items/item_functions.cpp

### getClassification(...)
Source: src/lua/functions/items/item_functions.cpp

### getContainer(...)
Source: src/lua/functions/items/item_functions.cpp

### getCount(...)
Source: src/lua/functions/items/item_functions.cpp

### getCustomAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### getDescription(distance: number)
Source: src/lua/functions/items/item_functions.cpp

### getFluidType(...)
Source: src/lua/functions/items/item_functions.cpp

### getId(...)
Source: src/lua/functions/items/item_functions.cpp

### getImbuement(...)
Source: src/lua/functions/items/item_functions.cpp

### getImbuementSlot(...)
Source: src/lua/functions/items/item_functions.cpp

### getName(...)
Source: src/lua/functions/items/item_functions.cpp

### getOwnerId(...)
Source: src/lua/functions/items/item_functions.cpp

### getOwnerName(...)
Source: src/lua/functions/items/item_functions.cpp

### getParent(...)
Source: src/lua/functions/items/item_functions.cpp

### getPluralName(...)
Source: src/lua/functions/items/item_functions.cpp

### getPosition(...)
Source: src/lua/functions/items/item_functions.cpp

### getShader(...)
Source: src/lua/functions/items/item_functions.cpp

### getSubType(...)
Source: src/lua/functions/items/item_functions.cpp

### getTier(...)
Source: src/lua/functions/items/item_functions.cpp

### getTile(...)
Source: src/lua/functions/items/item_functions.cpp

### getTopParent(...)
Source: src/lua/functions/items/item_functions.cpp

### getUniqueId(...)
Source: src/lua/functions/items/item_functions.cpp

### getWeight(...)
Source: src/lua/functions/items/item_functions.cpp

### hasAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### hasOwner(...)
Source: src/lua/functions/items/item_functions.cpp

### hasProperty(property: ItemProperty)
Source: src/lua/functions/items/item_functions.cpp

### hasShader(...)
Source: src/lua/functions/items/item_functions.cpp

### isContainer(...)
Source: src/lua/functions/items/item_functions.cpp

### isInsideDepot(...)
Source: src/lua/functions/items/item_functions.cpp

### isItem(...)
Source: src/lua/functions/items/item_functions.cpp

### isOwner(...)
Source: src/lua/functions/items/item_functions.cpp

### moveTo(itemPtr: Item)
Source: src/lua/functions/items/item_functions.cpp

### moveToSlot(...)
Source: src/lua/functions/items/item_functions.cpp

### remove(...)
Source: src/lua/functions/items/item_functions.cpp

### removeAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### removeCustomAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### serializeAttributes(...)
Source: src/lua/functions/items/item_functions.cpp

### setActionId(actionId: number)
Source: src/lua/functions/items/item_functions.cpp

### setAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### setCustomAttribute(...)
Source: src/lua/functions/items/item_functions.cpp

### setDuration(...)
Source: src/lua/functions/items/item_functions.cpp

### setOwner(...)
Source: src/lua/functions/items/item_functions.cpp

### setShader(...)
Source: src/lua/functions/items/item_functions.cpp

### setTier(...)
Source: src/lua/functions/items/item_functions.cpp

### split(itemPtr: Item)
Source: src/lua/functions/items/item_functions.cpp

### transform(itemPtr: Item)
Source: src/lua/functions/items/item_functions.cpp

## ItemClassification
### __eq()
Source: src/lua/functions/items/item_classification_functions.cpp

### addTier(itemClassification: ItemClassification, arg2: number, arg3: number, arg4: number, arg5: number, arg6: number)
Source: src/lua/functions/items/item_classification_functions.cpp

## ItemType
### __eq()
Source: src/lua/functions/items/item_type_functions.cpp

### getAmmoType(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getArmor(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getArticle(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getAttack(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getBaseSpeed(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getCapacity(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getCharges(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getDecayId(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getDecayTime(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getDefense(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getDescription(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getDestroyId(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getElementDamage(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getElementType(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getExtraDefense(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getFluidSource(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getHitChance(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getId(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getImbuementSlot(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getName(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getPluralName(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getRequiredLevel(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getShootRange(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getShowDuration(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getSlotPosition(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getSpeed(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getStackSize(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getTransformDeEquipId(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getTransformEquipId(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getType(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getVocationString(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getWeaponType(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getWeight(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### getWrapableTo(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### hasSubType(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isBlocking(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isContainer(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isCorpse(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isDoor(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isFluidContainer(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isGroundTile(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isKey(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isMagicField(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isMovable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isMultiUse(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isPickupable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isPodium(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isQuiver(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isReadable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isRune(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isStackable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isStowable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

### isWritable(itemType: ItemType)
Source: src/lua/functions/items/item_type_functions.cpp

## KV
### get(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### keys(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### remove(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### scoped(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### set(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

## Loot
### addChildLoot(childLoot: Loot)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setActionId(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setArmor(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setArticle(arg2: string)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setAttack(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setChance(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setDefense(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setExtraDefense(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setHitChance(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setId(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setIdFromName(name: string)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setMaxCount(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setMinCount(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setNameItem(arg2: string)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setShootRange(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setSubType(arg2: number)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setText(arg2: string)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

### setUnique(...)
Source: src/lua/functions/creatures/monster/loot_functions.cpp

## ModalWindow
### __eq()
Source: src/lua/functions/core/game/modal_window_functions.cpp

### addButton(id: number, arg3: string)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### addChoice(id: number, arg3: string)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getButtonCount(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getChoiceCount(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getDefaultEnterButton(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getDefaultEscapeButton(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getId(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getMessage(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### getTitle(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### hasPriority(...)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### sendToPlayer(player: Player)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### setDefaultEnterButton(arg2: number)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### setDefaultEscapeButton(arg2: number)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### setMessage(arg2: string)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### setPriority(arg2: boolean)
Source: src/lua/functions/core/game/modal_window_functions.cpp

### setTitle(arg2: string)
Source: src/lua/functions/core/game/modal_window_functions.cpp

## Monster
### __eq()
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addAttackSpell(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addDefense(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addDefenseSpell(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addFriend(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addReflectElement(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### addTarget(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### changeTargetDistance(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### clearFiendishStatus(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### configureForgeSystem(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### criticalChance(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### criticalDamage(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getDefense(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getForgeStack(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getFriendCount(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getFriendList(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getMonsterForgeClassification(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getRespawnType(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getSpawnPosition(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getTargetCount(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getTargetList(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getTimeToChangeFiendish(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### getType(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### hazard(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### hazardCrit(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### hazardDamageBoost(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### hazardDefenseBoost(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### hazardDodge(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### immune(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isChallenged(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isDead(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isForgeable(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isFriend(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isIdle(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isInSpawnRange(arg2?: Position)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isMonster(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isOpponent(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### isTarget(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### removeFriend(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### removeTarget(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### searchTarget(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### selectTarget(creature: Creature)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setForgeStack(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setIdle(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setMonsterForgeClassification(classification: ForgeClassifications_t)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setName(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setSpawnPosition(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setTimeToChangeFiendish(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### setType(arg2: number)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

### soulPit(...)
Source: src/lua/functions/creatures/monster/monster_functions.cpp

## MonsterSpell
### castSound(...)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### impactSound(...)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setAttackValue(arg2: number, arg3: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setChance(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatEffect(arg2: MagicEffectClasses)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatLength(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatRadius(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatShootEffect(arg2: ShootType_t)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatSpread(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatType(arg2: CombatType_t)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setCombatValue(arg2: number, arg3: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setConditionDamage(arg2: number, arg3: number, arg4: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setConditionDuration(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setConditionSpeedChange(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setConditionTickInterval(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setConditionType(conditionType: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setInterval(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setNeedTarget(arg2: boolean)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setOutfitItem(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setOutfitMonster(arg2: string)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setRange(arg2: number)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setScriptName(arg2: string)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

### setType(arg2: string)
Source: src/lua/functions/creatures/monster/monster_spell_functions.cpp

## MonsterType
### BestiaryCharmsPoints(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiaryFirstUnlock(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiaryLocations(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiaryOccurrence(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiarySecondUnlock(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiaryStars(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### Bestiaryclass(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### Bestiaryrace(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### BestiarytoKill(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### __eq()
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addAttack(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addDefense(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addElement(element: CombatType_t, arg3: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addHealing(element: CombatType_t, arg3: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addLoot(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addReflect(element: CombatType_t, arg3: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addSound(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addSummon(arg2: string, arg3: number, arg4: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### addVoice(arg2: string, arg3: number, arg4: number, arg5: boolean)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### armor(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### baseSpeed(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### bossRace(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### bossRaceId(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canPushCreatures(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canPushItems(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canSpawn(arg2: Position)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canWalkOnEnergy(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canWalkOnFire(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### canWalkOnPoison(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### changeTargetChance(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### changeTargetSpeed(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### combatImmunities(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### conditionImmunities(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### corpseId(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### critChance(arg2: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### deathSound(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### defense(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### enemyFactions(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### eventType(arg2: MonstersEvent_t)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### experience(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### faction(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### familiar(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getAttackList(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getCorpseId(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getCreatureEvents(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getDefenseList(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getElementList(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getLoot(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getMonstersByBestiaryStars(stars: number)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getMonstersByRace(race: BestiaryType_t)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getSounds(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getSummonList(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getTypeName(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### getVoices(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### health(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isAttackable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isBlockable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isConvinceable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isForgeCreature(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isHealthHidden(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isHostile(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isIllusionable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isPreyExclusive(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isPreyable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isPushable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isRewardBoss(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### isSummonable(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### light(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### manaCost(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### maxHealth(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### maxSummons(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### mitigation(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### name(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### nameDescription(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onAppear(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onDisappear(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onMove(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onPlayerAttack(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onSay(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onSpawn(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### onThink(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### outfit(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### race(race?: string)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### raceId(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### registerEvent(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### respawnTypeIsUnderground(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### respawnTypePeriod(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### runHealth(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### soundChance(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### soundSpeedTicks(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### staticAttackChance(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### strategiesTargetDamage(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### strategiesTargetHealth(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### strategiesTargetNearest(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### strategiesTargetRandom(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### targetDistance(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### targetPreferMaster(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### targetPreferPlayer(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### variant(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### yellChance(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

### yellSpeedTicks(...)
Source: src/lua/functions/creatures/monster/monster_type_functions.cpp

## Mount
### __eq()
Source: src/lua/functions/creatures/player/mount_functions.cpp

### getClientId(...)
Source: src/lua/functions/creatures/player/mount_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/player/mount_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/player/mount_functions.cpp

### getSpeed(...)
Source: src/lua/functions/creatures/player/mount_functions.cpp

## MoveEvent
### aid(...)
Source: src/lua/functions/events/move_event_functions.cpp

### id(...)
Source: src/lua/functions/events/move_event_functions.cpp

### level(arg2: number)
Source: src/lua/functions/events/move_event_functions.cpp

### magicLevel(arg2: number)
Source: src/lua/functions/events/move_event_functions.cpp

### onAddItem(...)
Source: src/lua/functions/events/move_event_functions.cpp

### onDeEquip(...)
Source: src/lua/functions/events/move_event_functions.cpp

### onEquip(...)
Source: src/lua/functions/events/move_event_functions.cpp

### onRemoveItem(...)
Source: src/lua/functions/events/move_event_functions.cpp

### onStepIn(...)
Source: src/lua/functions/events/move_event_functions.cpp

### onStepOut(...)
Source: src/lua/functions/events/move_event_functions.cpp

### position(...)
Source: src/lua/functions/events/move_event_functions.cpp

### premium(arg2: boolean)
Source: src/lua/functions/events/move_event_functions.cpp

### register(...)
Source: src/lua/functions/events/move_event_functions.cpp

### slot(...)
Source: src/lua/functions/events/move_event_functions.cpp

### type(typeName: string)
Source: src/lua/functions/events/move_event_functions.cpp

### uid(...)
Source: src/lua/functions/events/move_event_functions.cpp

### vocation(arg2: string, arg3: boolean)
Source: src/lua/functions/events/move_event_functions.cpp

## NetworkMessage
### __eq()
Source: src/lua/functions/core/network/network_message_functions.cpp

### add16(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### add32(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### add64(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### add8(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addByte(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addDouble(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addItem(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addPosition(arg2: Position)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addString(arg2: string, arg3: string)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addU16(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addU32(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### addU64(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

### delete()
Source: src/lua/functions/core/network/network_message_functions.cpp

### getByte(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### getPosition(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### getString(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### getU16(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### getU32(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### getU64(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### reset(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### sendToPlayer(...)
Source: src/lua/functions/core/network/network_message_functions.cpp

### skipBytes(number: number)
Source: src/lua/functions/core/network/network_message_functions.cpp

## Npc
### __eq()
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### closeShopWindow(player: Player)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### follow(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getCurrency(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getDistanceTo(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getShopItem(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### getSpeechBubble(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### isInTalkRange(arg2: Position)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### isInteractingWithPlayer(creature: Creature)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### isMerchant(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### isNpc(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### isPlayerInteractingOnTopic(creature: Creature)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### move(arg2: Direction)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### openShopWindow(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### openShopWindowTable(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### place(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### removePlayerInteraction(creature: Creature)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### say(arg6: Position)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### sellItem(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### setCurrency(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### setMasterPos(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### setName(arg2: string)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### setPlayerInteraction(creature: Creature)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### setSpeechBubble(...)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### turn(arg2: Direction)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

### turnToCreature(creature: Creature)
Source: src/lua/functions/creatures/npc/npc_functions.cpp

## NpcType
### __eq()
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### addShopItem(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### addSound(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### addVoice(arg2: string, arg3: number, arg4: number, arg5: boolean)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### baseSpeed(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### canPushCreatures(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### canPushItems(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### canSpawn(arg2: Position)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### currency(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### eventType(arg2: NpcsEvent_t)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### floorChange(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### getCreatureEvents(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### getSounds(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### getVoices(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### health(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### isPushable(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### light(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### maxHealth(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### name(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### nameDescription(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onAppear(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onBuyItem(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onCheckItem(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onCloseChannel(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onDisappear(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onMove(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onSay(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onSellItem(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### onThink(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### outfit(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### registerEvent(arg2: string)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### respawnTypeIsUnderground(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### respawnTypePeriod(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### soundChance(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### soundSpeedTicks(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### speechBubble(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### walkInterval(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### walkRadius(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### yellChance(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

### yellSpeedTicks(...)
Source: src/lua/functions/creatures/npc/npc_type_functions.cpp

## Party
### __eq()
Source: src/lua/functions/creatures/player/party_functions.cpp

### addInvite(player: Player)
Source: src/lua/functions/creatures/player/party_functions.cpp

### addMember(player: Player)
Source: src/lua/functions/creatures/player/party_functions.cpp

### disband(partyPtr: Party)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getInviteeCount(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getInvitees(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getLeader(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getMemberCount(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getMembers(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### getUniqueVocationsCount(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### isSharedExperienceActive(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### isSharedExperienceEnabled(...)
Source: src/lua/functions/creatures/player/party_functions.cpp

### removeInvite(player: Player)
Source: src/lua/functions/creatures/player/party_functions.cpp

### removeMember(player: Player)
Source: src/lua/functions/creatures/player/party_functions.cpp

### setLeader(player: Player)
Source: src/lua/functions/creatures/player/party_functions.cpp

### setSharedExperience(active: boolean)
Source: src/lua/functions/creatures/player/party_functions.cpp

### shareExperience(experience: number)
Source: src/lua/functions/creatures/player/party_functions.cpp

## Player
### __eq()
Source: src/lua/functions/creatures/player/player_functions.cpp

### addAchievement(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addAchievementPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addAnimusMastery(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addBadge(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addBestiaryKill(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addBlessing(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addBosstiaryKill(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addCharmPoints(charms: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addCustomOutfit(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addExperience(experience: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addFamiliar(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addForgeDustLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addForgeDusts(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addItem(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addItemEx(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addItemStash(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addMana(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addManaSpent(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addMapMark(arg2: Position, type: number, arg4: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addMinorCharmEchoes(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addMoney(money: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addMount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addOfflineTrainingTime(time: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addOfflineTrainingTries(skillType: skills_t, tries: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addOutfit(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addOutfitAddon(lookType: number, addon: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addPremiumDays(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addPreyCards(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addSkillTries(skillType: skills_t, tries: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addSoul(soulChange: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addTaskHuntingPoints(points: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addTibiaCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addTitle(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### addTransferableCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### avatarTimer(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### canCast(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### canLearnSpell(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### canReceiveLoot(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### changeName(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### channelSay(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### charmExpansion(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### clearSpellCooldowns(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### closeForge(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### closeImbuementWindow(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### createTransactionSummary(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### forgetSpell(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getAccountId(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getAccountType(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getAchievementPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBankBalance(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBaseMagicLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBaseMaxHealth(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBaseMaxMana(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBaseXpGain(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBlessingCount(index: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBossBonus(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBosstiaryKills(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getBosstiaryLevel(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getCapacity(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getCharmChance(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getCharmMonsterType(charmid: charmRune_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getCharmTier(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getClient(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getContainerById(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getContainerId(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getContainerIndex(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getDeathPenalty(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getDepotChest(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getDepotLocker(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getEffectiveSkillLevel(skillType: skills_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getExperience(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getFaction(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getFamiliarLooktype(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getFightMode(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getForgeCores(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getForgeDustLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getForgeDusts(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getForgeSlivers(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getFreeBackpackSlots(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getFreeCapacity(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGrindingXpBoost(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGroup(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGuid(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGuild(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGuildLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getGuildNick(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getHazardSystemPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getHouse(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getIdleTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getInbox(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getInstantSpells(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getIp(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getItemById(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getItemCount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getKills(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLastLoginSaved(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLastLogout(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLoyaltyBonus(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLoyaltyPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getLoyaltyTitle(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMagicLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMagicShieldCapacityFlat(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMagicShieldCapacityPercent(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMana(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getManaSpent(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMapShader(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMaxMana(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMaxSoul(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getMoney(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getOfflineTrainingSkill(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getOfflineTrainingTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getParty(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getPremiumDays(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getPreyCards(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getPreyExperiencePercentage(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getPreyLootPercentage(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getPronoun(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getReward(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getRewardList(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSex(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSkillLevel(skillType: skills_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSkillPercent(skillType: skills_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSkillTries(skillType: skills_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSkullTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSlotBossId(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSlotItem(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getSoul(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStamina(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStaminaXpBoost(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStashCount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStashItemCount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStorageValue(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getStoreInbox(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getTaskHuntingPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getTibiaCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getTitles(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getTown(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getTransferableCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getVipDays(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getVipTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getVocation(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getVoucherXpBoost(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getWheelSpellAdditionalArea(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getWheelSpellAdditionalDuration(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getWheelSpellAdditionalTarget(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getXpBoostPercent(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### getXpBoostTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasAchievement(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasAnimusMastery(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasBlessing(blessing: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasChaseMode(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasFamiliar(lookType: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasGroupFlag(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasLearnedSpell(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasMount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasOutfit(lookType: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### hasSecureMode(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### instantSkillWOD(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isMonsterBestiaryUnlocked(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isMonsterPrey(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isOffline(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isPlayer(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isPromoted(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isPzLocked(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isTraining(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isUIExhausted(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### isVip(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### kv(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### learnSpell(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### onThinkWheelOfDestiny(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### openChannel(channelId: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### openForge(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### openImbuementWindow(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### openMarket(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### openStash(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### popupFYI(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### preyThirdSlot(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### reloadData(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeAchievement(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeAchievementPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeAnimusMastery(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeBlessing(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeCustomOutfit(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeExperience(experience: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeFamiliar(lookType: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeForgeDustLevel(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeForgeDusts(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeGroupFlag(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeIconBakragore(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeItem(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeMoney(money: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeMount(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeOfflineTrainingTime(time: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeOutfit(lookType: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeOutfitAddon(lookType: number, addon: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removePremiumDays(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removePreyStamina(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeReward(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeStashItem(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeTaskHuntingPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeTibiaCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### removeTransferableCoins(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### resetCharmsBestiary(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### resetOldCharms(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### revelationStageWOD(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### save(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendBlessStatus(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendBosstiaryCooldownTimer(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendChannelMessage(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendContainer(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendCreatureAppear(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendDoubleSoundEffect(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendHouseWindow(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendIconBakragore(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendInventory(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendLootStats(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendOutfitWindow(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendPrivateMessage(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendSingleSoundEffect(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendSpellCooldown(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendSpellGroupCooldown(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendTextMessage(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendTutorial(tutorialId: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### sendUpdateContainer(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setAccountType(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setBankBalance(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setBaseXpGain(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setBossPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setCapacity(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setCurrentTitle(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setDailyReward(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setEditHouse(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setFaction(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setFamiliarLooktype(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setForgeDusts(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGhostMode(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGrindingXpBoost(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGroup(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGroupFlag(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGuild(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGuildLevel(level: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setGuildNick(arg2: string)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setHazardSystemPoints(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setKills(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setLevel(level: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setLoyaltyBonus(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setLoyaltyTitle(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setMagicLevel(level: number, manaSpent: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setMapShader(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setMaxMana(player: Player)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setOfflineTrainingSkill(skillId: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setPronoun(newPronoun: PlayerPronoun_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setRemoveBossTime(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setSex(newSex: PlayerSex_t)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setSkillLevel(skillType: skills_t, level: number, tries: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setSkullTime(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setSpecialContainersAvailable(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setStamina(stamina: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setStaminaXpBoost(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setStorageValue(key: number, value: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setTown(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setTraining(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setVocation(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setVoucherXpBoost(arg2: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setXpBoostPercent(percent: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### setXpBoostTime(timeLeft: number)
Source: src/lua/functions/creatures/player/player_functions.cpp

### showTextDialog(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### takeScreenshot(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### taskHuntingThirdSlot(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### unlockAllCharmRunes(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### updateConcoction(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### updateKillTracker(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### updateSupplyTracker(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### updateUIExhausted(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### upgradeSpellsWOD(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

### wheelUnlockScroll(...)
Source: src/lua/functions/creatures/player/player_functions.cpp

## Position
### __add(...)
Source: src/lua/functions/map/position_functions.cpp

### __eq(arg1: Position, arg2: Position)
Source: src/lua/functions/map/position_functions.cpp

### __sub(...)
Source: src/lua/functions/map/position_functions.cpp

### getDistance(arg1: Position, arg2: Position)
Source: src/lua/functions/map/position_functions.cpp

### getPathTo(arg1: Position, arg2: Position)
Source: src/lua/functions/map/position_functions.cpp

### getTile(arg1: Position)
Source: src/lua/functions/map/position_functions.cpp

### getZones(arg1: Position)
Source: src/lua/functions/map/position_functions.cpp

### isSightClear(arg1: Position, arg2: Position)
Source: src/lua/functions/map/position_functions.cpp

### removeMagicEffect(player?: Player)
Source: src/lua/functions/map/position_functions.cpp

### sendDistanceEffect(player?: Player)
Source: src/lua/functions/map/position_functions.cpp

### sendDoubleSoundEffect(arg1: Position, mainSoundEffect: SoundEffect_t, secondarySoundEffect: SoundEffect_t, actor: Creature)
Source: src/lua/functions/map/position_functions.cpp

### sendMagicEffect(player?: Player)
Source: src/lua/functions/map/position_functions.cpp

### sendSingleSoundEffect(arg1: Position, soundEffect: SoundEffect_t, actor: Creature)
Source: src/lua/functions/map/position_functions.cpp

### toString(arg1: Position)
Source: src/lua/functions/map/position_functions.cpp

## Result
### free(...)
Source: src/lua/functions/core/libs/result_functions.cpp

### getNumber(arg1: number)
Source: src/lua/functions/core/libs/result_functions.cpp

### getStream(arg1: number)
Source: src/lua/functions/core/libs/result_functions.cpp

### getString(arg1: number)
Source: src/lua/functions/core/libs/result_functions.cpp

### next(...)
Source: src/lua/functions/core/libs/result_functions.cpp

## Shop
### addChildShop(...)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setBuyPrice(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setCount(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setId(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setIdFromName(name: string)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setNameItem(arg2: string)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setSellPrice(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setStorageKey(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

### setStorageValue(arg2: number)
Source: src/lua/functions/creatures/npc/shop_functions.cpp

## Spdlog
### debug(arg1: string)
Source: src/lua/functions/core/libs/logger_functions.cpp

### error(arg1: string)
Source: src/lua/functions/core/libs/logger_functions.cpp

### info(arg1: string)
Source: src/lua/functions/core/libs/logger_functions.cpp

### warn(arg1: string)
Source: src/lua/functions/core/libs/logger_functions.cpp

## Spell
### __eq()
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### allowFarUse(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### allowOnSelf(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### blockWalls(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### castSound(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### charges(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### checkFloor(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### cooldown(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### group(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### groupCooldown(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### hasParams(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### hasPlayerNameParam(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### id(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### impactSound(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isAggressive(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isBlocking(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isBlockingWalls(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isEnabled(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isPremium(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### isSelfTarget(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### level(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### magicLevel(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### mana(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### manaPercent(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### name(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### needCasterTargetOrDirection(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### needDirection(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### needLearn(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### needTarget(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### needWeapon(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### onCastSpell(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### range(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### register(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### runeId(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### setPzLocked(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### soul(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### vocation(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

### words(...)
Source: src/lua/functions/creatures/combat/spell_functions.cpp

## TalkAction
### getDescription(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### getGroupType(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### getName(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### groupType(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### onSay(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### register(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### separator(...)
Source: src/lua/functions/events/talk_action_functions.cpp

### setDescription(...)
Source: src/lua/functions/events/talk_action_functions.cpp

## Teleport
### __eq()
Source: src/lua/functions/map/teleport_functions.cpp

### getDestination(...)
Source: src/lua/functions/map/teleport_functions.cpp

### setDestination(arg2: Position)
Source: src/lua/functions/map/teleport_functions.cpp

## Tile
### __eq()
Source: src/lua/functions/map/tile_functions.cpp

### addItem(...)
Source: src/lua/functions/map/tile_functions.cpp

### addItemEx(...)
Source: src/lua/functions/map/tile_functions.cpp

### getBottomCreature(...)
Source: src/lua/functions/map/tile_functions.cpp

### getBottomVisibleCreature(...)
Source: src/lua/functions/map/tile_functions.cpp

### getCreatureCount(...)
Source: src/lua/functions/map/tile_functions.cpp

### getCreatures(...)
Source: src/lua/functions/map/tile_functions.cpp

### getDownItemCount(...)
Source: src/lua/functions/map/tile_functions.cpp

### getFieldItem(...)
Source: src/lua/functions/map/tile_functions.cpp

### getGround(...)
Source: src/lua/functions/map/tile_functions.cpp

### getHouse(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItemById(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItemByTopOrder(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItemByType(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItemCount(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItemCountById(...)
Source: src/lua/functions/map/tile_functions.cpp

### getItems(...)
Source: src/lua/functions/map/tile_functions.cpp

### getPosition(...)
Source: src/lua/functions/map/tile_functions.cpp

### getThing(index: number)
Source: src/lua/functions/map/tile_functions.cpp

### getThingCount(...)
Source: src/lua/functions/map/tile_functions.cpp

### getThingIndex(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopCreature(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopDownItem(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopItemCount(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopTopItem(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopVisibleCreature(...)
Source: src/lua/functions/map/tile_functions.cpp

### getTopVisibleThing(creature: Creature)
Source: src/lua/functions/map/tile_functions.cpp

### hasFlag(flag: TileFlags_t)
Source: src/lua/functions/map/tile_functions.cpp

### hasProperty(...)
Source: src/lua/functions/map/tile_functions.cpp

### queryAdd(...)
Source: src/lua/functions/map/tile_functions.cpp

### sweep(...)
Source: src/lua/functions/map/tile_functions.cpp

## Town
### __eq()
Source: src/lua/functions/map/town_functions.cpp

### getId(...)
Source: src/lua/functions/map/town_functions.cpp

### getName(...)
Source: src/lua/functions/map/town_functions.cpp

### getTemplePosition(...)
Source: src/lua/functions/map/town_functions.cpp

## Variant
### getNumber(arg1: Variant)
Source: src/lua/functions/creatures/combat/variant_functions.cpp

### getPosition(arg1: Variant)
Source: src/lua/functions/creatures/combat/variant_functions.cpp

### getString(arg1: Variant)
Source: src/lua/functions/creatures/combat/variant_functions.cpp

## Vocation
### __eq()
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getAttackSpeed(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getBaseAttackSpeed(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getBaseId(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getBaseSpeed(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getCapacityGain(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getClientId(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getDemotion(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getDescription(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getHealthGain(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getHealthGainAmount(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getHealthGainTicks(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getId(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getManaGain(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getManaGainAmount(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getManaGainTicks(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getMaxSoul(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getName(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getPromotion(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getRequiredManaSpent(magicLevel: number)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getRequiredSkillTries(skillType: skills_t, skillLevel: number)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

### getSoulGainTicks(...)
Source: src/lua/functions/creatures/player/vocation_functions.cpp

## Weapon
### action(typeName: string)
Source: src/lua/functions/items/weapon_functions.cpp

### ammoType(type: string)
Source: src/lua/functions/items/weapon_functions.cpp

### attack(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### breakChance(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### charges(arg3?: boolean)
Source: src/lua/functions/items/weapon_functions.cpp

### damage(arg2?: number, arg3?: number)
Source: src/lua/functions/items/weapon_functions.cpp

### decayTo(arg2?: number)
Source: src/lua/functions/items/weapon_functions.cpp

### defense(arg2?: number, arg3?: number)
Source: src/lua/functions/items/weapon_functions.cpp

### duration(arg3?: boolean)
Source: src/lua/functions/items/weapon_functions.cpp

### element(element: string)
Source: src/lua/functions/items/weapon_functions.cpp

### extraElement(arg2: number, element: string)
Source: src/lua/functions/items/weapon_functions.cpp

### health(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### healthPercent(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### hitChance(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### id(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### level(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### magicLevel(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### mana(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### manaPercent(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### maxHitChance(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### onUseWeapon(...)
Source: src/lua/functions/items/weapon_functions.cpp

### premium(arg2: boolean)
Source: src/lua/functions/items/weapon_functions.cpp

### range(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### register(weaponPtr: WeaponShared_ptr)
Source: src/lua/functions/items/weapon_functions.cpp

### shootType(arg2: ShootType_t)
Source: src/lua/functions/items/weapon_functions.cpp

### slotType(slot: string)
Source: src/lua/functions/items/weapon_functions.cpp

### soul(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### transformDeEquipTo(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### transformEquipTo(arg2: number)
Source: src/lua/functions/items/weapon_functions.cpp

### vocation(arg2: string, arg3: boolean)
Source: src/lua/functions/items/weapon_functions.cpp

### wieldUnproperly(arg2: boolean)
Source: src/lua/functions/items/weapon_functions.cpp

## Webhook
### sendMessage(title: string, message: string)
Source: src/lua/functions/core/network/webhook_functions.cpp

## Zone
### __eq(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### addArea(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getAll(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getByName(name: string)
Source: src/lua/functions/core/game/zone_functions.cpp

### getByPosition(pos: Position)
Source: src/lua/functions/core/game/zone_functions.cpp

### getCreatures(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getItems(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getMonsters(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getName(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getNpcs(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getPlayers(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getPositions(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### getRemoveDestination(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### refresh(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### removeMonsters(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### removeNpcs(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### removePlayers(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### setMonsterVariant(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### setRemoveDestination(...)
Source: src/lua/functions/core/game/zone_functions.cpp

### subtractArea(...)
Source: src/lua/functions/core/game/zone_functions.cpp

## configManager
### getBoolean(...)
Source: src/lua/functions/core/game/config_functions.cpp

### getFloat(key: is provided and is a valid enum
	const auto)
Source: src/lua/functions/core/game/config_functions.cpp

### getNumber(...)
Source: src/lua/functions/core/game/config_functions.cpp

### getString(...)
Source: src/lua/functions/core/game/config_functions.cpp

## db
### asyncQuery(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### asyncStoreQuery(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### escapeBlob(arg1: string, length: number)
Source: src/lua/functions/core/libs/db_functions.cpp

### escapeString(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### lastInsertId(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### query(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### storeQuery(...)
Source: src/lua/functions/core/libs/db_functions.cpp

### tableExists(...)
Source: src/lua/functions/core/libs/db_functions.cpp

## kv
### get(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### keys(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### remove(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### scoped(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

### set(...)
Source: src/lua/functions/core/libs/kv_functions.cpp

## logger
### debug(...)
Source: src/lua/functions/core/libs/logger_functions.cpp

### error(...)
Source: src/lua/functions/core/libs/logger_functions.cpp

### info(...)
Source: src/lua/functions/core/libs/logger_functions.cpp

### trace(...)
Source: src/lua/functions/core/libs/logger_functions.cpp

### warn(...)
Source: src/lua/functions/core/libs/logger_functions.cpp

## metrics
### addCounter(name: string, value: number, attributes: Attributes)
Source: src/lua/functions/core/libs/metrics_functions.cpp

