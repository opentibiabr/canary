local advanceSave = CreatureEvent("AdvanceSave")

function advanceSave.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	player:save()

	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		local baseRate = getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXP))
	
	-- Event scheduler
		if SCHEDULE_EXP_RATE ~= 100 then
			baseRate = math.max(0, (baseRate * SCHEDULE_EXP_RATE)/100)
		end

		player:setBaseXpGain(baseRate * 100)
		end
			return true
	end

advanceSave:register()
