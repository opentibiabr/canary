local ec = EventCallback

function ec.onGainSkillTries(player, skill, tries)
	-- Dawnport skills limit
	if  IsRunningGlobalDatapack() and isSkillGrowthLimited(player, skill) then
		return 0
	end
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	-- Event scheduler skill rate
	local STAGES_DEFAULT = skillsStages or nil
	local SKILL_DEFAULT = player:getSkillLevel(skill)
	local RATE_DEFAULT = configManager.getNumber(configKeys.RATE_SKILL)

	if(skill == SKILL_MAGLEVEL) then -- Magic Level
		STAGES_DEFAULT = magicLevelStages or nil
		SKILL_DEFAULT = player:getBaseMagicLevel()
		RATE_DEFAULT = configManager.getNumber(configKeys.RATE_MAGIC)
	end

	skillOrMagicRate = getRateFromTable(STAGES_DEFAULT, SKILL_DEFAULT, RATE_DEFAULT)

	if SCHEDULE_SKILL_RATE ~= 100 then
		skillOrMagicRate = math.max(0, (skillOrMagicRate * SCHEDULE_SKILL_RATE) / 100)
	end

	return tries / 100 * (skillOrMagicRate * 100)
end

ec:register(--[[0]])
