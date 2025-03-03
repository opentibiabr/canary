-- Functions from The Forgotten Server
local foodCondition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

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
	if self:getGroup():getAccess() and self:getAccountType() == ACCOUNT_TYPE_GOD then
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
	networkMessage:addString(buffer, "Player.sendExtendedOpcode - buffer")
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

function Player.removeMoneyBank(self, amount)
	local inventoryMoney = self:getMoney()
	local bankBalance = self:getBankBalance()

	if amount <= inventoryMoney then
		self:removeMoney(amount)
		if amount > 0 then
			self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from inventory."):format(amount))
		end
		return true
	end

	if amount <= (inventoryMoney + bankBalance) then
		local remainingAmount = amount

		if inventoryMoney > 0 then
			self:removeMoney(inventoryMoney)
			remainingAmount = remainingAmount - inventoryMoney
		end

		Bank.debit(self, remainingAmount)

		self:setBankBalance(bankBalance - remainingAmount)
		self:sendTextMessage(MESSAGE_TRADE, ("Paid %s from inventory and %s gold from bank account. Your account balance is now %s gold."):format(FormatNumber(amount - remainingAmount), FormatNumber(remainingAmount), FormatNumber(self:getBankBalance())))
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
			descr = descr .. " " .. thing:getSubjectPronoun():titleCase() .. " " .. thing:getSubjectVerb() .. " "
		end
		descr = descr .. "married to " .. getPlayerNameById(playerSpouse) .. "."
	end
	return descr
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
	self:kv():set("familiar-summon-time", os.time() + timeLeft)
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

function Player.updateHazard(self)
	local zones = self:getZones()
	if not zones or #zones == 0 then
		self:setHazardSystemPoints(0)
		return true
	end

	self:setHazardSystemPoints(0)
	for _, zone in pairs(zones) do
		local hazard = Hazard.getByName(zone:getName())
		if hazard then
			if self:getParty() then
				self:getParty():refreshHazard()
			else
				self:setHazardSystemPoints(hazard:getPlayerCurrentLevel(self))
			end
			return true
		end
	end
	return true
end

function Player:addItemStoreInboxEx(item, movable, setOwner)
	local inbox = self:getStoreInbox()
	if not movable then
		item:setOwner(self)
		item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
	elseif setOwner then
		item:setOwner(self)
	end
	inbox:addItemEx(item, INDEX_WHEREEVER, FLAG_NOLIMIT)
	return item
end

function Player:addItemStoreInbox(itemId, amount, movable, setOwner)
	if not amount then
		logger.error("[Player:addItemStoreInbox] item '{}' amount is nil.", itemId)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Item amount is wrong, please contact an administrator.")
		return nil
	end

	local iType = ItemType(itemId)
	if not iType then
		return nil
	end

	if iType:isStackable() then
		local stackSize = iType:getStackSize()
		while amount > stackSize do
			self:addItemStoreInboxEx(Game.createItem(itemId, stackSize), movable, setOwner)
			amount = amount - stackSize
		end
	end

	local item
	if iType:getCharges() > 0 then
		item = Game.createItem(itemId, 1)
		if item then
			item:setAttribute(ITEM_ATTRIBUTE_CHARGES, amount)
		end
	else
		item = Game.createItem(itemId, amount)
	end

	if not item then
		return nil
	end

	return self:addItemStoreInboxEx(item, movable, setOwner)
end

---@param monster Monster
---@return {factor: number, msgSuffix: string}
function Player:calculateLootFactor(monster)
	if not self:canReceiveLoot() then
		return {
			factor = 0.0,
			msgSuffix = "due to low stamina",
		}
	end

	local participants = { self }
	local factor = 1
	if configManager.getBoolean(configKeys.PARTY_SHARE_LOOT_BOOSTS) then
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
		suffix = string.format("vip bonus %d%%", math.floor(vipBoost * 100 + 0.5))
	end

	return {
		factor = factor,
		msgSuffix = suffix,
	}
end

function Player:setExhaustion(scope, seconds)
	return self:kv():scoped("exhaustion"):set(scope, os.time() + seconds)
end

function Player:getExhaustion(scope)
	local exhaustionKV = self:kv():scoped("exhaustion"):get(scope) or 0
	return math.max(exhaustionKV - os.time(), 0)
end

function Player:hasExhaustion(scope)
	return self:getExhaustion(scope) > 0 and true or false
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

function Player:showInfoModal(title, message, buttonText)
	local modal = ModalWindow({
		title = title,
		message = message,
	})
	buttonText = buttonText or "Close"
	modal:addButton(buttonText, function() end)
	modal:setDefaultEscapeButton(buttonText)

	modal:sendToPlayer(self)
end

function Player:showConfirmationModal(title, message, yesCallback, noCallback, yesText, noText)
	local modal = ModalWindow({
		title = title,
		message = message,
	})
	yesText = yesText or "Yes"
	modal:addButton(yesText, yesCallback or function() end)
	noText = noText or "No"
	modal:addButton(noText, noCallback or function() end)
	modal:setDefaultEscapeButton(noText)

	modal:sendToPlayer(self)
end

function Player:removeAll(itemId)
	local count = 0
	while self:removeItem(itemId, 1) do
		count = count + 1
	end
	return count
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

function Player.getCollectionTokens(self)
	return math.max(self:getStorageValue(DailyReward.storages.collectionTokens), 0)
end

function Player.getJokerTokens(self)
	return math.max(self:getStorageValue(DailyReward.storages.jokerTokens), 0)
end

function Player.setJokerTokens(self, value)
	self:setStorageValue(DailyReward.storages.jokerTokens, value)
end

function Player.setCollectionTokens(self, value)
	self:setStorageValue(DailyReward.storages.collectionTokens, value)
end

function Player.getDayStreak(self)
	return math.max(self:getStorageValue(DailyReward.storages.currentDayStreak), 0)
end

function Player.setDayStreak(self, value)
	self:setStorageValue(DailyReward.storages.currentDayStreak, value)
end

function Player.getStreakLevel(self)
	return self:kv():scoped("daily-reward"):get("streak") or 7
end

function Player.setStreakLevel(self, value)
	self:kv():scoped("daily-reward"):set("streak", value)
end

function Player.setNextRewardTime(self, value)
	self:setStorageValue(DailyReward.storages.nextRewardTime, value)
end

function Player.getNextRewardTime(self)
	return math.max(self:getStorageValue(DailyReward.storages.nextRewardTime), 0)
end

function Player.getActiveDailyRewardBonusesName(self)
	local msg = ""
	local streakLevel = self:getStreakLevel()
	if streakLevel >= 2 then
		if streakLevel > 7 then
			streakLevel = 7
		end
		for i = DAILY_REWARD_FIRST, streakLevel do
			if i ~= streakLevel then
				msg = msg .. "" .. DailyReward.strikeBonuses[i].text .. ", "
			else
				msg = msg .. "" .. DailyReward.strikeBonuses[i].text .. "."
			end
		end
	end
	return msg
end

function Player.getDailyRewardBonusesCount(self)
	local count = 1
	local streakLevel = self:getStreakLevel()
	if streakLevel > 2 then
		if streakLevel > 7 then
			streakLevel = 7
		end
		for i = DAILY_REWARD_FIRST, streakLevel do
			count = count + 1
		end
	else
		count = 0
	end
	return count
end

function Player.isBonusActiveById(self, bonusId)
	local streakLevel = self:getStreakLevel()
	local bonus = "locked"
	if streakLevel > 2 then
		if streakLevel > 7 then
			streakLevel = 7
		end
		if streakLevel >= bonusId then
			bonus = "unlocked"
		end
	end
	return bonus
end

function Player.loadDailyRewardBonuses(self)
	local streakLevel = self:getStreakLevel()
	-- Stamina regeneration
	if streakLevel >= DAILY_REWARD_STAMINA_REGENERATION then
		local staminaEvent = DailyRewardBonus.Stamina[self:getId()]
		if not staminaEvent then
			local delay = 3
			if self:getStamina() > 2340 and self:getStamina() <= 2520 then
				delay = 6
			end
			DailyRewardBonus.Stamina[self:getId()] = addEvent(RegenStamina, delay * 60 * 1000, self:getId(), delay * 60 * 1000)
		end
	end
	-- Soul regeneration
	if streakLevel >= DAILY_REWARD_SOUL_REGENERATION then
		local soulEvent = DailyRewardBonus.Soul[self:getId()]
		if not soulEvent then
			local delay = self:getVocation():getSoulGainTicks()
			DailyRewardBonus.Soul[self:getId()] = addEvent(RegenSoul, delay, self:getId(), delay)
		end
	end
	logger.debug("Player: {}, streak level: {}, active bonuses: {}", self:getName(), streakLevel, self:getActiveDailyRewardBonusesName())
end

function Player.getRewardChest(self, autocreate)
	return self:getDepotChest(99, autocreate)
end

function Player.inBossFight(self)
	if not next(_G.GlobalBosses) then
		return false
	end

	local playerGuid = self:getGuid()
	for _, info in pairs(_G.GlobalBosses) do
		local stats = info[playerGuid]
		if stats and stats.active then
			return stats
		end
	end
	return false
end

do
	local loyaltySystem = {
		enable = configManager.getBoolean(configKeys.LOYALTY_ENABLED),
		titles = {
			[1] = { name = "Scout of Tibia", points = 50 },
			[2] = { name = "Sentinel of Tibia", points = 100 },
			[3] = { name = "Steward of Tibia", points = 200 },
			[4] = { name = "Warden of Tibia", points = 400 },
			[5] = { name = "Squire of Tibia", points = 1000 },
			[6] = { name = "Warrior of Tibia", points = 2000 },
			[7] = { name = "Keeper of Tibia", points = 3000 },
			[8] = { name = "Guardian of Tibia", points = 4000 },
			[9] = { name = "Sage of Tibia", points = 5000 },
			[10] = { name = "Savant of Tibia", points = 6000 },
			[11] = { name = "Enlightened of Tibia", points = 7000 },
		},
		bonus = {
			{ minPoints = 360, percentage = 5 },
			{ minPoints = 720, percentage = 10 },
			{ minPoints = 1080, percentage = 15 },
			{ minPoints = 1440, percentage = 20 },
			{ minPoints = 1800, percentage = 25 },
			{ minPoints = 2160, percentage = 30 },
			{ minPoints = 2520, percentage = 35 },
			{ minPoints = 2880, percentage = 40 },
			{ minPoints = 3240, percentage = 45 },
			{ minPoints = 3600, percentage = 50 },
		},
		messageTemplate = "Due to your long-term loyalty to " .. SERVER_NAME .. " you currently benefit from a ${bonusPercentage}% bonus on all of your skills. (You have ${loyaltyPoints} loyalty points)",
	}

	function Player.initializeLoyaltySystem(self)
		if not loyaltySystem.enable then
			return true
		end

		local playerLoyaltyPoints = self:getLoyaltyPoints()

		-- Title
		local title = ""
		for _, titleTable in ipairs(loyaltySystem.titles) do
			if playerLoyaltyPoints >= titleTable.points then
				title = titleTable.name
			end
		end

		if title ~= "" then
			self:setLoyaltyTitle(title)
		end

		-- Bonus
		local playerBonusPercentage = 0
		for _, bonusTable in ipairs(loyaltySystem.bonus) do
			if playerLoyaltyPoints >= bonusTable.minPoints then
				playerBonusPercentage = bonusTable.percentage
			end
		end

		playerBonusPercentage = playerBonusPercentage * configManager.getFloat(configKeys.LOYALTY_BONUS_PERCENTAGE_MULTIPLIER)
		self:setLoyaltyBonus(playerBonusPercentage)

		if self:getLoyaltyBonus() ~= 0 then
			self:sendTextMessage(MESSAGE_STATUS, string.formatNamed(loyaltySystem.messageTemplate, { bonusPercentage = playerBonusPercentage, loyaltyPoints = playerLoyaltyPoints }))
		end

		return true
	end
end

function Player:questKV(questName)
	return self:kv():scoped("quests"):scoped(questName)
end

function Player:canGetReward(rewardId, questName)
	if self:questKV(questName):get("completed") then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
		return false
	end

	local rewardItem = ItemType(rewardId)
	if not rewardItem then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reward item is wrong, please contact an administrator.")
		return false
	end

	local itemWeight = rewardItem:getWeight() / 100
	local baseMessage = "You have found a " .. rewardItem:getName()
	local backpack = self:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		baseMessage = baseMessage .. ", but you have no room to take it."
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, baseMessage)
		return false
	end

	if (self:getFreeCapacity() / 100) < itemWeight then
		baseMessage = baseMessage .. ". Weighing " .. itemWeight .. " oz, it is too heavy for you to carry."
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, baseMessage)
		return false
	end

	return true
end

function Player.getURL(self)
	local playerName = self:getName():gsub("%s+", "+")
	local serverURL = configManager.getString(configKeys.URL)

	return serverURL .. "/characters/" .. playerName
end

local emojiMap = {
	["knight"] = ":crossed_swords:",
	["paladin"] = ":bow_and_arrow:",
	["druid"] = ":herb:",
	["sorcerer"] = ":crystal_ball:",
}

function Player.getMarkdownLink(self)
	local vocation = self:vocationAbbrev()
	local emoji = emojiMap[self:getVocation():getName():lower()] or ":school_satchel:"
	local playerURL = self:getURL()

	return string.format("**[%s](%s)** %s [_%s_]", self:getName(), playerURL, emoji, vocation)
end

function Player.findItemInInbox(self, itemId, name)
	local inbox = self:getStoreInbox()
	local items = inbox:getItems()

	for _, item in pairs(items) do
		if item:getId() == itemId and (not name or item:getName() == name) then
			return item
		end
	end
	return nil
end
