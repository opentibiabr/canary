local config = {
	heal = true,
	save = true,
	effect = false
}

local advanceSave = CreatureEvent("AdvanceSave")

function advanceSave.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	if config.effect then
		player:getPosition():sendMagicEffect(math.random(CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_BLUE))
		player:say('LEVEL UP!', TALKTYPE_MONSTER_SAY)
	end

	if config.heal then
		player:addHealth(player:getMaxHealth())
	end

	if config.save then
		player:save()
	end

	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		local baseRate = getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXPERIENCE))
		-- Event scheduler
		if SCHEDULE_EXP_RATE ~= 100 then
			baseRate = math.max(0, (baseRate * SCHEDULE_EXP_RATE)/100)
		end
		player:setBaseXpGain(baseRate * 100)
	end

	return true
end

advanceSave:register()
