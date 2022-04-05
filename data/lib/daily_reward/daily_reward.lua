DAILY_REWARD_HP_REGENERATION = 2
DAILY_REWARD_MP_REGENERATION = 3
DAILY_REWARD_STAMINA_REGENERATION = 4
DAILY_REWARD_DOUBLE_HP_REGENERATION = 5
DAILY_REWARD_DOUBLE_MP_REGENERATION = 6
DAILY_REWARD_SOUL_REGENERATION = 7
DAILY_REWARD_FIRST = 2
DAILY_REWARD_LAST = 7

function RegenStamina(id, delay)
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
	Daily_Bonus.stamina[id] = addEvent(RegenStamina, delay, id, delay)
	return true
end

function RegenSoul(id, delay)
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
	Daily_Bonus.soul[id] = addEvent(RegenSoul, delay, id, delay)
	return true
end
