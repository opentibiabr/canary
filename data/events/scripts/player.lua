CONTAINER_WEIGHT_CHECK = true -- true = enable / false = disable
CONTAINER_WEIGHT_MAX = 1000000 -- 1000000 = 10k = 10000.00 oz

local storeItemID = {
	-- registered item ids here are not tradable with players
	-- these items can be set to moveable at items.xml
	-- 500 charges exercise weapons
	32384, -- exercise sword
	32385, -- exercise axe
	32386, -- exercise club
	32387, -- exercise bow
	32388, -- exercise rod
	32389, -- exercise wand

	-- 50 charges exercise weapons
	32124, -- training sword
	32125, -- training axe
	32126, -- training club
	32127, -- training bow
	32128, -- training wand
	32129, -- training club

	-- magic gold and magic converter (activated/deactivated)
	32109, -- magic gold converter
	33299, -- magic gold converter
	26378, -- gold converter
	29020, -- gold converter

	-- foods
	35172, -- roasted wyvern wings
	35173, -- carrot pie
	35174, -- tropical marinated tiger
	35175, -- delicatessen salad
	35176, -- chilli con carniphila
	35177, -- svargrond salmon filet
	35178, -- carrion casserole
	35179, -- consecrated beef
	35180, -- overcooked noodles
}

-- Capacity imbuement store
local STORAGE_CAPACITY_IMBUEMENT = 42154

-- Players cannot throw items on teleports if set to true
local blockTeleportTrashing = true

local titles = {
	{storageID = 14960, title = " Scout"},
	{storageID = 14961, title = " Sentinel"},
	{storageID = 14962, title = " Steward"},
	{storageID = 14963, title = " Warden"},
	{storageID = 14964, title = " Squire"},
	{storageID = 14965, title = " Warrior"},
	{storageID = 14966, title = " Keeper"},
	{storageID = 14967, title = " Guardian"},
	{storageID = 14968, title = " Sage"},
	{storageID = 14969, title = " Tutor"},
	{storageID = 14970, title = " Senior Tutor"},
	{storageID = 14971, title = " King"},
}

local function getTitle(uid)
	local player = Player(uid)
	if not player then return false end

	for i = #titles, 1, -1 do
		if player:getStorageValue(titles[i].storageID) == 1 then
			return titles[i].title
		end
	end

	return false
end

function Player:onBrowseField(position)
	return true
end

local function getHours(seconds)
	return math.floor((seconds/60)/60)
end

local function getMinutes(seconds)
	return math.floor(seconds/60)
end

local function getSeconds(seconds)
	return seconds%60
end

local function getTime(seconds)
	local hours, minutes = getHours(seconds), getMinutes(seconds)
	if (minutes > 59) then
		minutes = minutes-hours*60
	end

	if (minutes < 10) then
		minutes = "0" ..minutes
	end

	return hours..":"..minutes.. "h"
end

local function getTimeinWords(secs)
	local hours, minutes, seconds = getHours(secs), getMinutes(secs), getSeconds(secs)
	if (minutes > 59) then
		minutes = minutes-hours*60
	end

	local timeStr = ''

	if hours > 0 then
		timeStr = timeStr .. ' hours '
	end

	timeStr = timeStr .. minutes .. ' minutes and '.. seconds .. ' seconds.'

	return timeStr
end

function Player:onLook(thing, position, distance)
	local description = "You see "
	if thing:isItem() then
		if thing.actionid == 5640 then
			description = description .. "a honeyflower patch."
		elseif thing.actionid == 5641 then
			description = description .. "a banana palm."
		elseif thing.itemid >= ITEM_HEALTH_CASK_START and thing.itemid <= ITEM_HEALTH_CASK_END
		or thing.itemid >= ITEM_MANA_CASK_START and thing.itemid <= ITEM_MANA_CASK_END
		or thing.itemid >= ITEM_SPIRIT_CASK_START and thing.itemid <= ITEM_SPIRIT_CASK_END
		or thing.itemid >= ITEM_KEG_START and thing.itemid <= ITEM_KEG_END then
			description = description .. thing:getDescription(distance)
			local charges = thing:getCharges()
			if charges then
				description = string.format("%s\nIt has %d refillings left.", description, charges)
			end
		else
			description = description .. thing:getDescription(distance)
		end

		local itemType = thing:getType()
		if (itemType and itemType:getImbuingSlots() > 0) then
			local imbuingSlots = "Imbuements: ("
			for slot = 0, itemType:getImbuingSlots() - 1 do
				if slot > 0 then
					imbuingSlots = string.format("%s, ", imbuingSlots)
				end
				local duration = thing:getImbuementDuration(slot)
				if duration > 0 then
					local imbue = thing:getImbuement(slot)
					imbuingSlots = string.format("%s%s %s %s",
						imbuingSlots, imbue:getBase().name, imbue:getName(), getTime(duration))
				else
					imbuingSlots = string.format("%sEmpty Slot", imbuingSlots)
				end
			end
			imbuingSlots = string.format("%s).", imbuingSlots)
			description = string.gsub(description, "It weighs", imbuingSlots.. "\nIt weighs")
		end
	else
		description = description .. thing:getDescription(distance)
		if thing:isMonster() then
			local master = thing:getMaster()
			if master and table.contains({'sorcerer familiar','knight familiar','druid familiar','paladin familiar'},
																						thing:getName():lower()) then
				description = description..' (Master: ' .. master:getName() .. '). \z
				It will disappear in ' .. getTimeinWords(master:getStorageValue(Storage.PetSummon) - os.time())
			end
		end
	end

	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
			
			local clientId = itemType:getClientId()
			if clientId then
				description = string.format("%s\nClient ID: %d", description, clientId)
			end
			
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:isPlayer() and thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		description = string.format(
		"%s\nPosition: %d, %d, %d",
		description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_LOOK, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if creature:isMonster() then
		local master = creature:getMaster()
		local summons = {'sorcerer familiar','knight familiar','druid familiar','paladin familiar'}
		if master and table.contains(summons, creature:getName():lower()) then
			description = description..' (Master: ' .. master:getName() .. '). \z
				It will disappear in ' .. getTimeinWords(master:getStorageValue(Storage.PetSummon) - os.time())
		end
	end
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:isPlayer() and creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
		"%s\nPosition: %d, %d, %d",
		description, position.x, position.y, position.z

		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_LOOK, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_LOOK, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

local config = {
	maxItemsPerSeconds = 1,
	exhaustTime = 2000,
}

if not pushDelay then
	pushDelay = { }
end

local function antiPush(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if toPosition.x == CONTAINER_POSITION then
		return true
	end

	local tile = Tile(toPosition)
	if not tile then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	local cid = self:getId()
	if not pushDelay[cid] then
		pushDelay[cid] = {items = 0, time = 0}
	end

	pushDelay[cid].items = pushDelay[cid].items + 1

	local currentTime = os.mtime()
	if pushDelay[cid].time == 0 then
		pushDelay[cid].time = currentTime
	elseif pushDelay[cid].time == currentTime then
		pushDelay[cid].items = pushDelay[cid].items + 1
	elseif currentTime > pushDelay[cid].time then
		pushDelay[cid].time = 0
		pushDelay[cid].items = 0
	end

	if pushDelay[cid].items > config.maxItemsPerSeconds then
		pushDelay[cid].time = currentTime + config.exhaustTime
	end

	if pushDelay[cid].time > currentTime then
		self:sendCancelMessage("You can't move that item so fast.")
		return false
	end

	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)

	-- No move items with actionID = 100
	if item:getActionId() == NOT_MOVEABLE_ACTION then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- No move if item count > 20 items
	local tile = Tile(toPosition)
	if tile and tile:getItemCount() > 20 then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- No move parcel very heavy
	if CONTAINER_WEIGHT_CHECK and ItemType(item:getId()):isContainer()
	and item:getWeight() > CONTAINER_WEIGHT_MAX then
		self:sendCancelMessage("Your cannot move this item too heavy.")
		return false
	end

	-- Cults of Tibia begin
	local frompos = Position(33023, 31904, 14) -- Checagem
	local topos = Position(33052, 31932, 15) -- Checagem
	if self:getPosition():isInRange(frompos, topos) and item:getId() == 26397 then
		local tileBoss = Tile(toPosition)
		if tileBoss and tileBoss:getTopCreature() and tileBoss:getTopCreature():isMonster() then
			if tileBoss:getTopCreature():getName():lower() == 'the remorseless corruptor' then
				tileBoss:getTopCreature():addHealth(-17000)
				item:remove(1)
				if tileBoss:getTopCreature():getHealth() <= 300 then
					tileBoss:getTopCreature():remove()
					local monster = Game.createMonster('the corruptor of souls', toPosition)
					monster:registerEvent('CheckTile')
					if Game.getStorageValue('healthSoul') > 0 then
						monster:addHealth(-(monster:getHealth() - Game.getStorageValue('healthSoul')))
					end
					Game.setStorageValue('CheckTile', os.time()+30)
				end
			elseif tileBoss:getTopCreature():getName():lower() == 'the corruptor of souls' then
				Game.setStorageValue('CheckTile', os.time()+30)
				item:remove(1)
			end
		end
	end
	-- Cults of Tibia end

	-- SSA exhaust
	local exhaust = { }
	if toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_NECKLACE
	and item:getId() == ITEM_STONE_SKIN_AMULET then
		local pid = self:getId()
		if exhaust[pid] then
			self:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
			return false
		else
			exhaust[pid] = true
			addEvent(function() exhaust[pid] = false end, 2000, pid)
			return true
		end
	end

	-- Store Inbox
	local containerIdFrom = fromPosition.y - 64
	local containerFrom = self:getContainerById(containerIdFrom)
	if (containerFrom) then
		if (containerFrom:getId() == ITEM_STORE_INBOX
		and toPosition.y >= 1 and toPosition.y <= 11 and toPosition.y ~= 3) then
			self:sendCancelMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM)
			return false
		end
	end

	local containerTo = self:getContainerById(toPosition.y-64)
	if (containerTo) then
		if (containerTo:getId() == ITEM_STORE_INBOX) or (containerTo:getParent():isContainer() and containerTo:getParent():getId() == ITEM_STORE_INBOX and containerTo:getId() ~= ITEM_GOLD_POUCH) then
			self:sendCancelMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM)
			return false
		end
		-- Gold Pouch
		if (containerTo:getId() == ITEM_GOLD_POUCH) then
			if (not (item:getId() == ITEM_CRYSTAL_COIN or item:getId() == ITEM_PLATINUM_COIN
			or item:getId() == ITEM_GOLD_COIN)) then
				self:sendCancelMessage("You can move only money to this container.")
				return false
			end
		end
	end


	-- Bath tube
	local toTile = Tile(toCylinder:getPosition())
	local topDownItem = toTile:getTopDownItem()
	if topDownItem and table.contains({ BATHTUB_EMPTY, BATHTUB_FILLED }, topDownItem:getId()) then
		return false
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
			if moveItem and itemType:getWeaponType() == WEAPON_DISTANCE and ItemType(moveItem:getId()):getWeaponType() == WEAPON_QUIVER then
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
			else
				return moveItem:moveTo(parent)
			end
		end
	end

	-- Reward System
	if toPosition.x == CONTAINER_POSITION then
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
		for index, value in ipairs(tileCorpse:getItems() or { }) do
			if value:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 and value:getName() == container:getName() then
				self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
				return false
			end
		end
	end

	-- Do not let the player move the boss corpse.
	if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 then
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

	-- Players cannot throw items on teleports
	if blockTeleportTrashing and toPosition.x ~= CONTAINER_POSITION then
		local thing = Tile(toPosition):getItemByType(ITEM_TYPE_TELEPORT)
		if thing then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			self:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	if tile and tile:getItemById(370) then -- Trapdoor
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
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	if creature:isPlayer() and creature:getStorageValue(Storage.isTraining) == 1 and self:getGroup():hasFlag(PlayerFlag_CanPushAllCreatures) == false then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	return false
	end
	return true
end

local function hasPendingReport(name, targetName, reportType)
	local f = io.open(string.format("data/reports/players/%s-%s-%d.txt", name, targetName, reportType), "r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	local name = self:getName()
	if hasPendingReport(name, targetName, reportType) then
		self:sendTextMessage(MESSAGE_REPORT, "Your report is being processed.")
		return
	end

	local file = io.open(string.format("data/reports/players/%s-%s-%d.txt", name, targetName, reportType), "a")
	if not file then
		self:sendTextMessage(MESSAGE_REPORT,
			"There was an error when processing your report, please contact a gamemaster.")
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
	self:sendTextMessage(MESSAGE_REPORT, string.format("Thank you for reporting %s. Your report \z
	will be processed by %s team as soon as possible.", targetName, configManager.getString(configKeys.SERVER_NAME)))
	return
end

function Player:onReportBug(message, position, category)
	if self:getAccountType() == ACCOUNT_TYPE_NORMAL then
		return false
	end

	local name = self:getName()
	local file = io.open("data/reports/bugs/" .. name .. " report.txt", "a")

	if not file then
		self:sendTextMessage(MESSAGE_REPORT,
			"There was an error when processing your report, please contact a gamemaster.")
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

	self:sendTextMessage(MESSAGE_REPORT,
		"Your report has been sent to " .. configManager.getString(configKeys.SERVER_NAME) .. ".")
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
	-- No trade items with actionID = 100
	if item:getActionId() == NOT_MOVEABLE_ACTION then
		return false
	end

	if isInArray(storeItemID,item.itemid) then
		return false
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	self:closeImbuementWindow()
	target:closeImbuementWindow()
	return true
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

local function useStaminaXp(player)
	local staminaMinutes = player:getExpBoostStamina() / 60
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseXpStamina[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseXpStamina[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseXpStamina[playerId] = currentTime + 60
	end
	player:setExpBoostStamina(staminaMinutes * 60)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Experience Stage Multiplier
	local expStage = getRateFromTable(experienceStages, self:getLevel(), configManager.getNumber(configKeys.RATE_EXP))
	exp = exp * expStage
	baseExp = rawExp * expStage
	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		displayRate = expStage
	else
		displayRate = 1
	end

	-- Prey Bonus
	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		if (self:getPreyCurrentMonster(slot) == source:getName()
		and self:getPreyBonusType(slot) == CONST_BONUS_XP_BONUS) then
			exp = exp + math.floor(exp * (self:getPreyBonusValue(slot) / 100))
			break
		end
		if (self:getPreyTimeLeft(slot) / 60) > 0 then
			preyTimeLeft(self, slot) -- slot consumption, outside of the mosnter check
		end
	end

	-- Store Bonus
	useStaminaXp(self) -- Use store boost stamina

	local Boost = self:getExpBoostStamina()
	local stillHasBoost = Boost > 0
	local storeXpBoostAmount = stillHasBoost and self:getStoreXpBoost() or 0

	self:setStoreXpBoost(storeXpBoostAmount)

	if (storeXpBoostAmount > 0) then
		exp = exp + (baseExp * (storeXpBoostAmount/100)) -- Exp Boost
	end

	-- Stamina Bonus
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)
		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2340 and self:isPremium() then
			exp = exp * 1.5
			self:setStaminaXpBoost(150)
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5 --TODO destroy loot of people with 840- stamina
			self:setStaminaXpBoost(50)
		else
			self:setStaminaXpBoost(100)
		end
	end
			
	-- Boosted creature
	if source:getName():lower() == (Game.getBoostedCreature()):lower() then
		exp = exp * 2
	end

	-- Event scheduler
	if SCHEDULE_EXP_RATE ~= 100 then
		exp = (exp * SCHEDULE_EXP_RATE)/100
	end
	self:setBaseXpGain(displayRate * 100)
	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
	-- Dawnport skills limit
	if isSkillGrowthLimited(self, skill) then
		return 0
	end
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	-- Event scheduler skill rate
	if SCHEDULE_SKILL_RATE ~= 100 then
		tries = (tries * SCHEDULE_SKILL_RATE)/100
	end

	local skillRate = configManager.getNumber(configKeys.RATE_SKILL)
	local magicRate = configManager.getNumber(configKeys.RATE_MAGIC)

	if(skill == SKILL_MAGLEVEL) then -- Magic getLevel
		return tries * getRateFromTable(magicLevelStages, self:getMagicLevel(), magicRate)
	end

	return tries * getRateFromTable(skillsStages, self:getEffectiveSkillLevel(skill), skillRate)
end

function Player:onRemoveCount(item)
	self:sendWaste(item:getId())
end

function Player:onRequestQuestLog()
	self:sendQuestLog()
end

function Player:onRequestQuestLine(questId)
	self:sendQuestLine(questId)
end

function Player:onStorageUpdate(key, value, oldValue, currentFrameTime)
	self:updateStorage(key, value, oldValue, currentFrameTime)
end

function Player:canBeAppliedImbuement(imbuement, item)
	local categories = {}
	local slots = ItemType(item:getId()):getImbuingSlots()
	if slots > 0 then
		for slot = 0, slots - 1 do
			local duration = item:getImbuementDuration(slot)
			if duration > 0 then
				local imbue = item:getImbuement(slot)
				local catid = imbue:getCategory().id
				table.insert(categories, catid)
			end
		end
	end

	if isInArray(categories, imbuement:getCategory().id) then
		return false
	end

	if imbuement:isPremium() and self:getPremiumDays() < 1 then
		return false
	end

	if self:getStorageValue(Storage.ForgottenKnowledge.Tomes) > 0 then
		imbuable = true
	else
		return false
	end

	if not self:canImbueItem(imbuement, item) then
		return false
	end

	return true
end

function Player:onApplyImbuement(imbuement, item, slot, protectionCharm)
	for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
    	local slotItem = self:getSlotItem(slot)
   		if slotItem and slotItem == item then
			self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED, "You can't imbue a equipped item.")
			self:closeImbuementWindow()
            return true
   		end
	end

	for _, pid in pairs(imbuement:getItems()) do
		if (self:getItemCount(pid.itemid) + self:getStashItemCount(pid.itemid)) < pid.count then
			self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED, "You don't have all necessary items.")
			return false
		end
	end

	if item:getImbuementDuration(slot) > 0 then
		self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ERROR, "An error ocurred, please reopen imbuement window.")
		return false
	end
	local base = imbuement:getBase()
	local price = base.price + (protectionCharm and base.protection or 0)

	local chance = protectionCharm and 100 or base.percent
	if math.random(100) > chance then -- failed attempt
		self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED, "Oh no!\n\nThe imbuement has failed. You have lost the astral sources and gold you needed for the imbuement.\n\nNext time use a protection charm to better your chances.")
		-- Removing items
		for _, pid in pairs(imbuement:getItems()) do
			self:removeItem(pid.itemid, pid.count)
		end
		-- Removing money
		self:removeMoneyNpc(price)
		-- Refreshing shrine window
		local nitem = Item(item.uid)
		self:sendImbuementPanel(nitem)
		return false
	end

	-- Removing items
	for _, pid in pairs(imbuement:getItems()) do
		local invertoryItemCount = self:getItemCount(pid.itemid)
		if invertoryItemCount >= pid.count then
			if not(self:removeItem(pid.itemid, pid.count)) then
				self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ERROR, "An error ocurred, please reopen imbuement window.")
				return false
			end
		else
			local mathItemCount = pid.count
			if invertoryItemCount > 0 and self:removeItem(pid.itemid, invertoryItemCount) then
				mathItemCount = mathItemCount - invertoryItemCount
			end

			if not(self:removeStashItem(pid.itemid, mathItemCount)) then
				self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ERROR, "An error ocurred, please reopen imbuement window.")
				return false
			end
		end
	end

	if not self:removeMoneyNpc(price) then
		self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED, "You don't have enough money " ..price.. " gps.")
		return false
	end

	if not item:addImbuement(slot, imbuement:getId()) then
		self:sendImbuementResult(MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED, "Item failed to apply imbuement.")
		return false
	end

	-- Update item
	local nitem = Item(item.uid)
	self:sendImbuementPanel(nitem)
	return true
end

function Player:clearImbuement(item, slot)
	local slots = ItemType(item:getId()):getImbuingSlots()
	if slots < slot then
		self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_ERROR, "Sorry, not possible.")
		return false
	end

	if item:getTopParent() ~= self or item:getParent() == self then
		self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_ERROR,
			"An error occurred while applying the clearing charm to the item.")
		return false
	end

	-- slot is not used
	local info = item:getImbuementDuration(slot)
	if info == 0 then
		self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_ERROR,
			"An error occurred while applying the clearing charm to the item.")
		return false
	end

	local imbuement = item:getImbuement(slot)
	if not self:removeMoneyNpc(imbuement:getBase().removecust) then
		self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_ERROR,
			"You don't have enough money " ..imbuement:getBase().removecust.. " gps.")
		return false
	end

	if not item:cleanImbuement(slot) then
		self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_ERROR,
			"An error occurred while applying the clearing charm to the item.")
		return false
	end

	-- Update item
	local nitem = Item(item.uid)
	self:sendImbuementResult(MESSAGEDIALOG_CLEARING_CHARM_SUCCESS,
		"Congratulations! You have successfully applied the clearing charm to your item.");
	self:sendImbuementPanel(nitem)

	return true
end

function Player:onCombat(target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not item or not target then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	
	if ItemType(item:getId()):getWeaponType() == WEAPON_AMMO then
		if isInArray({ITEM_OLD_DIAMOND_ARROW, ITEM_DIAMOND_ARROW}, item:getId()) then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		else
			item = self:getSlotItem(CONST_SLOT_LEFT)
		end
	end

	local slots = ItemType(item:getId()):getImbuingSlots()
	if slots > 0 then
		for i = 0, slots - 1 do
			local imbuement = item:getImbuement(i)
			if imbuement then
				local percent = imbuement:getElementDamage()
				local totalDmg = primaryDamage --store it for damage adjustment
				if percent and percent > 0 then
					if primaryDamage ~= 0 then
						local factor = percent / 100
						secondaryType = imbuement:getCombatType()
						primaryDamage = totalDmg * (1 - factor)
						secondaryDamage = totalDmg * (factor)
					end
				end
			end
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
