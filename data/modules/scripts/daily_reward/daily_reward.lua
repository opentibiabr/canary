DailyRewardSystem = {
	Developer = "Westwol, Marcosvf132",
	Version = "1.3",
	lastUpdate = "12/10/2020 - 20:30",
	ToDo = "Move this system to CPP"
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
	JokerResource = 0x15
}

--[[-- Constants
Please do not edit any of the next constants:
	]]

--[[ Overall ]]--
local DAILY_REWARD_COUNT = 7
local REWARD_FROM_SHRINE = 0
local REWARD_FROM_PANEL = 1

--[[ Bonuses ]] --
local DAILY_REWARD_NONE = 1
local DAILY_REWARD_HP_REGENERATION = 2
local DAILY_REWARD_MP_REGENERATION = 3
local DAILY_REWARD_STAMINA_REGENERATION = 4
local DAILY_REWARD_DOUBLE_HP_REGENERATION = 5
local DAILY_REWARD_DOUBLE_MP_REGENERATION = 6
local DAILY_REWARD_SOUL_REGENERATION = 7

--[[ Reward Types ]] --

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

--[[ Account Status ]] --
local DAILY_REWARD_STATUS_FREE = 0
local DAILY_REWARD_STATUS_PREMIUM = 1

local DailyRewardItems = {
	[0] = {7618, 7620}, -- God/no vocation character
	[VOCATION.CLIENT_ID.PALADIN] = {7618, 7588, 7620, 7589, 8472, 26030, 2316, 2274, 2291, 2266, 2310, 2262, 2277, 2313, 2305, 2301, 2303, 2302, 2304, 2271, 2265, 2293, 2286, 2289, 2308, 2288, 2268, 2315},
	[VOCATION.CLIENT_ID.DRUID] = {7618, 7620, 7589, 7590, 26029, 2316, 2274, 2291, 2266, 2310, 2262, 2277, 2313, 2305, 2301, 2303, 2302, 2269, 2304, 2271, 2265, 2293, 2286, 2289, 2308, 2288, 2268, 2315},
	[VOCATION.CLIENT_ID.SORCERER] = {7618, 7620, 7589, 7590, 26029, 2316, 2274, 2291, 2266, 2310, 2262, 2277, 2313, 2305, 2301, 2303, 2302, 2304, 2271, 2265, 2293, 2286, 2289, 2308, 2288, 2268, 2315},
	[VOCATION.CLIENT_ID.KNIGHT] = {7618, 7588, 7591, 8473, 26031, 7620, 2316, 2274, 2291, 2266, 2310, 2262, 2277, 2313, 2305, 2301, 2303, 2302, 2304, 2271, 2265, 2293, 2286, 2289, 2308, 2288, 2268, 2315},
}

DailyReward = {
	testMode = false,
	serverTimeThreshold = (24 * 60 * 60), -- Counting down 24hours from last server save

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
		avoidDoubleJoker = 13414
	},

	strikeBonuses = {
		-- day
		[1] = {text = "No bonus for first day"},
		[2] = {text = "Allow Hit Point Regeneration"},
		[3] = {text = "Allow Mana Regeneration"},
		[4] = {text = "Stamina Regeneration"},
		[5] = {text = "Double Hit Point Regeneration"},
		[6] = {text = "Double Mana Regeneration"},
		[7] = {text = "Soul Points Regeneration"}
	},

	rewards = {
		-- day
		[1] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 5,
			premiumAccount = 10
		},
		[2] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 5,
			premiumAccount = 10
		},
		[3] = {
			type = DAILY_REWARD_TYPE_PREY_REROLL,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 1,
			premiumAccount = 2
		},
		[4] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			freeAccount = 10,
			premiumAccount = 20
		},
		[5] = {
			type = DAILY_REWARD_TYPE_PREY_REROLL,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 1,
			premiumAccount = 2
		},
		[6] = {
			type = DAILY_REWARD_TYPE_ITEM,
			systemType = DAILY_REWARD_SYSTEM_TYPE_ONE,
			items = {32124, 32125, 32126, 32127, 32128, 32129},
			freeAccount = 1,
			premiumAccount = 2,
			itemCharges = 50
		},
		[7] = {
			type = DAILY_REWARD_TYPE_XP_BOOST,
			systemType = DAILY_REWARD_SYSTEM_TYPE_TWO,
			freeAccount = 10,
			premiumAccount = 30
		}
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
	}
}

function onRecvbyte(player, msg, byte)
	if (byte == ClientPackets.OpenRewardWall) then
		DailyReward.loadDailyReward(player:getId(), REWARD_FROM_PANEL)
	elseif (byte == ClientPackets.OpenRewardHistory) then
		player:sendRewardHistory()
	elseif (byte == ClientPackets.SelectReward) then
		player:selectDailyReward(msg)
	end
end


-- Core functions
DailyReward.insertHistory = function(playerId, dayStreak, description)
	return db.query(string.format("INSERT INTO `daily_reward_history`(`player_id`, `daystreak`, `timestamp`, \z
		`description`) VALUES (%s, %s, %s, %s)", playerId, dayStreak, os.time(), db.escapeString(description)))
end

DailyReward.retrieveHistoryEntries = function(playerId)

	local player = Player(playerId)
	if not player then
		return false
	end

	local entries = {}
	local resultId = db.storeQuery("SELECT * FROM `daily_reward_history` WHERE `player_id` = \z
		" .. player:getGuid() .. " ORDER BY `timestamp` DESC LIMIT 15;")
	if resultId ~= false then
		repeat
			local entry = {
				description = result.getDataString(resultId, "description"),
				timestamp = result.getDataInt(resultId, "timestamp"),
				daystreak = result.getDataInt(resultId, "daystreak"),
			}
			table.insert(entries, entry)
		until not result.next(resultId)
		result.free(resultId)
	end
	return entries
end

DailyReward.loadDailyReward = function(playerId, source)
	local player = Player(playerId)
	if not player then
		return false
	end
	if source ~= 0 then
		source = REWARD_FROM_SHRINE
	else
		source = REWARD_FROM_PANEL
	end

	player:sendCollectionResource(ClientPackets.JokerResource, player:getJokerTokens())
	player:sendCollectionResource(ClientPackets.CollectionResource, player:getCollectionTokens())
	player:sendDailyReward()
	player:sendOpenRewardWall(source)
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
	player:setStorageValue(DailyReward.storages.avoidDouble, Game.getLastServerSave())
	player:setDailyReward(DAILY_REWARD_COLLECTED)
	player:setNextRewardTime(Game.getLastServerSave() + DailyReward.serverTimeThreshold)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
	return true
end

DailyReward.isShrine = function(source)
	if source ~= 0 then
		return false
	else
		return true
	end
end

function Player.iterateTest(self)
	local dailyTable = DailyReward.rewards[5]
	local reward = DailyRewardItems[self:getVocation():getClientId()]

	if not(reward) then
		reward = {}
	end

	for i = 1, #reward.things do
		for j = 1, #reward.things[i].storages do
			self:setStorageValue(reward.things[i].storages[j].storageId, reward.things[i].storages[j].value)
		end
	end
end

DailyReward.isRewardTaken = function(playerId)
	local player = Player(playerId)
	if not player then
		return false
	end
	local playerStorage = player:getStorageValue(DailyReward.storages.avoidDouble)
	if playerStorage == Game.getLastServerSave() then
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

	local timeMath = Game.getLastServerSave() - player:getNextRewardTime()
	if player:getNextRewardTime() < Game.getLastServerSave() then
		if player:getStorageValue(DailyReward.storages.notifyReset) ~= Game.getLastServerSave() then
			player:setStorageValue(DailyReward.storages.notifyReset, Game.getLastServerSave())
			timeMath = math.ceil(timeMath/(DailyReward.serverTimeThreshold))
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

DailyReward.processReward = function(playerId, source)
	DailyReward.pickedReward(playerId)
	DailyReward.loadDailyReward(playerId, source)
	local player = Player(playerId)
	if player then
		player:loadDailyRewardBonuses()
	end
	return true
end

function Player.sendOpenRewardWall(self, shrine)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.OpenRewardWall) -- initial packet
	msg:addByte(shrine) -- isPlayer taking bonus from reward shrine (1) - taking it from a instant bonus reward (0)
	if DailyReward.testMode or not(DailyReward.isRewardTaken(self:getId())) then
		msg:addU32(0)
	else
		msg:addU32(Game.getLastServerSave() + DailyReward.serverTimeThreshold)
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
		msg:addU32(Game.getLastServerSave() + DailyReward.serverTimeThreshold) --timeLeft to pickUp reward without loosing streak
		msg:addU16(self:getJokerTokens())
	end
	msg:addU16(self:getStreakLevel()) -- day strike
	msg:sendToPlayer(self)
end

function Player.sendCollectionResource(self, byte, value)
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

	local source = msg:getByte() -- 0 -> shrine / 1 -> tibia panel
	if not DailyReward.isShrine(source) then
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

	-- Items as reward
	if (dailyTable.type == DAILY_REWARD_TYPE_ITEM) then

		local items = {}

		-- Creating items table
		local columnsPicked = msg:getByte() -- Columns picked
		for i = 1, columnsPicked do
			local spriteId = msg:getU16()
			local count = msg:getByte()
			items[i] = {spriteId = spriteId, count = count}
		end

		-- Verifying if items if player is picking the correct amount
		local counter = 0
		for k, v in ipairs(items) do
			counter = counter + v.count
		end

		if self:isPremium() then
			count = dailyTable.premiumAccount
		else
			count = dailyTable.freeAccount
		end

		if counter > count then
			self:sendError("Something went wrong here, please restart this dialog.")
			return false
		end

		-- Adding items to store inbox
		local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
		if inbox and inbox:getEmptySlots() < columnsPicked then
			self:sendError("You do not have enough space in your store inbox.")
			return false
		end

		local description = ""
		for k, v in ipairs(items) do
			local item = Game.getItemIdByClientId(v.spriteId)
			if dailyTable.itemCharges then
				for i = 1, v.count do
					inbox:addItem(item:getId(), dailyTable.itemCharges) -- adding charges for each item
				end
			else
				inbox:addItem(item:getId(), v.count) -- adding single item w/o charges
			end
			if k ~= columnsPicked then
				description = description .. "" .. v.count .. "x " .. getItemName(item:getId()) .. ", "
			else
				description = description .. "" .. v.count .. "x " .. getItemName(item:getId()) .. "."
			end
		end

		-- Registering history
		DailyReward.insertHistory(self:getGuid(), self:getDayStreak(), "Claimed reward no. \z
			" .. self:getDayStreak() + 1 .. ". Picked items: " .. description)
		DailyReward.processReward(playerId, source)
	end

	local reward = nil
	if self:isPremium() then
		reward = dailyTable.premiumAccount
	else
		reward = dailyTable.freeAccount
	end

	-- if (dailyTable.type == DAILY_REWARD_TYPE_STORAGE) then
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
		-- DailyReward.insertHistory(self:getGuid(), self:getDayStreak(), "Claimed reward no. \z
			-- " .. self:getDayStreak() + 1 .. ". Picked reward: " .. description)
		-- DailyReward.processReward(playerId, source)
	-- end

	if (dailyTable.type == DAILY_REWARD_TYPE_XP_BOOST) then
		self:setExpBoostStamina(self:getExpBoostStamina() + (reward * 60))
		self:setStoreXpBoost(50)
		DailyReward.insertHistory(self:getGuid(), self:getDayStreak(), "Claimed reward no. \z
			" .. self:getDayStreak() + 1 .. ". Picked reward: XP Bonus for " .. reward .. " minutes.")
		DailyReward.processReward(playerId, source)
	end

	if (dailyTable.type == DAILY_REWARD_TYPE_PREY_REROLL) then
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() + reward)
		DailyReward.insertHistory(self:getGuid(), self:getDayStreak(), "Claimed reward no. \z
			" .. self:getDayStreak() + 1 .. ". Picked reward: " .. reward .. "x Prey bonus reroll(s)")
		DailyReward.processReward(playerId, source)
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
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.DailyRewardCollectionState)
	msg:addByte(state)
	msg:sendToPlayer(self)
end

function Player.sendRewardHistory(self)
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
	local itemsToPick = 0
	if currentDay == 3 or (currentDay >= 5 and currentDay <= 7) then
		rewards = dailyTable.items
		if (state == DAILY_REWARD_STATUS_FREE) then
			itemsToPick = dailyTable.freeAccount
		else
			itemsToPick = dailyTable.premiumAccount
		end
	else
		if systemType == 1 then
			if (state == DAILY_REWARD_STATUS_FREE) then
				rewards = DailyRewardItems[self:getVocation():getClientId()]
				itemsToPick = dailyTable.freeAccount
			else
				rewards = DailyRewardItems[self:getVocation():getClientId()]
				itemsToPick = dailyTable.premiumAccount
			end

			if not(rewards) then
				rewards = {}
			end
		else
			if (state == DAILY_REWARD_STATUS_FREE) then
				rewards = dailyTable.freeAccount
			else
				rewards = dailyTable.premiumAccount
			end
		end
	end
	msg:addByte(systemType)
	if (systemType == 1) then
		if (type == DAILY_REWARD_TYPE_ITEM) then
			msg:addByte(itemsToPick)
			msg:addByte(#rewards)
			for i = 1, #rewards do
				local itemId = rewards[i]
				local itemType = ItemType(itemId)
				local itemName = itemType:getArticle() .. " " .. getItemName(itemId)
				local itemWeight = itemType:getWeight()
				msg:addItemId(itemId)
				msg:addString(itemName)
				msg:addU32(itemWeight)
			end
		end
	elseif (systemType == 2) then
		if (type == DAILY_REWARD_TYPE_STORAGE) then
			-- msg:addByte(#rewards.things)
			-- for i = 1, #rewards.things do
				-- msg:addByte(DAILY_REWARD_SYSTEM_TYPE_OTHER) -- type
				-- msg:addU16(rewards.things[i].id * 100)
				-- msg:addString(rewards.things[i].name)
				-- msg:addByte(rewards.things[i].quantity)
			-- end
		elseif (type == DAILY_REWARD_TYPE_PREY_REROLL) then
			msg:addByte(DAILY_REWARD_SYSTEM_SKIP)
			msg:addByte(DAILY_REWARD_SYSTEM_TYPE_PREY_REROLL)
			msg:addByte(itemsToPick)
		elseif (type == DAILY_REWARD_TYPE_XP_BOOST) then
			msg:addByte(DAILY_REWARD_SYSTEM_SKIP)
			msg:addByte(DAILY_REWARD_SYSTEM_TYPE_XP_BOOST)
			msg:addU16(itemsToPick)
		end
	end
end

function Player.sendDailyReward(self)
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
