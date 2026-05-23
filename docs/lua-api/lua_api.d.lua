---@meta
--- Auto-generated Lua API (do not edit manually)

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

---@param callback function
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

---@param other Charm
---@return boolean
function Charm:__eq(other) end

---@return boolean|number
function Charm:castSound() end

---@return boolean|number
function Charm:category() end

---@return boolean|table
function Charm:chance() end

---@return boolean|number
function Charm:damageType() end

---@return boolean|string
function Charm:description() end

---@return boolean|number
function Charm:effect() end

---@return boolean|number
function Charm:impactSound() end

---@return boolean|string
function Charm:messageCancel() end

---@return boolean
function Charm:messageServerLog() end

---@return boolean|string
function Charm:name() end

---@return boolean|number
function Charm:percentage() end

---@return boolean|table
function Charm:points() end

---@return boolean|number
function Charm:type() end

---@class Combat
---@operator eq(Combat):boolean
Combat = {}

---@param other Combat
---@return boolean
function Combat:__eq(other) end

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
---@param value boolean
---@return boolean|nil
function Combat:setParameter(key, value) end

---@class Condition
---@operator eq(Condition):boolean
Condition = {}

---@param other Condition
---@return boolean
function Condition:__eq(other) end

---@return nil
function Condition:__gc() end

---@param rounds number
---@param time number
---@param value number
---@return boolean|nil
function Condition:addDamage(rounds, time, value) end

---@return nil|Condition
function Condition:clone() end

---@return nil
function Condition:delete() end

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
---@param value boolean
---@return boolean|nil
function Condition:setParameter(key, value) end

---@param ticks number
---@return boolean|nil
function Condition:setTicks(ticks) end

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

---@class Container: Item
---@operator eq(Container):boolean
Container = {}

---@param other Container
---@return boolean
function Container:__eq(other) end

---@param itemId string
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

---@param itemId string
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

---@param itemId string
---@param count number
---@param subType? number
---@return boolean|nil
function Container:removeItemById(itemId, count, subType) end

---@class Creature
---@operator eq(Creature):boolean
Creature = {}

---@param other Creature
---@return boolean
function Creature:__eq(other) end

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

---@return table|nil
function Creature:getZones() end

---@return number|nil
function Creature:getZoneType() end

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

---@return boolean|nil
function CreatureEvent:onAdvance() end

---@return boolean|nil
function CreatureEvent:onDeath() end

---@return boolean|nil
function CreatureEvent:onExtendedOpcode() end

---@return boolean|nil
function CreatureEvent:onHealthChange() end

---@return boolean|nil
function CreatureEvent:onKill() end

---@return boolean|nil
function CreatureEvent:onLogin() end

---@return boolean|nil
function CreatureEvent:onLogout() end

---@return boolean|nil
function CreatureEvent:onManaChange() end

---@return boolean|nil
function CreatureEvent:onModalWindow() end

---@return boolean|nil
function CreatureEvent:onPrepareDeath() end

---@return boolean|nil
function CreatureEvent:onTextEdit() end

---@return boolean|nil
function CreatureEvent:onThink() end

---@return boolean|nil
function CreatureEvent:register() end

---@param callback string
---@return boolean|nil
function CreatureEvent:type(callback) end

---@class db
db = {}

---@param query string
---@param callback? fun(success: boolean)
---@return nil
function db.asyncQuery(query, callback) end

---@param query string
---@param callback? fun(resultId: number|boolean)
---@return nil
function db.asyncStoreQuery(query, callback) end

---@param value string
---@param length number
---@return string
function db.escapeBlob(value, length) end

---@param value string
---@return string
function db.escapeString(value) end

---@return number
function db.lastInsertId() end

---@param query string
---@return boolean
function db.query(query) end

---@param query string
---@return boolean|number
function db.storeQuery(query) end

---@param tableName string
---@return boolean
function db.tableExists(tableName) end

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

---@param itemId string
---@param size number
---@param position? Position
---@return nil|Container
function Game.createContainer(itemId, size, position) end

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

---@param x number|Position
---@param y? number|boolean
---@param z? number
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

---@return table
function Game.getAchievements() end

---@return table
function Game.getBestiaryCharm() end

---@param arg1? any
---@return number|string|table
function Game.getBestiaryList(arg1) end

---@return string
function Game.getBoostedBoss() end

---@return string
function Game.getBoostedCreature() end

---@return table
function Game.getClientVersion() end

---@param ... any
---@return table
function Game.getDummies(...) end

---@param ... any
---@return string|table
function Game.getEventCallbacks(...) end

---@param level number
---@return number
function Game.getExperienceForLevel(level) end

---@return table
function Game.getFiendishMonsters() end

---@return number
function Game.getGameState() end

---@return table
function Game.getHouses() end

---@return table
function Game.getInfluencedMonsters() end

---@return table
function Game.getLadderIds() end

---@return number
function Game.getMonsterCount() end

---@param stars number
---@return table
function Game.getMonstersByBestiaryStars(stars) end

---@param race any
---@return table
function Game.getMonstersByRace(race) end

---@param name string
---@return boolean|MonsterType
function Game.getMonsterTypeByName(name) end

---@return table
function Game.getMonsterTypes() end

---@param name string
---@return string|nil
function Game.getNormalizedGuildName(name) end

---@param name string
---@param isNewName? boolean
---@return string|nil
function Game.getNormalizedPlayerName(name, isNewName) end

---@return number
function Game.getNpcCount() end

---@param nameOrId number|string
---@return nil|Player
function Game.getOfflinePlayer(nameOrId) end

---@return number
function Game.getPlayerCount() end

---@return table
function Game.getPlayers() end

---@return table
function Game.getPublicAchievements() end

---@param value any
---@return string
function Game.getReturnMessage(value) end

---@return table
function Game.getSecretAchievements() end

---@return table
function Game.getSoulCoreItems() end

---@param position Position
---@param multifloor? boolean
---@param onlyPlayer? boolean
---@param minRangeX? number
---@param maxRangeX? number
---@param minRangeY? number
---@param maxRangeY? number
---@return table
function Game.getSpectators(position, multifloor, onlyPlayer, minRangeX, maxRangeX, minRangeY, maxRangeY) end

---@return table
function Game.getTalkActions() end

---@return table
function Game.getTowns() end

---@return number
function Game.getWorldType() end

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

---@return boolean|nil
function GlobalEvent:onPeriodChange() end

---@return boolean|nil
function GlobalEvent:onRecord() end

---@return boolean|nil
function GlobalEvent:onSave() end

---@return boolean|nil
function GlobalEvent:onShutdown() end

---@return boolean|nil
function GlobalEvent:onStartup() end

---@return boolean|nil
function GlobalEvent:onThink() end

---@return boolean|nil
function GlobalEvent:onTime() end

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

---@param other Group
---@return boolean
function Group:__eq(other) end

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

---@param other Guild
---@return boolean
function Guild:__eq(other) end

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

---@param other House
---@return boolean
function House:__eq(other) end

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

---@param other Imbuement
---@return boolean
function Imbuement:__eq(other) end

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

---@param other Item
---@return boolean
function Item:__eq(other) end

---@return boolean
function Item:actor() end

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

---@param key string
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

---@param creatureOrCreatureId Creature
---@return boolean
function Item:isOwner(creatureOrCreatureId) end

---@param positionOrCylinder any
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

---@param key string
---@return boolean|nil
function Item:removeCustomAttribute(key) end

---@return nil
function Item:serializeAttributes() end

---@param actionId number
---@return boolean|nil
function Item:setActionId(actionId) end

---@param key string
---@param value string
---@return boolean|nil
function Item:setAttribute(key, value) end

---@param key string
---@param value string
---@return boolean|nil
function Item:setCustomAttribute(key, value) end

---@param minDuration? number
---@param maxDuration? number
---@param decayTo? number
---@param showDuration? boolean
---@return boolean
function Item:setDuration(minDuration, maxDuration, decayTo, showDuration) end

---@param creatureOrCreatureId Creature
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

---@param itemId string
---@param arg2? number
---@return boolean|nil
function Item:transform(itemId, arg2) end

---@class ItemClassification
---@operator eq(ItemClassification):boolean
ItemClassification = {}

---@param other ItemClassification
---@return boolean
function ItemClassification:__eq(other) end

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

---@param other ItemType
---@return boolean
function ItemType:__eq(other) end

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
function ItemType:getElementalBond() end

---@return number|nil
function ItemType:getElementDamage() end

---@return number|nil
function ItemType:getElementType() end

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

---@class kv
kv = {}

---@param key string
---@param forceLoad? boolean
---@return nil
function kv.get(key, forceLoad) end

---@param prefix? KV
---@return table
function kv.keys(prefix) end

---@param key string
---@return nil
function kv.remove(key) end

---@param key string
---@return KV
function kv.scoped(key) end

---@param key string
---@param value number
---@return boolean
function kv.set(key, value) end

---@class KV
KV = {}

---@param key string
---@param forceLoad? boolean
---@return nil
function KV.get(key, forceLoad) end

---@param prefix? KV
---@return table
function KV.keys(prefix) end

---@param key string
---@return nil
function KV.remove(key) end

---@param key string
---@return KV
function KV.scoped(key) end

---@param key string
---@param value number
---@return boolean
function KV.set(key, value) end

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

---@class metrics
metrics = {}

---@param name string
---@param value number
---@param attributes any
---@return nil
function metrics.addCounter(name, value, attributes) end

---@class ModalWindow
---@operator eq(ModalWindow):boolean
ModalWindow = {}

---@param other ModalWindow
---@return boolean
function ModalWindow:__eq(other) end

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

---@param other Monster
---@return boolean
function Monster:__eq(other) end

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

---@return boolean|nil
function Monster:criticalChance() end

---@return boolean|nil
function Monster:criticalDamage() end

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

---@return boolean|nil
function Monster:hazard() end

---@return boolean|nil
function Monster:hazardCrit() end

---@return boolean|nil
function Monster:hazardDamageBoost() end

---@return boolean|nil
function Monster:hazardDefenseBoost() end

---@return boolean|nil
function Monster:hazardDodge() end

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

---@param nameOrRaceId string
---@param restoreHealth boolean
---@return boolean|nil
function Monster:setType(nameOrRaceId, restoreHealth) end

---@return boolean|nil
function Monster:soulPit() end

---@class MonsterSpell
MonsterSpell = {}

---@return boolean|number
function MonsterSpell:castSound() end

---@return boolean|number
function MonsterSpell:impactSound() end

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

---@param other MonsterType
---@return boolean
function MonsterType:__eq(other) end

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

---@param soundId any
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

---@return boolean|number|nil
function MonsterType:armor() end

---@return boolean|number|nil
function MonsterType:baseSpeed() end

---@return boolean|number|nil
function MonsterType:BestiaryCharmsPoints() end

---@return boolean|string|nil
function MonsterType:Bestiaryclass() end

---@return boolean|number|nil
function MonsterType:BestiaryFirstUnlock() end

---@return boolean|string|nil
function MonsterType:BestiaryLocations() end

---@return boolean|number|nil
function MonsterType:BestiaryOccurrence() end

---@return boolean|number|nil
function MonsterType:Bestiaryrace() end

---@return boolean|number|nil
function MonsterType:BestiarySecondUnlock() end

---@return boolean|number|nil
function MonsterType:BestiaryStars() end

---@return boolean|number|nil
function MonsterType:BestiarytoKill() end

---@param raceId? number
---@param class? string
---@return boolean|string|nil
function MonsterType:bossRace(raceId, class) end

---@param raceId? number
---@return boolean|number
function MonsterType:bossRaceId(raceId) end

---@return boolean|nil
function MonsterType:canPushCreatures() end

---@return boolean|nil
function MonsterType:canPushItems() end

---@param pos Position
---@return boolean|nil
function MonsterType:canSpawn(pos) end

---@return boolean|nil
function MonsterType:canWalkOnEnergy() end

---@return boolean|nil
function MonsterType:canWalkOnFire() end

---@return boolean|nil
function MonsterType:canWalkOnPoison() end

---@return boolean|number|nil
function MonsterType:changeTargetChance() end

---@return boolean|number|nil
function MonsterType:changeTargetSpeed() end

---@return boolean|table|nil
function MonsterType:combatImmunities() end

---@return boolean|table|nil
function MonsterType:conditionImmunities() end

---@return boolean|number|nil
function MonsterType:corpseId() end

---@return number|nil
function MonsterType:critChance() end

---@return boolean|number
function MonsterType:deathSound() end

---@return boolean|number|nil
function MonsterType:defense() end

---@return boolean|table|nil
function MonsterType:enemyFactions() end

---@param event any
---@return boolean|nil
function MonsterType:eventType(event) end

---@return boolean|number|nil
function MonsterType:experience() end

---@return boolean|number|nil
function MonsterType:faction() end

---@return boolean|nil
function MonsterType:familiar() end

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

---@return boolean|number|nil
function MonsterType:health() end

---@return boolean|nil
function MonsterType:isAttackable() end

---@return boolean|nil
function MonsterType:isBlockable() end

---@return boolean|nil
function MonsterType:isConvinceable() end

---@return boolean
function MonsterType:isForgeCreature() end

---@return boolean|nil
function MonsterType:isHealthHidden() end

---@return boolean|nil
function MonsterType:isHostile() end

---@return boolean|nil
function MonsterType:isIllusionable() end

---@return boolean|nil
function MonsterType:isPreyable() end

---@return boolean|nil
function MonsterType:isPreyExclusive() end

---@return boolean|nil
function MonsterType:isPushable() end

---@return boolean|nil
function MonsterType:isRewardBoss() end

---@return boolean|nil
function MonsterType:isSummonable() end

---@return boolean|number|nil
function MonsterType:light() end

---@return boolean|number|nil
function MonsterType:manaCost() end

---@return boolean|number|nil
function MonsterType:maxHealth() end

---@return boolean|number|nil
function MonsterType:maxSummons() end

---@return boolean|number
function MonsterType:mitigation() end

---@return boolean|string|nil
function MonsterType:name() end

---@return boolean|string|nil
function MonsterType:nameDescription() end

---@param callback function
---@return boolean|nil
function MonsterType:onAppear(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onDisappear(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onMove(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onPlayerAttack(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onSay(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onSpawn(callback) end

---@param callback function
---@return boolean|nil
function MonsterType:onThink(callback) end

---@return boolean|nil
function MonsterType:outfit() end

---@return boolean|number|nil
function MonsterType:race() end

---@return boolean|number|nil
function MonsterType:raceId() end

---@param name string
---@return boolean|nil
function MonsterType:registerEvent(name) end

---@return boolean|number|nil
function MonsterType:respawnTypeIsUnderground() end

---@return boolean|number|nil
function MonsterType:respawnTypePeriod() end

---@return boolean|number|nil
function MonsterType:runHealth() end

---@return boolean|number
function MonsterType:soundChance() end

---@return boolean|number
function MonsterType:soundSpeedTicks() end

---@return boolean|number|nil
function MonsterType:staticAttackChance() end

---@return boolean|number|nil
function MonsterType:strategiesTargetDamage() end

---@return boolean|number|nil
function MonsterType:strategiesTargetHealth() end

---@return boolean|number|nil
function MonsterType:strategiesTargetNearest() end

---@return boolean|number|nil
function MonsterType:strategiesTargetRandom() end

---@return boolean|number|nil
function MonsterType:targetDistance() end

---@return boolean|number|nil
function MonsterType:targetPreferMaster() end

---@return boolean|nil
function MonsterType:targetPreferPlayer() end

---@return boolean|string
function MonsterType:variant() end

---@return boolean|number|nil
function MonsterType:yellChance() end

---@return boolean|number|nil
function MonsterType:yellSpeedTicks() end

---@class Mount
---@operator eq(Mount):boolean
Mount = {}

---@param other Mount
---@return boolean
function Mount:__eq(other) end

---@return number|nil
function Mount:getClientId() end

---@return number|nil
function Mount:getId() end

---@return string|nil
function Mount:getName() end

---@return number|nil
function Mount:getSpeed() end

---@class MoveEvent
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

---@return boolean|nil
function MoveEvent:onAddItem() end

---@return boolean|nil
function MoveEvent:onDeEquip() end

---@return boolean|nil
function MoveEvent:onEquip() end

---@return boolean|nil
function MoveEvent:onRemoveItem() end

---@return boolean|nil
function MoveEvent:onStepIn() end

---@return boolean|nil
function MoveEvent:onStepOut() end

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

---@param other NetworkMessage
---@return boolean
function NetworkMessage:__eq(other) end

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

---@param other Npc
---@return boolean
function Npc:__eq(other) end

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

---@return boolean
function Npc:isMerchant() end

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

---@return boolean|nil
function Npc:removePlayerInteraction() end

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

---@return boolean
function Npc:setCurrency() end

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
---@operator eq(NpcType):boolean
NpcType = {}

---@param other NpcType
---@return boolean
function NpcType:__eq(other) end

---@param shop Shop
---@return boolean|nil
function NpcType:addShopItem(shop) end

---@param soundId any
---@return boolean
function NpcType:addSound(soundId) end

---@param sentence string
---@param interval number
---@param chance number
---@param yell boolean
---@return boolean|nil
function NpcType:addVoice(sentence, interval, chance, yell) end

---@return boolean|number|nil
function NpcType:baseSpeed() end

---@return boolean|nil
function NpcType:canPushCreatures() end

---@return boolean|nil
function NpcType:canPushItems() end

---@param pos Position
---@return boolean|nil
function NpcType:canSpawn(pos) end

---@param arg2? number
---@return boolean|number
function NpcType:currency(arg2) end

---@param event any
---@return boolean|nil
function NpcType:eventType(event) end

---@return boolean|nil
function NpcType:floorChange() end

---@return table|nil
function NpcType:getCreatureEvents() end

---@return table|nil
function NpcType:getSounds() end

---@return table|nil
function NpcType:getVoices() end

---@return boolean|number|nil
function NpcType:health() end

---@return boolean|nil
function NpcType:isPushable() end

---@return boolean|number|nil
function NpcType:light() end

---@return boolean|number|nil
function NpcType:maxHealth() end

---@return boolean|string|nil
function NpcType:name() end

---@return boolean|string|nil
function NpcType:nameDescription() end

---@param callback function
---@return boolean|nil
function NpcType:onAppear(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onBuyItem(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onCheckItem(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onCloseChannel(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onDisappear(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onMove(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onSay(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onSellItem(callback) end

---@param callback function
---@return boolean|nil
function NpcType:onThink(callback) end

---@return boolean|nil
function NpcType:outfit() end

---@param name string
---@return boolean|nil
function NpcType:registerEvent(name) end

---@return boolean|number|nil
function NpcType:respawnTypeIsUnderground() end

---@return boolean|number|nil
function NpcType:respawnTypePeriod() end

---@return boolean|number
function NpcType:soundChance() end

---@return boolean|number
function NpcType:soundSpeedTicks() end

---@param arg2? number
---@return boolean|number
function NpcType:speechBubble(arg2) end

---@return boolean|number|nil
function NpcType:walkInterval() end

---@return boolean|number|nil
function NpcType:walkRadius() end

---@return boolean|number|nil
function NpcType:yellChance() end

---@return boolean|number|nil
function NpcType:yellSpeedTicks() end

---@class Party
---@operator eq(Party):boolean
Party = {}

---@param other Party
---@return boolean
function Party:__eq(other) end

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

---@return table|nil
function Party:getInvitees() end

---@return nil|Player
function Party:getLeader() end

---@return number|nil
function Party:getMemberCount() end

---@return table|nil
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
---@operator eq(Player):boolean
Player = {}

---@param other Player
---@return boolean
function Player:__eq(other) end

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

---@return boolean|nil
function Player:addCharmPoints() end

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
---@return Item|Item[]|nil
function Player:addItem(itemId, count, canDropOnMap, subType, slot, tier) end

---@param container Container
---@param itemId number
---@param count number
---@param tier number
---@param flags number
---@return number|nil
function Player:addItemBatchToPaginedContainer(container, itemId, count, tier, flags) end

---@param item Item
---@param canDropOnMap? boolean
---@param index? number
---@param flags? number
---@return boolean|number|nil
function Player:addItemEx(item, canDropOnMap, index, flags) end

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

---@return boolean
function Player:addMinorCharmEchoes() end

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

---@return boolean|nil
function Player:charmExpansion() end

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

---@param baseMin number
---@param baseMax number
---@return number
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

---@param itemId string
---@param deepSearch boolean
---@param subType? number
---@return nil|Item
function Player:getItemById(itemId, deepSearch, subType) end

---@param itemId string
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

---@param itemId string
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

---@return boolean
function Player:isUIExhausted() end

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

---@return boolean|nil
function Player:preyThirdSlot() end

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

---@param itemId string
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

---@param itemId string
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
---@param set? boolean
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

---@param mainSoundId any
---@param secondarySoundId any
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

---@param soundId any
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
---@param position? Position
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

---@return boolean
function Player:setBossPoints() end

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

---@return boolean
function Player:setForgeDusts() end

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

---@return boolean
function Player:setRemoveBossTime() end

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
---@return boolean|nil
function Player:takeScreenshot(screenshotType) end

---@return boolean|nil
function Player:taskHuntingThirdSlot() end

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
---@operator add(Position):Position
---@operator eq(Position):boolean
---@operator sub(Position):Position
Position = {}

---@param arg2 Position
---@return Position
function Position:__add(arg2) end

---@param arg2 Position
---@return boolean
function Position:__eq(arg2) end

---@param arg2 Position
---@return Position
function Position:__sub(arg2) end

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

---@return nil
function Position:getZones() end

---@param positionEx Position
---@param sameFloor? boolean
---@return boolean
function Position:isSightClear(positionEx, sameFloor) end

---@param magicEffect any
---@param player? Player
---@return boolean
function Position:removeMagicEffect(magicEffect, player) end

---@param positionEx Position
---@param distanceEffect any
---@param player? Player
---@return boolean
function Position:sendDistanceEffect(positionEx, distanceEffect, player) end

---@param mainSoundId any
---@param secondarySoundId any
---@param actor? Creature
---@return boolean
function Position:sendDoubleSoundEffect(mainSoundId, secondarySoundId, actor) end

---@param magicEffect any
---@param player? Player
---@return boolean
function Position:sendMagicEffect(magicEffect, player) end

---@param soundId any
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
---@return boolean|number
function Result.getNumber(resultId, column) end

---@param resultId number
---@param column string
---@return string|boolean stream
---@return number? length
function Result.getStream(resultId, column) end

---@param resultId number
---@param column string
---@return boolean|string
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

---@param other Spell
---@return boolean
function Spell:__eq(other) end

---@param value? boolean
---@return boolean|nil
function Spell:allowFarUse(value) end

---@param value? boolean
---@return boolean|nil
function Spell:allowOnSelf(value) end

---@param value? boolean
---@return boolean|nil
function Spell:blockWalls(value) end

---@return boolean|number|nil
function Spell:castSound() end

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

---@return boolean|number|nil
function Spell:impactSound() end

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

---@param callback function
---@return boolean|nil
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
---@return boolean|table|nil
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

---@param groupType string
---@return boolean
function TalkAction:groupType(groupType) end

---@param callback function
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

---@param other Teleport
---@return boolean
function Teleport:__eq(other) end

---@return nil|Position
function Teleport:getDestination() end

---@param position Position
---@return boolean|nil
function Teleport:setDestination(position) end

---@class Tile
---@operator eq(Tile):boolean
Tile = {}

---@param other Tile
---@return boolean
function Tile:__eq(other) end

---@param itemId string
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

---@param itemId string
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

---@param itemId string
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

---@param other Town
---@return boolean
function Town:__eq(other) end

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

---@param other Vocation
---@return boolean
function Vocation:__eq(other) end

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

---@param callback function
---@return boolean|nil
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

---@param zone2 Zone
---@return boolean
function Zone:__eq(zone2) end

---@param fromPos Position
---@param toPos Position
---@return boolean
function Zone:addArea(fromPos, toPos) end

---@return table
function Zone.getAll() end

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
