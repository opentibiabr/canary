local storeItemID = {
	-- registered item ids here are not tradable with players
	-- these items can be set to movable at items.xml
	-- 500 charges exercise weapons
	28552, -- exercise sword
	28553, -- exercise axe
	28554, -- exercise club
	28555, -- exercise bow
	28556, -- exercise rod
	28557, -- exercise wand
	44065, -- exercise shield

	-- 50 charges exercise weapons
	28540, -- training sword
	28541, -- training axe
	28542, -- training club
	28543, -- training bow
	28544, -- training wand
	28545, -- training club
	44064, -- training shield

	-- magic gold and magic converter (activated/deactivated)
	28525, -- magic gold converter
	28526, -- magic gold converter
	23722, -- gold converter
	25719, -- gold converter

	-- foods
	29408, -- roasted wyvern wings
	29409, -- carrot pie
	29410, -- tropical marinated tiger
	29411, -- delicatessen salad
	29412, -- chilli con carniphila
	29413, -- svargrond salmon filet
	29414, -- carrion casserole
	29415, -- consecrated beef
	29416, -- overcooked noodles
}

-- Players cannot throw items on teleports if set to true
local blockTeleportTrashing = true

local configPush = {
	maxItemsPerSeconds = 1,
	exhaustTime = 2000,
}

local pushDelay = {}

local function antiPush(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if not player then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	if toPosition.x == CONTAINER_POSITION then
		return true
	end

	local tile = Tile(toPosition)
	if not tile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	local playerId = player:getId()
	if not pushDelay[playerId] then
		pushDelay[playerId] = { items = 0, time = 0 }
	end

	pushDelay[playerId].items = pushDelay[playerId].items + 1

	local currentTime = systemTime()
	if pushDelay[playerId].time == 0 then
		pushDelay[playerId].time = currentTime
	elseif pushDelay[playerId].time == currentTime then
		pushDelay[playerId].items = pushDelay[playerId].items + 1
	elseif currentTime > pushDelay[playerId].time then
		pushDelay[playerId].time = 0
		pushDelay[playerId].items = 0
	end

	if pushDelay[playerId].items > configPush.maxItemsPerSeconds then
		pushDelay[playerId].time = currentTime + configPush.exhaustTime
	end

	if pushDelay[playerId].time > currentTime then
		player:sendCancelMessage("You can't move that item so fast.")
		return false
	end

	return true
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player, isStaminaEnabled)
	if not player then
		return false
	end

	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not playerId or not _G.NextUseStaminaTime[playerId] then
		return false
	end

	local currentTime = os.time()
	local timePassed = currentTime - _G.NextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		_G.NextUseStaminaTime[playerId] = currentTime + 120
		player:removePreyStamina(120)
	else
		staminaMinutes = staminaMinutes - 1
		_G.NextUseStaminaTime[playerId] = currentTime + 60
		player:removePreyStamina(60)
	end
	if isStaminaEnabled then
		player:setStamina(staminaMinutes)
	end
end

local function useStaminaXpBoost(player)
	if not player then
		return false
	end

	local xpBoostMinutes = player:getXpBoostTime() / 60
	if xpBoostMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not playerId then
		return false
	end

	local currentTime = os.time()
	local timePassed = currentTime - _G.NextUseXpStamina[playerId]
	if timePassed <= 0 then
		return
	end

	local xpBoostLeftMinutesByDailyReward = player:kv():get("daily-reward-xp-boost") or 0
	if timePassed > 60 then
		if xpBoostMinutes > 2 then
			xpBoostMinutes = xpBoostMinutes - 2
			if xpBoostLeftMinutesByDailyReward > 2 then
				player:kv():set("daily-reward-xp-boost", xpBoostLeftMinutesByDailyReward - 2)
			end
		else
			xpBoostMinutes = 0
			player:kv():remove("daily-reward-xp-boost")
		end
		_G.NextUseXpStamina[playerId] = currentTime + 120
	else
		xpBoostMinutes = xpBoostMinutes - 1
		if xpBoostLeftMinutesByDailyReward > 0 then
			player:kv():set("daily-reward-xp-boost", xpBoostLeftMinutesByDailyReward - 1)
		end
		_G.NextUseXpStamina[playerId] = currentTime + 60
	end
	player:setXpBoostTime(xpBoostMinutes * 60)
end

local function useConcoctionTime(player)
	if not player then
		return false
	end

	local playerId = player:getId()
	if not playerId or not _G.NextUseConcoctionTime[playerId] then
		return false
	end

	local currentTime = os.time()
	local timePassed = currentTime - _G.NextUseConcoctionTime[playerId]
	if timePassed <= 0 then
		return false
	end

	local deduction = 60
	if timePassed > 60 then
		_G.NextUseConcoctionTime[playerId] = currentTime + 120
		deduction = 120
	else
		_G.NextUseConcoctionTime[playerId] = currentTime + 60
	end
	Concoction.experienceTick(player, deduction)
end

function Player:onLookInBattleList(creature, distance)
	if not creature then
		return false
	end

	local description = "You see " .. creature:getDescription(distance)
	if creature:isMonster() then
		local master = creature:getMaster()
		local summons = { "sorcerer familiar", "knight familiar", "druid familiar", "paladin familiar" }
		if master and table.contains(summons, creature:getName():lower()) then
			local familiarSummonTime = master:kv():get("familiar-summon-time") or 0
			description = description .. " (Master: " .. master:getName() .. "). \z
				It will disappear in " .. Game.getTimeInWords(familiarSummonTime - os.time())
		end
	end
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:isPlayer() and creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format("%s\nPosition: %d, %d, %d", description, position.x, position.y, position.z)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_LOOK, description)
end

local exhaust = {}

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if item:getActionId() == IMMOVABLE_ACTION_ID then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- No move if tile item count > 20 items
	local tile = Tile(toPosition)
	if tile and tile:getItemCount() > 20 then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- Players cannot throw items on teleports
	if blockTeleportTrashing and tile and toPosition.x ~= CONTAINER_POSITION then
		local thing = tile:getItemByType(ITEM_TYPE_TELEPORT)
		if thing then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			self:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	-- SSA exhaust
	if toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_NECKLACE and item:getId() == ITEM_STONE_SKIN_AMULET then
		local playerId = self:getId()
		if exhaust[playerId] then
			self:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
			return false
		end
		exhaust[playerId] = true
		addEvent(function(id)
			exhaust[id] = nil
		end, 2000, playerId)
		return true
	end

	-- Bath tube
	local toTile = Tile(toCylinder:getPosition())
	if toTile then
		local topDownItem = toTile:getTopDownItem()
		if topDownItem and table.contains({ BATHTUB_EMPTY, BATHTUB_FILLED }, topDownItem:getId()) then
			return false
		end
	end

	-- Handle move items to the ground
	if toPosition.x ~= CONTAINER_POSITION then
		return true
	end

	-- Check two-handed weapons
	if item:getTopParent() == self and bit.band(toPosition.y, 0x40) == 0 then
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = self:getSlotItem(CONST_SLOT_RIGHT)
			if moveItem and itemType:getWeaponType() == WEAPON_DISTANCE and ItemType(moveItem:getId()):isQuiver() then
				return true
			end
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = self:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return true
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:getSize() == parent:getCapacity() then
				self:sendTextMessage(MESSAGE_FAILURE, Game.getReturnMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM))
				return false
			end
			return moveItem:moveTo(parent)
		end
	end

	-- Reward System
	local containerThing = tile and tile:getItemByType(ITEM_TYPE_CONTAINER)
	if containerThing and toPosition.x == CONTAINER_POSITION then
		local containerId = toPosition.y - 64
		local container = self:getContainerById(containerId)
		if not container then
			return true
		end

		-- Do not let the player insert items into either the Reward Container or the Reward Chest
		local itemId = container:getId()
		if itemId == ITEM_REWARD_CONTAINER or itemId == ITEM_REWARD_CHEST then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return false
		end

		-- The player also shouldn't be able to insert items into the boss corpse
		local tileCorpse = Tile(container:getPosition())
		if tileCorpse then
			for index, value in ipairs(tileCorpse:getItems() or {}) do
				if value:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2 ^ 31 - 1 and value:getName() == container:getName() then
					self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
					return false
				end
			end
		end
	end

	-- Do not let the player move the boss corpse.
	if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2 ^ 31 - 1 then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- Players cannot throw items on reward chest
	local tileChest = Tile(toPosition)
	if tileChest and tileChest:getItemById(ITEM_REWARD_CHEST) then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if tile and tile:getItemById(370) then
		-- Trapdoor
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not antiPush(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder) then
		return false
	end

	return true
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if IsRunningGlobalDatapack() then
		-- The Secret Library Quest
		if toPosition == Position(32460, 32928, 7) and item.itemid == 3578 then
			toPosition:sendMagicEffect(CONST_ME_HEARTS)
			self:say("You feed the turtle, now you may pass.", TALKTYPE_MONSTER_SAY)
			Game.setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Turtle, os.time() + 10 * 60)
			item:remove(1)
		end

		-- Cults of Tibia begin
		local frompos = Position(33023, 31904, 14)
		local topos = Position(33052, 31932, 15)
		local removeItem = false
		if self:getPosition():isInRange(frompos, topos) and item:getId() == 23729 then
			local tile = Tile(toPosition)
			if tile then
				local tileBoss = tile:getTopCreature()
				if tileBoss and tileBoss:isMonster() then
					if tileBoss:getName():lower() == "the remorseless corruptor" then
						tileBoss:addHealth(-17000)
						tileBoss:remove()
						local monster = Game.createMonster("The Corruptor of Souls", toPosition)
						if not monster then
							return false
						end
						removeItem = true
						monster:registerEvent("CheckTile")
						if Game.getStorageValue("healthSoul") > 0 then
							monster:addHealth(-(monster:getHealth() - Game.getStorageValue("healthSoul")))
						end
						Game.setStorageValue("CheckTile", os.time() + 30)
					elseif tileBoss:getName():lower() == "the corruptor of souls" then
						Game.setStorageValue("CheckTile", os.time() + 30)
						removeItem = true
					end
				end
			end
			if removeItem then
				item:remove(1)
			end
		end
		-- Cults of Tibia end
	end
	return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	local player = creature:getPlayer()
	if player and _G.OnExerciseTraining[player:getId()] and not self:getGroup():hasFlag(PlayerFlag_CanPushAllCreatures) then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end
	return true
end

local function hasPendingReport(playerGuid, targetName, reportType)
	local player = Player(playerGuid)
	if not player then
		return false
	end
	local name = player:getName():gsub("%s+", "_")
	FS.mkdir_p(string.format("%s/reports/players/%s", CORE_DIRECTORY, name))
	local file = io.open(string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType), "r")
	if file then
		io.close(file)
		return true
	end
	return false
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	local name = self:getName()
	if hasPendingReport(self:getGuid(), targetName, reportType) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your report is being processed.")
		return
	end

	local file = io.open(string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType), "a")
	if not file then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when processing your report, please contact a gamemaster.")
		return
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Reported by: " .. name .. "\n")
	io.write("Target: " .. targetName .. "\n")
	io.write("Type: " .. reportType .. "\n")
	io.write("Reason: " .. reportReason .. "\n")
	io.write("Comment: " .. comment .. "\n")
	if reportType ~= REPORT_TYPE_BOT then
		io.write("Translation: " .. translation .. "\n")
	end
	io.write("------------------------------\n")
	io.close(file)
	self:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		string.format(
			"Thank you for reporting %s. Your report \z
	will be processed by %s team as soon as possible.",
			targetName,
			configManager.getString(configKeys.SERVER_NAME)
		)
	)
	return
end

function Player:onReportBug(message, position, category)
	local name = self:getName():gsub("%s+", "_")
	FS.mkdir_p(string.format("%s/reports/bugs/%s", CORE_DIRECTORY, name))
	local file = io.open(string.format("%s/reports/bugs/%s/report.txt", CORE_DIRECTORY, name), "a")

	if not file then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when processing your report, please contact a gamemaster.")
		return true
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Name: " .. name)
	if category == BUG_CATEGORY_MAP then
		io.write(" [Map position: " .. position.x .. ", " .. position.y .. ", " .. position.z .. "]")
	end
	local playerPosition = self:getPosition()
	io.write(" [Player Position: " .. playerPosition.x .. ", " .. playerPosition.y .. ", " .. playerPosition.z .. "]\n")
	io.write("Comment: " .. message .. "\n")
	io.close(file)

	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your report has been sent to " .. configManager.getString(configKeys.SERVER_NAME) .. ".")
	return true
end

function Player:onTurn(direction)
	if self:getGroup():getAccess() and self:getDirection() == direction then
		local nextPosition = self:getPosition()
		nextPosition:getNextPosition(direction)
		self:teleportTo(nextPosition, true)
	end

	return true
end

function Player:onTradeRequest(target, item)
	if item:getActionId() == IMMOVABLE_ACTION_ID then
		return false
	end

	if table.contains(storeItemID, item.itemid) then
		return false
	end
	return true
end

function Player:onGainExperience(target, exp, rawExp)
	if not target or target:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks())
		self:addCondition(soulCondition)
	end

	-- Apply XP Boost (Store or Daily Reward)
	useStaminaXpBoost(self)

	local xpBoostTimeLeft = self:getXpBoostTime()
	local hasXpBoost = xpBoostTimeLeft > 0
	local xpBoostPercent = hasXpBoost and self:getXpBoostPercent() or 0

	-- Stamina Bonus
	local staminaBonusXp = 1
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self, true)
		staminaBonusXp = self:getFinalBonusStamina()
		self:setStaminaXpBoost(staminaBonusXp * 100)
	end

	-- Concoction System
	useConcoctionTime(self)

	-- Apply Boosted Creature Bonus
	if target:getName():lower() == Game.getBoostedCreature():lower() then
		exp = exp * 2
	end

	-- Prey System
	if configManager.getBoolean(configKeys.PREY_ENABLED) then
		local monsterType = target:getType()
		if monsterType and monsterType:raceId() > 0 then
			exp = math.ceil((exp * self:getPreyExperiencePercentage(monsterType:raceId())) / 100)
		end
	end

	-- VIP Bonus Experience
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
		if vipBonusExp > 0 and self:isVip() then
			exp = exp * (1 + math.min(vipBonusExp, 100) / 100)
		end
	end

	-- Final Adjustments: Low Level Bonus and Base Rate
	local lowLevelBonusExp = self:getFinalLowLevelBonus()
	local baseRateExp = self:getFinalBaseRateExperience()

	-- Return final experience value
	return (exp * (1 + xpBoostPercent / 100 + lowLevelBonusExp / 100)) * staminaBonusXp * baseRateExp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
	-- Dawnport skills limit
	if IsRunningGlobalDatapack() and isSkillGrowthLimited(self, skill) then
		return 0
	end

	if not APPLY_SKILL_MULTIPLIER then
		return tries
	end

	-- Default skill rate settings
	local rateSkillStages = configManager.getBoolean(configKeys.RATE_USE_STAGES) and skillsStages or nil
	local currentSkillLevel = self:getSkillLevel(skill)
	local baseRate = configManager.getNumber(configKeys.RATE_SKILL)

	-- Special case for magic level
	if skill == SKILL_MAGLEVEL then
		rateSkillStages = configManager.getBoolean(configKeys.RATE_USE_STAGES) and magicLevelStages or nil
		currentSkillLevel = self:getBaseMagicLevel()
		baseRate = configManager.getNumber(configKeys.RATE_MAGIC)
	end

	-- Calculate skill rate from stages and schedule
	local skillRate = getRateFromTable(rateSkillStages, currentSkillLevel, baseRate)
	skillRate = (SCHEDULE_SKILL_RATE ~= 100) and (skillRate * SCHEDULE_SKILL_RATE / 100) or skillRate

	-- Apply VIP boost if applicable
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and self:isVip() then
		local vipBonusSkill = math.min(configManager.getNumber(configKeys.VIP_BONUS_SKILL), 100)
		skillRate = skillRate + (skillRate * (vipBonusSkill / 100))
	end

	-- Calculate and return the final experience gain
	return tries * skillRate
end

function Player:onCombat(target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not item or not target then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if ItemType(item:getId()):getWeaponType() == WEAPON_AMMO then
		if table.contains({ ITEM_OLD_DIAMOND_ARROW, ITEM_DIAMOND_ARROW }, item:getId()) then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
		item = self:getSlotItem(CONST_SLOT_LEFT)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function Player:onChangeZone(zone)
	if self:isPremium() then
		local event = staminaBonus.eventsPz[self:getId()]

		if configManager.getBoolean(configKeys.STAMINA_PZ) then
			if zone == ZONE_PROTECTION then
				local stamina = self:getStamina()
				if stamina < 2520 then
					if not event then
						local delay = configManager.getNumber(configKeys.STAMINA_ORANGE_DELAY)
						if stamina > 2340 and stamina <= 2520 then
							delay = configManager.getNumber(configKeys.STAMINA_GREEN_DELAY)
						end

						local message = string.format("In protection zone. Recharging %i stamina every %i minutes.", configManager.getNumber(configKeys.STAMINA_PZ_GAIN), delay)
						self:sendTextMessage(MESSAGE_FAILURE, message)
						staminaBonus.eventsPz[self:getId()] = addEvent(addStamina, delay * 60 * 1000, nil, self:getId(), delay * 60 * 1000)
					end
				end
			else
				if event then
					self:sendTextMessage(MESSAGE_FAILURE, "You are no longer refilling stamina, since you left a regeneration zone.")
					stopEvent(event)
					staminaBonus.eventsPz[self:getId()] = nil
				end
			end
			return not configManager.getBoolean(configKeys.STAMINA_PZ)
		end
	end
	return false
end

function Player:onInventoryUpdate(item, slot, equip) end
