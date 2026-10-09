DailyRewardSystem = {
	Developer = "Westwol, Marcosvf132",
	Version = "1.3",
	lastUpdate = "12/10/2020 - 20:30",
	ToDo = "Move this system to CPP",
}

local ServerPackets = {
	ShowDialog = 0xED, -- universal
	DailyRewardCollectionState = 0xDE, -- undone
	OpenRewardWall = 0xE2, -- Done
	CloseRewardWall = 0xE3, -- is it necessary?
	DailyRewardBasic = 0xE4, -- Done
	DailyRewardHistory = 0xE5, -- Done
	-- RestingAreaState = 0xA9 -- Moved to cpp
}

local ClientPackets = {
	OpenRewardWall = 0xD8,
	OpenRewardHistory = 0xD9,
	SelectReward = 0xDA,
	CollectionResource = 0x14,
	JokerResource = 0x15,
}

--[[-- Constants
Please do not edit any of the next constants:
	]]

--[[ Overall ]]
--
local DAILY_REWARD_COUNT = 7
local REWARD_FROM_SHRINE = 0
local REWARD_FROM_PANEL = 1

--[[ Bonuses ]]
--
local DAILY_REWARD_NONE = 1
local DAILY_REWARD_HP_REGENERATION = 2
local DAILY_REWARD_MP_REGENERATION = 3
local DAILY_REWARD_STAMINA_REGENERATION = 4
local DAILY_REWARD_DOUBLE_HP_REGENERATION = 5
local DAILY_REWARD_DOUBLE_MP_REGENERATION = 6
local DAILY_REWARD_SOUL_REGENERATION = 7

--[[ Reward Types ]]
--

-- Server Types
local DAILY_REWARD_TYPE_ITEM = 1
local DAILY_REWARD_TYPE_STORAGE = 2
local DAILY_REWARD_TYPE_PREY_REROLL = 3
local DAILY_REWARD_TYPE_XP_BOOST = 4

-- Client Types
local DAILY_REWARD_SYSTEM_SKIP = 1
local DAILY_REWARD_SYSTEM_TYPE_ONE = 1
local DAILY_REWARD_SYSTEM_TYPE_TWO = 2
local DAILY_REWARD_SYSTEM_TYPE_OTHER = 1
local DAILY_REWARD_SYSTEM_TYPE_PREY_REROLL = 2
local DAILY_REWARD_SYSTEM_TYPE_XP_BOOST = 3

--[[ Account Status ]]
--
local DAILY_REWARD_STATUS_FREE = 0
local DAILY_REWARD_STATUS_PREMIUM = 1

local DailyRewardItems = {
	[0] = { 266, 268 }, -- God/no vocation character
	[VOCATION.BASE_ID.PALADIN] = { 266, 236, 268, 237, 7642, 23374, 3203, 3161, 3178, 3153, 3197, 3149, 3164, 3200, 3192, 3188, 3190, 3189, 3191, 3158, 3152, 3180, 3173, 3176, 3195, 3175, 3155, 3202 },
	[VOCATION.BASE_ID.DRUID] = { 266, 268, 237, 238, 23373, 3203, 3161, 3178, 3153, 3197, 3149, 3164, 3200, 3192, 3188, 3190, 3189, 3156, 3191, 3158, 3152, 3180, 3173, 3176, 3195, 3175, 3155, 3202 },
	[VOCATION.BASE_ID.SORCERER] = { 266, 268, 237, 238, 23373, 3203, 3161, 3178, 3153, 3197, 3149, 3164, 3200, 3192, 3188, 3190, 3189, 3191, 3158, 3152, 3180, 3173, 3176, 3195, 3175, 3155, 3202 },
	[VOCATION.BASE_ID.KNIGHT] = { 266, 236, 239, 7643, 23375, 268, 3203, 3161, 3178, 3153, 3197, 3149, 3164, 3200, 3192, 3188, 3190, 3189, 3191, 3158, 3152, 3180, 3173, 3176, 3195, 3175, 3155, 3202 },
	[VOCATION.BASE_ID.MONK] = { 266, 236, 268, 237, 7642, 23374, 3203, 3161, 3178, 3153, 3197, 3149, 3164, 3200, 3192, 3188, 3190, 3189, 3191, 3158, 3152, 3180, 3173, 3176, 3195, 3175, 3155, 3202 },
}

DailyReward = {
	testMode = false,
	serverTimeThreshold = (25 * 60 * 60), -- Counting down 24hours from last server save

	storages = {
		-- Player
		currentDayStreak = 14897,
		nextRewardTime = 14899,
		collectionTokens = 14901,
		staminaBonus = 14902,
		jokerTokens = 14903,
		-- Global
		lastServerSave = 14110,
		avoidDouble = 13412,
		notifyReset = 13413,
		avoidDoubleJoker = 13414,
	},

	strikeBonuses = {
		-- day
		[1] = { text = "No bonus for first day" },
		[2] = { text = "Hit Point Regeneration" },
		[3] = { text = "Mana Regeneration" },
		[4] = { text = "Stamina Regeneration" },
		[5] = { text = "Double Hit Point Regeneration" },
		[6] = { text = "Double Mana Regeneration" },
		[7] = { text = "Soul Points Regeneration" },
	},

	rewards = {
		-- day
		[1] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 5,
			premiumAccount = 10,
		},
		[2] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 5,
			premiumAccount = 10,
		},
		[3] = {
			type = DAILY_REWARD_TYPE_PREY_REROLL,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 1,
			premiumAccount = 2,
		},
		[4] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 10,
			premiumAccount = 20,
		},
		[5] = {
			type = DAILY_REWARD_TYPE_PREY_REROLL,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 1,
			premiumAccount = 2,
		},
		[6] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			items = { 28540, 28541, 28542, 28543, 28544, 28545, 44064, 50292 },
			freeAccount = 1,
			premiumAccount = 2,
			itemCharges = 50,
		},
		[7] = {
			type = DAILY_REWARD_TYPE_XP_BOOST,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 10,
			premiumAccount = 30,
		},
		-- Storage reward template
		--[[[5] = {
			type = DAILY_REWARD_TYPE_STORAGE,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeCount = 1,
			premiumCount = 2,
			freeAccount = {
				things = {
					[1] = {
						name = "task boost",
						id = 1, -- this number can't be repeated
						quantity = 1,
						storages = {
							{storageId = 23454, value = 1},
							{storageId = 45141, value = 2},
							{storageId = 45141, value = 3}
						}
					}
				}
			},
			premiumAccount = {
				things = {
					[1] = {
						name = "task boostss",
						id = 2, -- this number can't be repeated
						quantity = 1,
						storages = {
							{storageId = 23454, value = 1}
						}
					},
					[2] = {
						name = "another task boost",
						id = 3, -- this number can't be repeated
						quantity = 2,
						storages = {
							{storageId = 23454, value = 1},
							{storageId = 45141, value = 2},
							{storageId = 45141, value = 3}
						}
					}
				}
			}
		},]]
	},
}

function onRecvbyte(player, msg, byte)
	if byte == ClientPackets.OpenRewardWall then
		DailyReward.loadDailyReward(player:getId(), REWARD_FROM_PANEL)
	elseif byte == ClientPackets.OpenRewardHistory then
		player:sendRewardHistory()
	elseif byte == ClientPackets.SelectReward then
		player:selectDailyReward(msg)
	end
end

-- Core functions
DailyReward.insertHistory = function(playerId, dayStreak, description)
	return db.query(string.format("INSERT INTO `daily_reward_history`(`player_id`, `daystreak`, `timestamp`, `description`) VALUES (%s, %s, %s, %s)", playerId, dayStreak, os.time(), db.escapeString(description)))
end

DailyReward.retrieveHistoryEntries = function(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local entries = {}
	local resultId = db.storeQuery("SELECT * FROM `daily_reward_history` WHERE `player_id` = " .. player:getGuid() .. " ORDER BY `timestamp` DESC LIMIT 15;")
	if resultId then
		repeat
			local entry = {
				description = Result.getString(resultId, "description"),
				timestamp = Result.getNumber(resultId, "timestamp"),
				daystreak = Result.getNumber(resultId, "daystreak"),
			}
			table.insert(entries, entry)
		until not Result.next(resultId)
		Result.free(resultId)
	end
	return entries
end

DailyReward.loadDailyReward = function(playerId, target)
	local player = Player(playerId)
	if not player then
		return false
	end

	if target == REWARD_FROM_SHRINE then -- if you receive 0 (shrine) send 1
		target = 1
	else
		target = 0 -- if you receive 1 (panel) send 0
	end

	player:sendCollectionResource(ClientPackets.JokerResource, player:getJokerTokens())
	player:sendCollectionResource(ClientPackets.CollectionResource, player:getCollectionTokens())
	player:sendDailyReward()
	player:sendOpenRewardWall(target)
	player:sendDailyRewardCollectionState(DailyReward.isRewardTaken(player:getId()) and DAILY_REWARD_COLLECTED or DAILY_REWARD_NOTCOLLECTED)
	return true
end

DailyReward.pickedReward = function(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	-- Reset day streak to 0 when reaches last reward
	if player:getDayStreak() ~= 6 then
		player:setDayStreak(player:getDayStreak() + 1)
	else
		player:setDayStreak(0)
	end

	player:setStreakLevel(player:getStreakLevel() + 1)
	player:setStorageValue(DailyReward.storages.avoidDouble, GetDailyRewardLastServerSave())
	player:setDailyRewardClaimedServerSave(GetDailyRewardServerSaveCount())
	player:setDailyReward(DAILY_REWARD_COLLECTED)
	player:setNextRewardTime(GetDailyRewardLastServerSave() + DailyReward.serverTimeThreshold)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
	return true
end

DailyReward.isShrine = function(target)
	if target ~= 0 then
		return false
	end
	return true
end

DailyReward.isRewardTaken = function(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end
	local playerStorage = player:getStorageValue(DailyReward.storages.avoidDouble)
	if playerStorage == GetDailyRewardLastServerSave() then
		return true
	end
	return false
end

-- Returns how many claim windows (periods between two server saves) passed without a claim.
DailyReward.getMissedDays = function(player, lastServerSave)
	local claimedServerSave = player:getDailyRewardClaimedServerSave()
	if claimedServerSave then
		return math.max(0, GetDailyRewardServerSaveCount() - claimedServerSave - 1)
	end

	-- Legacy players (claimed before the server save counter existed): rounding tolerates late or irregular server saves
	local nextRewardTime = player:getNextRewardTime()
	if nextRewardTime >= lastServerSave then
		return 0
	end
	return math.floor((lastServerSave - nextRewardTime) / DailyReward.serverTimeThreshold + 0.5)
end

-- The current window is the one the player must claim in to keep the streak.
DailyReward.settleMissedDays = function(player, lastServerSave)
	player:setDailyRewardClaimedServerSave(GetDailyRewardServerSaveCount() - 1)
	player:setNextRewardTime(lastServerSave)
end

DailyReward.init = function(playerId)
	local player = Player(playerId)

	if not player then
		return false
	end

	if player:getJokerTokens() < 3 and tonumber(os.date("%m")) ~= player:getStorageValue(DailyReward.storages.avoidDoubleJoker) then
		player:setStorageValue(DailyReward.storages.avoidDoubleJoker, tonumber(os.date("%m")))
		player:setJokerTokens(player:getJokerTokens() + 1)
	end

	local lastServerSave = GetDailyRewardLastServerSave()
	if not player:getDailyRewardClaimedServerSave() and player:getNextRewardTime() == 0 then
		-- Never claimed: start tracking from the current window so a configured start streak is kept until it is missed
		DailyReward.settleMissedDays(player, lastServerSave)
	end

	local missedDays = DailyReward.getMissedDays(player, lastServerSave)
	if missedDays > 0 and player:getStorageValue(DailyReward.storages.notifyReset) ~= lastServerSave then
		player:setStorageValue(DailyReward.storages.notifyReset, lastServerSave)
		if player:getJokerTokens() >= missedDays then
			player:setJokerTokens(player:getJokerTokens() - missedDays)
			player:sendTextMessage(MESSAGE_LOGIN, "You lost " .. missedDays .. " joker tokens to prevent losing your streak.")
		else
			player:setStreakLevel(0)
			if player:getLastLoginSaved() > 0 then -- message wont appear at first character login
				player:setJokerTokens(0)
				player:sendTextMessage(MESSAGE_LOGIN, "You just lost your daily reward streak.")
			end
		end
		DailyReward.settleMissedDays(player, lastServerSave)
	end

	-- Daily reward golden icon
	if DailyReward.isRewardTaken(player:getId()) then
		player:sendDailyRewardCollectionState(DAILY_REWARD_COLLECTED)
		player:setDailyReward(DAILY_REWARD_COLLECTED)
	else
		player:sendDailyRewardCollectionState(DAILY_REWARD_NOTCOLLECTED)
		player:setDailyReward(DAILY_REWARD_NOTCOLLECTED)
	end
	player:loadDailyRewardBonuses()
end

DailyReward.processReward = function(playerId, target)
	DailyReward.pickedReward(playerId)
	DailyReward.loadDailyReward(playerId, target)
	local player = Player(playerId)
	if player then
		player:loadDailyRewardBonuses()
	end
	return true
end

function Player.sendOpenRewardWall(self, shrine)
	if self:getClient().version < 1200 then
		return true
	end

	local msg = NetworkMessage()
	msg:addByte(ServerPackets.OpenRewardWall) -- initial packet
	msg:addByte(shrine) -- isPlayer taking bonus from reward shrine (1) - taking it from a instant bonus reward (0)
	if DailyReward.testMode or not (DailyReward.isRewardTaken(self:getId())) then
		msg:addU32(0)
	else
		msg:addU32(GetDailyRewardLastServerSave() + DailyReward.serverTimeThreshold)
	end
	msg:addByte(self:getDayStreak()) -- current reward? day = 0, day 1, ... this should be resetted to 0 every week imo
	if DailyReward.isRewardTaken(self:getId()) then -- state (player already took reward? but just make sure noone wpe)
		msg:addByte(1)
		msg:addString("Sorry, you have already taken your daily reward or you are unable to collect it.", "Player.sendOpenRewardWall - Sorry, you have already taken your daily reward or you are unable to collect it.") -- Unknown message
		if self:getJokerTokens() > 0 then
			msg:addByte(1)
			msg:addU16(self:getJokerTokens())
		else
			msg:addByte(0)
		end
	else
		msg:addByte(0)
		msg:addByte(2)
		msg:addU32(GetDailyRewardLastServerSave() + DailyReward.serverTimeThreshold) --timeLeft to pickUp reward without loosing streak
		msg:addU16(self:getJokerTokens())
	end
	msg:addU16(self:getStreakLevel()) -- day strike
	msg:sendToPlayer(self)
end

function Player.sendCollectionResource(self, byte, value)
	if self:getClient().version < 1200 then
		return true
	end

	-- TODO: Migrate to protocolgame.cpp
	local msg = NetworkMessage()
	msg:addByte(0xEE) -- resource byte
	msg:addByte(byte)
	msg:addU64(value)
	msg:sendToPlayer(self)
end

function Player.selectDailyReward(self, msg)
	local playerId = self:getId()

	if DailyReward.isRewardTaken(playerId) and not DailyReward.testMode then
		self:sendError("You have already collected your daily reward.")
		return false
	end

	local target = msg:getByte() -- 0 -> shrine / 1 -> tibia panel
	local usesToken = not DailyReward.isShrine(target)
	if usesToken and self:getCollectionTokens() < 1 then
		self:sendError("You do not have enough collection tokens to proceed.")
		return false
	end

	local dailyTable = DailyReward.rewards[self:getDayStreak() + 1]
	if not dailyTable then
		self:sendError("Something went wrong and we cannot process this request.")
		return false
	end

	local rewardCount = dailyTable.freeAccount
	if (configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and self:isVip()) or self:isPremium() then
		rewardCount = dailyTable.premiumAccount
	end

	local dailyRewardMessage = false

	-- Items as reward
	if dailyTable.type == DAILY_REWARD_TYPE_ITEM then
		local items = {}
		local possibleItems = DailyRewardItems[self:getVocation():getBaseId()] or DailyRewardItems[0]
		if dailyTable.items then
			possibleItems = dailyTable.items
		end

		-- Creating items table
		local allowedItems = {}
		for _, possibleItemId in ipairs(possibleItems) do
			allowedItems[possibleItemId] = true
		end

		-- Only entries with a positive count are picks; duplicates are merged
		local columnsPicked = msg:getByte()
		local pickedIndex = {}
		local totalCounter = 0
		for _ = 1, columnsPicked do
			local itemId = msg:getU16()
			local count = msg:getByte()
			if count > 0 then
				if not allowedItems[itemId] then
					logger.warn("Player {} tried to pick invalid daily reward item {}", self:getName(), itemId)
					self:sendError("Invalid reward selection.")
					return false
				end
				local entry = pickedIndex[itemId]
				if not entry then
					entry = { itemId = itemId, count = 0 }
					pickedIndex[itemId] = entry
					items[#items + 1] = entry
				end
				entry.count = entry.count + count
				totalCounter = totalCounter + count
			end
		end

		if totalCounter == 0 then
			self:sendError("You must select at least one reward item.")
			return false
		end
		if totalCounter > rewardCount then
			logger.warn("Player {} tried to pick {} daily reward items, limit is {}", self:getName(), totalCounter, rewardCount)
			self:sendError(string.format("You can select at most %d reward items.", rewardCount))
			return false
		end

		local inbox = self:getStoreInbox()
		if not inbox then
			self:sendError("You do not have enough space in your store inbox.")
			return false
		end

		local requiredSlots = 0
		if dailyTable.itemCharges then
			requiredSlots = totalCounter
		else
			for _, v in ipairs(items) do
				local itemType = ItemType(v.itemId)
				if itemType:isStackable() then
					requiredSlots = requiredSlots + math.ceil(v.count / itemType:getStackSize())
				else
					requiredSlots = requiredSlots + v.count
				end
			end
		end
		if #inbox:getItems() + requiredSlots > inbox:getMaxCapacity() then
			self:sendError("You do not have enough space in your store inbox.")
			return false
		end

		local maxInboxItems = configManager.getNumber(configKeys.MAX_INBOX_ITEMS)
		if maxInboxItems > 0 and inbox:getItemHoldingCount() + requiredSlots > maxInboxItems then
			self:sendError("You do not have enough space in your store inbox.")
			return false
		end

		local descriptionParts = {}
		local batchUpdate = BatchUpdate(self)
		batchUpdate:add(inbox)
		local originalItems = {}
		for _, item in ipairs(inbox:getItems()) do
			originalItems[#originalItems + 1] = { item = item, count = item:getCount() }
		end

		local deliveryFailed = false
		local failedItemId
		local function addRewardItem(itemId, count)
			local inboxItem = inbox:addItem(itemId, count)
			if not inboxItem then
				deliveryFailed = true
				failedItemId = itemId
				return
			end

			inboxItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
		end

		for _, v in ipairs(items) do
			if dailyTable.itemCharges then
				-- Charged items do not stack: one item per picked unit, each with the configured charges
				for _ = 1, v.count do
					addRewardItem(v.itemId, dailyTable.itemCharges)
					if deliveryFailed then
						break
					end
				end
			else
				local itemType = ItemType(v.itemId)
				if itemType:isStackable() then
					local stackSize = itemType:getStackSize()
					for count = 1, v.count, stackSize do
						addRewardItem(v.itemId, math.min(stackSize, v.count - count + 1))
						if deliveryFailed then
							break
						end
					end
				else
					for _ = 1, v.count do
						-- Zero preserves the item's default charges instead of treating the quantity as charges.
						addRewardItem(v.itemId, 0)
						if deliveryFailed then
							break
						end
					end
				end
			end
			if deliveryFailed then
				break
			end
			descriptionParts[#descriptionParts + 1] = v.count .. "x " .. ItemType(v.itemId):getName()
		end

		if deliveryFailed then
			for _, item in ipairs(inbox:getItems()) do
				local originalCount
				for _, original in ipairs(originalItems) do
					if item == original.item then
						originalCount = original.count
						break
					end
				end

				local removeCount
				if originalCount then
					if ItemType(item:getId()):isStackable() then
						removeCount = item:getCount() - originalCount
					end
				else
					removeCount = -1
				end

				if removeCount and (removeCount == -1 or removeCount > 0) and not item:remove(removeCount) then
					logger.error("Failed to roll back daily reward item {} for player {}", item:getId(), self:getName())
				end
			end
			batchUpdate:delete()
			logger.warn("Could not deliver daily reward item {} to player {}", failedItemId, self:getName())
			self:sendError("Something went wrong and we could not deliver your daily reward.")
			return false
		end

		batchUpdate:delete()
		dailyRewardMessage = "Picked items: " .. table.concat(descriptionParts, ", ") .. "."
	elseif dailyTable.type == DAILY_REWARD_TYPE_XP_BOOST then
		local rewardCountReviewed = rewardCount
		local xpBoostLeftMinutes = self:kv():get("daily-reward-xp-boost") or 0
		if xpBoostLeftMinutes > 0 then
			rewardCountReviewed = rewardCountReviewed - xpBoostLeftMinutes
		end

		self:setXpBoostTime(self:getXpBoostTime() + (rewardCountReviewed * 60))
		self:kv():set("daily-reward-xp-boost", rewardCount)
		self:setXpBoostPercent(50)
		dailyRewardMessage = "Picked reward: XP Bonus for " .. rewardCount .. " minutes."
	elseif dailyTable.type == DAILY_REWARD_TYPE_PREY_REROLL then
		self:addPreyCards(rewardCount)
		dailyRewardMessage = "Picked reward: " .. rewardCount .. "x Prey bonus reroll(s)."
	end

	if dailyRewardMessage and usesToken then
		self:setCollectionTokens(self:getCollectionTokens() - 1)
	end

	if dailyRewardMessage then
		-- Registering history
		DailyReward.insertHistory(self:getGuid(), self:getDayStreak(), "Claimed reward no. \z
			" .. self:getDayStreak() + 1 .. ". " .. dailyRewardMessage)
		DailyReward.processReward(playerId, target)
	end

	return true
end

function Player.sendError(self, error)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.ShowDialog)
	msg:addByte(0x14)
	msg:addString(error, "Player.sendError - error")
	msg:sendToPlayer(self)
end

function Player.sendDailyRewardCollectionState(self, state)
	if self:getClient().version < 1200 then
		return true
	end

	local msg = NetworkMessage()
	msg:addByte(ServerPackets.DailyRewardCollectionState)
	msg:addByte(state)
	msg:sendToPlayer(self)
end

function Player.sendRewardHistory(self)
	if self:getClient().version < 1200 then
		return true
	end

	local msg = NetworkMessage()
	msg:addByte(ServerPackets.DailyRewardHistory)

	local entries = DailyReward.retrieveHistoryEntries(self:getId())
	if #entries == 0 then
		self:sendError("You don't have any entries yet.")
		return false
	end

	msg:addByte(#entries)
	for k, entry in ipairs(entries) do
		msg:addU32(entry.timestamp)
		msg:addByte(0) -- (self:isPremium() and 0 or 0)
		msg:addString(entry.description, "Player.sendRewardHistory - entry.description")
		msg:addU16(entry.daystreak + 1)
	end
	msg:sendToPlayer(self)
end

function Player.readDailyReward(self, msg, currentDay, state)
	local dailyTable = DailyReward.rewards[currentDay]
	local type, systemType = dailyTable.type, dailyTable.systemType
	local rewards = nil
	local itemsToPick = dailyTable.freeAccount
	if state == DAILY_REWARD_STATUS_PREMIUM then
		itemsToPick = dailyTable.premiumAccount
	end

	if systemType == DAILY_REWARD_SYSTEM_TYPE_ONE then
		rewards = DailyRewardItems[self:getVocation():getBaseId()] or DailyRewardItems[0]
		if dailyTable.items then
			rewards = dailyTable.items
		end
	end

	msg:addByte(systemType)
	if systemType == DAILY_REWARD_SYSTEM_TYPE_ONE then
		if type == DAILY_REWARD_TYPE_ITEM then
			msg:addByte(itemsToPick)
			msg:addByte(#rewards)
			for i = 1, #rewards do
				local itemId = rewards[i]
				local itemType = ItemType(itemId)
				local itemName = itemType:getArticle() .. " " .. itemType:getName()
				local itemWeight = itemType:getWeight()
				msg:addU16(itemId)
				msg:addString(itemName, "Player.readDailyReward - itemName")
				msg:addU32(itemWeight)
			end
		end
	elseif systemType == DAILY_REWARD_SYSTEM_TYPE_TWO then
		if type == DAILY_REWARD_TYPE_STORAGE then
			-- msg:addByte(#rewards.things)
			-- for i = 1, #rewards.things do
			-- msg:addByte(DAILY_REWARD_SYSTEM_TYPE_OTHER) -- type
			-- msg:addU16(rewards.things[i].id * 100)
			-- msg:addString(rewards.things[i].name, "Player.readDailyReward - rewards.things[i].name")
			-- msg:addByte(rewards.things[i].quantity)
			-- end
		elseif type == DAILY_REWARD_TYPE_PREY_REROLL then
			msg:addByte(DAILY_REWARD_SYSTEM_SKIP)
			msg:addByte(DAILY_REWARD_SYSTEM_TYPE_PREY_REROLL)
			msg:addByte(itemsToPick)
		elseif type == DAILY_REWARD_TYPE_XP_BOOST then
			msg:addByte(DAILY_REWARD_SYSTEM_SKIP)
			msg:addByte(DAILY_REWARD_SYSTEM_TYPE_XP_BOOST)
			msg:addU16(itemsToPick)
		end
	end
end

function Player.sendDailyReward(self)
	if self:getClient().version < 1200 then
		return true
	end

	local msg = NetworkMessage()
	msg:addByte(ServerPackets.DailyRewardBasic)
	msg:addByte(DAILY_REWARD_COUNT)
	for currentDay = 1, DAILY_REWARD_COUNT do
		self:readDailyReward(msg, currentDay, DAILY_REWARD_STATUS_FREE) -- Free rewards
		self:readDailyReward(msg, currentDay, DAILY_REWARD_STATUS_PREMIUM) -- Premium rewards
	end
	-- Resting area bonuses
	local maxBonus = 7
	msg:addByte(maxBonus - 1)
	for i = 2, maxBonus do
		msg:addString(DailyReward.strikeBonuses[i].text, "Player.sendDailyReward - DailyReward.strikeBonuses[i].text")
		msg:addByte(i)
	end
	msg:addByte(1) -- Unknown
	msg:sendToPlayer(self)
end
