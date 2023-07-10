DAILY_REWARD_HP_REGENERATION = 2
DAILY_REWARD_MP_REGENERATION = 3
DAILY_REWARD_STAMINA_REGENERATION = 4
DAILY_REWARD_DOUBLE_HP_REGENERATION = 5
DAILY_REWARD_DOUBLE_MP_REGENERATION = 6
DAILY_REWARD_SOUL_REGENERATION = 7
DAILY_REWARD_FIRST = 2
DAILY_REWARD_LAST = 7

-- Global tables
DailyRewardBonus = {
	Stamina = {},
	Soul = {}
}

function RegenStamina(id, delay)
	local staminaEvent = DailyRewardBonus.Stamina[id]
	local player = Player(id)
	if not player then
		stopEvent(staminaEvent)
		DailyRewardBonus.Stamina[id] = nil
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
	DailyRewardBonus.Stamina[id] = addEvent(RegenStamina, delay, id, delay)
	return true
end

function RegenSoul(id, delay)
	local soulEvent = DailyRewardBonus.Soul[id]
	local maxsoul = 0
	local player = Player(id)
	if not player then
		stopEvent(soulEvent)
		DailyRewardBonus.Soul[id] = nil
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
	DailyRewardBonus.Soul[id] = addEvent(RegenSoul, delay, id, delay)
	return true
end

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

function GetDailyRewardLastServerSave()
	return RetrieveGlobalStorage(DailyReward.storages.lastServerSave)
end

function UpdateDailyRewardGlobalStorage(key, value)
	db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (".. key ..", ".. value ..") ON DUPLICATE KEY UPDATE `value` = ".. value)
end

function RetrieveGlobalStorage(key)
	local resultId = db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = " .. key)
	if resultId ~= false then
		local val = Result.getNumber(resultId, "value")
		Result.free(resultId)
		return val
	end
	return 1
end
