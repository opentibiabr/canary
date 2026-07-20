---@meta
--- Auto-generated Lua API (do not edit manually)

---@alias CombatType integer
---@alias DistanceEffect integer
---@alias MagicEffect integer
---@alias ReturnValue integer
---@alias SoundEffect integer
---@alias TileState integer

---@class Action
Action = {}

---@param aids number
---@return boolean
function Action:aid(aids) end

---@param value boolean
---@return boolean
function Action:allowFarUse(value) end

---@param value boolean
---@return boolean
function Action:blockWalls(value) end

---@param value boolean
---@return boolean
function Action:checkFloor(value) end

---@param ids number
---@return boolean
function Action:id(ids) end

---@param callback fun(player: Player, item: Item, fromPosition: Position, target: Creature|Item, toPosition: Position, isHotkey: boolean): boolean
---@return boolean
function Action:onUse(callback) end

---@param positions Position
---@param itemIdOrName number|string
---@return boolean
function Action:position(positions, itemIdOrName) end

---@return boolean
function Action:register() end

---@param uids number
---@return boolean
function Action:uid(uids) end

---@class Bank
Bank = {}

---@param playerOrGuild any
---@param amount? number
---@return boolean|number
function Bank.balance(playerOrGuild, amount) end

---@param playerOrGuild any
---@param amount number
---@return boolean
function Bank.credit(playerOrGuild, amount) end

---@param playerOrGuild any
---@param amount number
---@return boolean
function Bank.debit(playerOrGuild, amount) end

---@param player Player
---@param amount number
---@param destination? any
---@return boolean
function Bank.deposit(player, amount, destination) end

---@param playerOrGuild any
---@param amount number
---@return boolean
function Bank.hasBalance(playerOrGuild, amount) end

---@param fromPlayerOrGuild any
---@param toPlayerOrGuild any
---@param amount number
---@return boolean
function Bank.transfer(fromPlayerOrGuild, toPlayerOrGuild, amount) end

---@param fromPlayerOrGuild any
---@param toGuild any
---@param amount number
---@return boolean
function Bank.transferToGuild(fromPlayerOrGuild, toGuild, amount) end

---@param player Player
---@param amount number
---@param source? any
---@return boolean
function Bank.withdraw(player, amount, source) end

---@class BatchUpdate
BatchUpdate = {}

---@param container Container
---@return boolean
function BatchUpdate:add(container) end

---@return nil
function BatchUpdate.delete() end

---@class Charm
---@operator eq(Charm):boolean
Charm = {}

---@param arg2? any
---@return boolean|number
function Charm:castSound(arg2) end

---@param arg2? any
---@return boolean|number
function Charm:category(arg2) end

---@param arg2? table
---@return boolean|table
function Charm:chance(arg2) end

---@param arg2? any
---@return boolean|number
function Charm:damageType(arg2) end

---@param arg2? string
---@return boolean|string
function Charm:description(arg2) end

---@param arg2? number
---@return boolean|number
function Charm:effect(arg2) end

---@param arg2? any
---@return boolean|number
function Charm:impactSound(arg2) end

---@param arg2? string
---@return boolean|string
function Charm:messageCancel(arg2) end

---@param arg2? boolean
---@return boolean
function Charm:messageServerLog(arg2) end

---@param arg2? string
---@return boolean|string
function Charm:name(arg2) end

---@param arg2? number
---@return boolean|number
function Charm:percentage(arg2) end

---@param arg2? table
---@return boolean|table
function Charm:points(arg2) end

---@param arg2? any
---@return boolean|number
function Charm:type(arg2) end

---@class Combat
---@operator eq(Combat):boolean
Combat = {}

---@param condition Condition
---@return boolean|nil
function Combat:addCondition(condition) end

---@param creature Creature
---@param variant Variant
---@return boolean
function Combat:execute(creature, variant) end

---@param area number
---@return boolean|nil
function Combat:setArea(area) end

---@param key any
---@param callback string
---@return boolean|nil
function Combat:setCallback(key, callback) end

---@param type any
---@param mina number
---@param minb number
---@param maxa number
---@param maxb number
---@return boolean|nil
function Combat:setFormula(type, mina, minb, maxa, maxb) end

---@param origin any
---@return boolean|nil
function Combat:setOrigin(origin) end

---@param key any
---@param value boolean|number
---@return boolean|nil
function Combat:setParameter(key, value) end

---@class Condition
---@operator eq(Condition):boolean
Condition = {}

---@param rounds number
---@param time number
---@param value number
---@return boolean|nil
function Condition:addDamage(rounds, time, value) end

---@return nil|Condition
function Condition:clone() end

---@return nil
function Condition.delete() end

---@return number|nil
function Condition:getEndTime() end

---@return table|nil
function Condition:getIcons() end

---@return number|nil
function Condition:getId() end

---@return number|nil
function Condition:getSubId() end

---@return number|nil
function Condition:getTicks() end

---@return number|nil
function Condition:getType() end

---@param mina number
---@param minb number
---@param maxa number
---@param maxb number
---@return boolean|nil
function Condition:setFormula(mina, minb, maxa, maxb) end

---@param outfit number
---@return boolean|nil
function Condition:setOutfit(outfit) end

---@param key any
---@param value boolean|number
---@return boolean|nil
function Condition:setParameter(key, value) end

---@param ticks number
---@return boolean|nil
function Condition:setTicks(ticks) end

---@class Container: Item
---@operator eq(Container):boolean
Container = {}

---@param itemId number|string
---@param countOrSubType? number
---@param index? number
---@param flags? number
---@return boolean|nil|Item
function Container:addItem(itemId, countOrSubType, index, flags) end

---@param item Item
---@param index? number
---@param flags? number
---@return number|nil
function Container:addItemEx(item, index, flags) end

---@return number|nil
function Container:getCapacity() end

---@param oldProtocol? boolean
---@return string|nil
function Container:getContentDescription(oldProtocol) end

---@return number|nil
function Container:getCorpseOwner() end

---@param recursive? boolean
---@return number|nil
function Container:getEmptySlots(recursive) end

---@param index number
---@return nil|Item
function Container:getItem(index) end

---@param itemId number|string
---@param subType? number
---@return number|nil
function Container:getItemCountById(itemId, subType) end

---@return number|nil
function Container:getItemHoldingCount() end

---@param recursive? boolean
---@return table|nil
function Container:getItems(recursive) end

---@return number|nil
function Container:getMaxCapacity() end

---@return number|nil
function Container:getSize() end

---@param item Item
---@return boolean|nil
function Container:hasItem(item) end

---@return boolean|nil
function Container:registerReward() end

---@param actor Player
---@param recursive boolean
---@return number|nil
function Container:removeAllItems(actor, recursive) end

---@param itemId number|string
---@param count number
---@param subType? number
---@return boolean|nil
function Container:removeItemById(itemId, count, subType) end

---@class Creature
---@operator eq(Creature):boolean
Creature = {}

---@param condition Condition
---@return boolean|nil
function Creature:addCondition(condition) end

---@param healthChange number
---@param combatType any
---@return boolean|nil
function Creature:addHealth(healthChange, combatType) end

---@param effectId number
---@param temporary? boolean
---@return nil
function Creature:attachEffectById(effectId, temporary) end

---@param position Position
---@return boolean|nil
function Creature:canSee(position) end

---@param creature Creature
---@return boolean|nil
function Creature:canSeeCreature(creature) end

---@param delta number
---@return boolean
function Creature:changeSpeed(delta) end

---@return boolean
function Creature:clearIcons() end

---@param effectId number
---@return nil
function Creature:detachEffectById(effectId) end

---@return table
function Creature:getAttachedEffects() end

---@return number|nil
function Creature:getBaseSpeed() end

---@param conditionType any
---@param conditionId? any
---@param subId? number
---@return nil|Condition
function Creature:getCondition(conditionType, conditionId, subId) end

---@return table|nil
function Creature:getDamageMap() end

---@param distance number
---@return string|nil
function Creature:getDescription(distance) end

---@return number|nil
function Creature:getDirection() end

---@param type any
---@return table|nil
function Creature:getEvents(type) end

---@return nil|Creature
function Creature:getFollowCreature() end

---@return number|nil
function Creature:getHealth() end

---@param key string
---@return boolean|table|nil
function Creature:getIcon(key) end

---@return boolean|table
function Creature:getIcons() end

---@return number|nil
function Creature:getId() end

---@return number|nil
function Creature:getLight() end

---@return nil|Creature
function Creature:getMaster() end

---@return number|nil
function Creature:getMaxHealth() end

---@return string|nil
function Creature:getName() end

---@return nil
function Creature:getOutfit() end

---@return nil
function Creature:getParent() end

---@param pos Position
---@param minTargetDist? number
---@param maxTargetDist? number
---@param fullPathSearch? boolean
---@param clearSight? boolean
---@param maxSearchDist? number
---@return boolean|table|nil
function Creature:getPathTo(pos, minTargetDist, maxTargetDist, fullPathSearch, clearSight, maxSearchDist) end

---@return nil|Position
function Creature:getPosition() end

---@return string
function Creature:getShader() end

---@return number|nil
function Creature:getSkull() end

---@return number|nil
function Creature:getSpeed() end

---@return table|nil
function Creature:getSummons() end

---@return nil|Creature
function Creature:getTarget() end

---@return nil|Tile
function Creature:getTile() end

---@return string|nil
function Creature:getTypeName() end

---@return number|nil
function Creature:getZoneType() end

---@return table|nil
function Creature:getZones() end

---@return boolean|nil
function Creature:hasBeenSummoned() end

---@param conditionType any
---@param subId? number
---@return boolean|nil
function Creature:hasCondition(conditionType, subId) end

---@return boolean
function Creature:isCreature() end

---@return boolean|nil
function Creature:isDirectionLocked() end

---@return boolean|nil
function Creature:isHealthHidden() end

---@param conditionOrConditionType Condition
---@return boolean|nil
function Creature:isImmune(conditionOrConditionType) end

---@return boolean|nil
function Creature:isInGhostMode() end

---@return boolean|nil
function Creature:isMoveLocked() end

---@return boolean|nil
function Creature:isRemoved() end

---@param direction Tile
---@return number|nil
function Creature:move(direction) end

---@param name string
---@return boolean|nil
function Creature:registerEvent(name) end

---@return boolean|nil
function Creature:reload() end

---@param forced? boolean
---@return boolean|nil
function Creature:remove(forced) end

---@param conditionType any
---@param conditionId? any
---@param subId? number
---@param force? boolean
---@return boolean|nil
function Creature:removeCondition(conditionType, conditionId, subId, force) end

---@param key string
---@return boolean
function Creature:removeIcon(key) end

---@param text string
---@param type? any
---@param ghost? boolean
---@param target? Creature
---@param position? Position
---@return boolean|nil
function Creature:say(text, type, ghost, target, position) end

---@param direction any
---@return boolean|nil
function Creature:setDirection(direction) end

---@param directionLocked boolean
---@return boolean|nil
function Creature:setDirectionLocked(directionLocked) end

---@param doDrop boolean
---@return boolean|nil
function Creature:setDropLoot(doDrop) end

---@param followedCreature Creature
---@return boolean|nil
function Creature:setFollowCreature(followedCreature) end

---@param health number
---@return boolean|nil
function Creature:setHealth(health) end

---@param hide boolean
---@return boolean|nil
function Creature:setHiddenHealth(hide) end

---@param key string
---@param category any
---@param icon any
---@param value? number
---@return boolean
function Creature:setIcon(key, category, icon, value) end

---@param color number
---@param level number
---@return boolean|nil
function Creature:setLight(color, level) end

---@param master Creature
---@return boolean|nil
function Creature:setMaster(master) end

---@param maxHealth number
---@return boolean|nil
function Creature:setMaxHealth(maxHealth) end

---@param moveLocked boolean
---@return boolean|nil
function Creature:setMoveLocked(moveLocked) end

---@param outfit any
---@return boolean|nil
function Creature:setOutfit(outfit) end

---@param shaderName string
---@return boolean
function Creature:setShader(shaderName) end

---@param skillLoss boolean
---@return boolean|nil
function Creature:setSkillLoss(skillLoss) end

---@param skull any
---@return boolean|nil
function Creature:setSkull(skull) end

---@param speed number
---@return boolean
function Creature:setSpeed(speed) end

---@param target Creature
---@return boolean|nil
function Creature:setTarget(target) end

---@param position Position
---@param pushMovement? boolean
---@return boolean
function Creature:teleportTo(position, pushMovement) end

---@param name string
---@return boolean|nil
function Creature:unregisterEvent(name) end

---@class CreatureEvent
CreatureEvent = {}

---@param callback fun(player: Player, skill: integer, oldLevel: integer, newLevel: integer): boolean
---@return boolean
function CreatureEvent:onAdvance(callback) end

---@param callback fun(creature: Creature, corpse: Item, lastHitKiller: Creature|nil, mostDamageKiller: Creature|nil, lastHitUnjustified: boolean, mostDamageUnjustified: boolean): boolean
---@return boolean
function CreatureEvent:onDeath(callback) end

---@param callback fun(player: Player, opcode: integer, buffer: string)
---@return boolean
function CreatureEvent:onExtendedOpcode(callback) end

---@param callback fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType
---@return boolean
function CreatureEvent:onHealthChange(callback) end

---@param callback fun(creature: Creature, target: Creature, lastHit: boolean)
---@return boolean
function CreatureEvent:onKill(callback) end

---@param callback fun(player: Player): boolean
---@return boolean
function CreatureEvent:onLogin(callback) end

---@param callback fun(player: Player): boolean
---@return boolean
function CreatureEvent:onLogout(callback) end

---@param callback fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType
---@return boolean
function CreatureEvent:onManaChange(callback) end

---@param callback fun(player: Player, modalWindowId: integer, buttonId: integer, choiceId: integer)
---@return boolean
function CreatureEvent:onModalWindow(callback) end

---@param callback fun(creature: Creature, killer: Creature|nil, realDamage: integer): boolean
---@return boolean
function CreatureEvent:onPrepareDeath(callback) end

---@param callback fun(player: Player, item: Item, text: string): boolean
---@return boolean
function CreatureEvent:onTextEdit(callback) end

---@param callback fun(creature: Creature, interval: integer): boolean
---@return boolean
function CreatureEvent:onThink(callback) end

---@return boolean|nil
function CreatureEvent:register() end

---@param callback string
---@return boolean|nil
function CreatureEvent:type(callback) end

---@class EventCallback
EventCallback = {}

---@param ... any
---@return boolean
function EventCallback.register(...) end

---@param ... any
---@return boolean
function EventCallback.type(...) end

---@class EventsScheduler
EventsScheduler = {}

---@param ... any
---@return number
function EventsScheduler.getEventSBossLoot(...) end

---@param ... any
---@return number
function EventsScheduler.getEventSExp(...) end

---@param ... any
---@return number
function EventsScheduler.getEventSLoot(...) end

---@param ... any
---@return number
function EventsScheduler.getEventSSkill(...) end

---@param ... any
---@return number
function EventsScheduler.getSpawnMonsterSchedule(...) end

---@class Game
Game = {}

---@param monster Monster
---@param stack? number
---@return boolean
function Game.addInfluencedMonster(monster, stack) end

---@param id number
---@return nil|Charm
function Game.createBestiaryCharm(id) end

---@param itemIdOrName number|string
---@param size number
---@param position? Position
---@return Container|nil
function Game.createContainer(itemIdOrName, size, position) end

---@param itemIdOrName number|string
---@param count? number
---@param position? Position
---@return Item|Item[]|nil
function Game.createItem(itemIdOrName, count, position) end

---@param id number
---@return nil|ItemClassification
function Game.createItemClassification(id) end

---@param monsterName string
---@param position Position
---@param extended? boolean
---@param force? boolean
---@param master? Creature
---@return nil|Monster
function Game.createMonster(monsterName, position, extended, force, master) end

---@param name string
---@param variant? string
---@param alternateName? string
---@return nil|MonsterType
function Game.createMonsterType(name, variant, alternateName) end

---@param npcName string
---@param position Position
---@param extended? boolean
---@param force? boolean
---@return nil|Npc
function Game.createNpc(npcName, position, extended, force) end

---@param ... any
---@return nil
function Game.createNpcType(...) end

---@param monsterName string
---@param position Position
---@param stack? number
---@param extended? boolean
---@param force? boolean
---@param master? Creature
---@return nil|Monster
function Game.createSoulPitMonster(monsterName, position, stack, extended, force, master) end

---@overload fun(position: Position, isDynamic?: boolean): Tile
---@param x integer
---@param y integer
---@param z integer
---@param isDynamic? boolean
---@return Tile
function Game.createTile(x, y, z, isDynamic) end

---@param npcName string
---@return nil|Npc
function Game.generateNpc(npcName) end

---@param id number
---@return table
function Game.getAchievementInfoById(id) end

---@param name string
---@return table
function Game.getAchievementInfoByName(name) end

---@param ... any
---@return table
function Game.getAchievements(...) end

---@param ... any
---@return table
function Game.getBestiaryCharm(...) end

---@param arg1? any
---@return number|string|table
function Game.getBestiaryList(arg1) end

---@param ... any
---@return string
function Game.getBoostedBoss(...) end

---@param ... any
---@return string
function Game.getBoostedCreature(...) end

---@param ... any
---@return table
function Game.getClientVersion(...) end

---@param ... any
---@return table
function Game.getDummies(...) end

---@param ... any
---@return string|table
function Game.getEventCallbacks(...) end

---@param level number
---@return number
function Game.getExperienceForLevel(level) end

---@param ... any
---@return table
function Game.getFiendishMonsters(...) end

---@param ... any
---@return number
function Game.getGameState(...) end

---@param ... any
---@return House[]
function Game.getHouses(...) end

---@param ... any
---@return table
function Game.getInfluencedMonsters(...) end

---@param ... any
---@return table
function Game.getLadderIds(...) end

---@param ... any
---@return number
function Game.getMonsterCount(...) end

---@param name string
---@return boolean|MonsterType
function Game.getMonsterTypeByName(name) end

---@param ... any
---@return table<string, MonsterType>
function Game.getMonsterTypes(...) end

---@param stars number
---@return table
function Game.getMonstersByBestiaryStars(stars) end

---@param race any
---@return table
function Game.getMonstersByRace(race) end

---@param name string
---@return string|nil
function Game.getNormalizedGuildName(name) end

---@param name string
---@param isNewName? boolean
---@return string|nil
function Game.getNormalizedPlayerName(name, isNewName) end

---@param ... any
---@return number
function Game.getNpcCount(...) end

---@param nameOrId number|string
---@return nil|Player
function Game.getOfflinePlayer(nameOrId) end

---@param ... any
---@return number
function Game.getPlayerCount(...) end

---@param ... any
---@return Player[]
function Game.getPlayers(...) end

---@param ... any
---@return table
function Game.getPublicAchievements(...) end

---@param value any
---@return string
function Game.getReturnMessage(value) end

---@param ... any
---@return table
function Game.getSecretAchievements(...) end

---@param ... any
---@return table
function Game.getSoulCoreItems(...) end

---@param position Position
---@param multifloor? boolean
---@param onlyPlayer? boolean
---@param minRangeX? integer
---@param maxRangeX? integer
---@param minRangeY? integer
---@param maxRangeY? integer
---@return Creature[]
function Game.getSpectators(position, multifloor, onlyPlayer, minRangeX, maxRangeX, minRangeY, maxRangeY) end

---@param ... any
---@return table
function Game.getTalkActions(...) end

---@param ... any
---@return Town[]
function Game.getTowns(...) end

---@param ... any
---@return number
function Game.getWorldType(...) end

---@param effectId number
---@return boolean
function Game.hasDistanceEffect(effectId) end

---@param effectId number
---@return boolean
function Game.hasEffect(effectId) end

---@param path string
---@return nil
function Game.loadMap(path) end

---@param path string
---@param position Position
---@param remove any
---@return nil
function Game.loadMapChunk(path, position, remove) end

---@param monsterId number
---@return number
function Game.makeFiendishMonster(monsterId) end

---@param id number
---@param name string
---@param description string
---@param secret boolean
---@param grade number
---@param points number
---@return boolean
function Game.registerAchievement(id, name, description, secret, grade, points) end

---@param reloadType any
---@return boolean
function Game.reload(reloadType) end

---@param monsterId number
---@return number
function Game.removeFiendishMonster(monsterId) end

---@param monsterId number
---@return number
function Game.removeInfluencedMonster(monsterId) end

---@param state any
---@return boolean
function Game.setGameState(state) end

---@param type any
---@return boolean
function Game.setWorldType(type) end

---@param raidName string
---@return number
function Game.startRaid(raidName) end

---@class GlobalEvent
GlobalEvent = {}

---@param interval number
---@return boolean|nil
function GlobalEvent:interval(interval) end

---@param callback fun(lightState: integer, lightLevel: integer): boolean
---@return boolean
function GlobalEvent:onPeriodChange(callback) end

---@param callback fun(current: integer, old: integer): boolean
---@return boolean
function GlobalEvent:onRecord(callback) end

---@param callback fun(): boolean
---@return boolean
function GlobalEvent:onSave(callback) end

---@param callback fun(): boolean
---@return boolean
function GlobalEvent:onShutdown(callback) end

---@param callback fun(): boolean
---@return boolean
function GlobalEvent:onStartup(callback) end

---@param callback fun(interval: integer): boolean
---@return boolean
function GlobalEvent:onThink(callback) end

---@param callback fun(interval: integer): boolean
---@return boolean
function GlobalEvent:onTime(callback) end

---@return boolean|nil
function GlobalEvent:register() end

---@param time string
---@return boolean|nil
function GlobalEvent:time(time) end

---@param callback string
---@return boolean|nil
function GlobalEvent:type(callback) end

---@class Group
---@operator eq(Group):boolean
Group = {}

---@return boolean|nil
function Group:getAccess() end

---@return number|nil
function Group:getFlags() end

---@return number|nil
function Group:getId() end

---@return number|nil
function Group:getMaxDepotItems() end

---@return number|nil
function Group:getMaxVipEntries() end

---@return string|nil
function Group:getName() end

---@param flag number
---@return boolean|nil
function Group:hasFlag(flag) end

---@class Guild
---@operator eq(Guild):boolean
Guild = {}

---@param id number
---@param name string
---@param level number
---@return boolean|nil
function Guild:addRank(id, name, level) end

---@return number|nil
function Guild:getBankBalance() end

---@return number|nil
function Guild:getId() end

---@return table|nil
function Guild:getMembersOnline() end

---@return string|nil
function Guild:getMotd() end

---@return string|nil
function Guild:getName() end

---@param id number
---@return table|nil
function Guild:getRankById(id) end

---@param level number
---@return table|nil
function Guild:getRankByLevel(level) end

---@param bankBalance number
---@return boolean|nil
function Guild:setBankBalance(bankBalance) end

---@param motd string
---@return boolean|nil
function Guild:setMotd(motd) end

---@class House
---@operator eq(House):boolean
House = {}

---@param listId number
---@param player Player
---@return boolean|nil
function House:canEditAccessList(listId, player) end

---@param listId number
---@return boolean|string|nil
function House:getAccessList(listId) end

---@return number|nil
function House:getBedCount() end

---@return table|nil
function House:getBeds() end

---@return number|nil
function House:getDoorCount() end

---@param position Position
---@return number|nil
function House:getDoorIdByPosition(position) end

---@return table|nil
function House:getDoors() end

---@return nil|Position
function House:getExitPosition() end

---@return number|nil
function House:getId() end

---@return table|nil
function House:getItems() end

---@return string|nil
function House:getName() end

---@return number|nil
function House:getOwnerGuid() end

---@return number
function House:getPrice() end

---@return number|nil
function House:getRent() end

---@return number|nil
function House:getTileCount() end

---@return table|nil
function House:getTiles() end

---@return nil|Town
function House:getTown() end

---@return boolean|nil
function House:hasItemOnTile() end

---@param guid number
---@return boolean|nil
function House:hasNewOwnership(guid) end

---@param player Player
---@return boolean|nil
function House:isInvited(player) end

---@param player Player
---@param targetPlayer Player
---@return boolean|nil
function House:kickPlayer(player, targetPlayer) end

---@param listId number
---@param list string
---@return boolean|nil
function House:setAccessList(listId, list) end

---@param guid number
---@param updateDatabase? boolean
---@return boolean|nil
function House:setHouseOwner(guid, updateDatabase) end

---@param guid number
---@param updateDatabase? boolean
---@return boolean|nil
function House:setNewOwnerGuid(guid, updateDatabase) end

---@param player Player
---@param tradePartner Player
---@return number|nil
function House:startTrade(player, tradePartner) end

---@class Imbuement
---@operator eq(Imbuement):boolean
Imbuement = {}

---@return table|nil
function Imbuement:getBase() end

---@return table|nil
function Imbuement:getCategory() end

---@return number|nil
function Imbuement:getCombatType() end

---@return number|nil
function Imbuement:getElementDamage() end

---@return number|nil
function Imbuement:getId() end

---@return table|nil
function Imbuement:getItems() end

---@return string|nil
function Imbuement:getName() end

---@return boolean|nil
function Imbuement:isPremium() end

---@class Item
---@operator eq(Item):boolean
Item = {}

---@param arg2? boolean
---@return boolean
function Item:actor(arg2) end

---@return boolean|nil
function Item:canBeMoved() end

---@return boolean
function Item:canReceiveAutoCarpet() end

---@return nil|Item
function Item:clone() end

---@param decayId number
---@return boolean|nil
function Item:decay(decayId) end

---@return number|nil
function Item:getActionId() end

---@return string|nil
function Item:getArticle() end

---@param key string
---@return number|string|nil
function Item:getAttribute(key) end

---@return number|nil
function Item:getCharges() end

---@return boolean|number
function Item:getClassification() end

---@return boolean|nil
function Item:getContainer() end

---@return number|nil
function Item:getCount() end

---@param key number|string
---@return nil
function Item:getCustomAttribute(key) end

---@param distance number
---@return string|nil
function Item:getDescription(distance) end

---@return number|nil
function Item:getFluidType() end

---@return number|nil
function Item:getId() end

---@return boolean|table|Imbuement
function Item:getImbuement() end

---@return boolean|number
function Item:getImbuementSlot() end

---@return string|nil
function Item:getName() end

---@return number|nil
function Item:getOwnerId() end

---@return string|nil
function Item:getOwnerName() end

---@return nil
function Item:getParent() end

---@return string|nil
function Item:getPluralName() end

---@return nil|Position
function Item:getPosition() end

---@return boolean|string
function Item:getShader() end

---@return number|nil
function Item:getSubType() end

---@return boolean|number
function Item:getTier() end

---@return nil|Tile
function Item:getTile() end

---@return nil
function Item:getTopParent() end

---@return number|nil
function Item:getUniqueId() end

---@return number|nil
function Item:getWeight() end

---@param key string
---@return boolean|nil
function Item:hasAttribute(key) end

---@return boolean
function Item:hasOwner() end

---@param property any
---@return boolean|nil
function Item:hasProperty(property) end

---@return boolean
function Item:hasShader() end

---@return boolean
function Item:isContainer() end

---@param includeInbox? boolean
---@return boolean
function Item:isInsideDepot(includeInbox) end

---@return boolean
function Item:isItem() end

---@param creatureOrCreatureId number|Creature
---@return boolean
function Item:isOwner(creatureOrCreatureId) end

---@param positionOrCylinder Container|Player|Tile|Position
---@param flags? number
---@return boolean|nil
function Item:moveTo(positionOrCylinder, flags) end

---@param player Player
---@param slot any
---@return boolean|nil
function Item:moveToSlot(player, slot) end

---@param count? number
---@return boolean|nil
function Item:remove(count) end

---@param key string
---@return boolean|nil
function Item:removeAttribute(key) end

---@param key number|string
---@return boolean|nil
function Item:removeCustomAttribute(key) end

---@return nil
function Item:serializeAttributes() end

---@param actionId number
---@return boolean|nil
function Item:setActionId(actionId) end

---@param key string
---@param value string|number
---@return boolean|nil
function Item:setAttribute(key, value) end

---@param key number|string
---@param value number|string|boolean
---@return boolean|nil
function Item:setCustomAttribute(key, value) end

---@param minDuration? number
---@param maxDuration? number
---@param decayTo? number
---@param showDuration? boolean
---@return boolean
function Item:setDuration(minDuration, maxDuration, decayTo, showDuration) end

---@param creatureOrCreatureId number|Creature
---@return boolean
function Item:setOwner(creatureOrCreatureId) end

---@param shaderName string
---@return boolean
function Item:setShader(shaderName) end

---@param tier number
---@return boolean
function Item:setTier(tier) end

---@param count? number
---@return nil|Item
function Item:split(count) end

---@param itemId number|string
---@param countOrSubType? number
---@return boolean|nil
function Item:transform(itemId, countOrSubType) end

---@class ItemClassification
---@operator eq(ItemClassification):boolean
ItemClassification = {}

---@param id number
---@param core number
---@param regularPrice number
---@param convergenceFusionPrice number
---@param convergenceTransferPrice number
---@return boolean|nil
function ItemClassification:addTier(id, core, regularPrice, convergenceFusionPrice, convergenceTransferPrice) end

---@class ItemType
---@operator eq(ItemType):boolean
ItemType = {}

---@return number|nil
function ItemType:getAmmoType() end

---@return number|nil
function ItemType:getArmor() end

---@return string|nil
function ItemType:getArticle() end

---@return number|nil
function ItemType:getAttack() end

---@return number|nil
function ItemType:getBaseSpeed() end

---@return number|nil
function ItemType:getCapacity() end

---@return number|nil
function ItemType:getCharges() end

---@return number|nil
function ItemType:getDecayId() end

---@return number|nil
function ItemType:getDecayTime() end

---@return number|nil
function ItemType:getDefense() end

---@param count? number
---@return string|nil
function ItemType:getDescription(count) end

---@return number|nil
function ItemType:getDestroyId() end

---@return number|nil
function ItemType:getElementDamage() end

---@return number|nil
function ItemType:getElementType() end

---@return number|nil
function ItemType:getElementalBond() end

---@return number|nil
function ItemType:getExtraDefense() end

---@return number|nil
function ItemType:getFluidSource() end

---@return number|nil
function ItemType:getHitChance() end

---@return number|nil
function ItemType:getId() end

---@return number|nil
function ItemType:getImbuementSlot() end

---@return string|nil
function ItemType:getName() end

---@return string|nil
function ItemType:getPluralName() end

---@return number|nil
function ItemType:getRequiredLevel() end

---@return number|nil
function ItemType:getShootRange() end

---@return boolean|nil
function ItemType:getShowDuration() end

---@return number|nil
function ItemType:getSlotPosition() end

---@return number|nil
function ItemType:getSpeed() end

---@return number|nil
function ItemType:getStackSize() end

---@return number|nil
function ItemType:getTransformDeEquipId() end

---@return number|nil
function ItemType:getTransformEquipId() end

---@return number|nil
function ItemType:getType() end

---@return string|nil
function ItemType:getVocationString() end

---@return number|nil
function ItemType:getWeaponType() end

---@param count? number
---@return number|nil
function ItemType:getWeight(count) end

---@return number|nil
function ItemType:getWrapableTo() end

---@return boolean|nil
function ItemType:hasSubType() end

---@return boolean|nil
function ItemType:isBlocking() end

---@return boolean|nil
function ItemType:isContainer() end

---@return boolean|nil
function ItemType:isCorpse() end

---@return boolean|nil
function ItemType:isDoor() end

---@return boolean|nil
function ItemType:isFluidContainer() end

---@return boolean|nil
function ItemType:isGroundTile() end

---@return boolean|nil
function ItemType:isKey() end

---@return boolean|nil
function ItemType:isMagicField() end

---@return boolean|nil
function ItemType:isMovable() end

---@return boolean|nil
function ItemType:isMultiUse() end

---@return boolean|nil
function ItemType:isPickupable() end

---@return boolean|nil
function ItemType:isPodium() end

---@return boolean|nil
function ItemType:isQuiver() end

---@return boolean|nil
function ItemType:isReadable() end

---@return boolean|nil
function ItemType:isRune() end

---@return boolean|nil
function ItemType:isStackable() end

---@return boolean|nil
function ItemType:isStowable() end

---@return boolean|nil
function ItemType:isWeapon() end

---@return boolean|nil
function ItemType:isWritable() end

---@class KV
KV = {}

---@param key string|KV|boolean
---@param forceLoad? boolean
---@return nil
function KV.get(key, forceLoad) end

---@param prefix? KV|string
---@return table
function KV.keys(prefix) end

---@param key string|KV
---@return nil
function KV.remove(key) end

---@param key string|KV
---@return KV
function KV.scoped(key) end

---@param key string|KV
---@param value number
---@return boolean
function KV.set(key, value) end

---@class Loot
Loot = {}

---@param loot Loot
---@return boolean|nil
function Loot:addChildLoot(loot) end

---@param ... any
---@return nil
function Loot.setActionId(...) end

---@param ... any
---@return nil
function Loot.setArmor(...) end

---@param ... any
---@return nil
function Loot.setArticle(...) end

---@param ... any
---@return nil
function Loot.setAttack(...) end

---@param ... any
---@return nil
function Loot.setChance(...) end

---@param ... any
---@return nil
function Loot.setDefense(...) end

---@param ... any
---@return nil
function Loot.setExtraDefense(...) end

---@param ... any
---@return nil
function Loot.setHitChance(...) end

---@param ... any
---@return nil
function Loot.setId(...) end

---@param name string
---@return boolean|nil
function Loot:setIdFromName(name) end

---@param ... any
---@return nil
function Loot.setMaxCount(...) end

---@param ... any
---@return nil
function Loot.setMinCount(...) end

---@param ... any
---@return nil
function Loot.setNameItem(...) end

---@param ... any
---@return nil
function Loot.setShootRange(...) end

---@param ... any
---@return nil
function Loot.setSubType(...) end

---@param ... any
---@return nil
function Loot.setText(...) end

---@param value? boolean
---@return boolean|nil
function Loot:setUnique(value) end

---@class ModalWindow
---@operator eq(ModalWindow):boolean
ModalWindow = {}

---@param id number
---@param text string
---@return boolean|nil
function ModalWindow:addButton(id, text) end

---@param id number
---@param text string
---@return boolean|nil
function ModalWindow:addChoice(id, text) end

---@return number|nil
function ModalWindow:getButtonCount() end

---@return number|nil
function ModalWindow:getChoiceCount() end

---@return number|nil
function ModalWindow:getDefaultEnterButton() end

---@return number|nil
function ModalWindow:getDefaultEscapeButton() end

---@return number|nil
function ModalWindow:getId() end

---@return string|nil
function ModalWindow:getMessage() end

---@return string|nil
function ModalWindow:getTitle() end

---@return boolean|nil
function ModalWindow:hasPriority() end

---@param player Player
---@return boolean|nil
function ModalWindow:sendToPlayer(player) end

---@param buttonId number
---@return boolean|nil
function ModalWindow:setDefaultEnterButton(buttonId) end

---@param buttonId number
---@return boolean|nil
function ModalWindow:setDefaultEscapeButton(buttonId) end

---@param text string
---@return boolean|nil
function ModalWindow:setMessage(text) end

---@param priority boolean
---@return boolean|nil
function ModalWindow:setPriority(priority) end

---@param text string
---@return boolean|nil
function ModalWindow:setTitle(text) end

---@class Monster: Creature
---@operator eq(Monster):boolean
Monster = {}

---@param monsterspell MonsterSpell
---@return nil
function Monster:addAttackSpell(monsterspell) end

---@param defense number
---@return boolean
function Monster:addDefense(defense) end

---@param monsterspell MonsterSpell
---@return nil
function Monster:addDefenseSpell(monsterspell) end

---@param creature Creature
---@return boolean|nil
function Monster:addFriend(creature) end

---@param type any
---@param percent number
---@return boolean
function Monster:addReflectElement(type, percent) end

---@param creature Creature
---@param pushFront? boolean
---@return boolean|nil
function Monster:addTarget(creature, pushFront) end

---@param distance number
---@param duration? number
---@return boolean|nil
function Monster:changeTargetDistance(distance, duration) end

---@return boolean
function Monster:clearFiendishStatus() end

---@param stack? number
---@return boolean
function Monster:configureForgeSystem(stack) end

---@param critical? number
---@return boolean|nil
function Monster:criticalChance(critical) end

---@param damage? number
---@return boolean|nil
function Monster:criticalDamage(damage) end

---@param defense any
---@return boolean|number
function Monster:getDefense(defense) end

---@return boolean|number
function Monster:getForgeStack() end

---@return number|nil
function Monster:getFriendCount() end

---@return table|nil
function Monster:getFriendList() end

---@return boolean|number
function Monster:getMonsterForgeClassification() end

---@return boolean|string
function Monster:getName() end

---@return boolean|number|nil
function Monster:getRespawnType() end

---@return nil|Position
function Monster:getSpawnPosition() end

---@return number|nil
function Monster:getTargetCount() end

---@return table|nil
function Monster:getTargetList() end

---@return boolean|number
function Monster:getTimeToChangeFiendish() end

---@return nil|MonsterType
function Monster:getType() end

---@param hazard? boolean
---@return boolean|nil
function Monster:hazard(hazard) end

---@param hazardCrit? boolean
---@return boolean|nil
function Monster:hazardCrit(hazardCrit) end

---@param hazardDamageBoost? boolean
---@return boolean|nil
function Monster:hazardDamageBoost(hazardDamageBoost) end

---@param hazardDefenseBoost? boolean
---@return boolean|nil
function Monster:hazardDefenseBoost(hazardDefenseBoost) end

---@param hazardDodge? boolean
---@return boolean|nil
function Monster:hazardDodge(hazardDodge) end

---@param arg2? boolean
---@return boolean
function Monster:immune(arg2) end

---@return boolean|nil
function Monster:isChallenged() end

---@return boolean
function Monster:isDead() end

---@return boolean
function Monster:isForgeable() end

---@param creature Creature
---@return boolean|nil
function Monster:isFriend(creature) end

---@return boolean|nil
function Monster:isIdle() end

---@param position? Position
---@return boolean|nil
function Monster:isInSpawnRange(position) end

---@return boolean
function Monster:isMonster() end

---@param creature Creature
---@return boolean|nil
function Monster:isOpponent(creature) end

---@param creature Creature
---@return boolean|nil
function Monster:isTarget(creature) end

---@param creature Creature
---@return boolean|nil
function Monster:removeFriend(creature) end

---@param creature Creature
---@return boolean|nil
function Monster:removeTarget(creature) end

---@param arg2? number
---@return boolean|number|nil
function Monster:runHealth(arg2) end

---@param searchType? any
---@return boolean|nil
function Monster:searchTarget(searchType) end

---@param creature Creature
---@return boolean|nil
function Monster:selectTarget(creature) end

---@param stack number
---@return boolean
function Monster:setForgeStack(stack) end

---@param idle boolean
---@return boolean|nil
function Monster:setIdle(idle) end

---@param classication any
---@return boolean
function Monster:setMonsterForgeClassification(classication) end

---@param name string
---@param nameDescription? string
---@return boolean
function Monster:setName(name, nameDescription) end

---@param interval number
---@return boolean|nil
function Monster:setSpawnPosition(interval) end

---@param endTime number
---@return boolean
function Monster:setTimeToChangeFiendish(endTime) end

---@param nameOrRaceId number|string
---@param restoreHealth boolean
---@return boolean|nil
function Monster:setType(nameOrRaceId, restoreHealth) end

---@param soulPit? boolean
---@return boolean|nil
function Monster:soulPit(soulPit) end

---@class MonsterSpell
MonsterSpell = {}

---@param arg2? any
---@return boolean|number
function MonsterSpell:castSound(arg2) end

---@param arg2? any
---@return boolean|number
function MonsterSpell:impactSound(arg2) end

---@param attack number
---@param skill number
---@return boolean|nil
function MonsterSpell:setAttackValue(attack, skill) end

---@param chance number
---@return boolean|nil
function MonsterSpell:setChance(chance) end

---@param effect any
---@return boolean|nil
function MonsterSpell:setCombatEffect(effect) end

---@param length number
---@return boolean|nil
function MonsterSpell:setCombatLength(length) end

---@param radius number
---@return boolean|nil
function MonsterSpell:setCombatRadius(radius) end

---@param effect any
---@return boolean|nil
function MonsterSpell:setCombatShootEffect(effect) end

---@param spread number
---@return boolean|nil
function MonsterSpell:setCombatSpread(spread) end

---@param arg1 any
---@return boolean|nil
function MonsterSpell:setCombatType(arg1) end

---@param min number
---@param max number
---@return boolean|nil
function MonsterSpell:setCombatValue(min, max) end

---@param min number
---@param max number
---@param start number
---@return boolean|nil
function MonsterSpell:setConditionDamage(min, max, start) end

---@param duration number
---@return boolean|nil
function MonsterSpell:setConditionDuration(duration) end

---@param speed number
---@return boolean|nil
function MonsterSpell:setConditionSpeedChange(speed) end

---@param interval number
---@return boolean|nil
function MonsterSpell:setConditionTickInterval(interval) end

---@param type number
---@return boolean|nil
function MonsterSpell:setConditionType(type) end

---@param interval number
---@return boolean|nil
function MonsterSpell:setInterval(interval) end

---@param value boolean
---@return boolean|nil
function MonsterSpell:setNeedTarget(value) end

---@param effect number
---@return boolean|nil
function MonsterSpell:setOutfitItem(effect) end

---@param effect string
---@return boolean|nil
function MonsterSpell:setOutfitMonster(effect) end

---@param range number
---@return boolean|nil
function MonsterSpell:setRange(range) end

---@param name string
---@return boolean|nil
function MonsterSpell:setScriptName(name) end

---@param type string
---@return boolean|nil
function MonsterSpell:setType(type) end

---@class MonsterType
---@operator eq(MonsterType):boolean
MonsterType = {}

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiaryCharmsPoints(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiaryFirstUnlock(arg2) end

---@param arg2? string
---@return boolean|string|nil
function MonsterType:BestiaryLocations(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiaryOccurrence(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiarySecondUnlock(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiaryStars(arg2) end

---@param arg2? string
---@return boolean|string|nil
function MonsterType:Bestiaryclass(arg2) end

---@param race? any
---@return boolean|number|nil
function MonsterType:Bestiaryrace(race) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:BestiarytoKill(arg2) end

---@param monsterspell MonsterSpell
---@return nil
function MonsterType:addAttack(monsterspell) end

---@param monsterspell MonsterSpell
---@return nil
function MonsterType:addDefense(monsterspell) end

---@param type any
---@param percent number
---@return boolean|nil
function MonsterType:addElement(type, percent) end

---@param type any
---@param percent number
---@return boolean|nil
function MonsterType:addHealing(type, percent) end

---@param loot Loot
---@return boolean|nil
function MonsterType:addLoot(loot) end

---@param type any
---@param percent number
---@return boolean|nil
function MonsterType:addReflect(type, percent) end

---@param soundId SoundEffect
---@return boolean
function MonsterType:addSound(soundId) end

---@param name string
---@param interval number
---@param chance number
---@param count? number
---@return boolean|nil
function MonsterType:addSummon(name, interval, chance, count) end

---@param sentence string
---@param interval number
---@param chance number
---@param yell boolean
---@return boolean|nil
function MonsterType:addVoice(sentence, interval, chance, yell) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:armor(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:baseSpeed(arg2) end

---@param raceId? number
---@param class? string
---@return boolean|string|nil
function MonsterType:bossRace(raceId, class) end

---@param raceId? number
---@return boolean|number
function MonsterType:bossRaceId(raceId) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:canPushCreatures(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:canPushItems(arg2) end

---@param pos Position
---@return boolean|nil
function MonsterType:canSpawn(pos) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:canWalkOnEnergy(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:canWalkOnFire(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:canWalkOnPoison(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:changeTargetChance(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:changeTargetSpeed(arg2) end

---@param immunity? string
---@return boolean|table|nil
function MonsterType:combatImmunities(immunity) end

---@param immunity? string
---@return boolean|table|nil
function MonsterType:conditionImmunities(immunity) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:corpseId(arg2) end

---@param arg2 number
---@return number|nil
function MonsterType:critChance(arg2) end

---@param arg2? any
---@return boolean|number
function MonsterType:deathSound(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:defense(arg2) end

---@param faction? any
---@return boolean|table|nil
function MonsterType:enemyFactions(faction) end

---@param event any
---@return boolean|nil
function MonsterType:eventType(event) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:experience(arg2) end

---@param arg2? any
---@return boolean|number|nil
function MonsterType:faction(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:familiar(arg2) end

---@return table|nil
function MonsterType:getAttackList() end

---@return number|nil
function MonsterType:getCorpseId() end

---@return table|nil
function MonsterType:getCreatureEvents() end

---@return table|nil
function MonsterType:getDefenseList() end

---@return table|nil
function MonsterType:getElementList() end

---@return nil
function MonsterType:getLoot() end

---@param stars any
---@return table
function MonsterType:getMonstersByBestiaryStars(stars) end

---@param race any
---@return table
function MonsterType:getMonstersByRace(race) end

---@return table|nil
function MonsterType:getSounds() end

---@return table|nil
function MonsterType:getSummonList() end

---@return string
function MonsterType:getTypeName() end

---@return table|nil
function MonsterType:getVoices() end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:health(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isAttackable(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isBlockable(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isConvinceable(arg2) end

---@param arg2? boolean
---@return boolean
function MonsterType:isForgeCreature(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isHealthHidden(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isHostile(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isIllusionable(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isPreyExclusive(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isPreyable(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isPushable(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isRewardBoss(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:isSummonable(arg2) end

---@param arg2? number
---@param arg3? number
---@return boolean|number|nil
function MonsterType:light(arg2, arg3) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:manaCost(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:maxHealth(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:maxSummons(arg2) end

---@param arg2? number
---@return boolean|number
function MonsterType:mitigation(arg2) end

---@param arg2? string
---@return boolean|string|nil
function MonsterType:name(arg2) end

---@param arg2? string
---@return boolean|string|nil
function MonsterType:nameDescription(arg2) end

---@param callback fun(monster: Monster, creature: Creature): boolean
---@return boolean
function MonsterType:onAppear(callback) end

---@param callback fun(monster: Monster, creature: Creature): boolean
---@return boolean
function MonsterType:onDisappear(callback) end

---@param callback fun(monster: Monster, creature: Creature, oldPosition: Position, newPosition: Position): boolean
---@return boolean
function MonsterType:onMove(callback) end

---@param callback fun(monster: Monster, attacker: Player): boolean
---@return boolean
function MonsterType:onPlayerAttack(callback) end

---@param callback fun(monster: Monster, creature: Creature, type: integer, message: string): boolean
---@return boolean
function MonsterType:onSay(callback) end

---@param callback fun(monster: Monster, position: Position): boolean
---@return boolean
function MonsterType:onSpawn(callback) end

---@param callback fun(monster: Monster, interval: integer): boolean
---@return boolean
function MonsterType:onThink(callback) end

---@param outfit? any
---@return boolean|nil
function MonsterType:outfit(outfit) end

---@param race? string
---@return boolean|number|nil
function MonsterType:race(race) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:raceId(arg2) end

---@param name string
---@return boolean|nil
function MonsterType:registerEvent(name) end

---@param arg2? any
---@return boolean|number|nil
function MonsterType:respawnTypeIsUnderground(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:runHealth(arg2) end

---@param arg2? number
---@return boolean|number
function MonsterType:soundChance(arg2) end

---@param arg2? number
---@return boolean|number
function MonsterType:soundSpeedTicks(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:staticAttackChance(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:strategiesTargetDamage(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:strategiesTargetHealth(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:strategiesTargetNearest(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:strategiesTargetRandom(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:targetDistance(arg2) end

---@param arg2? boolean
---@return boolean|number|nil
function MonsterType:targetPreferMaster(arg2) end

---@param arg2? boolean
---@return boolean|nil
function MonsterType:targetPreferPlayer(arg2) end

---@param arg2? string
---@return boolean|string
function MonsterType:variant(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:yellChance(arg2) end

---@param arg2? number
---@return boolean|number|nil
function MonsterType:yellSpeedTicks(arg2) end

---@class Mount
---@operator eq(Mount):boolean
Mount = {}

---@return number|nil
function Mount:getClientId() end

---@return number|nil
function Mount:getId() end

---@return string|nil
function Mount:getName() end

---@return number|nil
function Mount:getSpeed() end

---@class MoveEvent
---@overload fun(): MoveEvent
MoveEvent = {}

---@param ids number
---@return boolean|nil
function MoveEvent:aid(ids) end

---@param ids number
---@return boolean|nil
function MoveEvent:id(ids) end

---@param lvl number
---@return boolean|nil
function MoveEvent:level(lvl) end

---@param lvl number
---@return boolean|nil
function MoveEvent:magicLevel(lvl) end

---@param callback fun(moveItem: Item, tileItemOrPosition: Item|Position, position?: Position): boolean
---@return boolean
function MoveEvent:onAddItem(callback) end

---@param callback fun(player: Player, item: Item, slot: integer, isCheck: boolean): boolean
---@return boolean
function MoveEvent:onDeEquip(callback) end

---@param callback fun(player: Player, item: Item, slot: integer, isCheck: boolean): boolean
---@return boolean
function MoveEvent:onEquip(callback) end

---@param callback fun(moveItem: Item, tileItemOrPosition: Item|Position, position?: Position): boolean
---@return boolean
function MoveEvent:onRemoveItem(callback) end

---@param callback fun(creature: Creature, item: Item|nil, position: Position, fromPosition: Position): boolean
---@return boolean
function MoveEvent:onStepIn(callback) end

---@param callback fun(creature: Creature, item: Item|nil, position: Position, fromPosition: Position): boolean
---@return boolean
function MoveEvent:onStepOut(callback) end

---@param positions Position
---@return boolean|nil
function MoveEvent:position(positions) end

---@param value boolean
---@return boolean|nil
function MoveEvent:premium(value) end

---@return boolean|nil
function MoveEvent:register() end

---@param slot string
---@return boolean|nil
function MoveEvent:slot(slot) end

---@param callback string
---@return boolean|nil
function MoveEvent:type(callback) end

---@param ids number
---@return boolean|nil
function MoveEvent:uid(ids) end

---@param vocName string
---@param showInDescription? boolean
---@param lastVoc? boolean
---@return boolean|nil
function MoveEvent:vocation(vocName, showInDescription, lastVoc) end

---@class NetworkMessage
---@operator eq(NetworkMessage):boolean
NetworkMessage = {}

---@param value number
---@return boolean|nil
function NetworkMessage:add16(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:add32(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:add64(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:add8(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:addByte(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:addDouble(value) end

---@param item Item
---@param player Player
---@return boolean|nil
function NetworkMessage:addItem(item, player) end

---@param position Position
---@return boolean|nil
function NetworkMessage:addPosition(position) end

---@param value string
---@param callback string
---@return boolean|nil
function NetworkMessage:addString(value, callback) end

---@param value number
---@return boolean|nil
function NetworkMessage:addU16(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:addU32(value) end

---@param value number
---@return boolean|nil
function NetworkMessage:addU64(value) end

---@return nil
function NetworkMessage.delete() end

---@return number|nil
function NetworkMessage:getByte() end

---@return nil|Position
function NetworkMessage:getPosition() end

---@return string|nil
function NetworkMessage:getString() end

---@return number|nil
function NetworkMessage:getU16() end

---@return number|nil
function NetworkMessage:getU32() end

---@return number|nil
function NetworkMessage:getU64() end

---@return number|nil
function NetworkMessage:getUnreadBytes() end

---@return boolean|nil
function NetworkMessage:reset() end

---@param player Player
---@return boolean|nil
function NetworkMessage:sendToPlayer(player) end

---@param value number
---@return boolean|nil
function NetworkMessage:skipBytes(value) end

---@class Npc: Creature
---@operator eq(Npc):boolean
Npc = {}

---@param player Player
---@return boolean
function Npc:closeShopWindow(player) end

---@param player Player
---@return boolean
function Npc:follow(player) end

---@return number|nil
function Npc:getCurrency() end

---@param uid number
---@return boolean|number|nil
function Npc:getDistanceTo(uid) end

---@return number|nil
function Npc:getId() end

---@return string|nil
function Npc:getName() end

---@param itemId number
---@return boolean
function Npc:getShopItem(itemId) end

---@return number|nil
function Npc:getSpeechBubble() end

---@param position Position
---@param range? number
---@return boolean|nil
function Npc:isInTalkRange(position, range) end

---@param creature Creature
---@return boolean|nil
function Npc:isInteractingWithPlayer(creature) end

---@param playerGUID number
---@return boolean
function Npc:isMerchant(playerGUID) end

---@return boolean
function Npc:isNpc() end

---@param creature Creature
---@param topicId number
---@return boolean|nil
function Npc:isPlayerInteractingOnTopic(creature, topicId) end

---@param direction any
---@return nil
function Npc:move(direction) end

---@param player Player
---@return boolean
function Npc:openShopWindow(player) end

---@param player Player
---@param items table
---@return boolean
function Npc:openShopWindowTable(player, items) end

---@param position Position
---@param extended? boolean
---@param force? boolean
---@return nil|Npc
function Npc:place(position, extended, force) end

---@param creature Creature
---@return boolean|nil
function Npc:removePlayerInteraction(creature) end

---@param text string
---@param type? any
---@param ghost? boolean
---@param target? Creature
---@param position? Position
---@return boolean|nil
function Npc:say(text, type, ghost, target, position) end

---@param player Player
---@param itemId number
---@param amount number
---@param subtype? number
---@param actionId? number
---@param ignoreCap? boolean
---@param inBackpacks? boolean
---@return boolean
function Npc:sellItem(player, itemId, amount, subtype, actionId, ignoreCap, inBackpacks) end

---@param arg2 number
---@return boolean
function Npc:setCurrency(arg2) end

---@param pos Position
---@return boolean
function Npc:setMasterPos(pos) end

---@param name string
---@return nil
function Npc:setName(name) end

---@param creature Creature
---@param topic number
---@return boolean|nil
function Npc:setPlayerInteraction(creature, topic) end

---@param speechBubble number
---@return nil
function Npc:setSpeechBubble(speechBubble) end

---@param direction any
---@return nil
function Npc:turn(direction) end

---@param creature Creature
---@param arg2 boolean
---@return boolean|nil
function Npc:turnToCreature(creature, arg2) end

---@class NpcType
---@overload fun(name: string): NpcType
---@operator eq(NpcType):boolean
NpcType = {}

---@param shop Shop
---@return boolean|nil
function NpcType:addShopItem(shop) end

---@param soundId SoundEffect
---@return boolean
function NpcType:addSound(soundId) end

---@param sentence string
---@param interval number
---@param chance number
---@param yell boolean
---@return boolean|nil
function NpcType:addVoice(sentence, interval, chance, yell) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:baseSpeed(arg2) end

---@param arg2? boolean
---@return boolean|nil
function NpcType:canPushCreatures(arg2) end

---@param arg2? boolean
---@return boolean|nil
function NpcType:canPushItems(arg2) end

---@param pos Position
---@return boolean|nil
function NpcType:canSpawn(pos) end

---@param arg2? number
---@return boolean|number
function NpcType:currency(arg2) end

---@param event any
---@return boolean|nil
function NpcType:eventType(event) end

---@param arg2? boolean
---@return boolean|nil
function NpcType:floorChange(arg2) end

---@return table|nil
function NpcType:getCreatureEvents() end

---@return table|nil
function NpcType:getSounds() end

---@return table|nil
function NpcType:getVoices() end

---@param arg2? number
---@return boolean|number|nil
function NpcType:health(arg2) end

---@param arg2? boolean
---@return boolean|nil
function NpcType:isPushable(arg2) end

---@param arg2? number
---@param arg3? number
---@return boolean|number|nil
function NpcType:light(arg2, arg3) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:maxHealth(arg2) end

---@param arg2? string
---@return boolean|string|nil
function NpcType:name(arg2) end

---@param arg2? string
---@return boolean|string|nil
function NpcType:nameDescription(arg2) end

---@param callback fun(npc: Npc, creature: Creature): boolean
---@return boolean
function NpcType:onAppear(callback) end

---@param callback fun(npc: Npc, player: Player, itemId: integer, subType: integer, amount: integer, ignore: boolean, inBackpacks: boolean, totalCost: integer): boolean
---@return boolean
function NpcType:onBuyItem(callback) end

---@param callback fun(npc: Npc, player: Player, itemId: integer, subType: integer): boolean
---@return boolean
function NpcType:onCheckItem(callback) end

---@param callback fun(npc: Npc, player: Player): boolean
---@return boolean
function NpcType:onCloseChannel(callback) end

---@param callback fun(npc: Npc, creature: Creature): boolean
---@return boolean
function NpcType:onDisappear(callback) end

---@param callback fun(npc: Npc, creature: Creature, oldPosition: Position, newPosition: Position): boolean
---@return boolean
function NpcType:onMove(callback) end

---@param callback fun(npc: Npc, creature: Creature, type: integer, message: string): boolean
---@return boolean
function NpcType:onSay(callback) end

---@param callback fun(npc: Npc, player: Player, itemId: integer, subType: integer, amount: integer, ignore: boolean, itemName: string, totalCost: integer): boolean
---@return boolean
function NpcType:onSellItem(callback) end

---@param callback fun(npc: Npc, interval: integer): boolean
---@return boolean
function NpcType:onThink(callback) end

---@param outfit? any
---@return boolean|nil
function NpcType:outfit(outfit) end

---@param name string
---@return boolean|nil
function NpcType:registerEvent(name) end

---@param arg2? any
---@return boolean|number|nil
function NpcType:respawnTypeIsUnderground(arg2) end

---@overload fun(name: string): NpcType
---@param arg2? any
---@return boolean|number|nil
function NpcType.respawnTypePeriod(arg2) end

---@param arg2? number
---@return boolean|number
function NpcType:soundChance(arg2) end

---@param arg2? number
---@return boolean|number
function NpcType:soundSpeedTicks(arg2) end

---@param arg2? number
---@return boolean|number
function NpcType:speechBubble(arg2) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:walkInterval(arg2) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:walkRadius(arg2) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:yellChance(arg2) end

---@param arg2? number
---@return boolean|number|nil
function NpcType:yellSpeedTicks(arg2) end

---@class Party
---@operator eq(Party):boolean
Party = {}

---@param player Player
---@return boolean|nil
function Party:addInvite(player) end

---@param player Player
---@return boolean|nil
function Party:addMember(player) end

---@return boolean|nil
function Party:disband() end

---@return number|nil
function Party:getInviteeCount() end

---@return Player[]|nil
function Party:getInvitees() end

---@return nil|Player
function Party:getLeader() end

---@return number|nil
function Party:getMemberCount() end

---@return Player[]|nil
function Party:getMembers() end

---@return number|nil
function Party:getUniqueVocationsCount() end

---@return boolean|nil
function Party:isSharedExperienceActive() end

---@return boolean|nil
function Party:isSharedExperienceEnabled() end

---@param player Player
---@return boolean|nil
function Party:removeInvite(player) end

---@param player Player
---@return boolean|nil
function Party:removeMember(player) end

---@param player Player
---@return boolean|nil
function Party:setLeader(player) end

---@param active boolean
---@return boolean|nil
function Party:setSharedExperience(active) end

---@param experience number
---@return boolean|nil
function Party:shareExperience(experience) end

---@class Player: Creature
---@overload fun(idOrGuid: integer): Player?
---@overload fun(name: string): Player?, integer?
---@overload fun(player: Player): Player?
---@operator eq(Player):boolean
Player = {}

---@param idOrName number|string
---@param sendMessage? boolean
---@return boolean
function Player:addAchievement(idOrName, sendMessage) end

---@param amount number
---@return boolean
function Player:addAchievementPoints(amount) end

---@param monsterType string
---@return nil
function Player:addAnimusMastery(monsterType) end

---@param id number
---@return boolean
function Player:addBadge(id) end

---@param name string
---@param amount? number
---@return boolean|nil
function Player:addBestiaryKill(name, amount) end

---@param blessing number
---@return boolean|nil
function Player:addBlessing(blessing) end

---@param name string
---@param amount? number
---@return boolean|nil
function Player:addBosstiaryKill(name, amount) end

---@param charms number
---@return boolean|nil
function Player:addCharmPoints(charms) end

---@param type string
---@param idOrName number|string
---@return boolean
function Player:addCustomOutfit(type, idOrName) end

---@param experience number
---@param sendText? boolean
---@return boolean|nil
function Player:addExperience(experience, sendText) end

---@param lookType number
---@return boolean|nil
function Player:addFamiliar(lookType) end

---@param amount number
---@return boolean
function Player:addForgeDustLevel(amount) end

---@param amount number
---@return boolean
function Player:addForgeDusts(amount) end

---@param itemId number|string
---@param count? number
---@param canDropOnMap? boolean
---@param subType? number
---@param slot? number
---@param tier? number
---@return Item|Item[]|nil|false
function Player:addItem(itemId, count, canDropOnMap, subType, slot, tier) end

---@param container Container
---@param itemId number
---@param count number
---@param tier number
---@param flags number
---@return number|nil
function Player:addItemBatchToPaginedContainer(container, itemId, count, tier, flags) end

---@overload fun(item: Item, canDropOnMap?: false, index?: integer, flags?: integer): integer|false|nil
---@overload fun(item: Item, canDropOnMap: true, slot?: integer): integer|false|nil
---@param item Item
---@param canDropOnMap? boolean
---@param indexOrSlot? integer
---@param flags? integer
---@return integer|false|nil
function Player:addItemEx(item, canDropOnMap, indexOrSlot, flags) end

---@param itemId number
---@param count number
---@return boolean|nil
function Player:addItemStash(itemId, count) end

---@param manaChange number
---@param animationOnLoss? boolean
---@return boolean|nil
function Player:addMana(manaChange, animationOnLoss) end

---@param amount number
---@return boolean|nil
function Player:addManaSpent(amount) end

---@param position Position
---@param type number
---@param description string
---@return boolean|nil
function Player:addMapMark(position, type, description) end

---@param charms number
---@return boolean
function Player:addMinorCharmEchoes(charms) end

---@param money number
---@param flags? number
---@return boolean|number|nil
function Player:addMoney(money, flags) end

---@param mountIdOrMountName number|string
---@return boolean|nil
function Player:addMount(mountIdOrMountName) end

---@param time number
---@return boolean|nil
function Player:addOfflineTrainingTime(time) end

---@param skillType any
---@param tries number
---@return boolean|nil
function Player:addOfflineTrainingTries(skillType, tries) end

---@param lookTypeOrName number|string
---@param addon number
---@return boolean|nil
function Player:addOutfit(lookTypeOrName, addon) end

---@param lookType number
---@param addon number
---@return boolean|nil
function Player:addOutfitAddon(lookType, addon) end

---@param days number
---@return boolean|nil
function Player:addPremiumDays(days) end

---@param amount number
---@return boolean|nil
function Player:addPreyCards(amount) end

---@param skillType any
---@param tries number
---@return boolean|nil
function Player:addSkillTries(skillType, tries) end

---@param soulChange number
---@return boolean|nil
function Player:addSoul(soulChange) end

---@param amount number
---@return number|nil
function Player:addTaskHuntingPoints(amount) end

---@param coins number
---@return boolean|nil
function Player:addTibiaCoins(coins) end

---@param id number
---@return boolean
function Player:addTitle(id) end

---@param coins number
---@return boolean|nil
function Player:addTransferableCoins(coins) end

---@param experience number
---@param itemId number
---@return boolean
function Player:addWeaponExperience(experience, itemId) end

---@param item Item
---@param scrollItem Item
---@return boolean
function Player:applyImbuementScroll(item, scrollItem) end

---@param value? number
---@return boolean|number|nil
function Player:avatarTimer(value) end

---@return number
function Player:calculateFlatDamageHealing() end

---@param spell any
---@return boolean|nil
function Player:canCast(spell) end

---@param spellName string
---@return boolean|nil
function Player:canLearnSpell(spellName) end

---@return boolean
function Player:canReceiveLoot() end

---@param newName string
---@return boolean
function Player:changeName(newName) end

---@param speaker Creature
---@param type any
---@param text string
---@param channelId number
---@return boolean|nil
function Player:channelSay(speaker, type, text, channelId) end

---@param arg2? boolean
---@return boolean|nil
function Player:charmExpansion(arg2) end

---@param item Item
---@return boolean
function Player:clearAllImbuements(item) end

---@param spenders boolean
---@param builder boolean
---@return boolean|nil
function Player:clearSpellCooldowns(spenders, builder) end

---@return boolean
function Player:closeForge() end

---@return boolean
function Player:closeImbuementWindow() end

---@param type number
---@param amount number
---@param id? string
---@return boolean
function Player:createTransactionSummary(type, amount, id) end

---@return boolean
function Player:fillHarmony() end

---@param spellName string
---@return boolean|nil
function Player:forgetSpell(spellName) end

---@return number|nil
function Player:getAccountId() end

---@return number|nil
function Player:getAccountType() end

---@return number
function Player:getAchievementPoints() end

---@return nil|Container
function Player:getBackpack() end

---@return number|nil
function Player:getBankBalance() end

---@return number|nil
function Player:getBaseMagicLevel() end

---@return number|nil
function Player:getBaseMaxHealth() end

---@return number|nil
function Player:getBaseMaxMana() end

---@return number|nil
function Player:getBaseXpGain() end

---@param index number
---@param storeCount? boolean
---@return number|nil
function Player:getBlessingCount(index, storeCount) end

---@param slotId number
---@return boolean|number
function Player:getBossBonus(slotId) end

---@param name string
---@return number|nil
function Player:getBosstiaryKills(name) end

---@param name string
---@return number|nil
function Player:getBosstiaryLevel(name) end

---@return number|nil
function Player:getCapacity() end

---@param charmId any
---@return number
function Player:getCharmChance(charmId) end

---@param arg1 any
---@return nil|MonsterType
function Player:getCharmMonsterType(arg1) end

---@param charmId any
---@return number
function Player:getCharmTier(charmId) end

---@return table|nil
function Player:getClient() end

---@param id number
---@return nil|Container
function Player:getContainerById(id) end

---@param container Container
---@return number|nil
function Player:getContainerId(container) end

---@param id number
---@return number|nil
function Player:getContainerIndex(id) end

---@return number|nil
function Player:getDeathPenalty() end

---@param depotId number
---@param autoCreate? boolean
---@return boolean|nil|Item
function Player:getDepotChest(depotId, autoCreate) end

---@param depotId number
---@return boolean|nil|Item
function Player:getDepotLocker(depotId) end

---@param skillType any
---@return number|nil
function Player:getEffectiveSkillLevel(skillType) end

---@return number|nil
function Player:getExperience() end

---@return boolean|number
function Player:getFaction() end

---@return number|nil
function Player:getFamiliarLooktype() end

---@return number|nil
function Player:getFightMode() end

---@return boolean|number
function Player:getForgeCores() end

---@return boolean|number
function Player:getForgeDustLevel() end

---@return boolean|number
function Player:getForgeDusts() end

---@return boolean|number
function Player:getForgeSlivers() end

---@return number|nil
function Player:getFreeBackpackSlots() end

---@return number|nil
function Player:getFreeCapacity() end

---@return number|nil
function Player:getGrindingXpBoost() end

---@return nil|Group
function Player:getGroup() end

---@return number|nil
function Player:getGuid() end

---@return nil|Guild
function Player:getGuild() end

---@return number|nil
function Player:getGuildLevel() end

---@return string|nil
function Player:getGuildNick() end

---@return number
function Player:getHarmony() end

---@param baseMin integer
---@param baseMax integer
---@return integer min
---@return integer max
function Player:getHarmonyDamage(baseMin, baseMax) end

---@return boolean|number
function Player:getHazardSystemPoints() end

---@return nil|House
function Player:getHouse() end

---@return number|nil
function Player:getIdleTime() end

---@return boolean|nil|Item
function Player:getInbox() end

---@return table|nil
function Player:getInstantSpells() end

---@return number|nil
function Player:getIp() end

---@param itemId number|string
---@param deepSearch boolean
---@param subType? number
---@return nil|Item
function Player:getItemById(itemId, deepSearch, subType) end

---@param itemId number|string
---@param subType? number
---@return number|nil
function Player:getItemCount(itemId, subType) end

---@return table|nil
function Player:getKills() end

---@return number|nil
function Player:getLastLoginSaved() end

---@return number|nil
function Player:getLastLogout() end

---@return number|nil
function Player:getLevel() end

---@return string|table|nil
function Player:getLivestreamViewers() end

---@return number|nil
function Player:getLivestreamViewersCount() end

---@return nil|Container
function Player:getLootPouch() end

---@return number|nil
function Player:getLoyaltyBonus() end

---@return number|nil
function Player:getLoyaltyPoints() end

---@return string|nil
function Player:getLoyaltyTitle() end

---@return number|nil
function Player:getMagicLevel() end

---@param useCharges boolean
---@return number|nil
function Player:getMagicShieldCapacityFlat(useCharges) end

---@param useCharges boolean
---@return number|nil
function Player:getMagicShieldCapacityPercent(useCharges) end

---@return number|nil
function Player:getMana() end

---@return number|nil
function Player:getManaSpent() end

---@return boolean|string
function Player:getMapShader() end

---@return number|nil
function Player:getMaxMana() end

---@return number|nil
function Player:getMaxSoul() end

---@return number|nil
function Player:getMoney() end

---@return boolean|string
function Player:getName() end

---@return number|nil
function Player:getOfflineTrainingSkill() end

---@return number|nil
function Player:getOfflineTrainingTime() end

---@return nil|Party
function Player:getParty() end

---@return number|nil
function Player:getPremiumDays() end

---@return number|nil
function Player:getPreyCards() end

---@param raceId number
---@return number|nil
function Player:getPreyExperiencePercentage(raceId) end

---@param raceId number
---@return number|nil
function Player:getPreyLootPercentage(raceId) end

---@return number|nil
function Player:getPronoun() end

---@param rewardId number
---@param autoCreate? boolean
---@return boolean|nil|Item
function Player:getReward(rewardId, autoCreate) end

---@return table|nil
function Player:getRewardList() end

---@return number|nil
function Player:getSex() end

---@param skillType any
---@return number|nil
function Player:getSkillLevel(skillType) end

---@param skillType any
---@return number|nil
function Player:getSkillPercent(skillType) end

---@param skillType any
---@return number|nil
function Player:getSkillTries(skillType) end

---@return number|nil
function Player:getSkullTime() end

---@param slotId number
---@return boolean|number
function Player:getSlotBossId(slotId) end

---@param slot number
---@return nil|Item
function Player:getSlotItem(slot) end

---@return number|nil
function Player:getSoul() end

---@return number|nil
function Player:getStamina() end

---@return number|nil
function Player:getStaminaXpBoost() end

---@return number|nil
function Player:getStashCount() end

---@param itemId number|string
---@return number|nil
function Player:getStashItemCount(itemId) end

---@param key number
---@return number|nil
function Player:getStorageValue(key) end

---@return boolean|nil|Item
function Player:getStoreInbox() end

---@return boolean|number
function Player:getTaskHuntingPoints() end

---@return number|nil
function Player:getTibiaCoins() end

---@return table
function Player:getTitles() end

---@return nil|Town
function Player:getTown() end

---@return number|nil
function Player:getTransferableCoins() end

---@return boolean|number
function Player:getVipDays() end

---@return boolean|number
function Player:getVipTime() end

---@return number
function Player:getVirtue() end

---@return nil|Vocation
function Player:getVocation() end

---@return number|nil
function Player:getVoucherXpBoost() end

---@param spellname string
---@return boolean
function Player:getWheelSpellAdditionalArea(spellname) end

---@param spellname string
---@return boolean|number
function Player:getWheelSpellAdditionalDuration(spellname) end

---@param spellname string
---@return boolean|number
function Player:getWheelSpellAdditionalTarget(spellname) end

---@return number|nil
function Player:getXpBoostPercent() end

---@return number|nil
function Player:getXpBoostTime() end

---@param idOrName number|string
---@return boolean
function Player:hasAchievement(idOrName) end

---@param monsterType string
---@return boolean
function Player:hasAnimusMastery(monsterType) end

---@param blessing number
---@return boolean|nil
function Player:hasBlessing(blessing) end

---@return boolean|nil
function Player:hasChaseMode() end

---@param lookType number
---@return boolean|nil
function Player:hasFamiliar(lookType) end

---@param flag any
---@return boolean
function Player:hasGroupFlag(flag) end

---@param spellName string
---@return boolean|nil
function Player:hasLearnedSpell(spellName) end

---@param mountIdOrMountName number|string
---@return boolean|nil
function Player:hasMount(mountIdOrMountName) end

---@param lookType number
---@param addon? number
---@return boolean|nil
function Player:hasOutfit(lookType, addon) end

---@return boolean|nil
function Player:hasSecureMode() end

---@param name string
---@param value? boolean
---@return boolean|nil
function Player:instantSkillWOD(name, value) end

---@return boolean
function Player:isIdleCombat() end

---@return boolean
function Player:isLivestreamViewer() end

---@param raceId number
---@return boolean
function Player:isMonsterBestiaryUnlocked(raceId) end

---@param raceId number
---@return boolean|nil
function Player:isMonsterPrey(raceId) end

---@return boolean
function Player:isOffline() end

---@return boolean
function Player:isPlayer() end

---@return boolean|nil
function Player:isPromoted() end

---@return boolean|nil
function Player:isPzLocked() end

---@return boolean|number
function Player:isTraining() end

---@param time number
---@return boolean
function Player:isUIExhausted(time) end

---@return boolean
function Player:isVip() end

---@return boolean|KV
function Player:kv() end

---@param spellName string
---@return boolean|nil
function Player:learnSpell(spellName) end

---@param force? boolean
---@return boolean|nil
function Player:onThinkWheelOfDestiny(force) end

---@param channelId number
---@return boolean|nil
function Player:openChannel(channelId) end

---@return boolean
function Player:openForge() end

---@param action? any
---@param item? Item
---@return boolean
function Player:openImbuementWindow(action, item) end

---@return boolean|nil
function Player:openMarket() end

---@param isNpc boolean
---@return boolean|nil
function Player:openStash(isNpc) end

---@param message string
---@return boolean|nil
function Player:popupFYI(message) end

---@param arg2? boolean
---@return boolean|nil
function Player:preyThirdSlot(arg2) end

---@return boolean|nil
function Player:reloadData() end

---@param idOrName number|string
---@return boolean
function Player:removeAchievement(idOrName) end

---@param amount number
---@return boolean
function Player:removeAchievementPoints(amount) end

---@param monsterType string
---@return nil
function Player:removeAnimusMastery(monsterType) end

---@param blessing number
---@return boolean|nil
function Player:removeBlessing(blessing) end

---@param type string
---@param idOrName number|string
---@return boolean
function Player:removeCustomOutfit(type, idOrName) end

---@param experience number
---@param sendText? boolean
---@return boolean|nil
function Player:removeExperience(experience, sendText) end

---@param lookType number
---@return boolean|nil
function Player:removeFamiliar(lookType) end

---@param amount number
---@return boolean
function Player:removeForgeDustLevel(amount) end

---@param amount number
---@return boolean
function Player:removeForgeDusts(amount) end

---@param flag any
---@return boolean
function Player:removeGroupFlag(flag) end

---@param iconType? any
---@return boolean|nil
function Player:removeIconBakragore(iconType) end

---@param itemId number|string
---@param count number
---@param subType? number
---@param ignoreEquipped? boolean
---@return boolean|nil
function Player:removeItem(itemId, count, subType, ignoreEquipped) end

---@param money number
---@param flags? number
---@param useBank? boolean
---@return boolean|nil
function Player:removeMoney(money, flags, useBank) end

---@param mountIdOrMountName number|string
---@return boolean|nil
function Player:removeMount(mountIdOrMountName) end

---@param time number
---@return boolean|nil
function Player:removeOfflineTrainingTime(time) end

---@param lookType number
---@return boolean|nil
function Player:removeOutfit(lookType) end

---@param lookType number
---@param addon number
---@return boolean|nil
function Player:removeOutfitAddon(lookType, addon) end

---@param days number
---@return boolean|nil
function Player:removePremiumDays(days) end

---@param amount number
---@return boolean|nil
function Player:removePreyStamina(amount) end

---@param rewardId number
---@return boolean|nil
function Player:removeReward(rewardId) end

---@param itemId number|string
---@param count number
---@return boolean|nil
function Player:removeStashItem(itemId, count) end

---@param amount number
---@return boolean|nil
function Player:removeTaskHuntingPoints(amount) end

---@param coins number
---@return boolean|nil
function Player:removeTibiaCoins(coins) end

---@param coins number
---@return boolean|nil
function Player:removeTransferableAndTibiaCoins(coins) end

---@param coins number
---@return boolean|nil
function Player:removeTransferableCoins(coins) end

---@return boolean|nil
function Player:resetCharmsBestiary() end

---@return boolean
function Player:resetOldCharms() end

---@param name? string
---@param set? boolean|number
---@return boolean|number|nil
function Player:revelationStageWOD(name, set) end

---@return boolean|nil
function Player:save() end

---@param id any
---@return boolean
function Player:sendAmbientSoundEffect(id) end

---@return boolean
function Player:sendBlessStatus() end

---@return boolean
function Player:sendBosstiaryCooldownTimer() end

---@param author string
---@param text string
---@param type any
---@param channelId number
---@return boolean|nil
function Player:sendChannelMessage(author, text, type, channelId) end

---@param container Container
---@return boolean|nil
function Player:sendContainer(container) end

---@param isLogin boolean
---@return boolean
function Player:sendCreatureAppear(isLogin) end

---@param mainSoundId SoundEffect
---@param secondarySoundId SoundEffect
---@param actor? boolean
---@return boolean
function Player:sendDoubleSoundEffect(mainSoundId, secondarySoundId, actor) end

---@param house House
---@param listId number
---@return boolean|nil
function Player:sendHouseWindow(house, listId) end

---@param iconType any
---@return boolean|nil
function Player:sendIconBakragore(iconType) end

---@return boolean|nil
function Player:sendInventory() end

---@param item Item
---@param count number
---@return boolean|nil
function Player:sendLootStats(item, count) end

---@param id any
---@return boolean
function Player:sendMusicSoundEffect(id) end

---@return boolean|nil
function Player:sendOutfitWindow() end

---@param speaker Player
---@param text string
---@param type? any
---@return boolean|nil
function Player:sendPrivateMessage(speaker, text, type) end

---@param soundId SoundEffect
---@param actor? boolean
---@return boolean
function Player:sendSingleSoundEffect(soundId, actor) end

---@param spellId number
---@param time number
---@return boolean|nil
function Player:sendSpellCooldown(spellId, time) end

---@param groupId any
---@param time number
---@return boolean|nil
function Player:sendSpellGroupCooldown(groupId, time) end

---@param type any
---@param text string
---@param position? number|Position
---@param primaryValue? number
---@param primaryColor? any
---@param secondaryValue? number
---@param secondaryColor? any
---@return boolean|nil
function Player:sendTextMessage(type, text, position, primaryValue, primaryColor, secondaryValue, secondaryColor) end

---@param tutorialId number
---@return boolean|nil
function Player:sendTutorial(tutorialId) end

---@param container Container
---@return boolean|nil
function Player:sendUpdateContainer(container) end

---@param accountType any
---@return boolean|nil
function Player:setAccountType(accountType) end

---@param bankBalance number
---@return boolean|nil
function Player:setBankBalance(bankBalance) end

---@param value number
---@return boolean|nil
function Player:setBaseXpGain(value) end

---@param arg2 number
---@return boolean
function Player:setBossPoints(arg2) end

---@param capacity number
---@return boolean|nil
function Player:setCapacity(capacity) end

---@param id number
---@return boolean
function Player:setCurrentTitle(id) end

---@param value number
---@return boolean|nil
function Player:setDailyReward(value) end

---@param house House
---@param listId number
---@return boolean|nil
function Player:setEditHouse(house, listId) end

---@param factionId any
---@return boolean
function Player:setFaction(factionId) end

---@param lookType number
---@return boolean|nil
function Player:setFamiliarLooktype(lookType) end

---@param arg2 number
---@return boolean
function Player:setForgeDusts(arg2) end

---@param enabled boolean
---@return boolean|nil
function Player:setGhostMode(enabled) end

---@param value number
---@return boolean|nil
function Player:setGrindingXpBoost(value) end

---@param group Group
---@return boolean|nil
function Player:setGroup(group) end

---@param flag any
---@return boolean
function Player:setGroupFlag(flag) end

---@param guild Guild
---@return boolean|nil
function Player:setGuild(guild) end

---@param level number
---@return boolean|nil
function Player:setGuildLevel(level) end

---@param nick string
---@return boolean|nil
function Player:setGuildNick(nick) end

---@param amount number
---@return boolean
function Player:setHazardSystemPoints(amount) end

---@param value boolean
---@return boolean|nil
function Player:setIdleCombat(value) end

---@param kills any
---@return boolean|nil
function Player:setKills(kills) end

---@param level number
---@return boolean|nil
function Player:setLevel(level) end

---@param data table
---@return boolean
function Player:setLivestreamViewers(data) end

---@param amount number
---@return boolean|nil
function Player:setLoyaltyBonus(amount) end

---@param name string
---@return boolean|nil
function Player:setLoyaltyTitle(name) end

---@param level number
---@param manaSpent? number
---@return boolean|nil
function Player:setMagicLevel(level, manaSpent) end

---@param shaderName string
---@param temporary? any
---@return boolean
function Player:setMapShader(shaderName, temporary) end

---@param maxMana number
---@return boolean
function Player:setMaxMana(maxMana) end

---@param skillId number
---@return boolean|nil
function Player:setOfflineTrainingSkill(skillId) end

---@param newPronoun any
---@return boolean|nil
function Player:setPronoun(newPronoun) end

---@param arg2 number
---@return boolean
function Player:setRemoveBossTime(arg2) end

---@param value boolean
---@param ticks number
---@return boolean
function Player:setSerene(value, ticks) end

---@param newSex any
---@return boolean|nil
function Player:setSex(newSex) end

---@param skillType any
---@param level number
---@param tries? number
---@return boolean|nil
function Player:setSkillLevel(skillType, level, tries) end

---@param skullTime number
---@return boolean|nil
function Player:setSkullTime(skullTime) end

---@param stashMenu boolean
---@param marketMenu boolean
---@param depotSearchMenu boolean
---@return boolean|nil
function Player:setSpecialContainersAvailable(stashMenu, marketMenu, depotSearchMenu) end

---@param speed number
---@return boolean
function Player:setSpeed(speed) end

---@param stamina number
---@return nil
function Player:setStamina(stamina) end

---@param value number
---@return boolean|nil
function Player:setStaminaXpBoost(value) end

---@param key number
---@param value number
---@return boolean|nil
function Player:setStorageValue(key, value) end

---@param town Town
---@return boolean|nil
function Player:setTown(town) end

---@param value boolean
---@return boolean|nil
function Player:setTraining(value) end

---@param virtue any
---@return boolean
function Player:setVirtue(virtue) end

---@param idOrNameOrUserdata number|string|Vocation
---@return boolean|nil
function Player:setVocation(idOrNameOrUserdata) end

---@param value number
---@return boolean|nil
function Player:setVoucherXpBoost(value) end

---@param value number
---@return boolean|nil
function Player:setXpBoostPercent(value) end

---@param timeLeft number
---@return boolean|nil
function Player:setXpBoostTime(timeLeft) end

---@param idOrNameOrUserdata number|string|Item
---@param text? string
---@param canWrite? boolean
---@param length? number
---@return boolean|nil
function Player:showTextDialog(idOrNameOrUserdata, text, canWrite, length) end

---@param screenshotType any
---@param skillId? number
---@param skillLevel? number
---@param achievementName? string
---@param raceId? number
---@param bestiaryStep? number
---@return boolean|nil
function Player:takeScreenshot(screenshotType, skillId, skillLevel, achievementName, raceId, bestiaryStep) end

---@param arg2? boolean
---@return boolean|nil
function Player:taskHuntingThirdSlot(arg2) end

---@return boolean|nil
function Player:unlockAllCharmRunes() end

---@param itemId number
---@param timeLeft number
---@return boolean|nil
function Player:updateConcoction(itemId, timeLeft) end

---@param itemId number
---@param timeLeft number
---@return boolean|nil
function Player:updateFood(itemId, timeLeft) end

---@param creature Creature
---@param corpse Container
---@return boolean|nil
function Player:updateKillTracker(creature, corpse) end

---@param item Item
---@return boolean|nil
function Player:updateSupplyTracker(item) end

---@param exhaustionTime number
---@return boolean
function Player:updateUIExhausted(exhaustionTime) end

---@param name? string
---@param add? boolean
---@return boolean|number|nil
function Player:upgradeSpellsWOD(name, add) end

---@param scrollName string
---@return boolean
function Player:wheelUnlockScroll(scrollName) end

---@class Position
---@field x integer
---@field y integer
---@field z integer
---@field stackpos integer
---@overload fun(): Position
---@overload fun(x?: integer, y?: integer, z?: integer, stackpos?: integer): Position
---@overload fun(position: Position): Position
---@operator add(Position):Position
---@operator eq(Position):boolean
---@operator sub(Position):Position
Position = {}

---@param positionEx Position
---@return number
function Position:getDistance(positionEx) end

---@param pos Position
---@param minTargetDist? number
---@param maxTargetDist? number
---@param fullPathSearch? boolean
---@param clearSight? boolean
---@param maxSearchDist? number
---@return boolean|table
function Position:getPathTo(pos, minTargetDist, maxTargetDist, fullPathSearch, clearSight, maxSearchDist) end

---@return nil|Tile
function Position:getTile() end

---@return table|nil
function Position:getZones() end

---@param positionEx Position
---@param sameFloor? boolean
---@return boolean
function Position:isSightClear(positionEx, sameFloor) end

---@param magicEffect MagicEffect
---@param player? Player
---@return boolean
function Position:removeMagicEffect(magicEffect, player) end

---@param positionEx Position
---@param distanceEffect DistanceEffect
---@param player? Player
---@return boolean
function Position:sendDistanceEffect(positionEx, distanceEffect, player) end

---@param mainSoundId SoundEffect
---@param secondarySoundId SoundEffect
---@param actor? Creature
---@return boolean
function Position:sendDoubleSoundEffect(mainSoundId, secondarySoundId, actor) end

---@param magicEffect MagicEffect
---@param player? Player
---@return boolean
function Position:sendMagicEffect(magicEffect, player) end

---@param soundId SoundEffect
---@param actor? Creature
---@return boolean
function Position:sendSingleSoundEffect(soundId, actor) end

---@return string
function Position:toString() end

---@class Result
Result = {}

---@param resultId number
---@return boolean
function Result.free(resultId) end

---@param resultId number
---@param column string
---@return number|false
function Result.getNumber(resultId, column) end

---@param resultId number
---@param column string
---@return string|false stream
---@return number? length
function Result.getStream(resultId, column) end

---@param resultId number
---@param column string
---@return string|false
function Result.getString(resultId, column) end

---@param resultId number
---@return boolean
function Result.next(resultId) end

---@class Shop
Shop = {}

---@param shop Shop
---@return nil
function Shop:addChildShop(shop) end

---@param price number
---@return boolean|nil
function Shop:setBuyPrice(price) end

---@param count number
---@return boolean|nil
function Shop:setCount(count) end

---@param id number
---@return boolean|nil
function Shop:setId(id) end

---@param name string
---@return boolean|nil
function Shop:setIdFromName(name) end

---@param name string
---@return boolean|nil
function Shop:setNameItem(name) end

---@param chance number
---@return boolean|nil
function Shop:setSellPrice(chance) end

---@param storage number
---@return boolean|nil
function Shop:setStorageKey(storage) end

---@param value number
---@return boolean|nil
function Shop:setStorageValue(value) end

---@class Spdlog
Spdlog = {}

---@param text string
---@return nil
function Spdlog.debug(text) end

---@param text string
---@return nil
function Spdlog.error(text) end

---@param text string
---@return nil
function Spdlog.info(text) end

---@param text string
---@return nil
function Spdlog.warn(text) end

---@class Spell
---@operator eq(Spell):boolean
Spell = {}

---@param value? boolean
---@return boolean|nil
function Spell:allowFarUse(value) end

---@param value? boolean
---@return boolean|nil
function Spell:allowOnSelf(value) end

---@param value? boolean
---@return boolean|nil
function Spell:blockWalls(value) end

---@param arg2? number
---@return boolean|number|nil
function Spell:castSound(arg2) end

---@param charges? number
---@return boolean|number|nil
function Spell:charges(charges) end

---@param value? boolean
---@return boolean|nil
function Spell:checkFloor(value) end

---@param cooldown? number
---@return boolean|number|nil
function Spell:cooldown(cooldown) end

---@param primaryGroup? string
---@param secondaryGroup? string
---@return boolean|number|nil
function Spell:group(primaryGroup, secondaryGroup) end

---@param primaryGroupCd? number
---@param secondaryGroupCd? number
---@return boolean|number|nil
function Spell:groupCooldown(primaryGroupCd, secondaryGroupCd) end

---@param value? boolean
---@return boolean|nil
function Spell:hasParams(value) end

---@param value? boolean
---@return boolean|nil
function Spell:hasPlayerNameParam(value) end

---@param id? number
---@return boolean|number|nil
function Spell:id(id) end

---@param arg2? number
---@return boolean|number|nil
function Spell:impactSound(arg2) end

---@param value? boolean
---@return boolean|nil
function Spell:isAggressive(value) end

---@param blockingSolid? boolean
---@param blockingCreature? boolean
---@return boolean|nil
function Spell:isBlocking(blockingSolid, blockingCreature) end

---@param value? boolean
---@return boolean|nil
function Spell:isBlockingWalls(value) end

---@param value? boolean
---@return boolean|nil
function Spell:isEnabled(value) end

---@param value? boolean
---@return boolean|nil
function Spell:isPremium(value) end

---@param value? boolean
---@return boolean|nil
function Spell:isSelfTarget(value) end

---@param lvl? number
---@return boolean|number|nil
function Spell:level(lvl) end

---@param lvl? number
---@return boolean|number|nil
function Spell:magicLevel(lvl) end

---@param mana? number
---@return boolean|number|nil
function Spell:mana(mana) end

---@param percent? number
---@return boolean|number|nil
function Spell:manaPercent(percent) end

---@param type? number
---@return boolean|number|nil
function Spell:monkSpellType(type) end

---@param name? string
---@return boolean|string|nil
function Spell:name(name) end

---@param value? boolean
---@return boolean|nil
function Spell:needCasterTargetOrDirection(value) end

---@param value? boolean
---@return boolean|nil
function Spell:needDirection(value) end

---@param value? boolean
---@return boolean|nil
function Spell:needLearn(value) end

---@param value? boolean
---@return boolean|nil
function Spell:needTarget(value) end

---@param value? boolean
---@return boolean|nil
function Spell:needWeapon(value) end

---@param callback fun(creature: Creature, variant: Variant, isHotkey?: boolean): boolean
---@return boolean
function Spell:onCastSpell(callback) end

---@param range? number
---@return boolean|number|nil
function Spell:range(range) end

---@return boolean
function Spell:register() end

---@param id? number
---@return boolean|number|nil
function Spell:runeId(id) end

---@param value? boolean
---@return boolean|nil
function Spell:setPzLocked(value) end

---@param soul? number
---@return boolean|number|nil
function Spell:soul(soul) end

---@param vocation any
---@return boolean|table|nil|Spell
function Spell:vocation(vocation) end

---@param words? string
---@param separator? string
---@return boolean|string|nil
function Spell:words(words, separator) end

---@class TalkAction
TalkAction = {}

---@return boolean|string
function TalkAction:getDescription() end

---@return boolean|number
function TalkAction:getGroupType() end

---@return boolean|string
function TalkAction:getName() end

---@param groupType string|number
---@return boolean
function TalkAction:groupType(groupType) end

---@param callback fun(player: Player, words: string, param: string, type: integer): boolean
---@return boolean
function TalkAction:onSay(callback) end

---@return boolean
function TalkAction:register() end

---@param sep string
---@return boolean
function TalkAction:separator(sep) end

---@param arg2 string
---@return boolean
function TalkAction:setDescription(arg2) end

---@class Teleport: Item
---@operator eq(Teleport):boolean
Teleport = {}

---@return nil|Position
function Teleport:getDestination() end

---@param position Position
---@return boolean|nil
function Teleport:setDestination(position) end

---@class Tile
---@operator eq(Tile):boolean
Tile = {}

---@param itemId number|string
---@param countOrSubType? number
---@param flags? number
---@return nil|Item
function Tile:addItem(itemId, countOrSubType, flags) end

---@param item Item
---@param flags? number
---@return number|nil
function Tile:addItemEx(item, flags) end

---@return nil|Creature
function Tile:getBottomCreature() end

---@param creature Creature
---@return nil|Creature
function Tile:getBottomVisibleCreature(creature) end

---@return number|nil
function Tile:getCreatureCount() end

---@return table|nil
function Tile:getCreatures() end

---@return number|nil
function Tile:getDownItemCount() end

---@return nil|Item
function Tile:getFieldItem() end

---@return nil|Item
function Tile:getGround() end

---@return nil|House
function Tile:getHouse() end

---@param itemId number|string
---@param subType? number
---@return nil|Item
function Tile:getItemById(itemId, subType) end

---@param topOrder number
---@return nil|Item
function Tile:getItemByTopOrder(topOrder) end

---@param itemType any
---@return nil|Item
function Tile:getItemByType(itemType) end

---@return number|nil
function Tile:getItemCount() end

---@param itemId number|string
---@param subType? number
---@return number|nil
function Tile:getItemCountById(itemId, subType) end

---@return table|nil
function Tile:getItems() end

---@return nil|Position
function Tile:getPosition() end

---@param index number
---@return nil|Creature|Item
function Tile:getThing(index) end

---@return number|nil
function Tile:getThingCount() end

---@param thing any
---@return number|nil
function Tile:getThingIndex(thing) end

---@return nil|Creature
function Tile:getTopCreature() end

---@return nil|Item
function Tile:getTopDownItem() end

---@return number|nil
function Tile:getTopItemCount() end

---@return nil|Item
function Tile:getTopTopItem() end

---@param creature Creature
---@return nil|Creature
function Tile:getTopVisibleCreature(creature) end

---@param creature Creature
---@return nil|Creature|Item
function Tile:getTopVisibleThing(creature) end

---@param flag any
---@return boolean|nil
function Tile:hasFlag(flag) end

---@param property any
---@param item? Item
---@return boolean|nil
function Tile:hasProperty(property, item) end

---@param thing any
---@param flags? number
---@return number|nil
function Tile:queryAdd(thing, flags) end

---@param actor Player
---@return boolean|nil
function Tile:sweep(actor) end

---@class Town
---@operator eq(Town):boolean
Town = {}

---@return number|nil
function Town:getId() end

---@return string|nil
function Town:getName() end

---@return nil|Position
function Town:getTemplePosition() end

---@class Variant
Variant = {}

---@return number
function Variant:getNumber() end

---@return Position
function Variant:getPosition() end

---@return string
function Variant:getString() end

---@class Vocation
---@operator eq(Vocation):boolean
Vocation = {}

---@return number|nil
function Vocation:getAttackSpeed() end

---@return number|nil
function Vocation:getBaseAttackSpeed() end

---@return number|nil
function Vocation:getBaseId() end

---@return number|nil
function Vocation:getBaseSpeed() end

---@return number|nil
function Vocation:getCapacityGain() end

---@return number|nil
function Vocation:getClientId() end

---@return nil|Vocation
function Vocation:getDemotion() end

---@return string|nil
function Vocation:getDescription() end

---@return number|nil
function Vocation:getHealthGain() end

---@return number|nil
function Vocation:getHealthGainAmount() end

---@return number|nil
function Vocation:getHealthGainTicks() end

---@return number|nil
function Vocation:getId() end

---@return number|nil
function Vocation:getManaGain() end

---@return number|nil
function Vocation:getManaGainAmount() end

---@return number|nil
function Vocation:getManaGainTicks() end

---@return number|nil
function Vocation:getMaxSoul() end

---@return string|nil
function Vocation:getName() end

---@return nil|Vocation
function Vocation:getPromotion() end

---@param magicLevel number
---@return number|nil
function Vocation:getRequiredManaSpent(magicLevel) end

---@param skillType any
---@param skillLevel number
---@return number|nil
function Vocation:getRequiredSkillTries(skillType, skillLevel) end

---@return number|nil
function Vocation:getSoulGainTicks() end

---@class Weapon
Weapon = {}

---@param callback string
---@return boolean|nil
function Weapon:action(callback) end

---@param type string
---@return boolean|nil
function Weapon:ammoType(type) end

---@param atk number
---@return boolean|nil
function Weapon:attack(atk) end

---@param percent number
---@return boolean|nil
function Weapon:breakChance(percent) end

---@param charges? number
---@param showCharges? boolean
---@return boolean|nil
function Weapon:charges(charges, showCharges) end

---@param damage? number
---@param max? number
---@return boolean|nil
function Weapon:damage(damage, max) end

---@param arg2? number
---@return boolean|nil
function Weapon:decayTo(arg2) end

---@param defense? number
---@param extraDefense? number
---@return boolean|nil
function Weapon:defense(defense, extraDefense) end

---@param duration? number
---@param showDuration? boolean
---@return boolean|nil
function Weapon:duration(duration, showDuration) end

---@param combatType string
---@return boolean|nil
function Weapon:element(combatType) end

---@param atk number
---@param combatType string
---@return boolean|nil
function Weapon:extraElement(atk, combatType) end

---@param health number
---@return boolean|nil
function Weapon:health(health) end

---@param percent number
---@return boolean|nil
function Weapon:healthPercent(percent) end

---@param chance number
---@return boolean|nil
function Weapon:hitChance(chance) end

---@param id number
---@return boolean|nil
function Weapon:id(id) end

---@param lvl number
---@return boolean|nil
function Weapon:level(lvl) end

---@param lvl number
---@return boolean|nil
function Weapon:magicLevel(lvl) end

---@param mana number
---@return boolean|nil
function Weapon:mana(mana) end

---@param percent number
---@return boolean|nil
function Weapon:manaPercent(percent) end

---@param max number
---@return boolean|nil
function Weapon:maxHitChance(max) end

---@param callback fun(player: Player, variant: Variant): boolean
---@return boolean
function Weapon:onUseWeapon(callback) end

---@param value boolean
---@return boolean|nil
function Weapon:premium(value) end

---@param range number
---@return boolean|nil
function Weapon:range(range) end

---@return boolean|nil
function Weapon:register() end

---@param type any
---@return boolean|nil
function Weapon:shootType(type) end

---@param slot string
---@return boolean|nil
function Weapon:slotType(slot) end

---@param soul number
---@return boolean|nil
function Weapon:soul(soul) end

---@param itemId number
---@return boolean|nil
function Weapon:transformDeEquipTo(itemId) end

---@param itemId number
---@return boolean|nil
function Weapon:transformEquipTo(itemId) end

---@param vocName string
---@param showInDescription? boolean
---@param lastVoc? boolean
---@return boolean|nil
function Weapon:vocation(vocName, showInDescription, lastVoc) end

---@param value boolean
---@return boolean|nil
function Weapon:wieldUnproperly(value) end

---@class Webhook
Webhook = {}

---@param title string
---@param message string
---@param color number
---@param url any
---@return nil
function Webhook.sendMessage(title, message, color, url) end

---@class Zone
---@operator eq(Zone):boolean
Zone = {}

---@param fromPos Position
---@param toPos Position
---@return boolean
function Zone:addArea(fromPos, toPos) end

---@param ... any
---@return table
function Zone.getAll(...) end

---@param name string
---@return nil|Zone
function Zone.getByName(name) end

---@param pos Position
---@return table|nil
function Zone.getByPosition(pos) end

---@return boolean|table
function Zone:getCreatures() end

---@return boolean|table
function Zone:getItems() end

---@return boolean|table
function Zone:getMonsters() end

---@return boolean|string
function Zone:getName() end

---@return boolean|table
function Zone:getNpcs() end

---@return boolean|table
function Zone:getPlayers() end

---@return boolean|table
function Zone:getPositions() end

---@return Position
function Zone:getRemoveDestination() end

---@return nil
function Zone:refresh() end

---@return boolean
function Zone:removeMonsters() end

---@return boolean
function Zone:removeNpcs() end

---@return boolean
function Zone:removePlayers() end

---@param variant string
---@return boolean
function Zone:setMonsterVariant(variant) end

---@param pos Position
---@return nil
function Zone:setRemoveDestination(pos) end

---@param fromPos Position
---@param toPos Position
---@return boolean
function Zone:subtractArea(fromPos, toPos) end

---@class configManager
configManager = {}

---@param key any
---@return boolean
function configManager.getBoolean(key) end

---@param key any
---@param shouldRound boolean
---@return number
function configManager.getFloat(key, shouldRound) end

---@param key any
---@return number
function configManager.getNumber(key) end

---@param key any
---@return string
function configManager.getString(key) end

---@class db
db = {}

---@param query string
---@param callback? fun(success: boolean)
---@return nil
function db.asyncQuery(query, callback) end

---@param query string
---@param callback? fun(resultId: number|false)
---@return nil
function db.asyncStoreQuery(query, callback) end

---@param value string
---@param length number
---@return string
function db.escapeBlob(value, length) end

---@param value string
---@return string
function db.escapeString(value) end

---@param ... any
---@return number
function db.lastInsertId(...) end

---@param query string
---@return boolean
function db.query(query) end

---@param query string
---@return boolean|number
function db.storeQuery(query) end

---@param tableName string
---@return boolean
function db.tableExists(tableName) end

---@class kv
kv = {}

---@param key string|KV|boolean
---@param forceLoad? boolean
---@return nil
function kv.get(key, forceLoad) end

---@param prefix? KV|string
---@return table
function kv.keys(prefix) end

---@param key string|KV
---@return nil
function kv.remove(key) end

---@param key string|KV
---@return KV
function kv.scoped(key) end

---@param key string|KV
---@param value number
---@return boolean
function kv.set(key, value) end

---@class logger
logger = {}

---@param text string
---@return nil
function logger.debug(text) end

---@param text string
---@return nil
function logger.error(text) end

---@param text string
---@return nil
function logger.info(text) end

---@param text string
---@return nil
function logger.trace(text) end

---@param text string
---@return nil
function logger.warn(text) end

---@class metrics
metrics = {}

---@param name string
---@param value number
---@param attributes any
---@return nil
function metrics.addCounter(name, value, attributes) end
