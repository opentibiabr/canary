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
}

DailyReward = {
	testMode = false,
	serverTimeThreshold = (25 * 60 * 60), -- Counting down 24hours from last server save

	storages = {
		-- Player
		currentDayStreak = 14897,
		currentStreakLevel = 14898, -- Cpp uses the same storage value on const.h (STORAGEVALUE_DAILYREWARD)
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
		[2] = { text = "Allow Hit Point Regeneration" },
		[3] = { text = "Allow Mana Regeneration" },
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
			items = { 28540, 28541, 28542, 28543, 28544, 28545, 44064 },
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
	return db.query(string.format(
		"INSERT INTO `daily_reward_history`(`player_id`, `daystreak`, `timestamp`, \z
		`description`) VALUES (%s, %s, %s, %s)",
		playerId,
		dayStreak,
		os.time(),
		db.escapeString(description)
	))
end

DailyReward.retrieveHistoryEntries = function(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local entries = {}
	local resultId = db.storeQuery("SELECT * FROM `daily_reward_history` WHERE `player_id` = \z
		" .. player:getGuid() .. " ORDER BY `timestamp` DESC LIMIT 15;")
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

DailyReward.init = function(playerId)
	local player = Player(playerId)

	if not player then
		return false
	end

	if player:getJokerTokens() < 3 and tonumber(os.date("%m")) ~= player:getStorageValue(DailyReward.storages.avoidDoubleJoker) then
		player:setStorageValue(DailyReward.storages.avoidDoubleJoker, tonumber(os.date("%m")))
		player:setJokerTokens(player:getJokerTokens() + 1)
	end

	local timeMath = GetDailyRewardLastServerSave() - player:getNextRewardTime()
	if player:getNextRewardTime() < GetDailyRewardLastServerSave() then
		if player:getStorageValue(DailyReward.storages.notifyReset) ~= GetDailyRewardLastServerSave() then
			player:setStorageValue(DailyReward.storages.notifyReset, GetDailyRewardLastServerSave())
			timeMath = math.ceil(timeMath / DailyReward.serverTimeThreshold)
			if player:getJokerTokens() >= timeMath then
				player:setJokerTokens(player:getJokerTokens() - timeMath)
				player:sendTextMessage(MESSAGE_LOGIN, "You lost " .. timeMath .. " joker tokens to prevent loosing your streak.")
			else
				player:setStreakLevel(0)
				if player:getLastLoginSaved() > 0 then -- message wont appear at first character login
					player:setJokerTokens(-(player:getJokerTokens()))
					player:sendTextMessage(MESSAGE_LOGIN, "You just lost your daily reward streak.")
				end
			end
		end
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
		msg:addString("Sorry, you have already taken your daily reward or you are unable to collect it.") -- Unknown message
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
	if not DailyReward.isShrine(target) then
		if self:getCollectionTokens() < 1 then
			self:sendError("You do not have enough collection tokens to proceed.")
			return false
		end
		self:setCollectionTokens(self:getCollectionTokens() - 1)
	end

	local dailyTable = DailyReward.rewards[self:getDayStreak() + 1]
	if not dailyTable then
		self:sendError("Something went wrong and we cannot process this request.")
		return false
	end

	local rewardCount = dailyTable.freeAccount
	if self:isPremium() then
		rewardCount = dailyTable.premiumAccount
	end

	local dailyRewardMessage = false

	-- Items as reward
	if dailyTable.type == DAILY_REWARD_TYPE_ITEM then
		local items = {}
		local possibleItems = DailyRewardItems[self:getVocation():getBaseId()]
		if dailyTable.items then
			possibleItems = dailyTable.items
		end

		-- Creating items table
		local columnsPicked = msg:getByte() -- Columns picked
		local orderedCounter = 0
		local totalCounter = 0
		for i = 1, columnsPicked do
			local itemId = msg:getU16()
			local count = msg:getByte()
			orderedCounter = orderedCounter + count
			for index, val in ipairs(possibleItems) do
				if val == itemId then
					items[i] = { itemId = itemId, count = count }
					totalCounter = totalCounter + count
					break
				end
			end
		end

		if totalCounter > rewardCount then
			self:sendError("Something went wrong here, please restart this dialog.")
			return false
		end
		if totalCounter ~= orderedCounter then
			logger.error("Player with name {} is trying to get wrong daily reward", self:getName())
			return false
		end

		-- Adding items to store inbox
		local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
		if not inbox then
			self:sendError("You do not have enough space in your store inbox.")
			return false
		end

		local description = ""
		for k, v in ipairs(items) do
			if dailyTable.itemCharges then
				for i = 1, v.count do
					local inboxItem = inbox:addItem(v.itemId, dailyTable.itemCharges) -- adding charges for each item
					if inboxItem then
						inboxItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
					end
				end
			else
				local inboxItem = inbox:addItem(v.itemId, v.count) -- adding single item w/o charges
				if inboxItem then
					inboxItem:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
				end
			end
			if k ~= columnsPicked then
				description = description .. "" .. v.count .. "x " .. ItemType(v.itemId):getName() .. ", "
			else
				description = description .. "" .. v.count .. "x " .. ItemType(v.itemId):getName() .. "."
			end
		end

		dailyRewardMessage = "Picked items: " .. description

		-- elseif dailyTable.type == DAILY_REWARD_TYPE_STORAGE then
		-- local description = ""
		-- for i = 1, #reward.things do
		-- for j = 1, #reward.things[i].storages do
		-- self:setStorageValue(reward.things[i].storages[j].storageId, reward.things[i].storages[j].value)
		-- end
		-- if i ~= #reward.things then
		-- description = description .. reward.things[i].name .. ", "
		-- else
		-- description = description .. reward.things[i].name .. "."
		-- end
		-- end
		-- dailyRewardMessage = "Picked reward: " .. description)
		-- end
	elseif dailyTable.type == DAILY_REWARD_TYPE_XP_BOOST then
		self:setExpBoostStamina(self:getExpBoostStamina() + (rewardCount * 60))
		self:setStoreXpBoost(50)
		dailyRewardMessage = "Picked reward: XP Bonus for " .. rewardCount .. " minutes."
	elseif dailyTable.type == DAILY_REWARD_TYPE_PREY_REROLL then
		self:addPreyCards(rewardCount)
		dailyRewardMessage = "Picked reward: " .. rewardCount .. "x Prey bonus reroll(s)."
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
	msg:addString(error)
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
		msg:addString(entry.description)
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
		rewards = DailyRewardItems[self:getVocation():getBaseId()]
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
				msg:addString(itemName)
				msg:addU32(itemWeight)
			end
		end
	elseif systemType == DAILY_REWARD_SYSTEM_TYPE_TWO then
		if type == DAILY_REWARD_TYPE_STORAGE then
			-- msg:addByte(#rewards.things)
			-- for i = 1, #rewards.things do
			-- msg:addByte(DAILY_REWARD_SYSTEM_TYPE_OTHER) -- type
			-- msg:addU16(rewards.things[i].id * 100)
			-- msg:addString(rewards.things[i].name)
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
		msg:addString(DailyReward.strikeBonuses[i].text)
		msg:addByte(i)
	end
	msg:addByte(1) -- Unknown
	msg:sendToPlayer(self)
end
