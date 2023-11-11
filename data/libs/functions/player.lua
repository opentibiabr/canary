-- Functions from The Forgotten Server
local foodCondition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

local function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function Player.feed(self, food)
	local condition = self:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition then
		condition:setTicks(condition:getTicks() + (food * 1000))
	else
		local vocation = self:getVocation()
		if not vocation then
			return nil
		end

		foodCondition:setTicks(food * 1000)
		foodCondition:setParameter(CONDITION_PARAM_HEALTHGAIN, vocation:getHealthGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_HEALTHTICKS, vocation:getHealthGainTicks())
		foodCondition:setParameter(CONDITION_PARAM_MANAGAIN, vocation:getManaGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_MANATICKS, vocation:getManaGainTicks())

		self:addCondition(foodCondition)
	end
	return true
end

function Player.getClosestFreePosition(self, position, extended)
	if self:getGroup():getAccess() and self:getAccountType() >= ACCOUNT_TYPE_GOD then
		return position
	end
	return Creature.getClosestFreePosition(self, position, extended)
end

function Player.getDepotItems(self, depotId)
	return self:getDepotChest(depotId, true):getItemHoldingCount()
end

function Player.hasFlag(self, flag)
	return self:getGroup():hasFlag(flag)
end

function Player.isPremium(self)
	return self:getPremiumDays() > 0 or configManager.getBoolean(configKeys.FREE_PREMIUM)
end

function Player.sendCancelMessage(self, message)
	if type(message) == "number" then
		message = Game.getReturnMessage(message)
	end
	return self:sendTextMessage(MESSAGE_FAILURE, message)
end

function Player.isUsingOtClient(self)
	return self:getClient().os >= CLIENTOS_OTCLIENT_LINUX
end

function Player.sendExtendedOpcode(self, opcode, buffer)
	if not self:isUsingOtClient() then
		return false
	end

	local networkMessage = NetworkMessage()
	networkMessage:addByte(0x32)
	networkMessage:addByte(opcode)
	networkMessage:addString(buffer)
	networkMessage:sendToPlayer(self)
	networkMessage:delete()
	return true
end

APPLY_SKILL_MULTIPLIER = true
local addSkillTriesFunc = Player.addSkillTries
function Player.addSkillTries(...)
	local arg = { ... }
	local param4 = arg[4]
	local applySkill = not param4
	APPLY_SKILL_MULTIPLIER = applySkill
	local ret = addSkillTriesFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end

local addManaSpentFunc = Player.addManaSpent
function Player.addManaSpent(...)
	local arg = { ... }
	local param3 = arg[3]
	local applySkill = not param3
	APPLY_SKILL_MULTIPLIER = applySkill
	local ret = addManaSpentFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end

-- Functions From OTServBR-Global
function Player.getCookiesDelivered(self)
	if not IsRunningGlobalDatapack() then
		return true
	end

	local storage, amount =
		{
			Storage.WhatAFoolish.CookieDelivery.SimonTheBeggar,
			Storage.WhatAFoolish.CookieDelivery.Markwin,
			Storage.WhatAFoolish.CookieDelivery.Ariella,
			Storage.WhatAFoolish.CookieDelivery.Hairycles,
			Storage.WhatAFoolish.CookieDelivery.Djinn,
			Storage.WhatAFoolish.CookieDelivery.AvarTar,
			Storage.WhatAFoolish.CookieDelivery.OrcKing,
			Storage.WhatAFoolish.CookieDelivery.Lorbas,
			Storage.WhatAFoolish.CookieDelivery.Wyda,
			Storage.WhatAFoolish.CookieDelivery.Hjaern,
		}, 0
	for i = 1, #storage do
		if self:getStorageValue(storage[i]) == 1 then
			amount = amount + 1
		end
	end
	return amount
end

function Player.allowMovement(self, allow)
	return self:setStorageValue(Global.Storage.BlockMovementStorage, allow and -1 or 1)
end

function Player.hasAllowMovement(self)
	return self:getStorageValue(Global.Storage.BlockMovementStorage) ~= 1
end

function Player.checkGnomeRank(self)
	if not IsRunningGlobalDatapack() then
		return true
	end

	local points = self:getStorageValue(Storage.BigfootBurden.Rank)
	local questProgress = self:getStorageValue(Storage.BigfootBurden.QuestLine)
	if points >= 30 and points < 120 then
		if questProgress <= 25 then
			self:setStorageValue(Storage.BigfootBurden.QuestLine, 26)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
		end
	elseif points >= 120 and points < 480 then
		if questProgress <= 26 then
			self:setStorageValue(Storage.BigfootBurden.QuestLine, 27)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
		end
	elseif points >= 480 and points < 1440 then
		if questProgress <= 27 then
			self:setStorageValue(Storage.BigfootBurden.QuestLine, 28)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
			self:addAchievement("Gnomelike")
		end
	elseif points >= 1440 then
		if questProgress <= 29 then
			self:setStorageValue(Storage.BigfootBurden.QuestLine, 30)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			self:addAchievement("Gnome Little Helper")
			self:addAchievement("Gnome Friend")
			self:addAchievement("Gnomelike")
			self:addAchievement("Honorary Gnome")
		end
	end
	return true
end

function Player.addFamePoint(self)
	local points = self:getStorageValue(SPIKE_FAME_POINTS)
	local current = math.max(0, points)
	self:setStorageValue(SPIKE_FAME_POINTS, current + 1)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received a fame point.")
end

function Player.getFamePoints(self)
	local points = self:getStorageValue(SPIKE_FAME_POINTS)
	return math.max(0, points)
end

function Player.removeFamePoints(self, amount)
	local points = self:getStorageValue(SPIKE_FAME_POINTS)
	local current = math.max(0, points)
	self:setStorageValue(SPIKE_FAME_POINTS, current - amount)
end

function Player.depositMoney(self, amount)
	return Bank.deposit(self, amount)
end

function Player.transferMoneyTo(self, target, amount)
	if not target then
		return false
	end
	if not Bank.transfer(self, target, amount) then
		return false
	end

	local targetPlayer = Player(target)
	if targetPlayer then
		targetPlayer:sendTextMessage(MESSAGE_LOOK, self:getName() .. " has transferred " .. FormatNumber(amount) .. " gold coins to you.")
	end
	return true
end

function Player.withdrawMoney(self, amount)
	return Bank.withdraw(self, amount)
end

-- player:removeMoneyBank(money)
function Player:removeMoneyBank(amount)
	if type(amount) == "string" then
		amount = tonumber(amount)
	end

	local moneyCount = self:getMoney()
	local bankCount = self:getBankBalance()

	-- The player have all the money with him
	if amount <= moneyCount then
		-- Removes player inventory money
		self:removeMoney(amount)

		self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from inventory."):format(amount))
		return true

		-- The player doens't have all the money with him
	elseif amount <= (moneyCount + bankCount) then
		-- Check if the player has some money
		if moneyCount ~= 0 then
			-- Removes player inventory money
			self:removeMoney(moneyCount)
			local remains = amount - moneyCount

			-- Removes player bank money
			Bank.debit(self, remains)

			self:sendTextMessage(MESSAGE_TRADE, ("Paid %s from inventory and %s gold from bank account. Your account balance is now %s gold."):format(FormatNumber(moneyCount), FormatNumber(amount - moneyCount), FormatNumber(self:getBankBalance())))
			return true
		end
		self:setBankBalance(bankCount - amount)
		self:sendTextMessage(MESSAGE_TRADE, ("Paid %s gold from bank account. Your account balance is now %s gold."):format(FormatNumber(amount), FormatNumber(self:getBankBalance())))
		return true
	end
	return false
end

function Player.hasRookgaardShield(self)
	-- Wooden Shield, Studded Shield, Brass Shield, Plate Shield, Copper Shield
	return self:getItemCount(3412) > 0 or self:getItemCount(3426) > 0 or self:getItemCount(3411) > 0 or self:getItemCount(3410) > 0 or self:getItemCount(3430) > 0
end

function Player:vocationAbbrev()
	local vocation = self:getVocation()
	if not vocation then
		return "N"
	end

	local vocationName = vocation:getName():split(" ")
	local abbrev = ""
	for _, name in ipairs(vocationName) do
		abbrev = abbrev .. name:sub(1, 1)
	end
	return abbrev:upper()
end

function Player.isSorcerer(self)
	return table.contains({ VOCATION.ID.SORCERER, VOCATION.ID.MASTER_SORCERER }, self:getVocation():getId())
end

function Player.isDruid(self)
	return table.contains({ VOCATION.ID.DRUID, VOCATION.ID.ELDER_DRUID }, self:getVocation():getId())
end

function Player.isKnight(self)
	return table.contains({ VOCATION.ID.KNIGHT, VOCATION.ID.ELITE_KNIGHT }, self:getVocation():getId())
end

function Player.isPaladin(self)
	return table.contains({ VOCATION.ID.PALADIN, VOCATION.ID.ROYAL_PALADIN }, self:getVocation():getId())
end

function Player.isMage(self)
	return table.contains({ VOCATION.ID.SORCERER, VOCATION.ID.MASTER_SORCERER, VOCATION.ID.DRUID, VOCATION.ID.ELDER_DRUID }, self:getVocation():getId())
end

local ACCOUNT_STORAGES = {}
function Player.getAccountStorage(self, key, forceUpdate)
	local accountId = self:getAccountId()
	if ACCOUNT_STORAGES[accountId] and not forceUpdate then
		return ACCOUNT_STORAGES[accountId]
	end

	local query = db.storeQuery("SELECT `key`, MAX(`value`) as value FROM `player_storage` WHERE `player_id` IN (SELECT `id` FROM `players` WHERE `account_id` = " .. accountId .. ") AND `key` = " .. key .. " GROUP BY `key` LIMIT 1;")
	if query ~= false then
		local value = Result.getNumber(query, "value")
		ACCOUNT_STORAGES[accountId] = value
		Result.free(query)
		return value
	end
	return false
end

function Player:getUpdatedAccountStorage(bucket)
	local fromMemory = self:getStorageValue(bucket) > 0 and self:getStorageValue(bucket) or 0
	local fromDB = self:getAccountStorage(bucket, true) and self:getAccountStorage(bucket, true) or 0
	return bit.bor(fromDB, fromMemory)
end

function Player.getMarriageDescription(thing)
	local descr = ""
	if getPlayerMarriageStatus(thing:getGuid()) == MARRIED_STATUS then
		playerSpouse = getPlayerSpouse(thing:getGuid())
		if self == thing then
			descr = descr .. " You are "
		else
			descr = descr .. " " .. firstToUpper(thing:getSubjectPronoun()) .. " " .. thing:getSubjectVerb() .. " "
		end
		descr = descr .. "married to " .. getPlayerNameById(playerSpouse) .. "."
	end
	return descr
end

function Player.sendWeatherEffect(self, groundEffect, fallEffect, thunderEffect)
	local position, random = self:getPosition(), math.random
	position.x = position.x + random(-7, 7)
	position.y = position.y + random(-5, 5)
	local fromPosition = Position(position.x + 1, position.y, position.z)
	fromPosition.x = position.x - 7
	fromPosition.y = position.y - 5
	local tile, getGround
	for Z = 1, 7 do
		fromPosition.z = Z
		position.z = Z
		tile = Tile(position)
		if tile then
			-- If there is a tile, stop checking floors
			fromPosition:sendDistanceEffect(position, fallEffect)
			position:sendMagicEffect(groundEffect, self)
			getGround = tile:getGround()
			if getGround and ItemType(getGround:getId()):getFluidSource() == 1 then
				position:sendMagicEffect(CONST_ME_LOSEENERGY, self)
			end
			break
		end
	end
	if thunderEffect and tile and not tile:hasFlag(TILESTATE_PROTECTIONZONE) then
		if random(2) == 1 then
			local topCreature = tile:getTopCreature()
			if topCreature and topCreature:isPlayer() and topCreature:getAccountType() < ACCOUNT_TYPE_SENIORTUTOR then
				position:sendMagicEffect(CONST_ME_BIGCLOUDS, self)
				doTargetCombatHealth(0, self, COMBAT_ENERGYDAMAGE, -weatherConfig.minDMG, -weatherConfig.maxDMG, CONST_ME_NONE)
				--self:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You were hit by lightning and lost some health.")
			end
		end
	end
end

function Player:getFamiliarName()
	local vocation = FAMILIAR_ID[self:getVocation():getBaseId()]
	local familiarName
	if vocation then
		familiarName = vocation.name
	end
	return familiarName
end

function Player:CreateFamiliarSpell(spellId)
	local playerPosition = self:getPosition()
	if not self:isPremium() then
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		self:sendCancelMessage("You need a premium account.")
		return false
	end

	if #self:getSummons() >= 1 and self:getAccountType() < ACCOUNT_TYPE_GOD then
		self:sendCancelMessage("You can't have other summons.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local familiarName = self:getFamiliarName()
	if not familiarName then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Divide by 2 to get half the time (the default total time is 30 / 2 = 15)
	local summonDuration = 60 * configManager.getNumber(configKeys.FAMILIAR_TIME) / 2
	local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, spellId)
	local cooldown = summonDuration * 2
	if self:isVip() then
		local reduction = configManager.getNumber(configKeys.VIP_FAMILIAR_TIME_COOLDOWN_REDUCTION)
		reduction = (reduction > summonDuration and summonDuration) or reduction
		cooldown = cooldown - reduction * 60
	end
	condition:setTicks(1000 * cooldown / configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
	self:addCondition(condition)

	self:createFamiliar(familiarName, summonDuration)

	return true
end

function Player:createFamiliar(familiarName, timeLeft)
	local playerPosition = self:getPosition()
	if not familiarName then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local myFamiliar = Game.createMonster(familiarName, playerPosition, true, false, self)
	if not myFamiliar then
		self:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		playerPosition:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	myFamiliar:setOutfit({ lookType = self:getFamiliarLooktype() })
	myFamiliar:registerEvent("FamiliarDeath")
	myFamiliar:changeSpeed(math.max(self:getSpeed() - myFamiliar:getBaseSpeed(), 0))
	playerPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	myFamiliar:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	-- Divide by 2 to get half the time (the default total time is 30 / 2 = 15)
	self:setStorageValue(Global.Storage.FamiliarSummon, os.time() + timeLeft)
	addEvent(RemoveFamiliar, timeLeft * 1000, myFamiliar:getId(), self:getId())
	for sendMessage = 1, #FAMILIAR_TIMER do
		self:setStorageValue(
			FAMILIAR_TIMER[sendMessage].storage,
			addEvent(
				-- Calling function
				SendMessageFunction,
				-- Time for execute event
				(timeLeft - FAMILIAR_TIMER[sendMessage].countdown) * 1000,
				-- Param "playerId"
				self:getId(),
				-- Param "message"
				FAMILIAR_TIMER[sendMessage].message
			)
		)
	end
	return true
end

function Player:dispellFamiliar()
	local summons = self:getSummons()
	for i = 1, #summons do
		if summons[i]:getName():lower() == self:getFamiliarName():lower() then
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			summons[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
			summons[i]:remove()
			return true
		end
	end
	return false
end

function Player.getFinalBaseRateExperience(self)
	-- Experience Stage Multiplier
	local baseRate
	local rateExperience = configManager.getNumber(configKeys.RATE_EXPERIENCE)
	if configManager.getBoolean(configKeys.RATE_USE_STAGES) then
		baseRate = getRateFromTable(experienceStages, self:getLevel(), rateExperience)
	else
		baseRate = rateExperience
	end
	-- Event scheduler
	if SCHEDULE_EXP_RATE ~= 100 then
		baseRate = math.max(0, (baseRate * SCHEDULE_EXP_RATE) / 100)
	end
	return baseRate
end

function Player.getFinalBonusStamina(self)
	local staminaBonus = 1
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2340 and self:isPremium() then
			staminaBonus = 1.5
		elseif staminaMinutes <= 840 then
			staminaBonus = 0.5
		end
	end
	return staminaBonus
end

function Player.getFinalLowLevelBonus(self)
	local level = self:getLevel()
	if level > 0 and level <= 50 then
		self:setGrindingXpBoost(configManager.getNumber(configKeys.LOW_LEVEL_BONUS_EXP))
	else
		self:setGrindingXpBoost(0)
	end
	return self:getGrindingXpBoost()
end

function Player.getSubjectPronoun(self)
	return Pronouns.getPlayerSubjectPronoun(self:getPronoun(), self:getSex(), self:getName())
end

function Player.getObjectPronoun(self)
	return Pronouns.getPlayerObjectPronoun(self:getPronoun(), self:getSex(), self:getName())
end

function Player.getPossessivePronoun(self)
	return Pronouns.getPlayerPossessivePronoun(self:getPronoun(), self:getSex(), self:getName())
end

function Player.getSubjectVerb(self, past)
	return Pronouns.getPlayerSubjectVerb(self:getPronoun(), past)
end

function Player.findItemInInbox(self, itemId)
	local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
	local items = inbox:getItems()
	for _, item in pairs(items) do
		if item:getId() == itemId then
			return item
		end
	end
	return nil
end

function Player.updateHazard(self)
	local zones = self:getZones()
	if not zones or #zones == 0 then
		self:setHazardSystemPoints(0)
		return true
	end

	for _, zone in pairs(zones) do
		local hazard = Hazard.getByName(zone:getName())
		if not hazard then
			self:setHazardSystemPoints(0)
			return true
		end

		if self:getParty() then
			self:getParty():refreshHazard()
		else
			self:setHazardSystemPoints(hazard:getPlayerCurrentLevel(self))
		end
		return true
	end
	return true
end

function Player:addItemStoreInbox(itemId, amount, moveable)
	local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not moveable then
		for _, item in pairs(inbox:getItems()) do
			if item:getId() == itemId then
				item:removeAttribute(ITEM_ATTRIBUTE_STORE)
			end
		end
	end

	local newItem = inbox:addItem(itemId, amount, INDEX_WHEREEVER, FLAG_NOLIMIT)

	if not moveable then
		for _, item in pairs(inbox:getItems()) do
			if item:getId() == itemId then
				item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			end
		end
	end
	return newItem
end

---@param monster Monster
---@return {factor: number, msgSuffix: string}
function Player:calculateLootFactor(monster)
	if self:getStamina() <= 840 then
		return {
			factor = 0.0,
			msgSuffix = " (due to low stamina)",
		}
	end

	local participants = { self }
	local factor = 1
	if configManager.getBoolean(PARTY_SHARE_LOOT_BOOSTS) then
		local party = self:getParty()
		if party and party:isSharedExperienceEnabled() then
			participants = party:getMembers()
			table.insert(participants, party:getLeader())
		end
	end

	local vipActivators = 0
	local vipBoost = 0
	local suffix = ""

	for _, participant in ipairs(participants) do
		if participant:isVip() then
			local boost = configManager.getNumber(configKeys.VIP_BONUS_LOOT)
			boost = ((boost > 100 and 100) or boost) / 100
			vipBoost = vipBoost + boost
			vipActivators = vipActivators + 1
		end
	end
	if vipActivators > 0 then
		vipBoost = vipBoost / (vipActivators ^ configManager.getFloat(configKeys.PARTY_SHARE_LOOT_BOOSTS_DIMINISHING_FACTOR))
		factor = factor * (1 + vipBoost)
	end
	if vipBoost > 0 then
		suffix = suffix .. (" (vip bonus: %d%%)"):format(math.floor(vipBoost * 100 + 0.5))
	end

	return {
		factor = factor,
		msgSuffix = suffix,
	}
end

function Player:setExhaustion(key, seconds)
	return self:setStorageValue(key, os.time() + seconds)
end

function Player:getExhaustion(key)
	return math.max(self:getStorageValue(key) - os.time(), 0)
end

function Player:hasExhaustion(key)
	return self:getExhaustion(key) > 0 and true or false
end

function Player:setFiendish()
	local position = self:getPosition()
	position:getNextPosition(self:getDirection())

	local tile = Tile(position)
	local thing = tile:getTopVisibleThing(self)
	if not tile or thing and not thing:isMonster() then
		self:sendCancelMessage("Monster not found.")
		return false
	end

	local monster = thing:getMonster()
	if monster then
		monster:setFiendish(position, self)
	end
	return false
end

local function bossKVScope(bossNameOrId)
	local mType = MonsterType(bossNameOrId)
	if not mType then
		logger.error("bossKVScope - Invalid boss name or id: " .. bossNameOrId)
		return false
	end
	return "boss.cooldown." .. toKey(tostring(mType:raceId()))
end

function Player:getBossCooldown(bossNameOrId)
	local scope = bossKVScope(bossNameOrId)
	if not scope then
		return false
	end
	return self:kv():get(scope) or 0
end

function Player:setBossCooldown(bossNameOrId, time)
	local scope = bossKVScope(bossNameOrId)
	if not scope then
		return false
	end
	local result = self:kv():set(scope, time)
	self:sendBosstiaryCooldownTimer()
	return result
end

function Player:canFightBoss(bossNameOrId)
	local cooldown = self:getBossCooldown(bossNameOrId)
	return cooldown <= os.time()
end
