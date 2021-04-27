-- Global virtual tables
Daily_Bonus = {
	stamina = {},
	soul = {}
}

function string.diff(self)
	local format = {
		{'day', self / 60 / 60 / 24},
		{'hour', self / 60 / 60 % 24},
		{'minute', self / 60 % 60},
		{'second', self % 60}
	}

	local out = {}
	for k, t in ipairs(format) do
		local v = math.floor(t[2])
		if(v > 0) then
			table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' and ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
		end
	end
	local ret = table.concat(out)
	if ret:len() < 16 and ret:find('second') then
		local a, b = ret:find(' and ')
		ret = ret:sub(b+1)
	end
	return ret
end

function Game.getLastServerSave()
	return retrieveGlobalStorage(DailyReward.storages.lastServerSave)
end

function updateGlobalStorage(key, value)
	db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (".. key ..", ".. value ..") ON DUPLICATE KEY UPDATE `value` = ".. value)
end

function retrieveGlobalStorage(key)
	local resultId = db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = " .. key)
	if resultId ~= false then
		local val = result.getNumber(resultId, "value")
		result.free(resultId)
		return val
	end
	return 1
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
	return math.max(self:getStorageValue(DailyReward.storages.currentStreakLevel), 0)
end

function Player.setStreakLevel(self, value)
	self:setStorageValue(DailyReward.storages.currentStreakLevel, value)
end

function Player.setNextRewardTime(self, value)
	self:setStorageValue(DailyReward.storages.nextRewardTime, value)
end

function Player.getNextRewardTime(self)
	return math.max(self:getStorageValue(DailyReward.storages.nextRewardTime), 0)
end

function Player.isRestingAreaBonusActive(self)
	local levelStreak = self:getStreakLevel()
	if levelStreak > 1 then
		return true
	else
		return false
	end
end

local function regenStamina(id, delay)
	local staminaEvent = Daily_Bonus.stamina[id]
	local player = Player(id)
	if not player then
		stopEvent(staminaEvent)
		Daily_Bonus.stamina[id] = nil
		return false
	end
	if player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		local actualStamina = player:getStamina()
		if actualStamina > 2340 and actualStamina < 2520 then
			delay = 6 * 60 * 1000 -- Bonus stamina
		end
		if actualStamina < 2520 then
			player:setStamina(actualStamina + 1)
			player:sendTextMessage(MESSAGE_FAILURE, "One minute of stamina has been refilled.")
		end
	end
	stopEvent(staminaEvent)
	Daily_Bonus.stamina[id] = addEvent(regenStamina, delay, id, delay)
	return true
end

local function regenSoul(id, delay)
	local soulEvent = Daily_Bonus.soul[id]
	local maxsoul = 0
	local player = Player(id)
	if not player then
		stopEvent(soulEvent)
		Daily_Bonus.soul[id] = nil
		return false
	end
	if player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		if player:isPremium() then
			maxsoul = 200
		else
			maxsoul = 100
		end
		if player:getSoul() < maxsoul then
			player:addSoul(1)
			player:sendTextMessage(MESSAGE_FAILURE, "One soul point has been restored.")
		end
	end
	stopEvent(soulEvent)
	Daily_Bonus.soul[id] = addEvent(regenSoul, delay, id, delay)
	return true
end

local DAILY_REWARD_HP_REGENERATION = 2
local DAILY_REWARD_MP_REGENERATION = 3
local DAILY_REWARD_STAMINA_REGENERATION = 4
local DAILY_REWARD_DOUBLE_HP_REGENERATION = 5
local DAILY_REWARD_DOUBLE_MP_REGENERATION = 6
local DAILY_REWARD_SOUL_REGENERATION = 7
local DAILY_REWARD_FIRST = 2
local DAILY_REWARD_LAST = 7

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
	local staminaEvent = Daily_Bonus.stamina[self:getId()]
		if not staminaEvent then
			local delay = 3
			if self:getStamina() > 2340 and self:getStamina() <= 2520 then
				delay = 6
			end
			Daily_Bonus.stamina[self:getId()] = addEvent(regenStamina, delay * 60 * 1000, self:getId(), delay * 60 * 1000)
		end
	end
	-- Soul regeneration
	if streakLevel >= DAILY_REWARD_SOUL_REGENERATION then
		local soulEvent = Daily_Bonus.soul[self:getId()]
		if not soulEvent then
			local delay = self:getVocation():getSoulGainTicks()
			Daily_Bonus.soul[self:getId()] = addEvent(regenSoul, delay * 1000, self:getId(), delay * 1000)
		end
	end
	Spdlog.debug(string.format("Player: %s, streak level: %d, active bonuses: %s",
		self:getName(), streakLevel, self:getActiveDailyRewardBonusesName()))
end
