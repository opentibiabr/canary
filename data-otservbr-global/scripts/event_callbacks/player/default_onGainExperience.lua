local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	if not player then
		return false
	end

	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not playerId then
		return false
	end

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
		player:removePreyStamina(120)
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
		player:removePreyStamina(60)
	end
	player:setStamina(staminaMinutes)
end

local function useStaminaXpBoost(player)
	if not player then
		return false
	end

	local staminaMinutes = player:getExpBoostStamina() / 60
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not playerId then
		return false
	end

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

local ec = EventCallback

function ec.onGainExperience(player, source, exp, rawExp)
	if not target or target:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = player:getVocation()
	if player:getSoul() < vocation:getMaxSoul() and exp >= player:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks())
		player:addCondition(soulCondition)
	end

	-- Store Bonus
	useStaminaXpBoost(player) -- Use store boost stamina

	local Boost = player:getExpBoostStamina()
	local stillHasBoost = Boost > 0
	local storeXpBoostAmount = stillHasBoost and player:getStoreXpBoost() or 0

	player:setStoreXpBoost(storeXpBoostAmount)

	-- Stamina Bonus
	local staminaBoost = 1
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(player)
		local staminaMinutes = player:getStamina()
			if staminaMinutes > 2340 and player:isPremium() then
				staminaBoost = 1.5
			elseif staminaMinutes <= 840 then
				staminaBoost = 0.5 --TODO destroy loot of people with 840- stamina
			end
		player:setStaminaXpBoost(staminaBoost * 100)
	end

	-- Boosted creature
	if target:getName():lower() == (Game.getBoostedCreature()):lower() then
		exp = exp * 2
	end

	-- Prey system
	if configManager.getBoolean(configKeys.PREY_ENABLED) then
		local monsterType = target:getType()
		if monsterType and monsterType:raceId() > 0 then
			exp = math.ceil((exp * player:getPreyExperiencePercentage(monsterType:raceId())) / 100)
		end
	end

	local baseRate = player:getFinalBaseRateExperience()

	return (exp * baseRate + (exp * (storeXpBoostAmount/100))) * staminaBoost
end

ec:register(--[[0]])
