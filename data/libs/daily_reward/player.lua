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
	Spdlog.debug(string.format("Player: %s, streak level: %d, active bonuses: %s",
		self:getName(), streakLevel, self:getActiveDailyRewardBonusesName()))
end
