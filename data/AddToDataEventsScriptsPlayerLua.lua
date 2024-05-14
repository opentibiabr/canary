local function SendXPtoClient(player)

	-- Send Client Exp Display
	if configManager.getBoolean(configKeys.XP_DISPLAY_MODE) then
		local baseRate = player:getFinalBaseRateExperience() * 100
		if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
			local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
			if vipBonusExp > 0 and player:isVip() then
				vipBonusExp = (vipBonusExp > 100 and 100) or vipBonusExp
				baseRate = baseRate * (1 + (vipBonusExp / 100))
				player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Normal base xp is: " .. baseRate .. "%, because you are VIP, bonus of " .. vipBonusExp .. "%")
			end
		end

		player:setBaseXpGain(baseRate)
	end

end

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
		if staminaMinutes > 1 then
			staminaMinutes = staminaMinutes - 1
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
	SendXPtoClient(player)
	if isStaminaEnabled then
		player:setStamina(staminaMinutes)
	end
end

function Player:onGainSkillTries(skill, tries)
	-- Dawnport skills limit
	if IsRunningGlobalDatapack() and isSkillGrowthLimited(self, skill) then
		return 0
	end
	if not APPLY_SKILL_MULTIPLIER then
		return tries
	end

	--Check Stamina
	local isStaminaEnabled = configManager.getBoolean(configKeys.STAMINA_SYSTEM)
	local isStaminaActive = false
	if isStaminaEnabled then
		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2340 and self:isPremium() then
			isStaminaActive = true
			if skill ~= SKILL_MAGLEVEL then				
				-- Stamina Bonus
				local staminaBonusXp = 1
				useStamina(self, isStaminaEnabled)
				staminaBonusXp = self:getFinalBonusStamina()
				self:setStaminaXpBoost(staminaBonusXp * 100)
			end
		end
	end
	
	-- Event scheduler skill rate
	local STAGES_DEFAULT = nil
	local SKILL_DEFAULT = nil
	local RATE_DEFAULT = nil
	local skillOrMagicRate = nil
	if skill == SKILL_MAGLEVEL then
		-- Magic Level
		if configManager.getBoolean(configKeys.RATE_USE_STAGES) then
			STAGES_DEFAULT = magicLevelStages
		end
		SKILL_DEFAULT = self:getBaseMagicLevel()
		RATE_DEFAULT = configManager.getNumber(configKeys.RATE_MAGIC)
		skillOrMagicRate = getRateFromTable(STAGES_DEFAULT, SKILL_DEFAULT, RATE_DEFAULT)
		tries = tries * (isStaminaActive and 1.25 or 1)
	else
		if configManager.getBoolean(configKeys.RATE_USE_STAGES) then
			STAGES_DEFAULT = skillsStages
		end
		SKILL_DEFAULT = self:getSkillLevel(skill)
		local DistanceFactor = skill == SKILL_DISTANCE and 2 or 1
		RATE_DEFAULT = configManager.getNumber(configKeys.RATE_SKILL)
		skillOrMagicRate = getRateFromTable(STAGES_DEFAULT, SKILL_DEFAULT, RATE_DEFAULT) * DistanceFactor
		tries = tries * (isStaminaActive and 1.5 or 1)
	end
	
	if SCHEDULE_SKILL_RATE ~= 100 then
		skillOrMagicRate = math.max(0, (skillOrMagicRate * SCHEDULE_SKILL_RATE) / 100)
	end

	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local vipBoost = configManager.getNumber(configKeys.VIP_BONUS_SKILL)
		if vipBoost > 0 and self:isVip() then
			vipBoost = (vipBoost > 100 and 100) or vipBoost
			skillOrMagicRate = skillOrMagicRate + (skillOrMagicRate * (vipBoost / 100))
		end
	end
	
	return tries / 100 * (skillOrMagicRate * 100)
end


logger.info("Peregrinaje Skills on Stamina Loaded")