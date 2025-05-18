if type(result) then
	result = Result
end

result.getDataInt = result.getNumber
result.getDataLong = result.getNumber
result.getDataString = result.getString
result.getDataStream = result.getStream

STACKPOS_TOP_CREATURE = 253
STACKPOS_TOP_FIELD = 254
STACKPOS_TOP_MOVABLE_ITEM_OR_CREATURE = 255

THING_TYPE_PLAYER = CREATURETYPE_PLAYER + 1
THING_TYPE_MONSTER = CREATURETYPE_MONSTER + 1
THING_TYPE_NPC = CREATURETYPE_NPC + 1

function pushThing(thing)
	local t = { uid = 0, itemid = 0, type = 0, actionid = 0 }
	if thing then
		if thing:isItem() then
			t.uid = thing:getUniqueId()
			t.itemid = thing:getId()
			if ItemType(t.itemid):hasSubType() then
				t.type = thing:getSubType()
			end
			t.actionid = thing:getActionId()
		elseif thing:isCreature() then
			t.uid = thing:getId()
			t.itemid = 1
			if thing:isPlayer() then
				t.type = THING_TYPE_PLAYER
			elseif thing:isMonster() then
				t.type = THING_TYPE_MONSTER
			else
				t.type = THING_TYPE_NPC
			end
		end
	end
	return t
end

createCombatObject = Combat
addCombatCondition = Combat.addCondition
setCombatArea = Combat.setArea
setCombatCallback = Combat.setCallback
setCombatFormula = Combat.setFormula
setCombatParam = Combat.setParameter

Combat.setCondition = function(...)
	logger.warn("[Combat.setCondition] - Function was renamed to Combat.addCondition and will be removed in the future")
	Combat.addCondition(...)
end

setCombatCondition = function(...)
	logger.warn("[setCombatCondition] - Function was renamed to Combat.addCondition and will be removed in the future")
	Combat.addCondition(...)
end

createConditionObject = Condition
setConditionParam = Condition.setParameter
setConditionFormula = Condition.setFormula
addDamageCondition = Condition.addDamage
addOutfitCondition = Condition.setOutfit

function doCombat(cid, combat, var)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'doCombat(cid, combat, var)' is outdated. Please use the new format 'combat:execute(cid, var)'. Update needed at: Line {}, Source: {}.", line, source)
	return combat:execute(cid, var)
end

function isCreature(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isCreature(cid)' is outdated. Please use the new format 'Creature(cid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Creature(cid) ~= nil
end

function isPlayer(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isPlayer(cid)' is outdated. Please use the new format 'Player(cid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Player(cid) ~= nil
end

function isMonster(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isMonster(cid)' is outdated. Please use the new format 'Monster(cid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Monster(cid) ~= nil
end

function isSummon(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isSummon(cid)' is outdated. Please use the new format 'c:getMaster()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	return Creature(cid):getMaster() ~= nil
end

function isNpc(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isNpc(cid)' is outdated. Please use the new format 'Npc(cid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Npc(cid) ~= nil
end

function isItem(uid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isItem(uid)' is outdated. Please use the new format 'Item(uid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Item(uid) ~= nil
end

function isContainer(uid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'isContainer(uid)' is outdated. Please use the new format 'Container(uid)'. Update needed at: Line {}, Source: {}.", line, source)
	return Container(uid) ~= nil
end

function getCreatureName(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureName(cid)' is outdated. Please use the new format 'c:getName()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getName() or false
end

function getCreatureHealth(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureHealth(cid)' is outdated. Please use the new format 'c:getHealth()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getHealth() or false
end

function getCreatureMaxHealth(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureMaxHealth(cid)' is outdated. Please use the new format 'c:getMaxHealth()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getMaxHealth() or false
end

function getCreaturePosition(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreaturePosition(cid)' is outdated. Please use the new format 'c:getPosition()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getPosition() or false
end

function getCreatureOutfit(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureOutfit(cid)' is outdated. Please use the new format 'c:getOutfit()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getOutfit() or false
end

function getCreatureSpeed(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureSpeed(cid)' is outdated. Please use the new format 'c:getSpeed()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getSpeed() or false
end

function getCreatureBaseSpeed(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureBaseSpeed(cid)' is outdated. Please use the new format 'c:getBaseSpeed()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:getBaseSpeed() or false
end

function getCreatureTarget(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureTarget(cid)' is outdated. Please use the new format 'c:getTarget():getId()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	if c then
		local target = c:getTarget()
		return target and target:getId() or 0
	end
	return false
end

function getCreatureMaster(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'getCreatureMaster(cid)' is outdated. Please use the new format 'c:getMaster():getId()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	if c then
		local master = c:getMaster()
		return master and master:getId() or c:getId()
	end
	return false
end

function getCreatureSummons(cid)
	local c = Creature(cid)
	if not c then
		return false
	end

	local result = {}
	for _, summon in ipairs(c:getSummons()) do
		result[#result + 1] = summon:getId()
	end
	return result
end

getCreaturePos = getCreaturePosition

function doCreatureAddHealth(cid, health)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'doCreatureAddHealth(cid, health)' is outdated. Please use the new format 'c:addHealth(health)', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:addHealth(health) or false
end

function doRemoveCreature(cid)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'doRemoveCreature(cid)' is outdated. Please use the new format 'c:remove()', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:remove() or false
end

function doCreatureSetLookDir(cid, direction)
	local line = debug.getinfo(2).currentline
	local source = debug.getinfo(2).source:match("@?(.*)")
	logger.warn("Deprecation Warning: The function 'doCreatureSetLookDir(cid, direction)' is outdated. Please use the new format 'c:setDirection(direction)', where 'c' refers to a Creature (player or monster). Update needed at: Line {}, Source: {}.", line, source)
	local c = Creature(cid)
	return c and c:setDirection(direction) or false
end

function doCreatureSay(cid, text, type, ...)
	local c = Creature(cid)
	return c and c:say(text, type, ...) or false
end

function doCreatureChangeOutfit(cid, outfit)
	local c = Creature(cid)
	return c and c:setOutfit(outfit) or false
end

function doSetCreatureDropLoot(cid, doDrop)
	local c = Creature(cid)
	return c and c:setDropLoot(doDrop) or false
end

function doChangeSpeed(cid, delta)
	local c = Creature(cid)
	return c and c:changeSpeed(delta) or false
end

function doAddCondition(cid, conditionId)
	local c = Creature(cid)
	return c and c:addCondition(conditionId) or false
end

function doRemoveCondition(cid, conditionType, subId)
	local c = Creature(cid)
	return c and (c:removeCondition(conditionType, CONDITIONID_COMBAT, subId) or c:removeCondition(conditionType, CONDITIONID_DEFAULT, subId) or true)
end

function getCreatureCondition(cid, type, subId)
	local c = Creature(cid)
	return c and c:hasCondition(type, subId) or false
end

doSetCreatureDirection = doCreatureSetLookDir

function registerCreatureEvent(cid, name)
	local c = Creature(cid)
	return c and c:registerEvent(name) or false
end

function unregisterCreatureEvent(cid, name)
	local c = Creature(cid)
	return c and c:unregisterEvent(name) or false
end

function getPlayerByName(name)
	local p = Player(name)
	return p and p:getId() or false
end

function getIPByPlayerName(name)
	local p = Player(name)
	return p and p:getIp() or false
end

function getPlayerGUID(cid)
	local p = Player(cid)
	return p and p:getGuid() or false
end

function getPlayerIp(cid)
	local p = Player(cid)
	return p and p:getIp() or false
end

function getPlayerAccountType(cid)
	local p = Player(cid)
	return p and p:getAccountType() or false
end

function getPlayerLastLoginSaved(cid)
	local p = Player(cid)
	return p and p:getLastLoginSaved() or false
end

function getPlayerName(cid)
	local p = Player(cid)
	return p and p:getName() or false
end

function getPlayerFreeCap(cid)
	local p = Player(cid)
	return p and (p:getFreeCapacity() / 100) or false
end

function getPlayerPosition(cid)
	local p = Player(cid)
	return p and p:getPosition() or false
end

function getPlayerMagLevel(cid)
	local p = Player(cid)
	return p and p:getMagicLevel() or false
end

function getPlayerAccess(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end
	return player:getGroup():getAccess() and 1 or 0
end

function getPlayerSkill(cid, skillId)
	local p = Player(cid)
	return p and p:getSkillLevel(skillId) or false
end

function getPlayerMana(cid)
	local p = Player(cid)
	return p and p:getMana() or false
end

function getPlayerMaxMana(cid)
	local p = Player(cid)
	return p and p:getMaxMana() or false
end

function getPlayerLevel(cid)
	local p = Player(cid)
	return p and p:getLevel() or false
end

function getPlayerTown(cid)
	local p = Player(cid)
	return p and p:getTown():getId() or false
end

function getPlayerVocation(cid)
	local p = Player(cid)
	return p and p:getVocation():getId() or false
end

function getPlayerSoul(cid)
	local p = Player(cid)
	return p and p:getSoul() or false
end

function getPlayerSex(cid)
	local p = Player(cid)
	return p and p:getSex() or false
end

function getPlayerStorageValue(cid, key)
	local p = Player(cid)
	return p and p:getStorageValue(key) or false
end

function getPlayerBalance(cid)
	local p = Player(cid)
	return p and p:getBankBalance() or false
end

function getPlayerMoney(cid)
	local p = Player(cid)
	return p and p:getMoney() or false
end

function getPlayerGroupId(cid)
	local p = Player(cid)
	return p and p:getGroup():getId() or false
end

function getPlayerLookDir(cid)
	local p = Player(cid)
	return p and p:getDirection() or false
end

function getPlayerLight(cid)
	local p = Player(cid)
	return p and p:getLight() or false
end

function getPlayerDepotItems(cid, depotId)
	local p = Player(cid)
	return p and p:getDepotItems(depotId) or false
end

function getPlayerSkullType(cid)
	local p = Player(cid)
	return p and p:getSkull() or false
end

function getPlayerLossPercent(cid)
	local p = Player(cid)
	return p and p:getDeathPenalty() or false
end

function getPlayerMount(cid, mountId)
	local p = Player(cid)
	return p and p:hasMount(mountId) or false
end

function getPlayerPremiumDays(cid)
	local p = Player(cid)
	return p and p:getPremiumDays() or false
end

function getPlayerBlessing(cid, blessing)
	local p = Player(cid)
	return p and p:hasBlessing(blessing) or false
end

function getPlayerFlagValue(cid, flag)
	local p = Player(cid)
	return p ~= nil and p:hasFlag(flag) or false
end

function getPlayerParty(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end

	local party = player:getParty()
	if party == nil then
		return nil
	end
	return party:getLeader():getId()
end

function getPlayerGuildId(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end

	local guild = player:getGuild()
	if guild == nil then
		return false
	end
	return guild:getId()
end

function getPlayerGuildLevel(cid)
	local p = Player(cid)
	return p and p:getGuildLevel() or false
end

function getPlayerGuildName(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end

	local guild = player:getGuild()
	if guild == nil then
		return false
	end
	return guild:getName()
end

function getPlayerGuildRank(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end

	local guild = player:getGuild()
	if guild == nil then
		return false
	end

	local rank = guild:getRankByLevel(player:getGuildLevel())
	return rank and rank.name or false
end

function getPlayerGuildNick(cid)
	local p = Player(cid)
	return p and p:getGuildNick() or false
end

function getPlayerMasterPos(cid)
	local p = Player(cid)
	return p and p:getTown():getTemplePosition() or false
end

function getPlayerItemCount(cid, itemId, ...)
	local p = Player(cid)
	return p and p:getItemCount(itemId, ...) or false
end

function getPlayerSlotItem(cid, slot)
	local player = Player(cid)
	if player == nil then
		return pushThing(nil)
	end
	return pushThing(player:getSlotItem(slot))
end

function getPlayerItemById(cid, deepSearch, itemId, ...)
	local player = Player(cid)
	if player == nil then
		return pushThing(nil)
	end
	return pushThing(player:getItemById(itemId, deepSearch, ...))
end

function getPlayerFood(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end
	local c = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	return c and math.floor(c:getTicks() / 1000) or 0
end

function canPlayerLearnInstantSpell(cid, name)
	local p = Player(cid)
	return p and p:canLearnSpell(name) or false
end

function getPlayerLearnedInstantSpell(cid, name)
	local p = Player(cid)
	return p and p:hasLearnedSpell(name) or false
end

function isPlayerGhost(cid)
	local p = Player(cid)
	return p ~= nil and p:isInGhostMode() or false
end

function isPlayerPzLocked(cid)
	local p = Player(cid)
	return p ~= nil and p:isPzLocked() or false
end

function isPremium(cid)
	local p = Player(cid)
	return p ~= nil and p:isPremium() or false
end

function getBlessingCost(level, byCommand, blessId)
	return Blessings.getBlessingCost(level, byCommand, blessId)
end

function getPvpBlessingCost(level, byCommand)
	return Blessings.getPvpBlessingCost(level, byCommand)
end

function getPlayersByIPAddress(ip, mask)
	if mask == nil then
		mask = 0xFFFFFFFF
	end
	local masked = bit.band(ip, mask)
	local result = {}
	for _, player in ipairs(Game.getPlayers()) do
		if bit.band(player:getIp(), mask) == masked then
			result[#result + 1] = player:getId()
		end
	end
	return result
end

function getOnlinePlayers()
	local result = {}
	for _, player in ipairs(Game.getPlayers()) do
		result[#result + 1] = player:getName()
	end
	return result
end

function getPlayerGUIDByName(name)
	local player = Player(name)
	if player then
		return player:getGuid()
	end

	local resultId = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId ~= false then
		local guid = Result.getNumber(resultId, "id")
		Result.free(resultId)
		return guid
	end
	return 0
end

function getAccountNumberByPlayerName(name)
	return Game.getPlayerAccountId(name)
end

getPlayerAccountBalance = getPlayerBalance
getIpByName = getIPByPlayerName

function setPlayerStorageValue(cid, key, value)
	local p = Player(cid)
	return p and p:setStorageValue(key, value) or false
end

function doPlayerSetBalance(cid, balance)
	local p = Player(cid)
	return p and p:setBankBalance(balance) or false
end

function doPlayerAddMoney(cid, money)
	local p = Player(cid)
	return p and p:addMoney(money) or false
end

function doPlayerRemoveMoney(cid, money)
	local p = Player(cid)
	return p and p:removeMoney(money) or false
end

function doPlayerTakeItem(cid, itemid, count)
	local p = Player(cid)
	return p and p:removeItem(itemid, count) or false
end

function doPlayerAddSoul(cid, soul)
	local p = Player(cid)
	return p and p:addSoul(soul) or false
end

function doPlayerSetVocation(cid, vocation)
	local p = Player(cid)
	return p and p:setVocation(Vocation(vocation)) or false
end

function doPlayerSetTown(cid, town)
	local p = Player(cid)
	return p and p:setTown(Town(town)) or false
end

function setPlayerGroupId(cid, groupId)
	local p = Player(cid)
	return p and p:setGroup(Group(groupId)) or false
end

function doPlayerSetSex(cid, sex)
	local p = Player(cid)
	return p and p:setSex(sex) or false
end

function doPlayerSetGuildLevel(cid, level)
	local p = Player(cid)
	return p and p:setGuildLevel(level) or false
end

function doPlayerSetGuildNick(cid, nick)
	local p = Player(cid)
	return p and p:setGuildNick(nick) or false
end

function doPlayerSetOfflineTrainingSkill(cid, skillId)
	local p = Player(cid)
	return p and p:setOfflineTrainingSkill(skillId) or false
end

function doShowTextDialog(cid, itemId, text)
	local p = Player(cid)
	return p and p:showTextDialog(itemId, text) or false
end

function doPlayerAddItemEx(cid, uid, ...)
	local p = Player(cid)
	return p and p:addItemEx(Item(uid), ...) or false
end

function doPlayerRemoveItem(cid, itemid, count, ...)
	local p = Player(cid)
	return p and p:removeItem(itemid, count, ...) or false
end

function doPlayerAddPremiumDays(cid, days)
	local p = Player(cid)
	return p and p:addPremiumDays(days) or false
end

function doPlayerRemovePremiumDays(cid, days)
	local p = Player(cid)
	return p and p:removePremiumDays(days) or false
end

function doPlayerAddBlessing(cid, blessing)
	local p = Player(cid)
	return p and p:addBlessing(blessing) or false
end

function doPlayerAddOutfit(cid, lookType, addons)
	local p = Player(cid)
	return p and p:addOutfitAddon(lookType, addons) or false
end

function doPlayerRemOutfit(cid, lookType, addons)
	local player = Player(cid)
	if player == nil then
		return false
	end
	if addons == 255 then
		return player:removeOutfit(lookType)
	else
		return player:removeOutfitAddon(lookType, addons)
	end
end

function canPlayerWearOutfit(cid, lookType, addons)
	local p = Player(cid)
	return p and p:hasOutfit(lookType, addons) or false
end

function doPlayerAddMount(cid, mountId)
	local p = Player(cid)
	return p and p:addMount(mountId) or false
end

function doPlayerRemoveMount(cid, mountId)
	local p = Player(cid)
	return p and p:removeMount(mountId) or false
end

function doPlayerSendCancel(cid, text)
	local p = Player(cid)
	return p and p:sendCancelMessage(text) or false
end

function doPlayerFeed(cid, food)
	local p = Player(cid)
	return p and p:feed(food) or false
end

function playerLearnInstantSpell(cid, name)
	local p = Player(cid)
	return p and p:learnSpell(name) or false
end

function doPlayerPopupFYI(cid, message)
	local p = Player(cid)
	return p and p:popupFYI(message) or false
end

function doSendTutorial(cid, tutorialId)
	local p = Player(cid)
	return p and p:sendTutorial(tutorialId) or false
end

function doAddMapMark(cid, pos, type, description)
	local p = Player(cid)
	return p and p:addMapMark(pos, type, description or "") or false
end

function doPlayerSendTextMessage(cid, type, text, ...)
	local p = Player(cid)
	return p and p:sendTextMessage(type, text, ...) or false
end

function doPlayerSendChannelMessage(cid, author, message, SpeakClasses, channel)
	local p = Player(cid)
	return p and p:sendChannelMessage(author, message, SpeakClasses, channel) or false
end

function doSendAnimatedText()
	debugPrint("Deprecated function.")
	return true
end

function doPlayerAddManaSpent(cid, mana)
	local p = Player(cid)
	return p and p:addManaSpent(mana) or false
end

function doPlayerAddSkillTry(cid, skillid, n)
	local p = Player(cid)
	return p and p:addSkillTries(skillid, n) or false
end

function doPlayerAddMana(cid, mana, ...)
	local p = Player(cid)
	return p and p:addMana(mana, ...) or false
end

function doPlayerJoinParty(cid, leaderId)
	local player = Player(cid)
	if player == nil then
		return false
	end

	if player:getParty() then
		player:sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "You are already in a party.")
		return true
	end

	local leader = Player(leaderId)
	if leader == nil then
		return false
	end

	local party = leader:getParty()
	if party == nil or party:getLeader() ~= leader then
		return true
	end

	for _, invitee in ipairs(party:getInvitees()) do
		if player ~= invitee then
			return true
		end
	end

	party:addMember(player)
	return true
end

function getPartyMembers(cid)
	local player = Player(cid)
	if player == nil then
		return false
	end

	local party = player:getParty()
	if party == nil then
		return false
	end

	local result = { party:getLeader():getId() }
	for _, member in ipairs(party:getMembers()) do
		result[#result + 1] = member:getId()
	end
	return result
end

doPlayerSendDefaultCancel = doPlayerSendCancel

function getMonsterTargetList(cid)
	local monster = Monster(cid)
	if monster == nil then
		return false
	end

	local result = {}
	for _, creature in ipairs(monster:getTargetList()) do
		if monster:isTarget(creature) then
			result[#result + 1] = creature:getId()
		end
	end
	return result
end

function getMonsterFriendList(cid)
	local monster = Monster(cid)
	if monster == nil then
		return false
	end

	local z = monster:getPosition().z

	local result = {}
	for _, creature in ipairs(monster:getFriendList()) do
		if not creature:isRemoved() and creature:getPosition().z == z then
			result[#result + 1] = creature:getId()
		end
	end
	return result
end

function doSetMonsterTarget(cid, target)
	local monster = Monster(cid)
	if monster == nil then
		return false
	end

	if monster:getMaster() then
		return true
	end

	local target = Creature(cid)
	if target == nil then
		return false
	end

	monster:selectTarget(target)
	return true
end

function doMonsterChangeTarget(cid)
	local monster = Monster(cid)
	if monster == nil then
		return false
	end

	if monster:getMaster() then
		return true
	end

	monster:searchTarget(1)
	return true
end

function doCreateNpc(name, pos, ...)
	local npc = Game.createNpc(name, pos, ...)
	return npc and npc:setMasterPos(pos) or false
end

function doSummonCreature(name, pos, ...)
	local m = Game.createMonster(name, pos, ...)
	return m and m:getId() or false
end

function doConvinceCreature(cid, target)
	local creature = Creature(cid)
	if creature == nil then
		return false
	end

	local targetCreature = Creature(target)
	if targetCreature == nil then
		return false
	end

	creature:setSummon(targetCreature)
	return true
end

function getTownId(townName)
	local t = Town(townName)
	return t and t:getId() or false
end

function getTownName(townId)
	local t = Town(townId)
	return t and t:getName() or false
end

function getTownTemplePosition(townId)
	local t = Town(townId)
	return t and t:getTemplePosition() or false
end

function doSetItemActionId(uid, actionId)
	local i = Item(uid)
	return i and i:setActionId(actionId) or false
end

function doTransformItem(uid, newItemId, ...)
	local i = Item(uid)
	return i and i:transform(newItemId, ...) or false
end

function doChangeTypeItem(uid, newType)
	local i = Item(uid)
	return i and i:transform(i:getId(), newType) or false
end

function doRemoveItem(uid, ...)
	local i = Item(uid)
	return i and i:remove(...) or false
end

function getContainerSize(uid)
	local c = Container(uid)
	return c and c:getSize() or false
end

function getContainerCap(uid)
	local c = Container(uid)
	return c and c:getCapacity() or false
end

function getContainerItem(uid, slot)
	local container = Container(uid)
	if container == nil then
		return pushThing(nil)
	end
	return pushThing(container:getItem(slot))
end

function doAddContainerItemEx(uid, virtualId)
	local container = Container(uid)
	if container == nil then
		return false
	end

	local res = container:addItemEx(Item(virtualId))
	if res == nil then
		return false
	end
	return res
end

function doSendMagicEffect(pos, magicEffect, ...)
	return Position(pos):sendMagicEffect(magicEffect, ...)
end

function doSendDistanceShoot(fromPos, toPos, distanceEffect, ...)
	return Position(fromPos):sendDistanceEffect(toPos, distanceEffect, ...)
end

function isSightClear(fromPos, toPos, floorCheck)
	return Position(fromPos):isSightClear(toPos, floorCheck)
end

function getPromotedVocation(vocationId)
	local vocation = Vocation(vocationId)
	if vocation == nil then
		return 0
	end

	local promotedVocation = vocation:getPromotion()
	if promotedVocation == nil then
		return 0
	end
	return promotedVocation:getId()
end

function getGuildId(guildName)
	local resultId = db.storeQuery("SELECT `id` FROM `guilds` WHERE `name` = " .. db.escapeString(guildName))
	if resultId == false then
		return false
	end

	local guildId = Result.getNumber(resultId, "id")
	Result.free(resultId)
	return guildId
end

function getHouseName(houseId)
	local h = House(houseId)
	return h and h:getName() or false
end

function getHouseOwner(houseId)
	local h = House(houseId)
	return h and h:getOwnerGuid() or false
end

function getHouseEntry(houseId)
	local h = House(houseId)
	return h and h:getExitPosition() or false
end

function getHouseTown(houseId)
	local h = House(houseId)
	if h == nil then
		return false
	end
	local t = h:getTown()
	return t and t:getId() or false
end

function getHouseTilesSize(houseId)
	local h = House(houseId)
	return h and h:getTileCount() or false
end

function isItemStackable(itemId)
	return ItemType(itemId):isStackable()
end

function isItemRune(itemId)
	return ItemType(itemId):isRune()
end

function isItemDoor(itemId)
	return ItemType(itemId):isDoor()
end

function isItemContainer(itemId)
	return ItemType(itemId):isContainer()
end

function isItemFluidContainer(itemId)
	return ItemType(itemId):isFluidContainer()
end

function isItemMovable(itemId)
	return ItemType(itemId):isMovable()
end

function isCorpse(uid)
	local i = Item(uid)
	return i ~= nil and ItemType(i:getId()):isCorpse() or false
end

isItemMovable = isItemMovable
isMovable = isMovable

function getItemName(itemId)
	return ItemType(itemId):getName()
end

function getItemWeight(itemId, ...)
	return ItemType(itemId):getWeight(...) / 100
end

function getItemDescriptions(itemId)
	local itemType = ItemType(itemId)
	return {
		name = itemType:getName(),
		plural = itemType:getPluralName(),
		article = itemType:getArticle(),
		description = itemType:getDescription(),
	}
end

function getItemIdByName(name)
	local id = ItemType(name):getId()
	if id == 0 then
		return false
	end
	return id
end

function getItemWeightByUID(uid, ...)
	local item = Item(uid)
	if item == nil then
		return false
	end

	local itemType = ItemType(item:getId())
	return itemType:isStackable() and (itemType:getWeight(item:getCount(), ...) / 100) or (itemType:getWeight(1, ...) / 100)
end

function getItemRWInfo(uid)
	local item = Item(uid)
	if item == nil then
		return false
	end

	local rwFlags = 0
	local itemType = ItemType(item:getId())
	if itemType:isReadable() then
		rwFlags = bit.bor(rwFlags, 1)
	end

	if itemType:isWritable() then
		rwFlags = bit.bor(rwFlags, 2)
	end
	return rwFlags
end

function getContainerCapById(itemId)
	return ItemType(itemId):getCapacity()
end

function getFluidSourceType(itemId)
	local it = ItemType(itemId)
	return it.id ~= 0 and it:getFluidSource() or false
end

function hasProperty(uid, prop)
	local item = Item(uid)
	if item == nil then
		return false
	end

	local parent = item:getParent()
	if parent:isTile() and item == parent:getGround() then
		return parent:hasProperty(prop)
	else
		return item:hasProperty(prop)
	end
end

function doSetItemText(uid, text)
	local item = Item(uid)
	if item == nil then
		return false
	end

	if text ~= "" then
		item:setAttribute(ITEM_ATTRIBUTE_TEXT, text)
	else
		item:removeAttribute(ITEM_ATTRIBUTE_TEXT)
	end
	return true
end

function doSetItemSpecialDescription(uid, desc)
	local item = Item(uid)
	if item == nil then
		return false
	end

	if desc ~= "" then
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, desc)
	else
		item:removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	end
	return true
end

function doDecayItem(uid)
	local i = Item(uid)
	return i and i:decay() or false
end

function setHouseOwner(id, guid)
	local h = House(id)
	return h and h:setHouseOwner(guid) or false
end

function getHouseRent(id)
	local h = House(id)
	return h and h:getRent() or nil
end

function getHouseAccessList(id, listId)
	local h = House(id)
	return h and h:getAccessList(listId) or nil
end

function setHouseAccessList(id, listId, listText)
	local h = House(id)
	return h and h:setAccessList(listId, listText) or false
end

function getHouseByPlayerGUID(playerGUID)
	for _, house in ipairs(Game.getHouses()) do
		if house:getOwnerGuid() == playerGUID then
			return house:getId()
		end
	end
	return nil
end

function getTileHouseInfo(pos)
	local t = Tile(pos)
	if t == nil then
		return false
	end
	local h = t:getHouse()
	return h and h:getId() or false
end

function getTileInfo(position)
	local t = Tile(position)
	if t == nil then
		return false
	end

	local ret = pushThing(t:getGround())
	ret.protection = t:hasFlag(TILESTATE_PROTECTIONZONE)
	ret.pvp = t:hasFlag(TILESTATE_PVPZONE)
	ret.nopvp = t:hasFlag(TILESTATE_NOPVPZONE)
	ret.nopz = ret.protection
	ret.nologout = t:hasFlag(TILESTATE_NOLOGOUT)
	ret.refresh = t:hasFlag(TILESTATE_REFRESH)
	ret.house = t:getHouse() ~= nil
	ret.bed = t:hasFlag(TILESTATE_BED)
	ret.depot = t:hasFlag(TILESTATE_DEPOT)

	ret.things = t:getThingCount()
	ret.creatures = t:getCreatureCount()
	ret.items = t:getItemCount()
	ret.topItems = t:getTopItemCount()
	ret.downItems = t:getDownItemCount()
	return ret
end

function getTileItemByType(position, itemType)
	local t = Tile(position)
	if t == nil then
		return pushThing(nil)
	end
	return pushThing(t:getItemByType(itemType))
end

function getTileItemById(position, itemId, ...)
	local t = Tile(position)
	if t == nil then
		return pushThing(nil)
	end
	return pushThing(t:getItemById(itemId, ...))
end

function getTileThingByPos(position)
	local t = Tile(position)
	if t == nil then
		if position.stackpos == -1 then
			return -1
		end
		return pushThing(nil)
	end

	if position.stackpos == -1 then
		return t:getThingCount()
	end
	return pushThing(t:getThing(position.stackpos))
end

function getTileThingByTopOrder(position, topOrder)
	local t = Tile(position)
	if t == nil then
		return pushThing(nil)
	end
	return pushThing(t:getItemByTopOrder(topOrder))
end

function getTopCreature(position)
	local t = Tile(position)
	if t == nil then
		return pushThing(nil)
	end
	return pushThing(t:getTopCreature())
end

function queryTileAddThing(thing, position, ...)
	local t = Tile(position)
	return t and t:queryAdd(thing, ...) or false
end

function doTeleportThing(uid, dest, pushMovement)
	if type(uid) == "userdata" then
		if uid:isCreature() then
			return uid:teleportTo(dest, pushMovement or false)
		else
			return uid:moveTo(dest)
		end
	else
		if uid >= 0x10000000 then
			local creature = Creature(uid)
			if creature then
				return creature:teleportTo(dest, pushMovement or false)
			end
		else
			local item = Item(uid)
			if item then
				return item:moveTo(dest)
			end
		end
	end
	return false
end

function getThingPos(uid)
	local thing
	if type(uid) ~= "userdata" then
		if uid >= 0x10000000 then
			thing = Creature(uid)
		else
			thing = Item(uid)
		end
	else
		thing = uid
	end

	if thing == nil then
		return false
	end

	local stackpos = 0
	local tile = thing:getTile()
	if tile then
		stackpos = tile:getThingIndex(thing)
	end

	local position = thing:getPosition()
	position.stackpos = stackpos
	return position
end

function getThingfromPos(pos)
	local tile = Tile(pos)
	if tile == nil then
		return pushThing(nil)
	end

	local thing
	local stackpos = pos.stackpos or 0
	if stackpos == STACKPOS_TOP_MOVABLE_ITEM_OR_CREATURE then
		thing = tile:getTopCreature()
		if thing == nil then
			local item = tile:getTopDownItem()
			if item and item:getType():isMovable() then
				thing = item
			end
		end
	elseif stackpos == STACKPOS_TOP_FIELD then
		thing = tile:getFieldItem()
	elseif stackpos == STACKPOS_TOP_CREATURE then
		thing = tile:getTopCreature()
	else
		thing = tile:getThing(stackpos)
	end
	return pushThing(thing)
end

function getThing(uid)
	return uid >= 0x10000000 and pushThing(Creature(uid)) or pushThing(Item(uid))
end

function getConfigInfo(info)
	if type(info) ~= "string" then
		return nil
	end
	dofile("config.lua")
	return _G[info]
end

function getWorldCreatures(type)
	if type == 0 then
		return Game.getPlayerCount()
	elseif type == 1 then
		return Game.getMonsterCount()
	elseif type == 2 then
		return Game.getNpcCount()
	end
	return Game.getPlayerCount() + Game.getMonsterCount() + Game.getNpcCount()
end

saveData = saveServer

function getGlobalStorageValue(key)
	return Game.getStorageValue(key) or -1
end

function setGlobalStorageValue(key, value)
	Game.setStorageValue(key, value)
	return true
end

getWorldType = Game.getWorldType

numberToVariant = Variant
stringToVariant = Variant
positionToVariant = Variant

function targetPositionToVariant(position)
	local variant = Variant(position)
	variant.type = VARIANT_TARGETPOSITION
	return variant
end

variantToNumber = Variant.getNumber
variantToString = Variant.getString
variantToPosition = Variant.getPosition

function doCreateTeleport(itemId, destination, position)
	local item = Game.createItem(itemId, 1, position)
	if not item:isTeleport() then
		item:remove()
		return false
	end
	item:setDestination(destination)
	return item:getUniqueId()
end

function getSpectators(centerPos, rangex, rangey, multifloor, onlyPlayers)
	local result = Game.getSpectators(centerPos, multifloor, onlyPlayers or false, rangex, rangex, rangey, rangey)
	if #result == 0 then
		return nil
	end

	for index, spectator in ipairs(result) do
		result[index] = spectator:getId()
	end
	return result
end

function broadcastMessage(message, messageType)
	Game.broadcastMessage(message, messageType)
	logger.info("Broadcasted message: {}", message)
end

function Guild.addMember(self, player)
	return player:setGuild(guild)
end

function Guild.removeMember(self, player)
	return player:getGuild() == self and player:setGuild(nil)
end

function getPlayerInstantSpellCount(cid)
	local p = Player(cid)
	return p and #p:getInstantSpells()
end

function getPlayerInstantSpellInfo(cid, spellId)
	local player = Player(cid)
	if not player then
		return false
	end

	local spell = Spell(spellId)
	if not spell or not player:canCast(spell) then
		return false
	end

	return spell
end

function doSetItemOutfit(cid, item, time)
	local c = Creature(cid)
	return c and c:setItemOutfit(item, time)
end

function doSetMonsterOutfit(cid, name, time)
	local c = Creature(cid)
	return c and c:setMonsterOutfit(name, time)
end

function doSetCreatureOutfit(cid, outfit, time)
	local creature = Creature(cid)
	if not creature then
		return false
	end

	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit(outfit)
	condition:setTicks(time)
	creature:addCondition(condition)

	return true
end

function doTileAddItemEx(pos, uid, flags)
	local tile = Tile(pos)
	if not tile then
		return false
	end

	local item = Item(uid)
	if item then
		return tile:addItemEx(item, flags)
	end

	return false
end

function isInArray(array, value)
	return table.contains(array, value)
end

function doCreateItem(itemid, count, pos)
	local tile = Tile(pos)
	if not tile then
		return false
	end

	local item = Game.createItem(itemid, count, pos)
	if item then
		return item:getUniqueId()
	end
	return false
end

function doCreateItemEx(itemid, count)
	local item = Game.createItem(itemid, count)
	if item then
		return item:getUniqueId()
	end
	return false
end

function doMoveCreature(cid, direction)
	local c = Creature(cid)
	return c ~= nil and c:move(direction)
end

function doSetCreatureLight(cid, lightLevel, lightColor, time)
	local creature = Creature(cid)
	if not creature then
		return false
	end

	local condition = Condition(CONDITION_LIGHT)
	condition:setParameter(CONDITION_PARAM_LIGHT_LEVEL, lightLevel)
	condition:setParameter(CONDITION_PARAM_LIGHT_COLOR, lightColor)
	condition:setTicks(time)
	creature:addCondition(condition)
	return true
end
